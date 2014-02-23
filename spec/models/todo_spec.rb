require 'spec_helper'

describe Todo do
  before(:all) do
    @user = User.create(name: "Example User", email: "correct@email.com")
  end

  it { should respond_to(:title) }
  it { should respond_to(:content) }
  it { should respond_to(:user) }
  #it { should respond_to(:type) }
  #it { should respond_to(:context) }
  #it { should respond_to(:project) }

  describe 'should be valid' do
    it 'with correct data' do
      #todo = @user.todos.new(title: 'Title', content: 'Content of invalid todo')
      #expect(todo).to be_valid
    end
  end

  describe 'should be invalid' do
    it 'without title' do
      todo = @user.todos.new(content: 'Content of invalid todo')
      expect(todo).not_to be_valid
    end
    it 'without user on their own' do
      todo = Todo.new(content: 'Content of invalid todo')
      expect(todo).not_to be_valid
    end
  end


  after(:all) do
    @user.destroy
  end
end