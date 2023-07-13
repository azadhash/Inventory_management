# frozen_string_literal: true

# this is migration file
class AddColumnToItems < ActiveRecord::Migration[6.1]
  def change
    add_column :items, :uid, :bigint
  end
end
