require "spec_helper"
feature "User login and logout" do
  before(:all) do
    @user = FactoryGirl.create(:user)
  end
  after(:all) do
    @user.destroy
  end
  scenario 'Check form' do
    sign_in_capybara(@user)
    visit todos_path
    click_on 'Create new'
    expect(page).to have_selector("input[type=text][id='todo_title'][name='todo[title]']")
    expect(page).to have_selector("select[id='todo_status'][name='todo[status]']")
    expect(page).to have_selector("input[type=submit][value='Create todo']")
    #without data
    expect { click_on 'Create todo' }.not_to change(Todo, :count)
    page.should have_content('can\'t be blank')
    #with data
    fill_in 'Title', :with => 'Test todo from feature test'
    select('next', :from => 'Status')
    expect { click_on 'Create todo' }.to change(@user.todos, :count).by(1)
    page.should have_content('User todos:')
    page.should have_content('Test todo from feature test')
  end

  scenario 'Edit todo' do
    sign_in_capybara(@user)
    todo = FactoryGirl.create(:todo, user: @user)
    visit todo_path(todo)
    page.should have_content('Factory girl todo')

  end
end