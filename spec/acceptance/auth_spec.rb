require 'acceptance/acceptance_helper'

feature 'Authorization', %q{
  In order to access dictionaries
  As a user
  I want to authorize myself
} do
  let!(:user) { FactoryGirl.create :twitter_user }

  scenario "authorization with twitter" do
    login_with :twitter, uid: user.uid, info: { name: user.name }

    visit dictionaries_path

    expect(logged_in?).to be_true
  end

end
