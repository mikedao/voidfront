FactoryBot.define do
  factory :empire do
    name { Faker::Space.galaxy }
    credits { 1000 }
    minerals { 500 }
    energy { 500 }
    food { 500 }
    tax_rate { 20 }
    association :user
  end
end
