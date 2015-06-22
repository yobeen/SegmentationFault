require_relative 'factory_utils.rb'

FactoryGirl.define do
  factory :answer do
    content { "MyText_" + rnd_string } 
  end
  
  factory :invalid_answer, class: "Answer" do
    content ""
  end


end
