require 'spec_helper'

describe TodosController do
  before do
    @user = User.find_by(email:'test@user.com')
    sign_in @user
  end

  describe "GET 'all'" do
    it "returns http success" do
      get 'index'
      response.should be_success
    end
  end

end
