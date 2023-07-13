# frozen_string_literal: true

# this is the Item model
class Item < ApplicationRecord
  include Searchable
  validates :name, presence: true, length: { maximum: 50 }, uniqueness: { case_sensitive: false }
  validates :notes, length: { maximum: 100 }
  validates :category_id, presence: true
  validates :brand_id, presence: true
  validate :validate_user_id_exists, if: -> { user_id.present? }

  def validate_user_id_exists
    return if User.exists?(user_id)

    errors.add(:user_id, 'is not a valid user')
  end

  has_many_attached :documents, dependent: :destroy
  belongs_to :user, optional: true
  belongs_to :brand
  belongs_to :category
  has_many :issues, dependent: :destroy

  def self.index_data
    __elasticsearch__.create_index! force: true
    __elasticsearch__.import
  end

  settings do
    mappings dynamic: 'true' do
      indexes :name, type: :text
      indexes :id, type: :keyword
      indexes :user_name, type: :text
      indexes :brand_name, type: :text
      indexes :category_name, type: :text
      indexes :brand_name, type: :text
    end
  end
  # rubocop:disable Metrics/Style/HashSyntax
  # rubocop:disable Metrics/MethodLength

  def as_indexed_json(_options = {})
    {
      id: id,
      name: name,
      notes: notes,
      status: status,
      user_id: user&.id,
      user_name: user&.name,
      category_id: category.id,
      category_name: category.name,
      brand_name: brand.name,
      brand_id: brand.id
    }
  end

  # rubocop:enable Metrics/Style/HashSyntax
  def self.search_result(query)
    search({
             "query": {
               "bool": {
                 "should": [
                   {
                     "query_string": {
                       "query": "#{query}*",
                       "fields": %w[name notes user_name category_name brand_name],
                       "default_operator": 'AND'
                     }
                   },
                   {
                     "multi_match": {
                       "query": query,
                       "fields": ['id'],
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
