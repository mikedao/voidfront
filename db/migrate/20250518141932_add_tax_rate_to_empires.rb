# frozen_string_literal: true

class AddTaxRateToEmpires < ActiveRecord::Migration[7.1]
  def change
    add_column :empires, :tax_rate, :integer, default: 20
  end
end
