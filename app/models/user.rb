class User
  include Mongoid::Document

  field :name,  type: String
  field :email, type: String
  attr_accessible :provider, :uid, :name

  has_many :dictionaries, dependent: :destroy
  embeds_many :identities

  def self.create_with_omniauth(auth)
    identity = { 
      provider: auth['provider'], 
      uid: auth['uid'],
      password: auth['password'],
      password_confirmation: auth['password_confirmation']
    }

    auth['info'] ||= {}

    self.create do |u|
      u.name = auth['info']['name']
      u.email = auth['info']['email']
      u.identities = [identity]
    end
  end

  def self.authenticate(key, password)
    user = where("identities.email" => key).first
    if user
      user.identities.select { |i| i.provider == :identity && i.authenticate(password) }.first
    end
  end
end