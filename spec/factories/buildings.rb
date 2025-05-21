FactoryBot.define do
  factory :building do
    association :building_type
    association :star_system
    level { 1 }
    status { "operational" }
    construction_start { 10.hours.ago }
    construction_end { 2.hours.ago }
    demolition_end { nil }

    trait :under_construction do
      status { "under_construction" }
      construction_start { 2.hours.ago }
      construction_end { 6.hours.from_now }
    end

    trait :being_demolished do
      status { "being_demolished" }
      demolition_end { 1.hour.from_now }
    end
  end
end
