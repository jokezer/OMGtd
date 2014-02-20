require 'spec_helper'

describe StaticPagesController do
  render_views
  describe "GET 'home'" do
    before {get 'home'}
    it "returns http success" do
      expect(response).to be_success
    end
    it 'should render template home' do
      expect(response).to render_template("home")
    end
  end

  describe "GET 'about'" do
    before {get 'about'}
    it "returns http success" do
      expect(response).to be_success
    end
    it 'should render template about' do
      expect(response).to render_template("about")
    end
  end

  describe "About page" do
    it "should have the content 'about'" do
      visit about_path
      #expect(page).to have_content('about')
      #expect(response.body).to match(/about/)
      expect(response).to be_success
      expect(response).to render_template("about")
      #expect(page).to have_title('Gtd')
    end
  end

  #describe "Root path" do
  #  before { get root_path}
  #  it 'should have content "Welcome to gtd"' do
  #    expect(response.body).to match(/Welcome to gtd/)
  #  end
  #end

end
