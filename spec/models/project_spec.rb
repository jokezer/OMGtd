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

  describe 'finish project' do
    pending 'should set all project todos as finished'
  end

  describe 'move project to trash' do
    pending 'should set all project todos as trash'
  end

end
