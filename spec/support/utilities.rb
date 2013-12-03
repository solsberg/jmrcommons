RSpec::Matchers.define :have_error_message do |message|
  match do |page|
    page.has_selector?('div.alert.alert-error', text: message) || 
      page.has_selector?('ul#error_list li', text: message)
  end
end

def sign_in(user, options={})
  if options[:no_capybara]
    cookies[:remember_token] = user.id
  else
    visit signin_path
    fill_in "Username", with: user.name
    fill_in "Password", with: user.password
    click_button "Sign in"
  end
end