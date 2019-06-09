class User < ApplicationRecord
  validates_uniqueness_of :telegram_id

  enum locale: [:ua, :en]

  # ******************** EMODJI ******************************
  WAVE      = "\xF0\x9F\x91\x8B".freeze
  GRING     = "\xF0\x9F\x98\x83".freeze
  WINKING   = "\xF0\x9F\x98\x89".freeze
  FEARFUL   = "\xF0\x9F\x98\xA8".freeze
  RELIEVED  = "\xF0\x9F\x98\x8C".freeze
  SMILING   = "\xF0\x9F\x98\x8A".freeze
  SEARCHING = "\xF0\x9F\x94\x8E".freeze
  CHECK_MARK = "\xE2\x9C\x85".freeze
  PARTY   = "\xF0\x9F\x8E\x89".freeze
  CONFETY = "\xF0\x9F\x8E\x8A".freeze
  COPYRIGHT = "\xC2\xA9".freeze

  # ************* DATE SEARCH TEXT MASSAGES *********************
  DATE_CRITERIA = { "#{I18n.t('today')}" => 0, "#{I18n.t('tomorrow')}" => 1, "#{I18n.t('week')}" => 7, "#{I18n.t('month')}" => 31 }.freeze

  # *************** USER COMMANDS ****************************
  START_COMMAND    = '/start'.freeze
  HELP_COMMAND     = '/help'.freeze
  ABOUT_COMMAND    = '/about'.freeze
  SCHEDULE_COMMAND = '/schedule'.freeze
  UKRAINIAN_COMMAND = '/ukrainian'.freeze
  ENGLISH_COMMAND = '/english'.freeze
  COMMANDS = [START_COMMAND, HELP_COMMAND, ABOUT_COMMAND, SCHEDULE_COMMAND, UKRAINIAN_COMMAND, ENGLISH_COMMAND]

  # ************** COMMAND OPTIONS ***************************
  TEACHER_OPTION = ' teacher'.freeze
  GROUP_OPTION   = ' group'.freeze

  # ************** SCHEDULE SITE CONFIGS **********************
  SCHEDULE_HOST     = '194.44.112.6'.freeze
  GET_SCHEDULE_URL  = '?n=700'.freeze
  SCHEDULE_BASE_URL = "#{SCHEDULE_HOST}/cgi-bin/timetable.cgi#{GET_SCHEDULE_URL}".freeze
  GROUP_EXISTS      = "?n=701&lev=142&faculty=0&query=".freeze
  TEACHER_EXISTS    = "?n=701&lev=141&faculty=0&query=".freeze
  DEFAULT_ENCODING_FOR_REQUEST = 'windows-1251'.freeze
  UTF_8_ENCODING = 'utf-8'.freeze

  def update_locale(locale_sym)
    update(locale: self.class.locales[locale_sym])
  end

  def self.start_keyboards
    { inline_keyboard:
      [
        [{ text: I18n.t('help_button'), callback_data: HELP_COMMAND },
         { text: I18n.t('schedule_button'), callback_data: SCHEDULE_COMMAND}],
         [{ text: 'Уркаїнська мова', callback_data: UKRAINIAN_COMMAND },
         { text: 'English language', callback_data: ENGLISH_COMMAND }]
      ] }
  end

  def self.help_keyboards
    { inline_keyboard:
      [
        [{ text: I18n.t('about_button'), callback_data: ABOUT_COMMAND },
         { text: I18n.t('schedule_button'), callback_data: SCHEDULE_COMMAND }]
      ] }
  end

  def self.schedule_keyboards
    { inline_keyboard:
      [
        [{ text: I18n.t('teacher_button'), callback_data: SCHEDULE_COMMAND + TEACHER_OPTION },
         { text: I18n.t('group_button'), callback_data: SCHEDULE_COMMAND + GROUP_OPTION }]
      ] }
  end

  def set_search_criteria(criteria_name:, criteria:)
    bot_command_data.store(criteria_name.to_s, criteria)
    update(bot_command_data: bot_command_data)
  end

  def search_message(criteria_name)
    name = bot_command_data[criteria_name.to_s]
    category = criteria_name.to_s == 'group' ? I18n.t('just_group') : I18n.t('just_teacher')
    response = I18n.t('search_message', name: name, CHECK_MARK: CHECK_MARK, category: category, SEARCHING: SEARCHING, SMILING: SMILING)
    response
  end

  def date_buttons(option, message)
    set_search_criteria(criteria_name: option.strip,
                        criteria: message['text'])
    date_keyboard(criteria_name: option.strip)
  end

  def date_keyboard(criteria_name:)
    { text: search_message(criteria_name),
      reply_markup: { keyboard: [["#{I18n.t('today')}", "#{I18n.t('tomorrow')}"],
                                 ["#{I18n.t('week')}", "#{I18n.t('month')}"]],
                      resize_keyboard: false,
                      one_time_keyboard: false,
                      selective: true } }
  end

  def self.date_filter
    { "#{I18n.t('today')}" => 0, "#{I18n.t('tomorrow')}" => 1, "#{I18n.t('week')}" => 7, "#{I18n.t('month')}" => 31 }
  end

  def setup_dates(message)
    sdate = Time.now
    edate = sdate + User.date_filter[message].days
    {
      sdate: sdate.strftime('%d.%m.%Y'),
      edate: edate.strftime('%d.%m.%Y')
    }
  end
end
