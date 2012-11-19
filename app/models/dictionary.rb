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
end