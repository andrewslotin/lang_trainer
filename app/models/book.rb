class Book
  include Mongoid::Document
  include Mongoid::Timestamps::Created

  paginates_per 25

  field :author, type: String
  field :title, type: String

  attr_accessible :author, :title

  validates :title, presence: true

  belongs_to :dictionary
  embeds_many :chapters
  
  delegate :user, :lang, to: :dictionary, allow_nil: true

  def created_at
    super || 10.years.ago
  end

  def progress
    unless chapters.empty?
      chapters.sum { |chapter| chapter.progress } / chapters.size
    end.to_f
  end

  def ignore_word(word)
    chapters.each { |chapter| chapter.ignore_word word }
  end
end