require 'spec_helper'

feature "User views list of members" do
  given(:user) { FactoryGirl.create(:user) }
  given(:other_users) { [] }
  before do
    (1..3).each do
      other_users << FactoryGirl.create(:user)
    end
  end

  scenario "all the members are listed" do
    sign_in user
    visit users_path

    other_users.each do |other_user|
      expect(page).to have_content(other_user.name)
    end
  end

  scenario "member names link to profile" do
    sign_in user
    visit users_path

    target_user = other_users[1]
    click_link target_user.name
    expect(current_path).to eq user_profile_path(target_user)
  end
end