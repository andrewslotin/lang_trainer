module HelperMethods
  def logged_in?
    page.has_no_content? "Sign in"
  end

  def login_with(provider, mock_options)
    if mock_options == :invalid_credentials
      OmniAuth.config.mock_auth[provider] = :invalid_credentials
    elsif mock_options
      OmniAuth.config.add_mock provider, mock_options
    end

    visit "/auth/#{provider}"
  end
end

RSpec.configuration.include HelperMethods, :type => :acceptance