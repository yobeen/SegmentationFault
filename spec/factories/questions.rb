FactoryGirl.define do
  factory :question do
    sequence :title do |n|
      "MyString_#{n}"
    end
    sequence :content do |n|
      "MyText_#{n}"
    end
  end

  factory :invalid_question, class: "Question" do
    title ""
    content ""
  end

  trait :with_answers do
    after(:create) { |q| create_list(:answer, 3, question: q ) }
  end
end
