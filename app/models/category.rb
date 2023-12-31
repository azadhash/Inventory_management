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
  validates :expected_buffer, presence: { message: 'Please write the number of expected buffer' },
                              numericality: { only_integer: true, greater_than_or_equal_to: 0 }
  validates :priority, presence: { message: 'Please select the priority' }
  validate  :validate_expected_buffer
  validate  :validate_required_quantity, on: :update
  validate  :validate_buffer_quantity, on: :update

  settings do
    mappings dynamic: false do
      indexes :name, type: :text
      indexes :required_quantity, type: :keyword
      indexes :buffer_quantity, type: :keyword
    end
  end

  def validate_expected_buffer
    return if expected_buffer.blank? || buffer_quantity.blank? || expected_buffer <= buffer_quantity

    errors.add(:expected_buffer, 'Expected buffer should be less than or equal to buffer quantity in this category')
  end

  def validate_required_quantity
    @category = Category.find(id)
    return if required_quantity.blank? || required_quantity >= items.count - @category.buffer_quantity

    errors.add(:required_quantity, 'Required quantity should be greater than or equal to total items in this category')
  end

  def validate_buffer_quantity
    return if buffer_quantity.blank? || buffer_quantity >= items.count - @category.required_quantity

    errors.add(:buffer_quantity, 'Buffer quantity should be greater than or equal to total items in this category')
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

  def count_allocated_items
    items.where.not(user_id: nil).count
  end

  def total_items
    required_quantity + buffer_quantity
  end

  def storage
    required_quantity + buffer_quantity - count_allocated_items
  end
  index_data
end
