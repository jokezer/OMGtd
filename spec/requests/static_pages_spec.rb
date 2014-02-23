#require 'spec_helper'
##devise helper methods does not work in request folder
#describe 'In all static pages' do
#  before do
#    @user = User.find_by(email:'test@email.com')
#    sign_in :user, @user
#  end
#  describe 'In root path' do
#    it 'it should render home template' do
#      get root_path
#      expect(response).to be_success
#      #expect(response).to render_template(:home)
#    end
#  end
#  describe 'In about path' do
#    it 'it should render about template' do
#      get about_path
#      expect(response).to be_success
#      #expect(response).to render_template(:about)
#    end
#  end
#end
