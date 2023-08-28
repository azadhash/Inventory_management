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
      indexes :description, type: :text
      indexes :id, type: :keyword
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
      id: id,
      description: description,
      item_id: item.uid,
      user_id: user.id
    }
  end

  def self.search_result(query)
    search({
             "query": {
               "query_string": {
                 "query": "*#{query}*",
                 "fields": %w[id description item_id user_id]
               }
             }
           })
  end
  index_data
end
