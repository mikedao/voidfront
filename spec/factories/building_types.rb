FactoryBot.define do
  factory :building_type do
    key { "government_administration" }
    name { "Government Administration Building" }
    description { "A central administrative complex that improves tax collection efficiency." }
    unique_per_system { true }
    max_level { 5 }
    level_data {
      {
        "1" => {
          construction_time: 8.hours.to_i,
          demolition_time: 1.hour.to_i,
          cost: {
            credits: 200,
            minerals: 100,
            energy: 125
          },
          effects: {
            tax_modifier: 0.05
          }
        },
        "2" => {
          construction_time: 12.hours.to_i,
          demolition_time: 1.hour.to_i,
          cost: {
            credits: 400,
            minerals: 200,
            energy: 250
          },
          effects: {
            tax_modifier: 0.10
          }
        }
      }
    } 
    prerequisites { {} }
  end
end
