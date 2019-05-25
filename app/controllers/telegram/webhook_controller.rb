class Telegram::WebhookController < Telegram::Bot::UpdatesController
  # TODO: update the logic and include the parser and refactor it

  include Telegram::Bot::UpdatesController::MessageContext
  before_action :current_user
  before_action :create_user, only: :start!
  before_action :last_update, except: [:message]

  def start!(*)
    binding.pry
    respond_with :message,
                 text: User::GREETING,
                 reply_markup: User.start_keyboards
  end

  def help!(*)
    respond_with :message,
                  text: User::HELP_ME,
                  reply_markup: User.help_keyboards
  end

  def schedule!(*)
    respond_with :message,
                 text: User::SCHEDULE,
                 reply_markup: User.schedule_keyboards
  end

  def about!(*)
    respond_with :message,
                 text: User::ABOUT_TEXT
  end

  def teacher_schedule!(*)
    respond_with :message,
                 text: 'Введи ПІБ викладача (дотримуйся формату)'
  end

  def group_schedule!(*)
    respond_with :message,
                 text: 'Введи назву групи'
  end

  def callback_query(data)
    case data
    when User::ABOUT_COMMAND
      about!
    when User::HELP_COMMAND
      help!
    when User::SCHEDULE_COMMAND
      schedule!
    when User::SCHEDULE_COMMAND + User::TEACHER_OPTION
      teacher_schedule!
    when User::SCHEDULE_COMMAND + User::GROUP_OPTION
      group_schedule!
    else
      answer_callback_query 'Невідома помилка'
    end
  end

  def message(message)
    if User::DATE_CRITERIA.key?(message['text']) && !User::COMMANDS.include?(session['last_command'])
      schedule_text = scraped_schedule(message)
      unless schedule_text.present?
        return respond_with :message,
                            text: "Щасливчик, #{message['text'].downcase} у тебе немає пар #{User::PARTY}"
      end
      schedule_text.each do |day, schedule|
        respond_with :message,
                     text: "<b>#{day}</b>\n\n#{schedule.join}",
                     parse_mode: 'HTML'
      end
    else
      criteria_setup(message)
    end
  end

  private

  def scraped_schedule(message)
    intervals = @current_user.setup_dates(message['text'])
    criteria_name = session['last_command'].split(' ').last
    criteria = @current_user.bot_command_data[criteria_name]
    schedule = if criteria_name == 'group'
                 ScheduleScraper.new(group: criteria)
               else
                 ScheduleScraper.new(teacher: criteria)
               end
    schedule.submit_form(start_date: intervals[:sdate], end_date: intervals[:edate])
  end

  def criteria_setup(message)
    case session[:last_command]
    when User::SCHEDULE_COMMAND + User::TEACHER_OPTION
      return invalide_group if group?(message)
      respond_with :message,
                   @current_user.date_buttons(User::TEACHER_OPTION, message)
    when User::SCHEDULE_COMMAND + User::GROUP_OPTION
      return invalide_teacher if teacher?(message)
      respond_with :message,
                   @current_user.date_buttons(User::GROUP_OPTION, message)
    else
      schedule!
    end
  end

  def create_user
    user = User.new(user_params)
    user.save! if user.valid?
  end

  def current_user
    @current_user = User.find_by(telegram_id: user_params[:telegram_id])
  end

  def user_params
    { telegram_id: from['id'], first_name: from['first_name'], last_name: from['last_name'] }
  end

  def last_update
    session[:last_command] = if bot_commad?
                               update['message']['text']
                             elsif callback?
                               update['callback_query']['data']
                             end
  end

  def bot_commad?
    message = update['message']
    return false unless message.present?
    return false unless message['entities'].present?
    update['message']['entities'][0]['type'] == 'bot_command'
  end

  def callback?
    update['callback_query'].present?
  end

  def teacher?(message)
    message['text'].split(' ').length.between?(2, 3)
  end

  def group?(message)
    message['text'].split('-').length.between?(2, 3)
  end

  def warn_message(who)
    "Здаєть ти мав увести #{who}.\n"\
    "#{@current_user[:first_name]} будь-ласка будь уважнішим #{User::SMILING}"
  end

  def invalide_group
    respond_with :message, text: warn_message('назву групи')
  end

  def invalide_teacher
    respond_with :message, text: warn_message('ПІБ викладача')
  end
end
