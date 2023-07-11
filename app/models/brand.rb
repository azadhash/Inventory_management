class Brand < ApplicationRecord
  include Searchable
  validates :name, presence: true, length: { maximum: 50 }, uniqueness: { case_sensitive: false }
  has_many :items, dependent: :destroy

  settings do
    mappings dynamic: false do
      indexes :name, type: :text
      indexes :id, type: :keyword
    end
  end
  def self.index_data
    self.__elasticsearch__.create_index! force: true
    self.__elasticsearch__.import
  end
  def as_indexed_json(options = {}){
    id: id,
    name: name
  }
  end
  def self.search_brand(query)
    self.search({
      "query": {
        "query_string": {
          "query": "*#{query}*",
          "fields": ["id","name"]
        }
      }
    })
  end
  index_data
end
