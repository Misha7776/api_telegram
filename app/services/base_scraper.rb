# base class for scraping any page
class BaseScraper
  include HTTParty
  include Nokogiri

  def get(url, options = {})
    HTTParty.get('http://' + url, options)
  end

  def post(url, options = {})
    HTTParty.post('http://' + url, options)
  end

  def parse(page)
    Nokogiri::HTML(page)
  end

  def encode_data(data, coding)
    return unless data.present?
    CGI.unescape(data.encode(coding))
  end

  def decode_data(data, from_encoding, to_encoding)
    return unless data.present? && from_encoding.present? && to_encoding.present?

    data.force_encoding(from_encoding).encode(to_encoding, undef: :replace)
  end
end
