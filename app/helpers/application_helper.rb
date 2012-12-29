require 'html/pipeline'

module ApplicationHelper
  def format_percentage(value, precision = 0)
    "%0.#{precision}f%%" % (value * 100)
  end

  def markdown(text)
    raw HTML::Pipeline::MarkdownFilter.new(text).call
  end
end
