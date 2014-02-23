require "spec_helper"

describe "User requests" do

  it "root path before login" do
    get root_path
    expect(response).to redirect_to(new_user_session_path)
  end
#login test in spec/features/user_login_spec.rb
end