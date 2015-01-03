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
  it { should respond_to(:due) }
  it { should respond_to(:name) }
  it { should respond_to(:label) }
  it { should respond_to(:state) }

  it 'create valid project' do
    project = user.projects.create(title: 'Test project', content: 'Text of test todo')
    expect(project.name).to eq('Test_project')
    expect(project.label).to eq('#Test_project')
  end

  context 'incorrect states' do
    it 'without user' do
      wrong_project = Project.new(title: '@Home')
      expect(wrong_project.valid?).to be_falsey
      expect(wrong_project.errors[:user].count).to eq(1)
    end

    it 'without title' do
      wrong_project = user.projects.new(title: '')
      expect(wrong_project.valid?).to be_falsey
      expect(wrong_project.errors[:title].count).to eq(1)
    end

    describe 'uniqueness in user scope' do
      let!(:user) { FactoryGirl.create(:user) }
      let!(:project) { FactoryGirl.create(:project, user: user, title: 'same') }

      it 'first context is valid' do
        expect(project).to be_valid
      end

      it 'second context with this name is invalid' do
        expect(user.projects.new(title: 'same').valid?).to be_falsey
      end

      it 'is register sensitive' do
        expect(user.projects.new(title: 'SAME').valid?).to be_falsey
      end

      it 'is works only in one user scope' do
        user2 = FactoryGirl.create(:user)
        project2 = FactoryGirl.create(:project, user: user2, name: project.name)
        expect(project2).to be_valid
      end
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

  context 'name and label' do
    it 'when name insert' do
      project = FactoryGirl.create(:project, title: 'When name insert',
                                   name: 'with name', user: user)
      expect(project.title).to eq('When name insert')
      expect(project.name).to eq('When_name_insert')
    end
    it 'when name is blank' do
      project = FactoryGirl.create(:project, title: 'When name insert',
                                   name: '', user: user)
      expect(project.title).to eq('When name insert')
      expect(project.name).to eq('When_name_insert')
    end
    it 'name cutting to 20 symbols' do
      project = FactoryGirl.create(:project, title: 'Project with very long title',
                                   name: '', user: user)
      expect(project.reload.name).to eq 'Project_with_very_lo'
    end
  end

  it 'dependency check' do
    FactoryGirl.create_list(:todo, 3, user: user, project: project)
    expect { project.destroy }.to change(user.todos, :count).by(-3)
  end

  context 'finite state machines' do
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
      expect(project.can_delete?).to be_falsey
      project.finish
      expect(project.can_delete?).to be_truthy
      project.cancel
      expect(project.can_delete?).to be_truthy
    end
    it 'transitions scope' do
      #actice
      expect(project.can_activate?).to be_falsey
      expect(project.can_cancel?).to be_truthy
      expect(project.can_finish?).to be_truthy
      #trash
      project.cancel
      expect(project.can_activate?).to be_truthy
      expect(project.can_cancel?).to be_falsey
      expect(project.can_finish?).to be_falsey
      #actice
      project.finish
      expect(project.can_activate?).to be_truthy
      expect(project.can_cancel?).to be_falsey
      expect(project.can_finish?).to be_falsey
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
  end
end
