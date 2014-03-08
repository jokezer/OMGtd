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
      user.contexts.count.should == 5
    end
    it 'works only if user does not have any contexts' do
      user = FactoryGirl.create(:user)
      user.contexts.create_defaults
      user.contexts.create_defaults
      user.contexts.count.should == 5 #not 10
    end
  end

  describe 'Deleting of context does not affect todos' do
    specify do
      context = user.contexts.first
      FactoryGirl.create_list(:todo, 3, user: user, context: context)
      expect{ context.destroy }.to change(user.contexts, :count).by(-1)
      user.todos.count.should == 3
    end
  end

  describe 'found by_name test' do
    it 'should be case insensitive' do
      user.contexts.by_name('@home').id.should == user.contexts.by_name('@HoMe').id
    end
  end

  describe 'validate uniqueness' do
    specify do
      user = FactoryGirl.create(:user)
      context = FactoryGirl.create(:context, user:user, name:'same')
      context.should be_valid #first time @same context is valid
      context = FactoryGirl.create(:context, user:user, name:'same')
      context.should_not be_valid #second time it not valid because uniqueness
      user2 = FactoryGirl.create(:user)
      context = FactoryGirl.create(:context, user:user2, name:'same')
      context.should be_valid #uniqness works only in user scope
    end
  end

end
