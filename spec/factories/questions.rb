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
end
