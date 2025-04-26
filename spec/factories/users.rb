FactoryBot.define do
  factory :user do
    email { Faker::Internet.unique.email }
    username { Faker::Internet.username }
    password_digest { "password_hash" }
  end
end