class CreateCategories < ActiveRecord::Migration[6.1]
  def change
    create_table :categories do |t|
      t.string :name
      t.integer :required_quantity
      t.integer :buffer_quantity
      t.timestamps
    end
  end
end
