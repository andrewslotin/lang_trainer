class Book
  include Mongoid::Document

  field :author, type: String
  field :title, type: String

  attr_accessible :author, :title

  validates :title, presence: true, uniqueness: { scope: :author }

  belongs_to :dictionary
  embeds_many :chapters
  
  delegate :user, :lang, to: :dictionary, allow_nil: true
end