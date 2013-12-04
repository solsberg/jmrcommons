require 'spec_helper'

feature "User responds to profile questions" do
  given(:user) { FactoryGirl.create(:user) }
  given(:questions) { [] }
  before do
    (1..3).each do
      questions << FactoryGirl.create(:profile_question)
    end
  end

  scenario "answering all the questions" do
    sign_in user
    visit user_profile_path(user)

    questions.each do |question|
      within ".questions div#question_#{question.id}" do
        fill_in "response_#{question.id}", with: "my answer to #{question.id}"
      end
    end

    click_button "Update"

    expect(current_path).to eq user_profile_path(user)
    questions.each do |question|
      within ".questions div#question_#{question.id}" do
        expect(page).to have_field("response_#{question.id}", with: "my answer to #{question.id}")
      end
    end
  end
end