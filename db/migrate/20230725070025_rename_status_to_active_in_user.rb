# frozen_string_literal: true

# this is migration file
class RenameStatusToActiveInUser < ActiveRecord::Migration[6.1]
  def change
    rename_column :users, :status, :active
  end
end
