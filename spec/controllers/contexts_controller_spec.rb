require 'spec_helper'

describe ContextsController do

  before do
    @user = FactoryGirl.create(:user)
    sign_in @user
  end

  describe 'GET#index' do
    before { xhr :get, :index }
    it 'render index template' do
      expect(response).to be_success
      expect(response).to render_template(:index)
    end
    it 'assigns user contexts' do
      expect(assigns(:contexts)).to eq @user.contexts.ordering
    end
  end

  describe 'GET#new' do
    it 'render new template' do
      xhr :get, :new
      expect(response).to be_success
      expect(response).to render_template(:edit)
    end
  end

  describe 'GET#show' do

    context 'with correct context' do
      it 'render list template' do
        xhr :get, :show, :name => @user.contexts.first.name
        expect(response).to be_success
        expect(response).to render_template('todos/list')
      end
    end

    context 'with incorrect context' do
      it 'redirects to root path' do
        xhr :get, :show, :name => 'incorrect_context'
        expect(response).to redirect_to(root_path)
      end
    end

  end

  describe 'POST#create' do
    context 'with correct data' do
      before do
        @new_context_request = lambda { xhr :post, :create, :context => {:name => 'context'} }
      end
      it 'save context to db' do
        expect { @new_context_request.call }
        .to change(@user.contexts, :count).by(1)
      end
      it 'redirects to contexts path' do
        @new_context_request.call
        expect(response.status).to eq(302)
        expect(response).to redirect_to(contexts_path)
      end
    end
    context 'with incorrect data' do
      before do
        @new_context_request = lambda { xhr :post, :create, :context => {:name => ''} }
      end
      it 'not save context to db' do
        expect { @new_context_request.call }
        .not_to change(@user.todos, :count)
      end
      it 'render edit template' do
        @new_context_request.call
        expect(response).to render_template(:edit)
      end
    end
  end

  describe 'PATCH#update' do
    before do
      @context = @user.contexts.first
      @context_request = lambda { |name='Correct'| xhr :patch, :update,
                                               :name => @context.id,
                                               :context => {:name => name} }
    end
    context 'with correct data' do
      it 'dont change contexts quantity' do
        expect { @context_request.call }.not_to change(@user.contexts, :count)
      end
      it 'redirects to context path' do
        @context_request.call
        expect(response.status).to eq(302)
        expect(response).to redirect_to(contexts_path)
      end
      it 'updates the context name' do
        @context_request.call
        expect(@user.contexts.first.name).to eq('Correct')
      end

    end
    context 'when try to create todo with incorrect data' do
      subject { lambda { xhr :post, :update,
                             :name => @context.id,
                             :context => {:name => ''} } }
      it do
        should_not change(@user.contexts, :count)
        expect(response).to render_template(:edit)
      end
    end
  end

  describe '#destroy' do
    render_views
    before do
      @context_to_destroy = FactoryGirl.create(:context, user: @user, name: 'to_delete')
    end
    context 'if statuses trash' do
      subject { lambda { xhr :delete, :destroy, :name => @context_to_destroy.id } }
      it do
        should change(@user.contexts, :count).by(-1)
        expect(response).to redirect_to(contexts_path)
      end
    end
  end


end
