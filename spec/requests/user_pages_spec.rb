require 'rails_helper'

describe "User Pages" do
  subject {page}
  describe "Singup page" do
    before {visit signup_path}

    it {should have_content('Sign up')}
    it { should have_title(full_title('Sign up')) }

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

