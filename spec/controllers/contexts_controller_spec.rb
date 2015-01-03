require 'spec_helper'

describe ContextsController do

  before do
    @user = FactoryGirl.create(:user)
    sign_in @user
  end

  describe 'GET#index' do
    before { xhr :get, :index, format:'json' }
    it 'render index template' do
      contexts = json
      expect(contexts.count).to eq(@user.contexts.count)
      expect(contexts.first).to include('id', 'label', 'errors')
    end
  end

  describe 'GET#show' do

    context 'with correct context' do
      xit 'returns a context' do
        req_context = @user.contexts.first
        xhr :get, :show, id: req_context.id, format:'json'
        expect(response).to be_success
        context = json
        expect(context['id']).to eq(req_context.id)
        expect(context['label']).to eq(req_context.label)
      end
    end

    context 'with incorrect context' do
      xit 'redirects to root path' do
        xhr :get, :show, :id => 'incorrect_context', format:'json'
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
      it 'responds with new context' do
        @new_context_request.call
        context = json
        expect(response).to be_success
        expect(context['label']).to eq('@context')
      end
    end
    context 'with incorrect data' do
      before do
        @new_context_request = lambda { xhr :post, :create, :context => {:name => ''}}
      end
      it 'not save context to db' do
        expect { @new_context_request.call }
        .not_to change(@user.todos, :count)
      end
      it 'returns context with error array' do
        @new_context_request.call
        errors = json['errors']
        expect(errors).to include('name')
        expect(errors.count).to eq(1)
      end
    end
  end

  describe 'PATCH#update' do
    before do
      @context = @user.contexts.first
      @context_request = lambda { |name='Correct'| xhr :patch, :update,
                                               :id => @context.id,
                                               :context => {:name => name} }
    end
    context 'with correct data' do
      it 'dont change contexts quantity' do
        expect { @context_request.call }.not_to change(@user.contexts, :count)
      end
      it 'responds with new context' do
        @context_request.call
        updated_context = json
        expect(response).to be_success
        expect(updated_context['id']).to eq(@context['id'])
        expect(updated_context['label']).to eq('@Correct')
      end
      it 'updates the db' do
        @context_request.call
        expect(@user.contexts.first.name).to eq('Correct')
      end

    end
    context 'when try to create todo with incorrect data' do
      subject { lambda { xhr :post, :update,
                             :id => @context.id,
                             :context => {:name => ''} } }
      it do
        should_not change(@user.contexts, :count)
        errors = json['errors']
        expect(errors).to include('name')
        expect(errors.count).to eq(1)
      end
    end
  end

  describe '#destroy' do
    # render_views
    before do
      @context_to_destroy = FactoryGirl.create(:context, user: @user, name: 'to_delete')
    end
    context 'if statuses trash' do
      subject { lambda { xhr :delete, :destroy, :id => @context_to_destroy.id } }
      it do
        should change(@user.contexts, :count).by(-1)
        expect(response).to redirect_to(contexts_path)
      end
    end
  end


end
