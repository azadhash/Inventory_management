class CreateIssues < ActiveRecord::Migration[6.1]
  def change
    create_table :issues do |t|
      t.text :description
      t.boolean :status, default: false
      t.belongs_to :user
      t.belongs_to :item
      t.timestamps
    end
  end
end
