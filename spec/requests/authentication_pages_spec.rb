require 'rails_helper'

RSpec.describe "AuthenticationPages", type: :request do

  subject {page}

  describe "signin page" do

    before { visit signin_path}

    it {should have_content "Sign in"}
    it {should have_title "Sign in"}

  end

  describe "signin" do
    before { visit signin_path}

    describe "with invalid information" do
      before { click_button "Sign in"}
      it {should have_title("Sign in")}

      it {should have_error_messages('Invalid')}

      # it {should have_selector("div.alert.alert-error")}

      describe "after visiting another page" do
        before { click_link "Home" }
        # it { should_not have_selector('div.alert.alert-error') }
        it {should_not have_error_messages('Invalid')}
      end
    end

    describe "with valid information" do
      let(:user)  {FactoryGirl.create(:user)}

      before do
        sign_in(user)
      end

      it {should_not have_error_messages('Invalid')}

      # it {should have_title(user.name)}
      # it {should have_link("Profile", href: user_path(user))}
      # it {should have_link("Sign out", href: signout_path)}
      # it {should_not have_link("Sign in", href: signin_path)}

      it {should is_true_profile_page}

      describe "followed by signout" do
        before { click_link "Sign out" }
        it { should have_link('Sign in') }
      end
    end

  end

  describe "authentication" do
    describe "for non-authenticated users" do
      let(:user)  {FactoryGirl.create(:user)}

      describe "Try to get protected page" do
        before do
          visit edit_user_path(user)
          sign_in(user)
        end

        describe "after sign in" do
          it "should render edit page after auth" do
            expect(page).to have_title("Edit user")
          end
        end

        describe "after resign in" do
          let(:user1)  {FactoryGirl.create(:user)}
          before { sign_in(user1) }
          it "should render profile page" do
            expect(page).to have_content(user1.name)
          end
        end

      end
      describe "in the Users controller" do

        describe "visit users page" do
          before {visit users_path}
          it { should have_title('Sign in') }
        end

        describe "visit edit page" do
          before {visit edit_user_path(user)}
          it { should have_title('Sign in') }
        end

        describe "submitting to the update action" do
          before { patch user_path(user) }
          specify { expect(response).to redirect_to(signin_path) }
        end
      end

      describe "it isn't any 'profile' or 'settings' link" do
        describe "visit root" do
          before { visit root_path }
          it {should_not have_link("Profile")}
          it {should_not have_link("Settings")}
        end
      end

      describe "in the Microposts controller" do

        describe "submitting to the create action" do
          before { post microposts_path }
          specify { expect(response).to redirect_to(signin_path) }
        end

        describe "submitting to the destroy action" do
          before { delete micropost_path(FactoryGirl.create(:micropost)) }
          specify { expect(response).to redirect_to(signin_path) }
        end
      end
    end
    describe "as wrong user" do
      let(:user)  {FactoryGirl.create(:user)}
      let(:wronguser)  {FactoryGirl.create(:user, email: "wrong@example.com")}
      before {sign_in wronguser, no_capybara: true}
      describe "try to visit edit user page" do
        before {get edit_user_path(user)}
        # it {should_not have_title("Edit user") }
        specify { expect(response.body).not_to match(full_title('Edit user')) }
        specify { expect(response).to redirect_to(root_url)}
      end

      describe "try to patch user" do
        before { patch user_path(user) }
        specify { expect(response).to redirect_to(root_url)}
      end

    end

  end

end
