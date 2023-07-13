# frozen_string_literal: true

# this is migration file
class AddTokenToUser < ActiveRecord::Migration[6.1]
  def change
    add_column :users, :token, :string
  end
end
