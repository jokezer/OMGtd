require 'spec_helper'
feature 'Todos CRUD actions' do
  let (:user) { FactoryGirl.create(:user) }
  let (:todo) { FactoryGirl.create(:todo, user: user) }
  before do
    sign_in_capybara(user)
  end
  scenario 'Check new form' do
    user.projects.destroy_all
    visit todos_path
    click_on 'Create new'
    expect(page).to have_selector("input[type=text][id='todo_title'][name='todo[title]']")
    expect(page).to have_selector("select[id='todo_kind'][name='todo[kind]']")
    expect(page).to have_selector("select[id='todo_prior'][name='todo[prior]']")
    expect(page).not_to have_selector("select[id='todo_project_id'][name='todo[project_id]']")
    expect(page).to have_selector("select[id='todo_context_id'][name='todo[context_id]']")
    expect(page).to have_selector("input[type=submit][value='Create todo']")
    expect(page).to have_selector("input[type=submit][value='Make project']")
    expect(page).to have_selector("option[value='']")
    expect(page).to have_selector("option[value='next']")
    #without data
    expect { click_on 'Create todo' }.not_to change(Todo, :count)
    expect(page).to have_content('can\'t be blank')
    #with data
    fill_in 'Title', :with => 'Test todo from feature test'
    select('next', :from => 'Kind')
    expect { click_on 'Create todo' }.to change(user.todos, :count).by(1)
    expect(page).to have_content('Todo created!')
    expect(page).to have_content('Test todo from feature test')
  end
  scenario 'Check edit form' do
    todo.update_attributes(kind: 'next')
    visit todo_path(todo)
    #expect(page).not_to have_selector("option[value='']") find by name
    expect(page).to have_selector("option[value='next']")
  end
  scenario 'Change kinds' do
    visit todo_path(todo)
    select('next', :from => 'Kind')
    expect { click_on 'Save changes' }
    .to change(user.todos.with_kind(:next), :count).by(1)
  end
  scenario 'Change context' do
    visit todo_path(todo)
    select('@Errands', :from => 'Context')
    expect { click_on 'Save changes' }
    .to change(user.contexts.find_by_name('Errands').todos, :count).by(1)
    expect(todo.reload.context.name).to eq('Errands')
  end
  scenario 'Change prior' do
    visit todo_path(todo)
    select('high', :from => 'Prior')
    click_on 'Save changes'
    expect(todo.reload.prior).to eq('high')
  end
  scenario 'Edit todo' do
    visit todo_path(todo)
    fill_in 'Title', :with => 'Changed title from feature test'
    fill_in 'Content', :with => 'Changed content from feature test'
    click_on 'Save changes'
    expect(page).to have_content('Todo updated!')
    visit todo_path(todo)
    expect(page).to have_selector("input[type=text][value='Changed title from feature test']")
    expect(page).to have_selector('textarea', text: 'Changed content from feature test')
    expect(todo.reload.due).to be_nil
  end
  scenario 'Delete button presence' do
    trash_todo = FactoryGirl.create(:todo, user: user, state: 'trash')
    completed_todo = FactoryGirl.create(:todo, user: user, state: 'completed')
    visit todo_path(trash_todo)
    expect(page).to have_link('Delete')
    visit todo_path(completed_todo)
    expect(page).to have_link('Delete')
    visit todo_path(todo) #inbox as default
    expect(page).not_to have_link('Delete')
  end
  scenario 'if user does n’t have contexts' do
    user.contexts.destroy_all
    visit todo_path(todo)
    expect(page).not_to have_selector("select[id='todo_context_id'][name='todo[context_id]']")
    expect(page).to have_link('Create contexts')
    expect(page).to have_content('There is no contexts')
  end
  scenario 'if has projects, he can choose' do
    project = FactoryGirl.create(:project, user: user)
    visit todo_path(todo)
    expect(page).to have_selector("select[id='todo_project_id'][name='todo[project_id]']")
    expect(page).to have_selector("option[value='#{project.id}']")
  end
  scenario 'Set project' do
    FactoryGirl.create(:project, title: 'Set project', user: user)
    visit todo_path(todo)
    select('#Set_project', :from => 'Project')
    expect { click_on 'Save changes' }
    .to change(user.projects.find_by_name('Set_project').todos, :count).by(1)
    expect(todo.reload.project.name).to eq('Set_project')
  end
  scenario 'create new todo from kind' do
    visit root_path
    click_on('waiting')
    click_on('Create new')
    expect(page).to have_select('Kind', :selected => 'waiting')
  end
  scenario 'edit todo with kind' do
    todo = FactoryGirl.create(:todo, user: user, kind: 'next')
    visit todo_path todo
    expect(page).to have_select('Kind', :selected => 'next')
  end
  scenario 'create todo from project' do
    project = FactoryGirl.create(:project, title: 'Set project', user: user)
    visit project_path project.name
    click_on('Create new')
    expect(page).to have_select('Project', :selected => project.label)
  end
  scenario 'edit todo from context' do
    visit root_path
    click_on '@Home'
    click_on 'Create new'
    expect(page).to have_select('Context', :selected => '@Home')
  end
  scenario 'create todo with project' do
    project = FactoryGirl.create(:project, title: 'Set project', user: user)
    todo = FactoryGirl.create(:todo, user: user, project: project)
    visit todo_path todo
    expect(page).to have_select('Project', :selected => project.label)
  end
  scenario 'edit todo with context' do
    context = user.contexts.first
    todo = FactoryGirl.create(:todo, user: user, context: context)
    visit todo_path todo
    expect(page).to have_select('Context', :selected => context.label)
  end
  scenario 'create todo from today, tomorrow paths' do
    pending 'todos should have date inserted'
  end
