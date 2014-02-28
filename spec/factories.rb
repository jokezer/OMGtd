FactoryGirl.define do
  factory :user do
    email "person_#{User.count+1}@example.com"
    password "foobar88"
    password_confirmation "foobar88"
  end

  factory :todo do
    title 'Factory girl todo'
    status_id '1' #inbox by default
    prior_id '1' #low by default
    user
  end
end