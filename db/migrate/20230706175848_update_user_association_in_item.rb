class UpdateUserAssociationInItem < ActiveRecord::Migration[6.1]
  def up
    change_column :items, :user_id, :bigint, null: true
  end

  def down
    change_column :items, :user_id, :bigint, null: false
  end
end
