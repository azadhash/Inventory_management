# frozen_string_literal: true

# this is the migration file for the categories table
class CreateCategories < ActiveRecord::Migration[6.1]
  def change
    create_table :categories do |t|
      t.string :name, null: false, unique: true
      t.integer :required_quantity, null: false
      t.integer :buffer_quantity, null: false
      t.timestamps
    end
  end
end
