class JapanesePublicHolidayCreatorService
  # https://app.clickup.com/t/2193w2n
  def initialize
    @base_url = "https://holidays-jp.github.io"
  end

  def run
    raw_response = connection.get("api/v1/date.json")
    public_holidays = raw_response.body
    public_holidays.each do |date, name|
      JapanesePublicHoliday.find_or_create_by(date: date, name: name)
    end
  end

  private

  def connection
    Faraday.new(@base_url) do |f|
      f.request :json
      f.request :retry
      f.response :json
      f.adapter :net_http
    end
  end

end
