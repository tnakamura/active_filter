# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :task do
    user_id 1
    list_id 1
    name "MyString"
    description "MyText"
    completed false
    deadline_at "2012-12-05 15:47:19"
  end
end
