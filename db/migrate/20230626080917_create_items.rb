# frozen_string_literal: true

# this is migration file
class CreateItems < ActiveRecord::Migration[6.1]
  def change
    create_table :items do |t|
      t.string :name, null: false, unique: true
      t.boolean :status, default: true
      t.text :notes
      t.belongs_to :user, null: true, foreign_key: true
      t.belongs_to :brand, null: false, foreign_key: true
      t.belongs_to :category, null: false, foreign_key: true
      t.timestamps
    end
  end
end
