require "helpers/application_helper_spec.rb"
include ApplicationHelper

def valid_signin(user)
  fill_in "Email", with: user.email.upcase
  fill_in "Password", with: user.password
  click_button "Sign in"
end

def sign_in(user, options={})
  if options[:no_capybara]
    remember_token = User.new_remember_token
    cookies[:remember_token] = remember_token
    user.update_attribute(:remember_token, User.encrypt(remember_token))
  else
    visit signin_path
    fill_in "Email", with: user.email.upcase
    fill_in "Password", with: user.password
    click_button "Sign in"
  end

end

RSpec::Matchers.define :have_error_messages do |message|
  match do |page|
    expect(page).to have_selector('div.alert.alert-error', text: message)
  end
end

RSpec::Matchers.define :is_true_profile_page do
  match do |page|
    expect(page).to have_title(user.name)
    expect(page).to have_link("Profile", href: user_path(user))
    expect(page).to have_link('Users',   href: users_path)
    expect(page).to have_link("Sign out", href: signout_path)
    expect(page).to have_link('Settings',    href: edit_user_path(user))
    expect(page).to_not have_link("Sign in", href: signin_path)
  end
end
# def full_title(page_title)
#   base_title = "Ruby on Rails Tutorial Sample App"
#   if page_title.empty?
#     base_title
#   else
#     "#{base_title} | #{page_title}"
#   end
# end