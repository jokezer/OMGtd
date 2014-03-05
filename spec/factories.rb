FactoryGirl.define do
  factory :user do
    email "person_#{User.count+1}@example.com"
    password "foobar88"
    password_confirmation "foobar88"
  end

  factory :todo do
    title 'Factory girl todo'
    status_id TodoStatus.label_id :inbox
    prior_id TodoPrior.label_id :low
    user
  end
end