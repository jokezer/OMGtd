require 'spec_helper'

describe Todo do
  let(:user) { FactoryGirl.create(:user) }
  let(:todo) { FactoryGirl.create(:todo, user: user) }
  let(:project) { FactoryGirl.create(:project, user: user) }

  it { should respond_to(:title) }
  it { should respond_to(:content) }
  it { should respond_to(:user) }
  it { should respond_to(:state) }
  it { should respond_to(:kind) }
  it { should respond_to(:prior) }
  it { should respond_to(:due) }
  it { should respond_to(:context) }
  it { should respond_to(:project) }
  it { should respond_to(:interval) }
  it 'with correct data' do
    expect(todo).to be_valid
  end

  context 'check order' do
    specify do
      #pending 'Fix default order in postgresql'
      FactoryGirl.create(:todo, user: user, title: 'First created todo')
      FactoryGirl.create(:todo, user: user, title: 'Last created todo')
      #user.todos.firstexpect().to eq()'Last created todo'
    end
  end
  context 'with incorrect data' do
    it 'without title' do
      todo.title = nil
      expect(todo).to have(1).errors_on(:title)
    end
    it 'with incorrect statuses' do
      todo.state = 'incorrect'
      expect(todo).to have(1).errors_on(:state)
    end
    it 'without user on their own' do
      todo = Todo.new(title: 'Content of invalid todo')
      expect(todo).not_to be_valid
    end
  end

  it 'Destroy user' do
    delete_user = FactoryGirl.create(:user, email: 'delete_user@email.ru')
    FactoryGirl.create(:todo, user: delete_user)
    expect { delete_user.destroy }.to change(Todo, :count).by(-1)
  end

  context 'scopes' do
    it 'Today scope' do
      FactoryGirl.create(:scheduled_todo,
                         title: 'First today deadline',
                         user: user)
      FactoryGirl.create(:next_todo,
                         user: user,
                         due: DateTime.now-1.hour)
      FactoryGirl.create(:waiting_todo,
                         title: 'Last created todo',
                         user: user,
                         due: DateTime.now-1.week)
      expect(user.todos.today.first.title).to eq('Last created todo')
      expect(user.todos.today.last.title).to eq('First today deadline')
      expect(user.todos.today.count).to eq(3)
    end
    it 'Tomorrow scope' do
      FactoryGirl.create(:scheduled_todo,
                         title: 'Tomorrow todo',
                         user: user,
                         due: DateTime.now.tomorrow)
      expect(user.todos.tomorrow.first.title).to eq('Tomorrow todo')
      expect(user.todos.tomorrow.count).to eq(1)
    end
    it 'This week scope' do
      FactoryGirl.create(:scheduled_todo,
                         title: 'Weekly todo',
                         user: user,
                         due: DateTime.now + 5.days)
      expect(user.todos.weekly.first.title).to eq('Weekly todo')
      expect(user.todos.weekly.count).to eq(1)
    end
    it 'later or with no deadline' do
      FactoryGirl.create(:scheduled_todo,
                         title: 'Later todo',
                         user: user,
                         due: DateTime.now + 3.days)
      expect(user.todos.later_or_no_deadline.first.title).to eq('Later todo')
      expect(user.todos.later_or_no_deadline.count).to eq(1)
    end
  end

  context 'finite state machines test' do
    it 'have 4 states' do
      expect(Todo.state_machines[:state].states.count).to eq(4)
      expect(Todo.state_machines[:state].states.map { |n| n.name })
      .to include(:inbox, :active, :trash, :completed)
    end
    it 'have 6 kinds' do
      expect(Todo.state_machines[:kind].states.count).to eq(6)
      expect(Todo.state_machines[:kind].states.map { |n| n.name })
      .to include(nil, :scheduled, :someday, :next, :cycled, :waiting)
    end
    it 'initial state check' do
      expect(todo.state).to eq('inbox')
      expect(todo.kind).to eq(nil)
      expect(todo.state_name).to eq(:inbox)
      expect(todo.kind_name).to eq(nil)
    end
    it 'with predefined kind it should have state active' do
      active_todo = FactoryGirl.create(:todo, user: user, kind: 'next')
      expect(active_todo.kind).to eq('next')
      expect(active_todo.state).to eq('active')
    end
    it 'events test' do
      todo = FactoryGirl.create(:next_todo, user: user)
      todo.cancel
      expect(todo.state).to eq('trash')
      expect(todo.kind).to eq('next')
      expect(todo.can_complete?).to be_false
      expect(todo.can_cancel?).to be_false
      expect(todo.can_activate?).to be_true
      todo.activate
      todo.complete
      expect(todo.state).to eq('completed')
      expect(todo.kind).to eq('next')
      expect(todo.can_complete?).to be_false
      expect(todo.can_cancel?).to be_false
      expect(todo.can_activate?).to be_true
      todo.activate
      expect(todo.state).to eq('active')
      expect(todo.kind).to eq('next')
      expect(todo.can_complete?).to be_true
      expect(todo.can_cancel?).to be_true
      expect(todo.can_activate?).to be_false
    end
    it 'make state active after update' do
      todo.update_attributes(title: 'Make active')
      expect(todo.state).to eq('inbox')
      todo.update_attributes(kind: 'next')
      expect(todo.state).to eq('active')
    end
    it 'should be impossible to set kind inbox to not new state todo' do
      todo = FactoryGirl.create(:next_todo)
      todo.update_attributes(kind: 'inbox')
      expect(todo.reload.kind).to eq('next')
    end
    it 'should be impossible to set state new to not inbox kind todo' do
      todo = FactoryGirl.create(:next_todo)
      todo.update_attributes(state: 'new')
      expect(todo.reload.kind).to eq('next')
      expect(todo.reload.state).to eq('active')
    end
    # it 'incorrect filter test' do
    #   expect(user.todos.filter(:state, :incorrect)).to be_false
    #   expect(user.todos.filter(:incorrect, :incorrect)).to be_false
    # end
  end

  context 'user scopes' do
    it 'context scope' do
      another_user = FactoryGirl.create(:user, email: 'another@user.tu')
      another_context = another_user.contexts.first
      expect(user.id).not_to eq(another_user.id)
      todo = user.todos.new(title: 'title', context: another_context)
      expect(todo).not_to be_valid
    end
    it 'project scope' do
      another_user = FactoryGirl.create(:user, email: 'another@user.tu')
      another_project = FactoryGirl.create(:project, name: 'Other user project1',
                                           user: another_user)
      todo = user.todos.new(title: 'title', project_id: another_project.id)
      expect(todo).not_to be_valid
    end
  end

  context 'special todos features' do
    it 'scheduled without deadline' do
      todo = user.todos.new(title: 'Title of scheduled', kind: 'scheduled')
      expect(todo).to_not be_valid
    end
    it 'cycled with deadline' do
      todo = user.todos.new(title: 'Title of scheduled', kind: 'cycled',
                            due: DateTime.now)
      expect(todo).to be_valid
    end
  end

  context 'Cycled todos intervals' do
    it 'has the interval states' do
      expect(Todo.state_machines[:interval].states.map { |n| n.name })
      .to include(nil, :weekly, :monthly)
    end
    it 'sets interval to monthly if no interval inserted' do
      cycled_todo = user.todos.create(title: 'Title of scheduled', kind: 'cycled',
                                   due: DateTime.now)
      expect(cycled_todo.interval).to eq('monthly')
    end
    it 'sets interval to inserted' do
      cycled_todo = user.todos.create(title: 'Title of scheduled', kind: 'cycled',
                                   due: DateTime.now, interval: 'weekly')
      expect(cycled_todo.interval).to eq('weekly')
    end
    it 'sets interval to monthly if interval is incorrect' do
      cycled_todo = user.todos.create(title: 'Title of scheduled', kind: 'cycled',
                                   due: DateTime.now, interval: 'incorrect')
      expect(cycled_todo.interval).to eq('monthly')
    end
    it 'has nil interval if not cycled' do
      scheduled_todo = FactoryGirl.create(:scheduled_todo, user: user, interval:'monthly')
      expect(scheduled_todo.interval).to be_nil
    end
    it 'reactivate todo when completed' do
      due = DateTime.now
      cycled_todo = FactoryGirl.create(:cycled_todo, user: user, due:due)
      cycled_todo.update_attributes(state:'completed', kind:'cycled')
      expect(cycled_todo.state).to eq('active')
      expect(cycled_todo.due.month).to eq((due+1.month).month)
    end
  end

end