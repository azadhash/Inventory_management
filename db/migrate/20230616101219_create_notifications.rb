# frozen_string_literal: true

# this is migration file
class CreateNotifications < ActiveRecord::Migration[6.1]
  def change
    create_table :notifications do |t|
      t.integer :recipient_id, null: false, foreign_key: true
      t.string :priority, null: false
      t.boolean :read, default: false
      t.text :message, null: false
      t.timestamps
    end
  end
end
