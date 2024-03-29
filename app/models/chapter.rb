# -*- encoding : utf-8 -*-

class Chapter
  include Mongoid::Document

  field :title, type: String
  field :words_number, type: Integer, default: 0

  embedded_in :book
  embeds_many :entries, as: :source

  delegate :dictionary, to: :book

  def progress
    if words_number > 0
      1 - entries.sum { |entry| entry.frequency } / words_number.to_f
    else
      1
    end
  end

  def has_marked_entries?
    self.entries.marked.present?
  end

  def entries=(value)
    known_entries = value.to_a.select do |w|
      dictionary << w if dictionary[w.word].exists?
    end

    self[:entries] = value.to_a.reject do |w| 
      known_entries.include?(w) ||
      dictionary.ignored_words.include?(w.word)
    end.sort_by { |entry| -entry.frequency.to_i }

    self.words_number = value.sum { |entry| entry.frequency }
  end

  def ignore_word(word)
    entry = entries.where(word: word).first

    if entry
      self.inc(:words_number, -entry.frequency)
      entry.destroy
    end
  end

  def build_entries_from(text, case_sensitive = false)
    self.entries = text.gsub(/[^a-zäöüëßа-я'’\s-]/i, "").gsub(/\s+['’-]|['’-]\s+/, "")
                       .split(/\s+/)
                       .select { |w| w.present? }
                       .group_by { |w| case_sensitive ? w : Unicode::downcase(w) }
                       .map { |k, v| Entry.new(word: v.first, frequency: v.size) }
  end
end