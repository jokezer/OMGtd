require 'spec_helper'

describe TodosController do
  before do
    @user = FactoryGirl.create(:user)
  end
  describe 'GET#index unauthorised user' do
    it 'render index template' do
      xhr :get, :index
      expect(response.status).to eq(401)
    end
  end

  describe "POST#create unauthorised user" do

    context "with correct data" do
      it 'should save todo to database' do
        expect { xhr :post, :create,
                     todo: FactoryGirl.attributes_for(:todo, user: @user) }
        .not_to change(@user.todos, :count)
      end
      it 'should redirect to state/inbox collection' do
        xhr :post, :create,
            todo: FactoryGirl.attributes_for(:todo, user: @user)
        expect(response.status).to eq(401)
      end
    end
  end
end

describe TodosController do
  let (:todo) { FactoryGirl.create(:todo, user: @user) }
  before do
    @user = FactoryGirl.create(:user)
    sign_in @user
  end

  describe 'GET#index' do
    render_views
    it 'render index template' do
      xhr :get, :index
      expect(response).to be_success
      expect(response).to render_template(:index)
    end
    it 'json request respond with array of todos' do
      FactoryGirl.create(:todo, user: @user)
      xhr :get, :index, format: 'json'
      expect(response.body).to eq @user.todos.ordering.to_json(
                                      methods: [:kind_label, :prior_name,
                                                :schedule_label])
    end
  end

  describe 'GET#show' do
    it 'render show' do
      xhr :get, :show, :id => todo.id
      expect(response).to be_success
      expect(response).to render_template(:show)
    end
    it 'get a todo object' do
      xhr :get, :show, :id => todo.id
      expect(assigns(:todo)).to eq todo
    end
  end

  describe 'GET#new' do

    it 'render new template' do
      xhr :get, :new
      expect(response).to be_success
      expect(response).to render_template(:new)
    end
    it 'assigns a new Todo instance' do
      xhr :get, :new
      expect(assigns(:todo)).to be_a_new Todo
    end
  end

  describe "POST#create" do

    context "with correct data" do
      it 'should save todo to database' do
        expect { xhr :post, :create, format:'json',
                     todo: FactoryGirl.attributes_for(:todo, user: @user) }
        .to change(@user.todos, :count).by(1)
      end
      it 'should respond with created todo' do
        xhr :post, :create, format:'json',
            todo: FactoryGirl.attributes_for(:todo, user: @user)
        expect(response.status).to eq(200)
        expect(response.body).to eq(@user.todos.last.to_json)
      end
    end
    context 'with incorrect data' do
      it 'dont save todo to db' do
        expect { xhr :post, :create, :todo => {title: ''} }
        .not_to change(@user.todos, :count)
      end
      it 'render the new template' do
        xhr :post, :create, :todo => {title: ''}
        expect(response).to render_template(:new)
      end
    end
    context 'create project from todo' do
      before do
        @count = @user.todos.count
        @project_request = lambda { xhr :post, :create,
                                        :todo => {title: 'Project'},
                                        make_project: 'Make project' }
      end
      it 'create new project' do
        expect { @project_request.call }.to change(@user.projects, :count).by(1)
      end
      it 'do not change todo count' do
        expect { @project_request.call }.not_to change(@user.todos, :count)
      end
      it 'redirects to projects path' do
        @project_request.call
        expect(response.status).to eq(302)
        expect(response).to redirect_to(projects_path)
      end
    end
  end

  describe 'PATCH#update' do
    before do
      @todo_update = FactoryGirl.create(:todo, user: @user)
      @update_request = lambda { |todo_attr, submit = :submit|
        xhr :patch, :update,
            :id => @todo_update.id,
            :todo => todo_attr,
            submit => true
      }
    end
    context 'with correct data' do
      it 'not change count of todos' do
        expect { @update_request.call(FactoryGirl.attributes_for(:next_todo, title: 'rspec updated statuses')) }
        .not_to change(@user.todos, :count)
      end
      it 'redirects to next filter' do
        @update_request.call(FactoryGirl.attributes_for(:next_todo, title: 'rspec updated statuses'))
        expect(response.status).to eq(302)
        expect(response).to redirect_to('http://test.host/todos/filter/kind/next')
      end
      it 'todo becomes updated' do
        @update_request.call(FactoryGirl.attributes_for(:next_todo, title: 'rspec updated statuses'))
        expect(@user.todos.order('updated_at').last.title)
        .to eq('rspec updated statuses')
      end
    end
    context 'with incorrect data' do
      it 'not change count of todos' do
        expect { @update_request.call(FactoryGirl.attributes_for(:next_todo, title: '')) }
        .not_to change(@user.todos, :count)
      end
      it 'render show template' do
        @update_request.call(FactoryGirl.attributes_for(:next_todo, title: ''))
        expect(response).to render_template(:show)
      end
    end
    context 'create project from todo' do

      it 'create new project' do
        expect { @update_request.call(FactoryGirl.attributes_for(:next_todo), :make_project) }
        .to change(@user.projects, :count).by(1)
      end
      it 'does not change todos count' do
        expect { @update_request.call(FactoryGirl.attributes_for(:next_todo), :make_project) }
        .to change(@user.todos, :count).by(-1)
      end
      it 'redirects to projects path' do
        @update_request.call(FactoryGirl.attributes_for(:next_todo), :make_project)
        expect(response.status).to eq(302)
        expect(response).to redirect_to(projects_path)
      end
    end
    context 'move todo to trash' do
      it 'move todo to trash' do
        expect { @update_request.call(FactoryGirl.attributes_for(:next_todo), :cancel) }
        .to change(@user.todos.with_state(:trash), :count).by(1)
      end
      it 'redirects to trash collection' do
        @update_request.call(FactoryGirl.attributes_for(:next_todo), :cancel)
        expect(response.status).to eq(302)
        expect(response).to redirect_to('http://test.host/todos/filter/state/trash')
      end
    end
  end

  describe 'DELETE#destroy' do
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
      @todo = FactoryGirl.create(:todo, user: @another_user, state: 'trash')
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
      xhr :get, :filter, type: 'state', type_name: 'inbox'
      expect(response).to render_template('list')
    end
    it 'state with correct label' do
      xhr :get, :filter, type: 'state', type_name: 'trash'
      expect(response).to render_template('list')
    end
    it 'kind with incorrect label' do
      xhr :get, :filter, type: 'kind', type_name: 'non_existed'
      expect(response).to redirect_to(root_path)
    end
    it 'state with incorrect label' do
      xhr :get, :filter, type: 'state', type_name: 'non_existed'
      expect(response).to redirect_to(root_path)
    end
  end

  describe 'change prior' do
    it 'should increase todos prior' do
      xhr :patch, :change_prior, id: todo.id, increase_prior: ''
      expect(todo.reload.prior_name).to eq :low
    end
  end
end


