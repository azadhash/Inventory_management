class Brand < ApplicationRecord
  include Searchable
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
    # category_name: category.items,
    # sub_category_name: sub_category.items,
  }
  end
  index_data
end
