class Empire < ApplicationRecord
  belongs_to :user
  has_many :star_systems, dependent: :destroy

  validates :name, presence: true, uniqueness: true
  validates :credits, :minerals, :energy, :food, 
            numericality: { only_integer: true, greater_than_or_equal_to: 0 }
  
  def resources_summary
    "Credits: #{credits} | Minerals: #{minerals} | Energy: #{energy} | Food: #{food}"
  end
end