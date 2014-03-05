require "spec_helper"
feature "User login and logout" do
  before(:all) do
    @user = FactoryGirl.create(:user)
  end
  after(:all) do
    @user.destroy
  end
  let (:todo) { FactoryGirl.create(:todo, user: @user) }
  scenario 'Check form' do
    sign_in_capybara(@user)
    visit todos_path
    click_on 'Create new'
    expect(page).to have_selector("input[type=text][id='todo_title'][name='todo[title]']")
    expect(page).to have_selector("select[id='todo_status_id'][name='todo[status_id]']")
    expect(page).to have_selector("select[id='todo_prior_id'][name='todo[prior_id]']")
    expect(page).to have_selector("input[type=submit][value='Create todo']")
    #without data
    expect { click_on 'Create todo' }.not_to change(Todo, :count)
    page.should have_content('can\'t be blank')
    #with data
    fill_in 'Title', :with => 'Test todo from feature test'
    select('next', :from => 'Status')
    expect { click_on 'Create todo' }.to change(@user.todos, :count).by(1)
    page.should have_content('Test todo from feature test')
  end

  scenario 'Change status' do
    sign_in_capybara(@user)
    visit todo_path(todo)
    page.should have_content('Factory girl todo')
    select('completed', :from => 'Status')
    expect { click_on 'Save changes' }.to change(@user.todos.by_status(:completed), :count).by(1)
  end
  scenario 'Change prior' do
    sign_in_capybara(@user)
    visit todo_path(todo)
    page.should have_content('Factory girl todo')
    select('high', :from => 'Prior')
    click_on 'Save changes'
    todo.reload.prior.should == :high
  end

  scenario 'Edit todo' do
    sign_in_capybara(@user)
    visit todo_path(todo)
    fill_in 'Title', :with => 'Changed title from feature test'
    fill_in 'Content', :with => 'Changed content from feature test'
    click_on 'Save changes'
    visit todo_path(todo)
    expect(page).to have_selector("input[type=text][value='Changed title from feature test']")
    expect(page).to have_selector('textarea', text: 'Changed content from feature test')
  end

  scenario 'Delete button presence' do
    sign_in_capybara(@user)
    trash_todo = FactoryGirl.create(:todo, user: @user, status_id: TodoStatus.label_id(:trash))
    completed_todo = FactoryGirl.create(:todo, user: @user, status_id: TodoStatus.label_id(:completed))
    visit todo_path(trash_todo)
    expect(page).to have_link("Delete todo")
    visit todo_path(completed_todo)
    expect(page).to have_link("Delete todo")
    visit todo_path(todo) #inbox as default
    expect(page).not_to have_link("Delete todo")
  end

  scenario 'Delete todo' do
    sign_in_capybara(@user)
    trash_todo = FactoryGirl.create(:todo, user: @user, status_id: TodoStatus.label_id(:trash))
    visit todo_path(trash_todo)
    click_on 'Delete todo'
    #expect(page).to have_content("You sure?")
  end

end






























































