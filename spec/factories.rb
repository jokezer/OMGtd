FactoryGirl.define do
  factory :user do
    sequence(:email) { |n| "person#{n}@example.com" }
    password "foobar88"
    password_confirmation "foobar88"
  end

  factory :todo do
    title 'Factory girl todo'
    prior_id TodoPrior.label_id :low
    user
    project
  end

  factory :context do
    name '@Home'
    user
  end

  factory :project do
    title 'Factory girl project'
    content 'Factory girl projects content'
    prior_id TodoPrior.label_id :low
    user
  end

end