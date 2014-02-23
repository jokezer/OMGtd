require 'spec_helper'

describe TodosController do
  before do
    @user = User.find_by(email:'test@user.com')
    sign_in @user
  end
  describe "GET 'all'" do
    it "returns http success" do
      get 'all'
      response.should be_success
    end
  end

  describe "GET 'new'" do
    it "returns http success" do
      get 'new'
      response.should be_success
    end
  end

  describe "GET 'edit'" do
    it "returns http success" do
      get 'edit'
      response.should be_success
    end
  end

end
