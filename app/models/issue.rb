class Issue < ApplicationRecord
  include Searchable
  belongs_to :user
  belongs_to :item
  settings do
    mappings dynamic: true do
      indexes :description, type: :text
      indexes :id, type: :keyword
      indexes :item_id, type: :keyword
      indexes :user_id, type: :keyword
    end
  end
  def self.index_data
    self.__elasticsearch__.create_index! force: true
    self.__elasticsearch__.import
  end
  def as_indexed_json(options = {}){
    id: id,
    description: description,
    item_id: item.id,
    user_id: user.id
  }
  end
  def self.search_result(query)
    self.search({
      "query": {
        "query_string": {
          "query": "*#{query}*",
          "fields": ["id","description","item_id","user_id"]
        }
      }
    })
  end
  index_data
end
