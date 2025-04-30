class CreateStarSystems < ActiveRecord::Migration[7.1]
  def change
    create_table :star_systems do |t|
      t.string :name
      t.string :system_type
      t.integer :max_population
      t.integer :current_population, default: 10
      t.integer :max_buildings
      t.integer :loyalty, default: 100
      t.references :empire, null: false, foreign_key: true

      t.timestamps
    end
  end
end
