class Chapter
  include Mongoid::Document

  field :title, type: String

  embedded_in :book
  embeds_many :entries, as: :source

  delegate :dictionary, to: :book

  def entries=(value)
    self[:entries] = value.to_a.reject do |w| 
      dictionary.entries.where(word: w.word).exists? ||
      dictionary.ignored_words.include?(w.word)
    end.sort_by { |entry| -entry.frequency.to_i }
  end

  def self.build_entries(text)
    text.gsub(/[,"'.:;!?\d@#\$%\^&*()\\\/-]/, "")
        .split(/\s+/)
        .group_by { |w| Unicode::downcase(w) }
        .map { |k, v| Entry.new(word: v.first, frequency: v.size) }
  end
end