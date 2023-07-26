# frozen_string_literal: true

# this is the Brand model
class Brand < ApplicationRecord
  include Searchable
  has_many :items, dependent: :destroy
  validates :name, presence: true, length: { maximum: 50 }, uniqueness: { case_sensitive: false }

  settings do
    mappings dynamic: false do
      indexes :name, type: :text
    end
  end
  def self.index_data
    __elasticsearch__.create_index! force: true
    __elasticsearch__.import
  end

  def self.search_result(query)
    search({
             "query": {
               "query_string": {
                 "query": "*#{query}*",
                 "fields": %w[name]
               }
             }
           })
  end
  index_data
end
