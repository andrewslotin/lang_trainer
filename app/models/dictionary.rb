class Dictionary
  include Mongoid::Document

  field :title, type: String
  field :lang, type: String
  field :ignored_words, type: Array, default: []

  belongs_to :user
  has_many :books, dependent: :destroy
  embeds_many :entries, as: :source

  validates :lang, presence: true
  validates :title, presence: true, uniqueness: { scope: :lang }

  def <<(entry)
    unless ignored_words.include? entry.word
      existing_entry = entries.where(word: entry.word).first

      if existing_entry
        existing_entry.update_attribute(:frequency, existing_entry.frequency.to_i + entry.frequency.to_i)
      else
        self.entries.build entry.attributes
      end

      self.save
    end
  end

  def ignore_word(word)
    unless ignored_words.include? word
      self.class.collection.where(_id: self._id).update(
          "$push" => { ignored_words: word },
          "$pull" => { entries: { word: word }}
      )

      books.each { |book| book.ignore_word word }
    end
  end
end