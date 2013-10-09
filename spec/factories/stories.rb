# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :story do
    due_on "2013-10-08"
    title "MyString"
    description "MyText"
    hours_est 1.5
    hours_worked 1.5
    hours_todo 1.5
    stopped_since "2013-10-08"
  end
end
