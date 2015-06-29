FactoryGirl.define do
  sequence :email do |n|
    "user#{n}@test.com"
  end

  sequence :name do |n|
    "John_#{n}"
  end

  factory :user do
    name
    email
    password '12345678'
    password_confirmation '12345678'
  end

  trait :with_questions do
    after(:create) do |user|
      user.questions.create(attributes_for(:question))
    end
  end
end
