class Identities
  class Common < ::Identity
    include OmniAuth::Identity::Models::Mongoid

    field :email, type: String
    field :password_digest, type: String
  end
end