class CreateItems < ActiveRecord::Migration[6.1]
  def change
    create_table :items do |t|
      t.string :name
      t.boolean :status, default: true
      t.text :notes
      t.belongs_to :user, default: nil
      t.belongs_to :brand
      t.belongs_to :category
      t.timestamps
    end
  end
end
