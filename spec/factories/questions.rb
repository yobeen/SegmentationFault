require_relative 'factory_utils.rb'

FactoryGirl.define do
  factory :question do
    title { "MyString_" + rnd_string }
    content { "MyText_" + rnd_string }
  end

  factory :invalid_question, class: "Question" do
    title ""
    content ""
  end
end
