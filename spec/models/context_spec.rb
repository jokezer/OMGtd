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

end
