# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :note do
    name "MyString"
    content "MyText"
    project_id 1
  end
end
