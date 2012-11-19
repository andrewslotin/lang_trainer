class User
  include Mongoid::Document

  field :provider, type: String
  field :uid,      type: String
  field :name,     type: String
  attr_accessible :provider, :uid, :name

  has_many :dictionaries

  def self.create_with_omniauth(auth)
    auth['info'] ||= {}

    options = {
        provider: auth['provider'],
        uid: auth['uid'],
        name: auth['info']['name'],
        email: auth['info']['email']
    }

    self.create(options)
  end
end