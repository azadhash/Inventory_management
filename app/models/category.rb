class Category < ApplicationRecord
  include Searchable

  has_many :items, dependent: :destroy 
  
  settings do
    mappings dynamic: false do
      indexes :name, type: :text
      indexes :id, type: :keyword
      indexes :required_quantity, type: :keyword
      indexes :buffer_quantity, type: :keyword
    end
  end
  def self.index_data
    self.__elasticsearch__.create_index! force: true
    self.__elasticsearch__.import
  end
  def as_indexed_json(options = {}){
    id: id,
    name: name,
    required_quantity: required_quantity,
    buffer_quantity: buffer_quantity,
    }
  end
  def self.search_name(query)
    self.search({
      "query": {
        "bool": {
          "should": [
            {
              "query_string": {
              "query": "*#{query}*",
              "fields": ["name"],
              "default_operator": "AND"
            }
            },
            {
              "multi_match": {
              "query": query,
              "fields": ["required_quantity", "buffer_quantity", "id"],
              "operator": "or"
            }
            }
          ]
        }
      }
    })
  end
  
  # Index the data before performing the search
  index_data  
end
