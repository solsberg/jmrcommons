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

feature "User views profile questions of another user" do
  given(:user) { FactoryGirl.create(:user) }
  given(:other_user) { FactoryGirl.create(:user) }
  given(:questions) { [] }
  before do
    (1..3).each do
      questions << FactoryGirl.create(:profile_question)
    end
  end

  scenario "other user answered all the questions" do
    questions.each do |question|
      other_user.respond_to(question, "response to #{question.id}")
    end

    sign_in user
    visit user_profile_path(other_user)

    questions.each do |question|
      within ".questions li#question_#{question.id}" do
        expect(page).to have_content(question.title)
        expect(page).to have_content("response to #{question.id}")
      end
    end
  end

  scenario "other user only answered one question" do
    answered = questions.first
    unanswered = questions.select { |q| q != answered }
    other_user.respond_to(answered, "response to #{answered.id}")

    sign_in user
    visit user_profile_path(other_user)

    within ".questions li#question_#{answered.id}" do
      expect(page).to have_content(answered.title)
      expect(page).to have_content("response to #{answered.id}")
    end

    unanswered.each do |question|
      expect(page).not_to have_content(question.title)
    end
  end
end