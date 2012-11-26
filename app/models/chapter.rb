# -*- encoding : utf-8 -*-

class Chapter
  include Mongoid::Document

  field :title, type: String
  field :words_number, type: Integer, default: 0

  embedded_in :book
  embeds_many :entries, as: :source

  delegate :dictionary, to: :book

  def progress
    1 - entries.sum { |entry| entry.frequency } / words_number
  end

  def entries=(value)
    known_entries = value.to_a.select do |w|
      dictionary << w if dictionary.entries.where(word: w.word).exists?
    end

    self[:entries] = value.to_a.reject do |w| 
      known_entries.include?(w) ||
      dictionary.ignored_words.include?(w.word)
    end.sort_by { |entry| -entry.frequency.to_i }

    self.words_number = value.sum { |entry| entry.frequency }
  end

  def ignore_word(word)
    entry = entries.find_by(word: word)

    if entry
      self.inc(:words_number, -entry.frequency)
      entry.destroy
    end
  end

  def self.build_entries(text)
    text.gsub(/[^a-zäöüëßа-я'’\s-]/i, "").gsub(/\s+['’-]|['’-]\s+/, "")
        .split(/\s+/)
        .group_by { |w| Unicode::downcase(w) }
        .map { |k, v| Entry.new(word: v.first, frequency: v.size) }
  end
end