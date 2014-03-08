FactoryGirl.define do
  factory :user do
    sequence(:email) { |n| "person#{n}@example.com" }
    password "foobar88"
    password_confirmation "foobar88"
  end

  factory :todo do
    title 'Factory girl todo'
    status_id TodoStatus.label_id :inbox
    prior_id TodoPrior.label_id :low
    user
  end

  factory :context do
    name '@Home'
    user
  end

end