# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :entry do
    recorded_for "2013-10-08"
    title "MyString"
    yesterdays_log "MyText"
    todays_log "MyText"
    show_stopper_log "MyText"
  end
end
