require 'spec_helper'

describe TodosController, type: :controller do
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

describe TodosController, type: :controller do
  let (:todo) { FactoryGirl.create(:todo, user: @user) }
  before do
    @user = FactoryGirl.create(:user)
    @request.env["devise.mapping"] = Devise.mappings[:user]
    sign_in @user
  end

  describe 'GET#index' do
    it 'json request responds with array of todos' do
      FactoryGirl.create(:todo, user: @user)
      get :index, format: 'json'
      todos = json
      expect(todos.count).to eq(@user.todos.count)
      expect(todos.first.keys).to include('id', 'title', 'content', 'state')
      expect(todos.first['id']).to eq(@user.todos.first.id)
    end
  end

  describe 'GET#show' do
    it 'returns a json todo object' do
      xhr :get, :show, :id => todo.id, format: 'json'
      json_todo = json
      expect(json_todo['id']).to eq(todo.id)
      expect(json_todo['title']).to eq(todo.title)
    end
  end

  # describe 'GET#new' do
  #
  #   it 'render new template' do
  #     xhr :get, :new
  #     expect(response).to be_success
  #     expect(response).to render_template(:new)
  #   end
  #   it 'assigns a new Todo instance' do
  #     xhr :get, :new
  #     expect(assigns(:todo)).to be_a_new Todo
  #   end
  # end

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
        expect(json['id']).to eq(@user.todos.last.id)
      end
    end
    context 'with incorrect data' do
      it 'dont save todo to db' do
        expect { post :create, todo: {title: ''}, format: :json }
        .not_to change(@user.todos, :count)
      end
      it 'responds with todo with errors array' do
        post :create, todo: {title: ''}, format: :json
        errors = json['errors']
        expect(errors).to include('title')
        expect(errors.count).to eq(1)
      end
      it 'with incorrect prior' do
        todo = FactoryGirl.attributes_for(:todo, user: @user)
        todo['prior'] = nil
        xhr :post, :create, todo: todo
        expect(json['prior']).to eq(0)
      end
    end
    pending 'create project from todo' do
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
      @update_request = lambda { |todo_attr|
        xhr :patch, :update, format:'json',
            :id => @todo_update.id,
            :todo => todo_attr
      }
    end
    context 'with correct data' do
      it 'not change count of todos' do
        expect { @update_request.call(FactoryGirl.attributes_for(:next_todo, title: 'rspec updated statuses')) }
        .not_to change(@user.todos, :count)
      end
      it 'returns an updated todo' do
        @update_request.call(FactoryGirl.attributes_for(:next_todo, title: 'rspec updated statuses'))
        expect(response.status).to eq(200)
        expect(json['title']).to eq('rspec updated statuses')
      end
      it 'updates a todo in db' do
        @update_request.call(FactoryGirl.attributes_for(:next_todo, title: 'rspec updated statuses'))
        expect(@user.todos.last.title).to eq('rspec updated statuses')
      end
    end
    context 'with incorrect data' do
      it 'not change count of todos' do
        expect { @update_request.call(FactoryGirl.attributes_for(:next_todo, title: '')) }
        .not_to change(@user.todos, :count)
      end
      it 'responds with todo with errors array' do
        post :create, todo: {title: ''}, format: :json
        errors = json['errors']
        expect(errors).to include('title')
        expect(errors.count).to eq(1)
      end
    end
    pending 'create project from todo' do

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
    pending 'move todo to trash' do
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
    before do
      @todo = FactoryGirl.create(:todo, user: @user)
      @todo_to_destroy = FactoryGirl.create(:todo, user: @user, state: :trash)
    end
    context 'if statuses inbox' do
      subject { lambda { xhr :delete, :destroy, format:'json', :id => @todo.id } }
      it do
        should_not change(@user.todos, :count)
        expect(response.body).to eq('false')
      end
    end
    context 'if statuses trash' do
      subject { lambda { xhr :delete, :destroy, format:'json', :id => @todo_to_destroy.id } }
      it do
        should change(@user.todos, :count).by(-1)
        expect(json['id']).to eq(@todo_to_destroy.id)
      end
    end
  end

  describe "User scope" do
    before do
      @another_user = FactoryGirl.create(:user, email: 'another_user@email.tu')
      @todo = FactoryGirl.create(:todo, user: @another_user, state: 'trash')
    end
    context 'one user try to delete another users todo' do
      subject { lambda { xhr :delete, :destroy, format:'json', :id => @todo.id } }
      it do
        should_not change(Todo, :count)
        expect(response).to redirect_to(root_path)
      end
    end
    context 'one user try to see another users todo' do
      it do
        xhr :get, :show, format:'json', :id => @todo.id
        expect(response).to_not render_template(:filter)
        expect(response).to redirect_to(root_path)
      end
    end
    context 'one user try to update another users todo' do
      it do
        xhr :post, :update, format:'json', :id => @todo.id
        expect(response).to_not render_template('list')
        expect(response).to redirect_to(root_path)
      end
    end
  end

  pending 'filter action' do
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

  pending 'change prior' do
    it 'should increase todos prior' do
      xhr :patch, :change_prior, id: todo.id, increase_prior: ''
      expect(todo.reload.prior_name).to eq :low
    end
  end
end


