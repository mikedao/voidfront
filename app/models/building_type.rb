class BuildingType < ApplicationRecord
  validates :key, presence: true, uniqueness: true
  validates :name, presence: true
  validates :description, presence: true
  validates :max_level, presence: true, numericality: { greater_than: 0 }

  def cost_for_level(level)
    level_data.dig(level.to_s, "cost")
  end

  def construction_time_for_level(level)
    level_data.dig(level.to_s, "construction_time")
  end

  def demolition_time_for_level(level)
    level_data.dig(level.to_s, "demolition_time")
  end 

  def effects_for_level(level)
    level_data.dig(level.to_s, "effects")
  end
end

