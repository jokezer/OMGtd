require 'spec_helper'
feature 'Todos CRUD actions' do
  let (:user) { FactoryGirl.create(:user) }
  let (:todo) { FactoryGirl.create(:todo, user: user) }
  scenario 'Check form' do
    sign_in_capybara(user)
    user.projects.destroy_all
    visit todos_path
    click_on 'Create new'
    expect(page).to have_selector("input[type=text][id='todo_title'][name='todo[title]']")
    expect(page).to have_selector("select[id='todo_status_id'][name='todo[status_id]']")
    expect(page).to have_selector("select[id='todo_prior_id'][name='todo[prior_id]']")
    expect(page).not_to have_selector("select[id='todo_project_id'][name='todo[project_id]']")
    expect(page).to have_selector("select[id='todo_context_id'][name='todo[context_id]']")
    expect(page).to have_selector("input[type=submit][value='Create todo']")
    #without data
    expect { click_on 'Create todo' }.not_to change(Todo, :count)
    page.should have_content('can\'t be blank')
    #with data
    fill_in 'Title', :with => 'Test todo from feature test'
    select('next', :from => 'Status')
    expect { click_on 'Create todo' }.to change(user.todos, :count).by(1)
    page.should have_content('Todo created!')
    page.should have_content('Test todo from feature test')
  end

  scenario 'Change statuses' do
    sign_in_capybara(user)
    visit todo_path(todo)
    select('completed', :from => 'Status')
    expect { click_on 'Save changes' }.to change(user.todos.by_status(:completed), :count).by(1)
  end
  scenario 'Change context' do
    sign_in_capybara(user)
    visit todo_path(todo)
    select('@Errands', :from => 'Context')
    expect { click_on 'Save changes' }.to change(user.contexts.find_by_name('Errands').todos, :count).by(1)
    todo.reload.context.name.should == 'Errands'
  end
  scenario 'Change prior' do
    sign_in_capybara(user)
    visit todo_path(todo)
    select('high', :from => 'Prior')
    click_on 'Save changes'
    todo.reload.prior.should == :high
  end

  scenario 'Edit todo' do
    sign_in_capybara(user)
    visit todo_path(todo)
    fill_in 'Title', :with => 'Changed title from feature test'
    fill_in 'Content', :with => 'Changed content from feature test'
    click_on 'Save changes'
    expect(page).to have_content('Todo updated!')
    visit todo_path(todo)
    expect(page).to have_selector("input[type=text][value='Changed title from feature test']")
    expect(page).to have_selector('textarea', text: 'Changed content from feature test')
    todo.reload.expire.should == nil
  end

  scenario 'Delete button presence' do
    sign_in_capybara(user)
    trash_todo = FactoryGirl.create(:todo, user: user, status_id: TodoStatus.label_id(:trash))
    completed_todo = FactoryGirl.create(:todo, user: user, status_id: TodoStatus.label_id(:completed))
    visit todo_path(trash_todo)
    expect(page).to have_link("Delete todo")
    visit todo_path(completed_todo)
    expect(page).to have_link("Delete todo")
    visit todo_path(todo) #inbox as default
    expect(page).not_to have_link("Delete todo")
  end

  scenario 'Delete todo' do
    sign_in_capybara(user)
    trash_todo = FactoryGirl.create(:todo, user: user, status_id: TodoStatus.label_id(:trash))
    visit todo_path(trash_todo)
    click_on 'Delete todo'
    #expect(page).to have_content("You sure?")
  end

  scenario 'Set deadline' do
    sign_in_capybara(user)
    visit todo_path(todo)
    find(:css, "#todo_is_deadline[value='1']").set(true)
    fill_in 'Title', :with => 'With deadline'
    click_on 'Save changes'
    todo.reload.expire.should_not == nil
  end

  scenario 'if user does n’t have contexts' do
    sign_in_capybara(user)
    user.contexts.destroy_all
    visit todo_path(todo)
    expect(page).not_to have_selector("select[id='todo_context_id'][name='todo[context_id]']")
    expect(page).to have_link('Create contexts')
    expect(page).to have_content('There is no contexts')
  end

  scenario 'if has projects, he can choose' do
    sign_in_capybara(user)
    project = FactoryGirl.create(:project, user: user)
    visit todo_path(todo)
    expect(page).to have_selector("select[id='todo_project_id'][name='todo[project_id]']")
    expect(page).to have_selector("option[value='#{project.id}']")
  end

  scenario 'Set project' do
    FactoryGirl.create(:project, title:'Set project', user: user)
    sign_in_capybara(user)
    visit todo_path(todo)
    select('#Set_project', :from => 'Project')
    expect { click_on 'Save changes' }.to change(user.projects.find_by_name('Set_project').todos, :count).by(1)
    todo.reload.project.name.should == 'Set_project'
  end

  scenario 'make project from todo' do
    #sign_in_capybara(user)
    #visit todo_path(todo)
    #todos_count = user.todos.count
    #fill_in 'Title', :with => 'Changed title from feature test'
    #expect { click_on 'Make project' }.to change(user.projects, :count).by(1)
    #user.todos.count.should == todos_count-1
  end

  scenario 'create todo fro content' do
    pending 'todo shod have this project selected'
  end

  scenario 'deadline checkbox' do
    pending 'checkbox should be selected if deadline exist'
  end

end