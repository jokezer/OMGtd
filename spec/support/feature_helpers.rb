module FeatureHelpers
  def sign_in_capybara(user, password = 'foobar88')
    visit new_user_session_path
    fill_in 'Email', :with => user.email
    fill_in 'Password', :with => password
    click_button 'Sign in'
  end
end
RSpec.configure do |c|
  c.include FeatureHelpers
end