require 'spec_helper'
feature 'Project CRUD actions' do
  let (:user) { FactoryGirl.create(:user) }
  let (:project) { FactoryGirl.create(:project, user: user) }
  let (:todo) { FactoryGirl.create(:todo, user: user, project: project) }
  before do
    sign_in_capybara(user)
  end
  scenario 'active project without todos' do
    visit project_path project.name
    expect(page).not_to have_content('Projects todos')
    expect(page).to have_selector("input[type=text][id='project_title'][name='project[title]']")
    find_field('Title').value.should eq(project.title)
    find_field('Prior').value.should eq(project.prior)
    expect(page).not_to have_link('Delete')
  end
  scenario 'active project with todos' do
    todo
    visit project_path project.name
    expect(page).to have_content('Projects todos')
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
    expect{click_on 'Cancel'}.not_to change(user.projects, :count)
    expect(project.reload.state).to eq('trash')
  end
  scenario 'activate canceled(finished) project' do
    project.cancel
    visit project_path project.name
    expect{click_on 'Activate'}.not_to change(user.projects, :count)
    expect(project.reload.state).to eq('active')
  end
end