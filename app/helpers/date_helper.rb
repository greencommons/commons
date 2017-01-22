module DateHelper
  def humanize_date(date)
    date ? date.strftime('%B %d, %Y') : 'Unknown'
  end

  def humanize_str_date(str)
    begin
      humanize_date(Date.parse(str))
    rescue StandardError => e
      return nil
    end
  end
end
