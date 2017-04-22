module DateHelper
  def humanize_date(date)
    date ? date.strftime('%d %B %Y') : 'Unknown'
  end

  def humanize_str_date(str)
    humanize_date(Date.parse(str))
  rescue StandardError
    return nil
  end
end
