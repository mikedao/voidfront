FactoryBot.define do
  factory :star_system do
    name { Faker::Space.star }
    system_type { %w[terrestrial ocean desert tundra gas_giant asteroid_belt].sample }
    max_population { 1000 }
    current_population { 500 }
    max_buildings { 10 }
    loyalty { 100 }
    association :empire
  end
end