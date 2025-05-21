class Building < ApplicationRecord
  belongs_to :building_type
  belongs_to :star_system

  # Statuses
  STATUSES = %w[under_construction being_demolished operational].freeze

  # Validations
  validates :level, presence: true, numericality: { only_integer: true, greater_than: 0 }
  validates :status, presence: true, inclusion: { in: STATUSES }
  validate :unique_per_system, if: -> { building_type&.unique_per_system? }
  
  # Status methods
  def under_construction?
    status == "under_construction"
  end

  def operational?
    status == "operational"
  end

  def being_demolished?
    status == "being_demolished"
  end

  # Progress calculation methods
  def construction_progress_percentage
    return 100 if operational? || being_demolished?
    return 0 if !construction_start || !construction_end

    elapsed_time = Time.current - construction_start
    total_time = construction_end - construction_start
    
    progress = (elapsed_time / total_time * 100).round
    [progress, 100].min
  end
  
  def demolition_progress_percentage
    return 0 unless being_demolished?
    return 0 if !updated_at || !demolition_end
    
    elapsed_time = Time.current - updated_at
    total_time = demolition_end - updated_at
    
    progress = (elapsed_time / total_time * 100).round
    [progress, 100].min
  end

  # Effects methods
  def current_effect(effect_key)
    return nil if under_construction? || being_demolished?

    building_type.effects_for_level(level)[effect_key]
  end

  private


  def unique_per_system
    return unless building_type.unique_per_system?

    existing = Building.where(building_type_id: building_type_id, star_system_id: star_system_id)
    existing = existing.where.not(id: id) if persisted?
    
    if existing.exists?
      errors.add(:building_type_id, "already exists in this star system")
    end
  end
end
