class Book
  include Mongoid::Document

  field :author, type: String
  field :title, type: String

  attr_accessible :author, :title

  validates :title, presence: true

  belongs_to :dictionary
  embeds_many :chapters
  
  delegate :user, :lang, to: :dictionary, allow_nil: true

  def progress
    chapters.sum { |chapter| chapter.progress } / chapters.size
  end

  def ignore_word(word)
    chapters.each { |chapter| chapter.ignore_word word }
  end
end