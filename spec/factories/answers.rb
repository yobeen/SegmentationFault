FactoryGirl.define do
  factory :answer do
    sequence :content do |n|
      "MyAnswer_#{n}"
    end
  end
  
  factory :invalid_answer, class: "Answer" do
    content ""
  end
end
