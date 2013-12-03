require 'spec_helper'

feature "User signs up" do
  given(:new_user) { User.new(name: 'solsberg', email: 'simon@olsbergfamily.net', 
    password: 'password') }

  scenario "with valid credentials" do
    visit root_path
    click_link 'Register'

    fill_in 'Username', with: new_user.name
    fill_in 'Email', with: new_user.email
    fill_in 'Password', with: new_user.password
    fill_in 'Confirm password', with: new_user.password
    click_button 'Complete Sign Up'

    expect(page).to have_content("needs to be approved")
  end

  scenario "with invalid credentials" do
    visit root_path
    click_link 'Register'

    fill_in 'Username', with: new_user.name
    fill_in 'Email', with: new_user.email
    fill_in 'Password', with: new_user.password
    fill_in 'Confirm password', with: new_user.password + 'x'
    click_button 'Complete Sign Up'

    expect(current_path).to eq signup_path
    expect(page).to have_error_message("doesn't match")
  end
end