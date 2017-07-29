FactoryGirl.define do
  factory :user do
    name RandomData.random_name
    sequence(:email){|n| "user#{n}@factory.com" }
    password "helloworld"
    password_confirmation "helloworld"
  end
end
