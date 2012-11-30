module ApplicationHelper
  def format_percentage(value, precision = 0)
    "%0.#{precision}f%%" % (value * 100)
  end
end
