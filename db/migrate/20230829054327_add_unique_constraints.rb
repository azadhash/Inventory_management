# Frozen_string_literal: true

# this is a migration file to add unique constraints to the tables
class AddUniqueConstraints < ActiveRecord::Migration[6.1]
  def change
    add_index :brands, [:name], unique: true
    add_index :categories, [:name], unique: true
    add_index :items, [:name], unique: true
    add_index :items, [:uid], unique: true
    add_index :users, [:email], unique: true
  end
end
