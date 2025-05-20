class CreateBuildingTypes < ActiveRecord::Migration[7.1]
  def change
    create_table :building_types do |t|
      t.string :key, null: false
      t.string :name, null: false
      t.text :description, null: false
      t.boolean :unique_per_system, default: false
      t.integer :max_level, default: 1, null: false
      t.json :level_data, default: {}, null: false
      t.json :prerequisites, default: {}, null: false

      t.timestamps
    end
  end
end
