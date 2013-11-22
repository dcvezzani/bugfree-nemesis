# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :work_hour do
    hours 1.5
    entry_story nil
  end
end
