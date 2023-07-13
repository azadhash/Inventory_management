# frozen_string_literal: true

# this is migration file
class CreateIssues < ActiveRecord::Migration[6.1]
  def change
    create_table :issues do |t|
      t.text :description, null: false
      t.boolean :status, default: false
      t.belongs_to :user, null: false, foreign_key: true
      t.belongs_to :item, null: false, foreign_key: true
      t.timestamps
    end
  end
end
