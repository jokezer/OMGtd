require 'spec_helper'
describe 'In all static pages' do
  describe 'In root path' do
    before do
      get root_path
    end
    it 'it should render home template' do
      expect(response).to be_success
      expect(response).to render_template(:home)
    end
  end
  describe 'In about path' do
    before { get about_path }
    it 'it should render about template' do
      expect(response).to be_success
      expect(response).to render_template(:about)
    end
  end
end
