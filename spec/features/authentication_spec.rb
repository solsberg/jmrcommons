require 'spec_helper'

feature  "User signs in" do
  scenario "with invalid credentials" do
    visit root_path

    fill_in 'Username', with: "someuser"
    fill_in 'Password', with: "password"
    click_button 'Sign in'

    expect(current_path).to eq signin_path
    expect(page).to have_error_message("account could not be found")
  end

  # scenario "when account not yet approved" do
  # end

  given(:user) { User.create!(name: "auser", email: "auser@example.com", 
    password: "password", password_confirmation: "password") }

  scenario "with valid credentials" do
    visit root_path

    fill_in 'Username', with: user.name
    fill_in 'Password', with: user.password
    click_button 'Sign in'

    expect(page).to have_title("About JMR Commons")
  end

  scenario "and signs out" do
    visit root_path

    fill_in 'Username', with: user.name
    fill_in 'Password', with: user.password
    click_button 'Sign in'

    visit signout_path
    visit about_path
    expect(current_path).to eq signin_path
  end
end