FactoryGirl.define do
  factory :user do
    email {Faker::Internet.email}
    password "foobar88"
    password_confirmation "foobar88"
    test_user true
  end

  factory :todo do
    title 'Factory girl todo'
    content {Faker::Lorem.paragraph}
    user
    factory :next_todo do
      kind 'next'
    end
    factory :scheduled_todo do
      kind 'scheduled'
      due DateTime.now
    end
    factoy :cycled_todo do
      kind 'scheduled'
      due DateTime.now
    end
    factory :waiting_todo do
      kind 'waiting'
    end
  end

  factory :context do
    name '@one_more'
    user
  end

  factory :project do
    sequence(:title) { |n| "Project #{n}" }
    content Faker::Lorem.paragraph
    user
    factory :finished_project do
      state 'finished'
    end
    factory :trash_project do
      state 'trash'
    end
  end

end