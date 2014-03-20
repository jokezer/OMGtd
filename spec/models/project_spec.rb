require 'spec_helper'

describe Project do
  let(:user) { FactoryGirl.create(:user) }
  let(:todo) { FactoryGirl.create(:todo, user: user) }
  let(:project) { FactoryGirl.create(:project, user: user) }

  it { should respond_to(:user) }
  it { should respond_to(:todos) }
  it { should respond_to(:title) }
  it { should respond_to(:content) }
  it { should respond_to(:prior) }
  it { should respond_to(:expire) }
  it { should respond_to(:name) }
  it { should respond_to(:label) }
  it { should respond_to(:state) }

  describe 'create valid project' do
    specify do
      project = user.projects.create(title: 'Test project', content: 'Text of test todo')
      expect(project.name).to eq('Test_project')
      expect(project.label).to eq('#Test_project')
    end
  end

  describe 'make project from todo' do
    specify do
      count = user.todos.count
      todo = FactoryGirl.create(:todo, title: 'Project from title', user: user)
      expect { user.projects.make_from_todo todo }.to change(user.projects, :count).by(1)
      expect(user.projects.last.label).to eq('#Project_from_title')
      expect(user.todos.count).to eq(count)
    end
    it 'impossible to make project from todo that already belongs to project' do
      todo = FactoryGirl.create(:todo, title: 'Project from title',
                                project: project, user: user)
      count = user.todos.count
      expect { user.projects.make_from_todo todo }
      .not_to change(user.projects, :count)
      expect(user.todos.count).to eq(count)
    end
  end
  describe 'name and label' do
    it 'when name insert' do
      project = FactoryGirl.create(:project, title: 'When name insert',
                                   name: 'with name', user: user)
      expect(project.title).to eq('When name insert')
      expect(project.name).to eq('with_name')
    end
    it 'when name is blank' do
      project = FactoryGirl.create(:project, title: 'When name insert',
                                   name: '', user: user)
      expect(project.title).to eq('When name insert')
      expect(project.name).to eq('When_name_insert')
    end
  end

  it 'dependency check' do
    FactoryGirl.create_list(:todo, 3, user: user, project: project)
    expect { project.destroy }.to change(user.todos, :count).by(-3)
  end

  describe 'finite state machines' do
    before do
      @project = project
      FactoryGirl.create_list(:todo, 3, user: user, project: @project)
      FactoryGirl.create_list(:todo, 3, user: user, kind: 'next', project: @project)
      FactoryGirl.create_list(:todo, 3, user: user, kind: 'waiting', state: 'trash', project: @project)
    end
    it 'have 3 states' do
      expect(Project.state_machines[:state].states.count).to eq(3)
      expect(Project.state_machines[:state].states.map { |n| n.name })
      .to include(:active, :trash, :finished)
    end
    it 'can delete only trash and finished' do
      expect(project.can_delete?).to be_false
      project.finish
      expect(project.can_delete?).to be_true
      project.cancel
      expect(project.can_delete?).to be_true
    end
    it 'transitions scope' do
      #actice
      expect(project.can_activate?).to be_false
      expect(project.can_cancel?).to be_true
      expect(project.can_finish?).to be_true
      #trash
      project.cancel
      expect(project.can_activate?).to be_true
      expect(project.can_cancel?).to be_false
      expect(project.can_finish?).to be_false
      #actice
      project.finish
      expect(project.can_activate?).to be_true
      expect(project.can_cancel?).to be_false
      expect(project.can_finish?).to be_false
    end
    it '@project active by default' do
      expect(@project.state).to eq('active')
    end
    it 'cancel @project' do
      @project.cancel
      expect(@project.state).to eq('trash')
      expect(@project.todos.with_state('trash').count).to eq(9)
    end
    it 'finish @project' do
      @project.finish
      expect(@project.state).to eq('finished')
      expect(@project.todos.with_state('completed').count).to eq(9)
    end
    it 'activate @project' do
      @project.finish
      @project.activate
      expect(@project.state).to eq('active')
      expect(@project.todos.with_state('active').count).to eq(6)
    end
    it 'should be impossible to add todo to not active project' do
      pending 'do it'
      project.finish
      count = project.todos.count
      todo = FactoryGirl.create(:todo, user: user, project: project)
      expect{todo.project}.to be_nil
      expect(project.todos.count).to eq(count)
    end
  end
end
