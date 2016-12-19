module DateHelper
  def humanize_date(date)
    date ? date.strftime('%B %d, %Y') : 'Unknown'
  end
end
