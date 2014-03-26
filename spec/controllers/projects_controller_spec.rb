require 'spec_helper'
describe ProjectsController do
  let (:project) { FactoryGirl.create(:project, user: @user) }
  let (:todo_params) { {title: 'New Title'} }
  before do
    @user = FactoryGirl.create(:user)
    sign_in @user
  end
  describe "GET index, show" do
    it "returns http success" do
      xhr :get, :index
      expect(response).to be_success
    end
    it 'new todo pass should render new template' do
      xhr :get, :show, :name => project.name
      expect(response).to be_success
      expect(response).to render_template(:show)
    end
  end
  describe 'update' do
    before do
      @project = project
    end
    context 'update the project' do
      subject { lambda { xhr :post, :update,
                             name: @project.id,
                             :project => {title: 'rspec title'} } }
      it do
        should_not change(@user.projects, :count)
        expect(response.status).to eq(200)
        expect(@project.reload.title).to eq('rspec title')
      end
    end
    context 'finish' do
      subject { lambda { xhr :post, :update,
                             name: @project.id,
                             finish: true,
                             :project => {title: 'finished title'} } }
      it do
        should change(@user.projects.with_state('finished'), :count).by(1)
        expect(response.status).to eq(200)
        expect(@project.reload.title).to eq('finished title')
      end
    end
    context 'cancel' do
      subject { lambda { xhr :post, :update,
                             name: @project.id,
                             cancel: true,
                             :project => {title: 'canceled title'} } }
      it do
        should change(@user.projects.with_state('trash'), :count).by(1)
        expect(response.status).to eq(200)
        expect(@project.reload.title).to eq('canceled title')
      end
    end
    context 'activate' do
      before do
        @project.finish
      end
      subject { lambda { xhr :post, :update,
                             name: @project.id,
                             activate: true,
                             :project => {title: 'activated title'} } }
      it do
        should change(@user.projects.with_state('active'), :count).by(1)
        expect(response.status).to eq(200)
        expect(@project.reload.title).to eq('activated title')
      end
    end
    context 'activate' do
      before do
        @project.finish
      end
      subject { lambda { xhr :post, :update,
                             name: @project.id,
                             cancel: true,
                             :project => {title: 'wrong title'} } }
      it do
        should_not change(@user.projects.with_state('finished'), :count)
        expect(response.status).to eq(200)
        expect(@project.reload.title).to eq('wrong title')
      end
    end
  end
  describe '#destroy' do
    before do
      @project_to_destroy = project
    end
    context 'if statuses trash' do
      subject { lambda { xhr :delete, :destroy, :name => @project_to_destroy.id } }
      it do
        should change(@user.projects, :count).by(-1)
        expect(response).to redirect_to(projects_path)
      end
    end
  end
end

