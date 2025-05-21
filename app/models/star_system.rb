class StarSystem < ApplicationRecord
  belongs_to :empire
  has_many :buildings, dependent: :destroy
  
  SYSTEM_TYPES = %w[terrestrial ocean desert tundra gas_giant asteroid_belt]
  
  validates :name, presence: true
  validates :system_type, presence: true, inclusion: { in: SYSTEM_TYPES }
  validates :max_population, numericality: { only_integer: true, greater_than: 0 }
  validates :current_population, numericality: { only_integer: true, greater_than_or_equal_to: 0 }
  validates :max_buildings, numericality: { only_integer: true, greater_than: 0 }
  validates :loyalty, numericality: { only_integer: true, greater_than_or_equal_to: 0, less_than_or_equal_to: 100 }

  def base_growth_rate
    case system_type
    when "terrestrial"
      0.05
    when "ocean"
      0.04
    when "tundra"
      0.03
    when "desert"
      0.02
    when "gas_giant"
      0.01
    when "asteroid_belt"
      0.005
    else
      0.01 # Default fallback
    end
  end

  def tax_growth_modifier
    2.0 - (3.0 * empire.tax_rate / 100.0)
  end

  def calculate_growth
    growth_percent = base_growth_rate * tax_growth_modifier
    (current_population * growth_percent).to_i
  end

  def new_population
    new_population = current_population + calculate_growth

    new_population = [new_population, 1].max  # Can't go below 1
    [new_population, max_population].min  # Can't exceed max
  end

  def buildings_count
    buildings.where(status: "operational").count
  end

  def tax_modifier_from_buildings
    buildings.where(status: "operational").sum do |building|
      building.current_effect("tax_modifier")
    end
  end
  
  def calculate_tax_income
    base_tax = (current_population * empire.tax_rate / 100.0).floor

    modifier = tax_modifier_from_buildings

    additional_tax = (base_tax * modifier).floor

    base_tax + additional_tax
  end
end
