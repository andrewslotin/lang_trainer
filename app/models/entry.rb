require 'open-uri'

class Entry
  include Mongoid::Document

  field :word, type: String
  field :frequency, type: Integer, default: 0
  field :variants, type: Array, default: []

  embedded_in :source, polymorphic: true, inverse_of: :entries

  validates :word, presence: true, uniqueness: true

  before_validation :preserve_word_in_variants

  def dictionary
    if source.is_a? Dictionary
      source
    else
      source.dictionary
    end
  end

  def lang
    dictionary.lang
  end

  def translations
    url = "http://m.slovari.yandex.ru/search.xml?text=#{CGI::escape(word)}&lang=#{dictionary.lang}"

    Nokogiri::HTML(open(url).read).css('.b-translate .l1 a').map { |v| v.inner_text }
  end

  protected

  def preserve_word_in_variants
    self.variants << self.word_was if self.word_changed? && self.word_was.present? && ! self.variants.include?(self.word_was)

    true
  end
end