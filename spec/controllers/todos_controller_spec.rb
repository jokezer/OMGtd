require 'spec_helper'

describe TodosController do
  let (:todo) { FactoryGirl.create(:todo, user: @user) }
  let (:todo_params) { {'title' => 'New Title', 'status' => 1} }
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
        response.should redirect_to('http://test.host/todos/status/inbox')
      end
    end

    context 'when try to create todo with incorrect data' do
      subject { lambda { xhr :post, :create, :todo => {'title' => '', 'status' => 0} } }
      it do
        should_not change(@user.todos, :count).by(1)
        response.should render_template(:new)
      end
    end
  end

  describe '#show' do
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
      subject { lambda { xhr :post, :update, :id => @todo_update.id, :todo => {'title' => 'rspec updated status', 'status' => 1} } }
      it do
        should_not change(@user.todos, :count)
        response.status.should == 302
        response.should redirect_to('http://test.host/todos/status/inbox')
        @user.todos.order("updated_at").last.title.should == 'rspec updated status'
      end
    end
    context 'when try to create todo with incorrect data' do
      subject { lambda { xhr :post, :update, :id => @todo_update.id, :todo => {'title' => '', 'status' => 1} } }
      it do
        should_not change(@user.todos, :count)
        response.should render_template(:show)
      end
    end
  end

  describe '#destroy' do
    render_views
    before do
      @todo = FactoryGirl.create(:todo, user: @user)
      @todo_to_destroy = FactoryGirl.create(:todo, user: @user, status: Todo.status_label_id(:trash))
    end
    context 'if status inbox' do
      subject { lambda { xhr :delete, :destroy, :id => @todo.id } }
      it do
        should_not change(@user.todos, :count)
        response.should redirect_to(root_path)
      end
    end
    context 'if status trash' do
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
      @todo = FactoryGirl.create(:todo, user: @another_user, status: Todo.status_label_id(:trash))
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
        response.should_not render_template('show')
        response.should redirect_to(root_path)
      end
    end
    context 'one user try to update another users todo' do
      it do
        xhr :post, :update, :id => @todo.id
        response.should_not render_template('show')
        response.should redirect_to(root_path)
      end
    end
  end

end
