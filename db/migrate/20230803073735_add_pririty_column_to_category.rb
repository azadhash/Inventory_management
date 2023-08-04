# Frozen_string_literal: true

# this is a migration file to change the default value of active column to true
class AddPrirityColumnToCategory < ActiveRecord::Migration[6.1]
  def change
    add_column :categories, :priority, :string
  end
end
