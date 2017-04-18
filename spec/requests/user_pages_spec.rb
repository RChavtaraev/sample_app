require 'rails_helper'
#require 'factories.rb'

describe "User Pages" do
  subject {page}

  describe "Profile Page" do
    let(:user) { FactoryGirl.create(:user) }
    before { visit user_path(user) }

    it {should have_content(user.name)}
    it {should have_title(user.name)}
  end

  describe "signup page" do
    before {visit signup_path}

    let(:submit) {"Create my account"}
    describe "with invalid information" do
      it "should not create a user" do
        expect { click_button "Create my accoun" }.not_to change(User,:count)
      end
    end

    describe "with valid information" do
      before do
        fill_in "Name",         with: "Example User"
        fill_in "Email",        with: "user@example.com"
        fill_in "Password",     with: "foobar"
        fill_in "Confirmation", with: "foobar"
      end
      it "should be create a user" do
        expect {click_button submit}.to change(User, :count).by(1)
      end
    end
  end
end



=begin
RSpec.describe "UserPages", type: :request do
  describe "GET /user_pages" do
    it "works! (now write some real specs)" do
      get user_pages_index_path
      expect(response).to have_http_status(200)
    end
  end
=end

