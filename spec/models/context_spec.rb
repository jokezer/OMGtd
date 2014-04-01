require 'spec_helper'

describe Context do

  let(:user) { FactoryGirl.create(:user) }
  let(:todo) { FactoryGirl.create(:todo, user: user) }

  it { should respond_to(:user) }
  it { should respond_to(:todos) }
  it { should respond_to(:name) }

  it 'correct context' do
    context = FactoryGirl.create(:context, user: user, name: 'New one')
    expect(context).to be_valid
  end
  context 'incorrect states' do
    it 'without user' do
      wrong_context = Context.new(name: '@Home')
      expect(wrong_context).to have(1).errors_on(:user)
    end

    it 'without name' do
      wrong_context = user.contexts.new(name: '')
      expect(wrong_context).to have(1).errors_on(:name)
    end
    it 'uniqueness in user scope' do
      user = FactoryGirl.create(:user)
      context = FactoryGirl.create(:context, user: user, name: 'same')
      expect(context).to be_valid #first time @same context is valid
      expect(user.contexts.new(name: 'same')).to have(1).errors_on(:name)
      expect(user.contexts.new(name: 'SAME')).to have(1).errors_on(:name)
      user2 = FactoryGirl.create(:user)
      context = FactoryGirl.create(:context, user: user2, name: 'same')
      expect(context).to be_valid #uniqness works only in user scope
    end
    it 'check max length of todo' do
      context = user.contexts.new(name: 'very very long context name')
      expect(context).to have(1).errors_on(:name)
    end
  end

  it 'New created user should have 5 default contexts' do
    user = FactoryGirl.create(:user)
    expect(user.contexts.count).to eq(5)
  end


  it 'Deleting of context does not affect todos' do
    context = user.contexts.first
    FactoryGirl.create_list(:todo, 3, user: user, context: context)
    expect(context.todos.count).to eq(3)
    expect { context.destroy }.to change(user.contexts, :count).by(-1)
    expect(user.todos.count).to eq(3)
    expect(user.todos.last.context_id).to be_nil
  end

  it 'found by_name should be case insensitive' do
    expect(user.contexts.by_name('home').id).to eq(user.contexts.by_name('HoMe').id)
  end

  it 'check label' do
    context = FactoryGirl.create(:context, user: user, name: 'label')
    expect(context.label).to eq('@label')
  end

  it 'spaces to underscore' do
    context = FactoryGirl.create(:context, user: user, name: 'with few words')
    expect(context.reload.label).to eq('@with_few_words')
  end

  it 'check max quantity of contexts' do
    expect(user.contexts.count).to eq 5
    context = user.contexts.create(name: '6th context')
    expect(context).to be_valid
    context2 = user.contexts.create(name: '7th context')
    expect(context2).not_to be_valid
    expect(context2.errors[:name]).to include 'Maximum 6 contexts allowed'
  end

end
