# frozen_string_literal: true
# rubocop:disable all
# this is the Issue model
class Issue < ApplicationRecord
  include Searchable
  belongs_to :user
  belongs_to :item
  validates :item_id, presence: { message: 'Please select an item' }
  validates :description, presence: { message: 'Please write some description' },
                          length: { maximum: 250, message: 'Description should be less than 250 characters' }
  settings do
    mappings dynamic: true do
      indexes :item_id, type: :keyword
      indexes :user_id, type: :keyword
    end
  end
  def self.index_data
    __elasticsearch__.create_index! force: true
    __elasticsearch__.import
  end

  def as_indexed_json(_options = {})
    {
      item_id: item.id,
      user_id: user.id
    }
  end

  def self.search_result(query)
    search({
             "query": {
               "query_string": {
                 "query": "*#{query}*",
                 "fields": %w[item_id user_id]
               }
             }
           })
  end
  index_data
end
