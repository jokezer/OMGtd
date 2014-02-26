require 'spec_helper'

describe Todo do
  before(:all) do
    @user = FactoryGirl.create(:user)
  end
  after(:all) do
    @user.destroy
  end
  let(:todo) {FactoryGirl.create(:todo, user: @user)}

  it { should respond_to(:title) }
  it { should respond_to(:content) }
  it { should respond_to(:status) }
  it { should respond_to(:user) }
  #it { should respond_to(:context) }
  #it { should respond_to(:project) }

  context 'with correct data' do
    specify do
      expect(todo).to be_valid
    end
  end

  context 'with incorrect data' do
    it 'without title' do
      todo.title = nil
      expect(todo).not_to be_valid
    end
    it 'without status' do
      todo.status = nil
      expect(todo).not_to be_valid
    end
    it 'with incorrect status' do
      todo.status = 10
      expect(todo).not_to be_valid
    end
    it 'without user on their own' do
      todo = Todo.new(title: 'Content of invalid todo', status:1)
      expect(todo).not_to be_valid
    end
    it 'correct' do
      expect(todo).to be_valid
    end
  end
end