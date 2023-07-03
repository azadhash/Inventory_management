class Item < ApplicationRecord
  include Searchable
  has_many_attached :documents
  belongs_to :user
  belongs_to :brand
  belongs_to :category
  has_many :issues

  def self.index_data
    self.__elasticsearch__.create_index! force: true
    self.__elasticsearch__.import
  end

  settings do
    mappings dynamic: 'true' do
      indexes :name, type: :text
      indexes :id, type: :keyword
      indexes :user_name,type: :text
      indexes :brand_name,type: :text
      indexes :category_name,type: :text
      indexes :brand_name,type: :text
    end
  end
  def as_indexed_json(options = {}){
    id: id,
    name: name,
    notes: notes,
    status: status,
    user_id: user.id,
    user_name: user.name,
    category_id: category.id,
    category_name: category.name,
    brand_name: brand.name,
    brand_id: brand.id
  }
  end

  def self.search_item(query)
    self.search({
      "query": {
        "bool": {
          "should": [
            {
              "query_string": {
              "query": "#{query}*",
              "fields": ["name","notes","user_name","category_name","brand_name"],
              "default_operator": "AND"
            }
            },
            {
              "multi_match": {
              "query": query,
              "fields": ["id"],
              "operator": "or"
            }
            }
          ]
        }
      }
    })
  end
  index_data
end
