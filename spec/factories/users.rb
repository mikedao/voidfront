# frozen_string_literal: true

FactoryBot.define do
  factory :user do
    email { Faker::Internet.unique.email }
    username { Faker::Internet.username }
    password { 'password123' }
  end
end
