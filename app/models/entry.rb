require 'open-uri'

class Entry
  include Mongoid::Document

  paginates_per 25

  field :word, type: String
  field :frequency, type: Integer, default: 0
  field :variants, type: Array, default: []
  field :notes, type: String, default: ""
  field :marked, type: Boolean, default: false

  embedded_in :source, polymorphic: true, inverse_of: :entries

  validates :word, presence: true, uniqueness: true

  before_validation :preserve_word_in_variants

  scope :marked, where(marked: true)

  def merge(entry)
    self.frequency += entry.frequency
    self.variants = (self.variants + entry.variants + [entry.word] - [self.word]).uniq
    self.notes += "\n#{entry.notes}"

    self
  end

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

  def mark!
    if source.is_a? Chapter
      self.marked = true
      self.save
    end
  end

  def unmark!
    if source.is_a? Chapter
      self.marked = false
      self.save
    end
  end

  protected

  def preserve_word_in_variants
    if self.word_changed? && self.word_was.present? && ! self.variants.include?(self.word_was)
      self.variants << self.word_was
      self.variants.delete self.word
    end

    true
  end
end