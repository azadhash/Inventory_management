# frozen_string_literal: true

# this is migration file for the categories table to add expectd buffer column
class AddExpectedBufferToCategory < ActiveRecord::Migration[6.1]
  def change
    add_column :categories, :expected_buffer, :integer, null: false, default: 0
  end
end
