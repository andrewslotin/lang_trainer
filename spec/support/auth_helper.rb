module AuthHelper
  def sign_in_with_omniauth(user)
    OmniAuth.config.add_mock user.provider.to_sym, { uid: user.uid }
    request.env["omniauth.auth"] = OmniAuth.config.mock_auth[user.provider.to_sym]

    visit "/auth/#{user.provider}"
  end
end