require 'spec_helper'
feature 'Project CRUD actions' do
  let (:user) { FactoryGirl.create(:user) }
  let (:project) { FactoryGirl.create(:project, user: user) }
  let (:todo) { FactoryGirl.create(:todo, user: user, project: project) }
  before do
    sign_in_capybara(user)
  end
  scenario 'active project without todos show path' do
    visit project_path project.name
    expect(page).to have_content project.label
    expect(page).to have_button('Cancel')
    expect(page).to have_button('Finish')
    expect(page).to have_link('Edit')
    expect(page).not_to have_link('Delete')
  end
  scenario 'active project with todos' do
    todo = FactoryGirl.create(:todo, user: user, project: project, kind:'next')
    visit project_path project.name
    expect(page).to have_content('Next todos (1 from 1):')
    expect(page).to have_content(todo.title)
  end
  scenario 'trash and finished project edit form' do
    project.cancel
    visit project_path project.name
    expect(page).to have_link('Delete')
    expect(page).to have_selector("input[type=submit][value='Activate']")
    expect(page).not_to have_selector("input[type=submit][value='Finish']")
    expect(page).not_to have_selector("input[type=submit][value='Cancel']")
    project.finish
    visit project_path project.name
    expect(page).to have_link('Delete')
    expect(page).to have_selector("input[type=submit][value='Activate']")
    expect(page).not_to have_selector("input[type=submit][value='Finish']")
    expect(page).not_to have_selector("input[type=submit][value='Cancel']")
  end
  scenario 'finish project' do
    visit project_path project.name
    expect{click_on 'Finish'}.not_to change(user.projects, :count)
    expect(project.reload.state).to eq('finished')
  end
  scenario 'cancel project' do
    visit project_path project.name
    expect{within('.edit_project'){click_on 'Cancel'}}.not_to change(user.projects, :count)
    expect(project.reload.state).to eq('trash')
  end
  scenario 'activate canceled(finished) project' do
    project.cancel
    visit project_path project.name
    expect{click_on 'Activate'}.not_to change(user.projects, :count)
    expect(project.reload.state).to eq('active')
  end
  scenario 'Change prior' do
    visit edit_project_path project.name
    page.choose 'High'
    click_on 'Update'
    expect(project.reload.prior_name).to eq(:high)
    visit edit_project_path project.name
    find("input[value='3'][name='project[prior]']").should be_checked
  end
end