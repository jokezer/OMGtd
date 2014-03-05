require 'spec_helper'

describe Todo do
  let(:user) { FactoryGirl.create(:user) }
  let(:todo) { FactoryGirl.create(:todo, user: user) }

  it { should respond_to(:title) }
  it { should respond_to(:content) }
  it { should respond_to(:user) }
  it { should respond_to(:status_id) }
  it { should respond_to(:status) }
  it { should respond_to(:prior_id) }
  it { should respond_to(:prior) }
  it { should respond_to(:expire) }
  #it { should respond_to(:project) }

  context 'with correct data' do
    specify do
      expect(todo).to be_valid
    end
  end

  context 'check order' do
    specify do
      FactoryGirl.create(:todo, user: user, title: 'First created todo')
      FactoryGirl.create(:todo, user: user, title: 'Last created todo')
      #user.todos.first.should == 'Last created todo'
      pending 'Fix default order in postgresql'
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

  describe 'Dependant check' do
    it 'Destroy user' do
      delete_user = FactoryGirl.create(:user, email: 'delete_user@email.ru')
      FactoryGirl.create(:todo, user: delete_user)
      expect { delete_user.destroy }.to change(Todo, :count).by(-1)
    end
  end

  describe 'scopes' do
    it 'Today scope' do
      FactoryGirl.create(:todo, title: 'First today deadline',
                         user: user,
                         expire: DateTime.now)
      FactoryGirl.create(:todo, status_id: TodoStatus.label_id(:next),
                         user: user,
                         expire: DateTime.now-1.hour)
      FactoryGirl.create(:todo, status_id: TodoStatus.label_id(:waiting),
                         title: 'Last created todo',
                         user: user,
                         expire: DateTime.now-1.week)
      user.todos.today.first.title.should == 'Last created todo'
      user.todos.today.last.title.should == 'First today deadline'
      user.todos.today.count.should == 3
    end
    it 'Tomorrow scope' do
      FactoryGirl.create(:todo, status_id: TodoStatus.label_id(:scheduled),
                         title: 'Tomorrow todo',
                         user: user,
                         expire: DateTime.now.tomorrow)
      user.todos.tomorrow.first.title.should == 'Tomorrow todo'
      user.todos.tomorrow.count.should == 1
    end
    it 'later or with no deadline' do
      FactoryGirl.create(:todo, status_id: TodoStatus.label_id(:scheduled),
                         title: 'Later todo',
                         user: user,
                         expire: DateTime.now + 2.days)
      user.todos.later_or_no_deadline.first.title.should == 'Later todo'
      user.todos.later_or_no_deadline.count.should == 1
    end
    it 'Canceled and completed actions dont included in today and tomorrow scopes' do
      FactoryGirl.create(:todo, status_id: TodoStatus.label_id(:trash),
                         user: user,
                         expire: DateTime.now.tomorrow)
      FactoryGirl.create(:todo, status_id: TodoStatus.label_id(:completed),
                         user: user,
                         expire: DateTime.now.tomorrow)
      FactoryGirl.create(:todo, status_id: TodoStatus.label_id(:trash),
                         user: user,
                         expire: DateTime.now)
      FactoryGirl.create(:todo, status_id: TodoStatus.label_id(:completed),
                         user: user,
                         expire: DateTime.now)
      user.todos.tomorrow.count.should == 0
      user.todos.today.count.should == 0
    end
  end

end