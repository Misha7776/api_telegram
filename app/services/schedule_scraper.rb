# class for scraping the IFNTUOG schedule page
class ScheduleScraper < BaseScraper
  def initialize(group: nil, teacher: nil)
    @group = encode_data(group, User::DEFAULT_ENCODING_FOR_REQUEST)
    @teacher = encode_data(teacher, User::DEFAULT_ENCODING_FOR_REQUEST)
    @base_url = User::SCHEDULE_BASE_URL
  end

  def parse_home_page
    page = get(@base_url)
    parse(page)
  end

  def submit_form(start_date: nil, end_date: nil)
    response = post(@base_url.to_str, body: { faculty: User::FACULTY,
                                              teacher: @teacher,
                                              group: @group,
                                              sdate: CGI.unescape(start_date),
                                              edate: CGI.unescape(end_date),
                                              n: '700' },
                                      headers: { 'Content-Type' => 'application/x-www-form-urlencoded',
                                                 'Accept-Language' => 'ru,en-US;q=0.9,en;q=0.8,uk;q=0.7' })
    data = parse(response)
    scrap_content(data)
  end

  def scrap_content(data)
    tables_of_lessons = data.css('div.col-md-6')
    result = {}
    tables_of_lessons.each do |table|
      next if table.children.first.name == 'button'

      date = table.css('h4').children[0].content.strip
      day = table.css('h4').children[1].content
      result["#{day} #{date}"] = []
      table.css('tr').each do |tr|
        next if tr.children[2].content.empty?

        lesson_number = tr.children[0].content
        lesson_time = tr.children[1].content.scan(/.{1,5}/)
        lesson_description = tr.children[2].content.gsub('  ', '')
        result["#{day} #{date}"] << "<i>#{lesson_number} пара #{lesson_time[0]} - #{lesson_time[1]}</i>\n"\
                            "#{lesson_description}\n\n"
      end
    end
    result
  end
end
