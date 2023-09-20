# frozen_string_literal: true

# this is the Category model
class Category < ApplicationRecord
  include Searchable
  enum priority: { low: 'low', medium: 'medium', high: 'high' }
  has_many :items

  validates :name, presence: { message: 'Please write the name of the category' }, length: { maximum: 50 },
                   uniqueness: { case_sensitive: false }
  validates :required_quantity, presence: { message: 'Please write the number of required quantity' },
                                numericality: { only_integer: true, greater_than_or_equal_to: 0 }
  validates :buffer_quantity, presence: { message: 'Please write the number of buffer quantity' },
                              numericality: { only_integer: true, greater_than_or_equal_to: 0 }
  validates :priority, presence: { message: 'Please select the priority' }

  settings do
    mappings dynamic: false do
      indexes :name, type: :text
      indexes :required_quantity, type: :keyword
      indexes :buffer_quantity, type: :keyword
    end
  end

  def self.index_data
    __elasticsearch__.create_index! force: true
    __elasticsearch__.import
  end

  # rubocop:disable Metrics/MethodLength

  def self.search_result(query)
    search({
             "query": {
               "bool": {
                 "should": [
                   {
                     "query_string": {
                       "query": "*#{query}*",
                       "fields": ['name'],
                       "default_operator": 'AND'
                     }
                   },
                   {
                     "multi_match": {
                       "query": query,
                       "fields": %w[required_quantity buffer_quantity],
                       "operator": 'or'
                     }
                   }
                 ]
               }
             }
           })
  end
  # rubocop:enable Metrics/MethodLength

  def count_user_id_nil
    items.where(user_id: nil).count
  end

  index_data
end
