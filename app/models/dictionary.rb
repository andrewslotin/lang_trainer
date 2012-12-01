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
      existing_entry = entries.any_of({word: entry.word}, {:variants.in => [entry.word]}).first

      if existing_entry
        existing_entry.update_attributes frequency: existing_entry.frequency.to_i + entry.frequency.to_i,
                                         variants: (existing_entry.variants + entry.variants - [existing_entry.word]).uniq
      else
        self.entries.build entry.attributes
      end
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