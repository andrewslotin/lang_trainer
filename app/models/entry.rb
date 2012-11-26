require 'open-uri'

class Entry
  include Mongoid::Document

  field :word, type: String
  field :frequency, type: Integer, default: 0

  embedded_in :source, polymorphic: true, inverse_of: :entries

  validates :word, presence: true, uniqueness: true

  delegate :dictionary, to: :source

  def ignore!
    dictionary.ignore word

    dictionary.save &&
    (!source.is_a?(Chapter) || source.update_attribute(:words_count, source.words_count - frequency)) &&
    self.destroy
  end

  def translations
    url = "http://m.slovari.yandex.ru/search.xml?text=#{CGI::escape(word)}&lang=#{dictionary.lang}"

    Nokogiri::HTML(open(url).read).css('.b-translate .l1 a').map { |v| v.inner_text }
  end
end