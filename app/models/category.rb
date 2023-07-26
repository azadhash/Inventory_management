# frozen_string_literal: true

# this is the Category model
class Category < ApplicationRecord
  include Searchable
  has_many :items, dependent: :destroy
  validates :name, presence: true, length: { maximum: 50 }, uniqueness: { case_sensitive: false }
  validates :required_quantity, presence: true, numericality: { only_integer: true, greater_than: 0 }
  validates :buffer_quantity, presence: true,
                              numericality: {
                                only_integer: true,
                                greater_than: 0,
                                less_than_or_equal_to: ->(category) { category.required_quantity }
                              }
  validate :required_quantity_greater_than_total_items, on: :update
  def required_quantity_greater_than_total_items
    return unless required_quantity.present? && items.present? && required_quantity < items.count

    errors.add(:required_quantity,
               "should be greater than the total number of items in this category (#{items.count})")
  end
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

  index_data
end
