module DateHelper
  def humanize_date(date)
    date.strftime("%B %d, %Y")
  end
end
