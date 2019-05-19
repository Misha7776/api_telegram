FactoryBot.define do
  factory :admin do
    name { Faker::Name.name }
    nickname { Faker::Name.unique.name }
    email { Faker::Internet.email }
    password { Faker::Internet.password }
  end
end
