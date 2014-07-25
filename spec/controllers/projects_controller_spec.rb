require 'spec_helper'
describe ProjectsController do
  let (:project) { FactoryGirl.create(:project, user: @user) }
  let (:todo_params) { {title: 'New Title'} }
  before do
    @user = FactoryGirl.create(:user)
    sign_in @user
    FactoryGirl.create_list(:project, 3, user: @user)
    FactoryGirl.create_list(:finished_project, 1, user: @user)
    FactoryGirl.create_list(:trash_project, 1, user: @user)
  end
  describe 'GET#index' do
    before { xhr :get, :index, format:'json' }
    it 'responds with user projects' do
      projects = json
      expect(projects.count).to eq(5)
      expect(projects.first).to include('id', 'label', 'title', 'content', 'state', 'errors')
    end
  end

  describe 'GET#show' do

    context 'with correct id' do
      it 'returns a context' do
        req_project = @user.projects.first
        xhr :get, :show, id: req_project.id, format:'json'
        expect(response).to be_success
        project = json
        expect(project['id']).to eq(req_project.id)
        expect(project['label']).to eq(req_project.label)
      end
    end

    context 'with incorrect id' do
      it 'redirects to root path' do
        xhr :get, :show, :id => 'incorrect_context', format:'json'
        expect(response).to redirect_to(root_path)
      end
    end
  end

  describe 'update' do
    before do
      @project = project
    end
    context 'update the project' do
      subject { lambda { xhr :post, :update,
                             id: @project.id,
                             :project => {title: 'rspec title'} } }
      it do
        should_not change(@user.projects, :count)
        expect(json['title']).to eq('rspec title')
        expect(@project.reload.title).to eq('rspec title')
      end
    end
    context 'finish' do
      subject { lambda { xhr :patch, :change_state,
                             id: @project.id,
                             :project => {state: 'finished'}
                             }}
      it do
        should change(@user.projects.with_state('finished'), :count).by(1)
        expect(response).to redirect_to(projects_path)
      end
    end
  end
  describe '#destroy' do
    before do
      @project_to_destroy = project
    end
    context 'if statuses trash' do
      subject { lambda { xhr :delete, :destroy, :name => @project_to_destroy.name } }
      it do
        should change(@user.projects, :count).by(-1)
        expect(response).to redirect_to(projects_path)
      end
    end
  end

end