end

feature 'finite machines' do
  let (:user) { FactoryGirl.create(:user) }
  let (:todo) { FactoryGirl.create(:todo, user: user) }
  before do
    sign_in_capybara(user)
  end
  scenario 'Complete todo' do
    todo = FactoryGirl.create(:todo, user: user, kind: 'next')
    visit todo_path todo
    expect(page).not_to have_selector("input[type=submit][value='Activate']")
    expect { click_on('Complete') }.to change(user.todos.with_state('completed'),
                                              :count).by(1)
  end
  scenario 'Cancel todo' do
    todo = FactoryGirl.create(:todo, user: user, kind: 'next')
    visit todo_path todo
    expect(page).not_to have_selector("input[type=submit][value='Activate']")
    expect { click_on('Cancel') }.to change(user.todos.with_state('trash'),
                                            :count).by(1)
  end
  scenario 'Activate todo' do
    todo = FactoryGirl.create(:todo, user: user, kind: 'next')
    todo.cancel
    visit todo_path todo
    expect(page).not_to have_selector("input[type=submit][value='Complete']")
    expect(page).not_to have_selector("input[type=submit][value='Cancel']")
    expect { click_on('Activate') }.to change(user.todos.with_state('active'),
                                              :count).by(1)
  end
  scenario 'Complete todo' do
    todo = FactoryGirl.create(:todo, user: user)
    visit todo_path todo
    expect(page).not_to have_selector("input[type=submit][value='Activate']")
  end
end

feature 'Scheduled todo' do
  let (:user) { FactoryGirl.create(:user) }
  let (:todo) { FactoryGirl.create(:todo, user: user) }
  before do
    sign_in_capybara(user)
  end
  scenario 'Set deadline' do
    visit todo_path(todo)
    find(:css, "#todo_is_deadline[value='1']").set(true)
    fill_in 'Title', :with => 'With deadline'
    click_on 'Save changes'
    expect(todo.reload.due).to_not be_nil
  end
  scenario 'create scheduled todo without deadline' do
    visit new_todo_path
    select('scheduled', :from => 'Kind')
    fill_in 'Title', :with => 'Scheduled without deadline'
    expect { click_on 'Create todo' }.not_to change(Todo, :count)
    expect(page).to have_content('Deadline is required!')
  end
  scenario 'deadline selected if due is set' do
    visit todo_path(todo)
    find(:css, "#todo_is_deadline").should_not be_checked
    todo_deadline = FactoryGirl.create(:todo, user: user, due: DateTime.now)
    visit todo_path(todo_deadline)
    find(:css, "#todo_is_deadline").should be_checked
  end
end

feature 'Quick add' do
  let (:user) { FactoryGirl.create(:user) }
  let (:todo) { FactoryGirl.create(:todo, user: user) }
  before do
    sign_in_capybara(user)
  end
  scenario 'Quick add inbox todo' do
    visit root_path
    fill_in 'Add todo', with: 'Some text'
    expect { click_on 'Add' }.to change(user.todos.with_state(:inbox), :count).by(1)
  end
end