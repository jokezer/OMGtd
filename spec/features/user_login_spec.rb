require "spec_helper"

feature "User login and logout" do
  scenario "visit-login-logout" do
    visit new_user_session_path
    fill_in 'Email', :with => 'test@user.com'
    fill_in 'Password', :with => '12345678'
    click_button 'Sign in'
    expect(page).to have_link("test@user.com")
    expect(page).to have_link("Sign out")
    expect(page).not_to have_link("Sign in")
    #sign out
    click_link 'Sign out'
    expect(page).not_to have_link("Sign out")
    expect(page).to have_link("Sign in")
  end
end