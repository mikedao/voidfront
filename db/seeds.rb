# frozen_string_literal: true

# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

# Create building types
building_types = [
  {
    key: 'government_administration',
    name: 'Government Administration',
    description: 'A central administrative complex that improves tax collection efficiency.',
    unique_per_system: true,
    max_level: 5,
    level_data: {
      '1' => {
        construction_time: 8.hours.to_i,
        demolition_time: 1.hour.to_i,
        cost: { credits: 200, minerals: 100, energy: 125 },
        effects: { tax_modifier: 0.05 }
      },
      '2' => {
        construction_time: 12.hours.to_i,
        demolition_time: 1.hour.to_i,
        cost: { credits: 400, minerals: 200, energy: 250 },
        effects: { tax_modifier: 0.10 }
      },
      '3' => {
        construction_time: 16.hours.to_i,
        demolition_time: 1.hour.to_i,
        cost: { credits: 800, minerals: 400, energy: 500 },
        effects: { tax_modifier: 0.15 }
      }
    },
    prerequisites: {}
  },
  {
    key: 'mining_facility',
    name: 'Mining Facility',
    description: "Extracts valuable minerals from the planet's crust.",
    unique_per_system: false,
    max_level: 3,
    level_data: {
      '1' => {
        construction_time: 6.hours.to_i,
        demolition_time: 1.hour.to_i,
        cost: { credits: 150, minerals: 50, energy: 100 },
        effects: { mineral_production: 10 }
      },
      '2' => {
        construction_time: 10.hours.to_i,
        demolition_time: 1.hour.to_i,
        cost: { credits: 300, minerals: 100, energy: 200 },
        effects: { mineral_production: 25 }
      }
    },
    prerequisites: {}
  },
  {
    key: 'power_plant',
    name: 'Power Plant',
    description: "Generates energy for the star system's infrastructure.",
    unique_per_system: false,
    max_level: 3,
    level_data: {
      '1' => {
        construction_time: 7.hours.to_i,
        demolition_time: 1.hour.to_i,
        cost: { credits: 180, minerals: 80, energy: 50 },
        effects: { energy_production: 15 }
      },
      '2' => {
        construction_time: 11.hours.to_i,
        demolition_time: 1.hour.to_i,
        cost: { credits: 360, minerals: 160, energy: 100 },
        effects: { energy_production: 35 }
      }
    },
    prerequisites: {}
  },
  {
    key: 'research_lab',
    name: 'Research Laboratory',
    description: 'Advances scientific knowledge and technological capabilities.',
    unique_per_system: true,
    max_level: 4,
    level_data: {
      '1' => {
        construction_time: 10.hours.to_i,
        demolition_time: 1.hour.to_i,
        cost: { credits: 300, minerals: 150, energy: 200 },
        effects: { research_points: 5 }
      },
      '2' => {
        construction_time: 14.hours.to_i,
        demolition_time: 1.hour.to_i,
        cost: { credits: 600, minerals: 300, energy: 400 },
        effects: { research_points: 12 }
      }
    },
    prerequisites: {}
  }
]

# Create or update building types
building_types.each do |building_type_data|
  BuildingType.find_or_create_by!(key: building_type_data[:key]) do |bt|
    bt.name = building_type_data[:name]
    bt.description = building_type_data[:description]
    bt.unique_per_system = building_type_data[:unique_per_system]
    bt.max_level = building_type_data[:max_level]
    bt.level_data = building_type_data[:level_data]
    bt.prerequisites = building_type_data[:prerequisites]
  end
end

puts "✅ Created #{building_types.length} building types"
