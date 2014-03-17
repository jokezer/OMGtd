require 'spec_helper'

describe Context do
  let(:user) { FactoryGirl.create(:user) }
  let(:todo) { FactoryGirl.create(:todo, user: user) }

  it { should respond_to(:user) }
  it { should respond_to(:todos) }
  it { should respond_to(:name) }

  context 'Without user' do
    specify do
      wrong_context = Context.new(name: '@Home')
      expect(wrong_context).not_to be_valid
    end
  end

  context 'Without name' do
    specify do
      wrong_context = user.contexts.new(name: '')
      expect(wrong_context).not_to be_valid
    end
  end

  describe 'New created user should have 5 default contexts' do
    specify do
      user = FactoryGirl.create(:user)
      expect(user.contexts.count).to eq(5)
    end
    it 'works only if user does not have any contexts' do
      user = FactoryGirl.create(:user)
      user.contexts.create_defaults
      user.contexts.create_defaults
      expect(user.contexts.count).to eq(5) #not 10
    end
  end

  describe 'Deleting of context does not affect todos' do
    specify do
      context = user.contexts.first
      FactoryGirl.create_list(:todo, 3, user: user, context: context)
      expect(context.todos.count).to eq(3)
      expect { context.destroy }.to change(user.contexts, :count).by(-1)
      expect(user.todos.count).to eq(3)
      expect(user.todos.last.context_id).to be_nil
    end
  end

  describe 'found by_name test' do
    it 'should be case insensitive' do
      expect(user.contexts.by_name('home').id).to eq(user.contexts.by_name('HoMe').id)
    end
  end

  describe 'validate uniqueness' do
    specify do
      user = FactoryGirl.create(:user)
      context = FactoryGirl.create(:context, user: user, name: 'same')
      expect(context).to be_valid #first time @same context is valid
      expect(user.contexts.new(name: 'same')).to_not be_valid
      expect(user.contexts.new(name: 'SAME')).to_not be_valid
      user2 = FactoryGirl.create(:user)
      context = FactoryGirl.create(:context, user: user2, name: 'same')
      expect(context).to be_valid #uniqness works only in user scope
    end
  end

  describe 'check label' do
    specify do
      context = FactoryGirl.create(:context, user: user, name: 'label')
      expect(context.label).to eq('@label')
    end
  end

  describe 'spaces to underscore' do
    specify do
      context = FactoryGirl.create(:context, user: user, name: 'with few words')
      expect(context.reload.label).to eq('@with_few_words')
    end
  end

  describe 'check max length of todo' do
    specify do
      context = user.contexts.new(name: 'very very long context name')
      expect(context).to_not be_valid
    end
  end
end
