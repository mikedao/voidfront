class CreateBuildings < ActiveRecord::Migration[7.1]
  def change
    create_table :buildings do |t|
      t.references :building_type, null: false, foreign_key: true
      t.references :star_system, null: false, foreign_key: true
      t.integer :level, null: false, default: 1
      t.string :status, null: false, default: "under_construction"
      t.datetime :construction_start
      t.datetime :construction_end
      t.datetime :demolition_end

      t.timestamps
    end

    add_index :buildings, [:building_type_id, :star_system_id], name: 'index_buildings_on_building_type_and_star_system'
  end
end
