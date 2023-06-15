class AddDocumentToItem < ActiveRecord::Migration[6.1]
  def change
    add_column :items, :document, :string
  end
end
