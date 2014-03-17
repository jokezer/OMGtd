require 'spec_helper'
describe TodosController do
  let (:todo) { FactoryGirl.create(:todo, user: @user) }
  let (:todo_params) { {title: 'New Title'} }
  before do
    @user = FactoryGirl.create(:user)
    sign_in @user
  end

  describe "GET index, show, new" do
    it "returns http success" do
      xhr :get, :index
      expect(response).to be_success
    end
    it 'new todo pass should render new template' do
      xhr :get, :show, :id => todo.id
      expect(response).to be_success
      expect(response).to render_template(:show)
    end
    it 'new todo pass should render new template' do
      xhr :get, :new
      expect(response).to be_success
      expect(response).to render_template(:new)
    end
  end

  describe "#create" do
    context "when create with correct data" do
      before do
        #Todoexpect().to_receive(:build)
        #.with({'title' => 'New Title'})
      end
      subject { lambda { xhr :post, :create, :todo => todo_params } }
      it do
        should change(@user.todos, :count).by(1)
        expect(response.status).to eq(302)
        expect(response).to redirect_to('/todos/filter/kind/inbox')
      end
    end
    context 'when try to create todo with incorrect data' do
      subject { lambda { xhr :post, :create, :todo => {title: '', status_id: 0} } }
      it do
        should_not change(@user.todos, :count)
        expect(response).to render_template(:new)
      end
    end
    context 'create project from todo' do
      pending 'create project from todo'
    end
  end

  describe '#update' do
    before do
      @todo_update = FactoryGirl.create(:todo, user: @user)
    end
    context 'when try to create todo with correct data' do
      subject { lambda { xhr :post, :update,
                             :id => @todo_update.id,
                             :todo => {title: 'rspec updated statuses',
                             } } }
      it do
        should_not change(@user.todos, :count)
        expect(response.status).to eq(302)
        expect(response).to redirect_to('http://test.host/todos/filter/kind/inbox')
        expect(@user.todos.order("updated_at").last.title).to eq('rspec updated statuses')
      end
    end
    context 'when try to create todo with incorrect data' do
      subject { lambda { xhr :post, :update,
                             :id => @todo_update.id,
                             :todo => {title: ''} } }
      it do
        should_not change(@user.todos, :count)
        expect(response).to render_template(:show)
      end
    end
  end

  describe '#destroy' do
    render_views
    before do
      @todo = FactoryGirl.create(:todo, user: @user)
      @todo_to_destroy = FactoryGirl.create(:todo, user: @user, state: :trash)
    end
    context 'if statuses inbox' do
      subject { lambda { xhr :delete, :destroy, :id => @todo.id } }
      it do
        should_not change(@user.todos, :count)
        expect(response).to redirect_to(root_path)
      end
    end
    context 'if statuses trash' do
      subject { lambda { xhr :delete, :destroy, :id => @todo_to_destroy.id } }
      it do
        should change(@user.todos, :count).by(-1)
        expect(response).to redirect_to(root_path)
      end
    end
  end

  describe "User scope" do
    before do
      @another_user = FactoryGirl.create(:user, email: 'another_user@email.tu')
      @todo = FactoryGirl.create(:todo, user: @another_user, state:'trash')
    end
    context 'one user try to delete another users todo' do
      subject { lambda { xhr :delete, :destroy, :id => @todo.id } }
      it do
        should_not change(Todo, :count)
        expect(response).to redirect_to(root_path)
      end
    end
    context 'one user try to see another users todo' do
      it do
        xhr :get, :show, :id => @todo.id
        expect(response).to_not render_template(:list)
        expect(response).to redirect_to(root_path)
      end
    end
    context 'one user try to update another users todo' do
      it do
        xhr :post, :update, :id => @todo.id
        expect(response).to_not render_template('list')
        expect(response).to redirect_to(root_path)
      end
    end
  end

  describe 'filter action' do
    before do
      FactoryGirl.create_list(:todo, 3, user: @user)
      FactoryGirl.create_list(:todo, 3, kind: 'next', user: @user)
      FactoryGirl.create_list(:todo, 3, kind: 'next', state: 'trash', user: @user)
    end
    it 'kind with correct label' do
      xhr :get, :filter, type: 'kind', label: 'inbox'
      expect(response).to render_template('list')
    end
    it 'state with correct label' do
      xhr :get, :filter, type: 'state', label: 'trash'
      expect(response).to render_template('list')
    end
    it 'kind with incorrect label' do
      xhr :get, :filter, type: 'kind', label: 'non_existed'
      expect(response).to redirect_to(root_path)
    end
    it 'state with incorrect label' do
      xhr :get, :filter, type: 'state', label: 'non_existed'
      expect(response).to redirect_to(root_path)
    end
  end

end
