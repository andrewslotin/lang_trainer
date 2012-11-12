class Dictionary
  include Mongoid::Document

  field :lang, type: String

  attr_accessible :lang

  belongs_to :user
  embeds_many :entries

  validates :lang, presence: true, uniqueness: true
end