require 'spec_helper'

describe ContextsController do

  before do
    @user = FactoryGirl.create(:user)
    sign_in @user
  end

  describe 'GET index' do
    it 'returns http success' do
      xhr :get, :index
      response.should be_success
    end
  end

  describe 'new' do
    it 'new todo pass should render new template' do
      xhr :get, :new
      response.should be_success
      response.should render_template(:edit)
    end
  end

  describe '#create' do

    context 'when create with correct data' do
      subject { lambda { xhr :post, :create, :context => {:name => 'context'} } }
      it do
        should change(@user.contexts, :count).by(1)
        response.status.should == 302
        response.should redirect_to(contexts_path)
      end
    end
    context 'when try to create todo with incorrect data' do
      subject { lambda { xhr :post, :create, :context => {:name => ''} } }
      it do
        should_not change(@user.todos, :count)
        response.should render_template(:edit)
      end
    end
  end

  describe '#show' do
    it 'with correct context' do
      xhr :get, :show, :label => @user.contexts.first.label
      response.should be_success
      response.should render_template('todos/list')
    end
    it 'with incorrect context' do
      xhr :get, :show, :label => 'incorrect_context'
      response.should redirect_to(root_path)
    end
  end

  describe '#update' do
    before do
      @context = @user.contexts.first
    end
    context 'when try to create todo with correct data' do
      subject { lambda { xhr :post, :update,
                             :label => @context.id,
                             :context => {:name => 'Correct'} } }
      it do
        should_not change(@user.contexts, :count)
        response.status.should == 302
        response.should redirect_to(contexts_path)
        @user.contexts.first.name.should == 'Correct'
      end
    end
    context 'when try to create todo with incorrect data' do
      subject { lambda { xhr :post, :update,
                             :label => @context.id,
                             :context => {:name => ''} } }
      it do
        should_not change(@user.contexts, :count)
        response.should render_template(:edit)
      end
    end
  end

  describe '#destroy' do
    render_views
    before do
      @context_to_destroy = FactoryGirl.create(:context, user: @user, name: 'to_delete')
    end
    context 'if statuses trash' do
      subject { lambda { xhr :delete, :destroy, :label => @context_to_destroy.id } }
      it do
        should change(@user.contexts, :count).by(-1)
        response.should redirect_to(contexts_path)
      end
    end
  end


end
