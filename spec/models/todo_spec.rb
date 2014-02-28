require 'spec_helper'

describe Todo do
  before(:all) do
    @user = FactoryGirl.create(:user)
  end
  after(:all) do
    @user.destroy
  end
  let(:todo) { FactoryGirl.create(:todo, user: @user) }

  it { should respond_to(:title) }
  it { should respond_to(:content) }
  it { should respond_to(:user) }
  it { should respond_to(:status_id) }
  it { should respond_to(:status) }
  it { should respond_to(:prior_id) }
  it { should respond_to(:prior) }
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
      todo.status_id = nil
      expect(todo).not_to be_valid
    end
    it 'with incorrect status' do
      todo.status_id = 0
      expect(todo).not_to be_valid
    end
    it 'without user on their own' do
      todo = Todo.new(title: 'Content of invalid todo', status_id: 1)
      expect(todo).not_to be_valid
    end
    it 'correct' do
      expect(todo).to be_valid
    end
  end

  describe "Dependant check" do
    it 'Destroy user' do
      delete_user = FactoryGirl.create(:user, email: 'delete_user@email.ru')
      FactoryGirl.create(:todo, user: delete_user)
      expect { delete_user.destroy }.to change(Todo, :count).by(-1)
    end
  end

end