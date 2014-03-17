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
    expect(page).to have_selector("select[id='todo_kind'][name='todo[kind]']")
    expect(page).to have_selector("select[id='todo_prior_id'][name='todo[prior_id]']")
    expect(page).not_to have_selector("select[id='todo_project_id'][name='todo[project_id]']")
    expect(page).to have_selector("select[id='todo_context_id'][name='todo[context_id]']")
    expect(page).to have_selector("input[type=submit][value='Create todo']")
    expect(page).to have_selector("input[type=submit][value='Make project']")
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

  scenario 'Change kinds' do
    sign_in_capybara(user)
    visit todo_path(todo)
    select('next', :from => 'Kind')
    expect { click_on 'Save changes' }.to change(user.todos.with_kind(:next), :count).by(1)
  end
  scenario 'Change context' do
    sign_in_capybara(user)
    visit todo_path(todo)
    select('@Errands', :from => 'Context')
    expect { click_on 'Save changes' }.to change(user.contexts.find_by_name('Errands').todos, :count).by(1)
    expect(todo.reload.context.name).to eq('Errands')
  end
  scenario 'Change prior' do
    sign_in_capybara(user)
    visit todo_path(todo)
    select('high', :from => 'Prior')
    click_on 'Save changes'
    expect(todo.reload.prior).to eq(:high)
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
    expect(todo.reload.expire).to be_nil
  end

  scenario 'Delete button presence' do
    sign_in_capybara(user)
    trash_todo = FactoryGirl.create(:todo, user: user, state: 'trash')
    completed_todo = FactoryGirl.create(:todo, user: user, state: 'completed')
    visit todo_path(trash_todo)
    expect(page).to have_link('Delete')
    visit todo_path(completed_todo)
    expect(page).to have_link('Delete')
    visit todo_path(todo) #inbox as default
    expect(page).not_to have_link('Delete')
  end

  scenario 'Set deadline' do
    sign_in_capybara(user)
    visit todo_path(todo)
    find(:css, "#todo_is_deadline[value='1']").set(true)
    fill_in 'Title', :with => 'With deadline'
    click_on 'Save changes'
    expect(todo.reload.expire).to_not be_nil
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
    FactoryGirl.create(:project, title: 'Set project', user: user)
    sign_in_capybara(user)
    visit todo_path(todo)
    select('#Set_project', :from => 'Project')
    expect { click_on 'Save changes' }.to change(user.projects.find_by_name('Set_project').todos, :count).by(1)
    expect(todo.reload.project.name).to eq('Set_project')
  end

  #scenario 'create todo from content' do
  #  pending 'todo should have this project selected'
  #end
  #
  #scenario 'create todo from today, tomorrow paths' do
  #  pending 'todos should have date inserted'
  #end
  #
  #scenario 'deadline checkbox' do
  #  pending 'checkbox should be selected if deadline exist'
  #  pending 'deadline checkbox becomes checked if update failed'
  #  pending 'check validation message when deadline is required'
  #end
  #
  #scenario 'deadline checkbox' do
  #  pending 'when edit todo inbox kind is not available'
  #end

end