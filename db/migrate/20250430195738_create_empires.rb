class CreateEmpires < ActiveRecord::Migration[7.1]
  def change
    create_table :empires do |t|
      t.string :name
      t.integer :credits, default: 1000
      t.integer :minerals, default: 500
      t.integer :energy, default: 500
      t.integer :food, default: 500
      t.references :user, null: false, foreign_key: true, index: { unique: true }

      t.timestamps
    end
  end
end
