Rails.application.config.middleware.use OmniAuth::Builder do
  provider :twitter, ENV["TWITTER_API_KEY"], ENV["TWITTER_API_SECRET"]
  provider :identity, fields: [:email],
                      on_failed_registration: IdentitiesController.action(:new),
                      model: User
end

module OmniAuth
  module Strategies
    class Identity
      def registration_phase
        IdentitiesController.action(:create).call(env)
      end
    end
  end
end