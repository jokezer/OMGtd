require "spec_helper"
feature "User login and logout" do
  before(:all) do
    @user = FactoryGirl.create(:user)
    sign_in_capybara(@user)
  end
  after(:all) do
    @user.destroy
  end
  scenario "visit-login-logout" do
    expect(page).to have_link(@user.email)
    expect(page).to have_link("Sign out")
    expect(page).not_to have_link("Sign in")
    #sign out
    click_on 'Sign out'
    expect(page).not_to have_link("Sign out")
    expect(page).to have_link("Sign in")
  end
end