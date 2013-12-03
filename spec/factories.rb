FactoryGirl.define do
  factory :user do
    sequence(:name)  { |n| "person_#{n}" }
    sequence(:email) { |n| "person_#{n}@example.com" }
    password  "password"
    password_confirmation "password"
  end

  factory :profile_question do
    sequence(:title) { |n| "A question about something ##{n}" }
  end
end