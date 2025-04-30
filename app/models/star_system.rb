class StarSystem < ApplicationRecord
  belongs_to :empire
  
  SYSTEM_TYPES = %w[terrestrial ocean desert tundra gas_giant asteroid_belt]
  
  validates :name, presence: true
  validates :system_type, presence: true, inclusion: { in: SYSTEM_TYPES }
  validates :max_population, numericality: { only_integer: true, greater_than: 0 }
  validates :current_population, numericality: { only_integer: true, greater_than_or_equal_to: 0 }
  validates :max_buildings, numericality: { only_integer: true, greater_than: 0 }
  validates :loyalty, numericality: { only_integer: true, greater_than_or_equal_to: 0, less_than_or_equal_to: 100 }
end