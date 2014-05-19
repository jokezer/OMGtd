require 'spec_helper'
describe ProjectsController do
  let (:project) { FactoryGirl.create(:project, user: @user) }
  let (:todo_params) { {title: 'New Title'} }
  before do
    @user = FactoryGirl.create(:user)
    sign_in @user
  end
  describe "GET index, show, edit, filter" do
    it "returns http success" do
      xhr :get, :index
      expect(response).to be_success
    end
    it 'responds with current user projects' do
      xhr :get, :show, :name => project.name
      expect(response).to be_success
      expect(response).to render_template(:show)
    end
    it "returns http success" do
      xhr :get, :edit, :name => project.name
      expect(response).to be_success
    end
    # it "returns http success" do
    #   xhr :get, :filter, :name => project.name, type:'kind', type_name:'next'
    #   expect(response).to be_success
    # end
  end
  describe 'update' do
    before do
      @project = project
    end
    context 'update the project' do
      subject { lambda { xhr :post, :update,
                             name: @project.name,
                             :project => {title: 'rspec title'} } }
      it do
        should_not change(@user.projects, :count)
        expect(response).to redirect_to(project_path @project.name)
        expect(@project.reload.title).to eq('rspec title')
      end
    end
    context 'finish' do
      subject { lambda { xhr :patch, :change_state,
                             name: @project.name,
                             finish: true
                             }}
      it do
        should change(@user.projects.with_state('finished'), :count).by(1)
        expect(response).to redirect_to(projects_path)
      end
    end
    context 'cancel' do
      subject { lambda { xhr :post, :change_state,
                             name: @project.name,
                             cancel: true
                             } }
      it do
        should change(@user.projects.with_state('trash'), :count).by(1)
        expect(response).to redirect_to(projects_path)
      end
    end
    context 'activate' do
      before do
        @project.finish
      end
      subject { lambda { xhr :patch, :change_state,
                             name: @project.name,
                             activate: true
                             } }
      it do
        should change(@user.projects.with_state('active'), :count).by(1)
        expect(response).to redirect_to(projects_path)
      end
    end
    context 'try to cancel finished' do
      before do
        @project.finish
      end
      subject { lambda { xhr :post, :change_state,
                             name: @project.id,
                             cancel: true
                             } }
      it do
        should_not change(@user.projects.with_state('finished'), :count)
        expect(response).to redirect_to(root_path)
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

