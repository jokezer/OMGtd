require 'spec_helper'

describe TodosController do
  let (:todo) { FactoryGirl.create(:todo, user: @user) }
  let (:todo_params) { {'title' => 'New Title', 'status_id' => 1} }
  before do
    @user = FactoryGirl.create(:user)
    sign_in @user
  end

  describe "GET index" do
    it "returns http success" do
      xhr :get, :index
      response.should be_success
    end
  end

  describe 'new' do
    it 'new todo pass should render new template' do
      xhr :get, :new
      response.should be_success
      response.should render_template('new')
    end
  end

  describe "#create" do

    context "when create with correct data" do
      before do
        #Todo.should_receive(:build)
        #.with({'title' => 'New Title'})
      end
      subject { lambda { xhr :post, :create, :todo => todo_params } }
      it do
        should change(@user.todos, :count).by(1)
        response.status.should == 302
        response.should redirect_to('http://test.host/todos/statuses/inbox')
      end
    end

    context 'when try to create todo with incorrect data' do
      subject { lambda { xhr :post, :create, :todo => {'title' => '', 'status_id' => 0} } }
      it do
        should_not change(@user.todos, :count).by(1)
        response.should render_template(:new)
      end
    end
  end

  describe '#get' do
    it 'new todo pass should render new template' do
      xhr :get, :show, :id => todo.id
      response.should be_success
      response.should render_template(:show)
    end
  end
  describe '#update' do
    before do
      @todo_update = FactoryGirl.create(:todo, user: @user)
    end
    context 'when try to create todo with correct data' do
      subject { lambda { xhr :post, :update,
                             :id => @todo_update.id,
                             :todo => {'title' => 'rspec updated statuses',
                                       'status_id' => 1} } }
      it do
        should_not change(@user.todos, :count)
        response.status.should == 302
        response.should redirect_to('http://test.host/todos/statuses/inbox')
        @user.todos.order("updated_at").last.title.should == 'rspec updated statuses'
      end
    end
    context 'when try to create todo with incorrect data' do
      subject { lambda { xhr :post, :update,
                             :id => @todo_update.id,
                             :todo => {'title' => '', 'statuses' => 1} } }
      it do
        should_not change(@user.todos, :count)
        response.should render_template(:new)
      end
    end
  end

  describe '#destroy' do
    render_views
    before do
      @todo = FactoryGirl.create(:todo, user: @user)
      @todo_to_destroy = FactoryGirl.create(:todo, user: @user, status_id: TodoStatus.label_id(:trash))
    end
    context 'if statuses inbox' do
      subject { lambda { xhr :delete, :destroy, :id => @todo.id } }
      it do
        should_not change(@user.todos, :count)
        response.should redirect_to(root_path)
      end
    end
    context 'if statuses trash' do
      subject { lambda { xhr :delete, :destroy, :id => @todo_to_destroy.id } }
      it do
        should change(@user.todos, :count).by(-1)
        response.should redirect_to(root_path)
      end
    end
  end

  describe "User scope" do
    before do
      @another_user = FactoryGirl.create(:user, email: 'another_user@email.tu')
      @todo = FactoryGirl.create(:todo, user: @another_user, status_id: TodoStatus.label_id(:trash))
    end
    context 'one user try to delete another users todo' do
      subject { lambda { xhr :delete, :destroy, :id => @todo.id } }
      it do
        should_not change(Todo, :count)
        response.should redirect_to(root_path)
      end
    end
    context 'one user try to see another users todo' do
      it do
        xhr :get, :show, :id => @todo.id
        response.should_not render_template(:list)
        response.should redirect_to(root_path)
      end
    end
    context 'one user try to update another users todo' do
      it do
        xhr :post, :update, :id => @todo.id
        response.should_not render_template('list')
        response.should redirect_to(root_path)
      end
    end
  end

end
