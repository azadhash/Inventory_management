# Frozen_string_literal: true

# this is a migration file to change the default value of active column to true
class ChangeDefaultValueToUser < ActiveRecord::Migration[6.1]
  def change
    change_column_default :users, :active, true
  end
end
