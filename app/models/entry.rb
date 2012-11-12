class Entry
  include Mongoid::Document

  field :word, type: String
  field :meaning, type: String

  embedded_in :dictionary

  validates :word, presence: true, uniqueness: true
  validates :meaning, presence: true
end