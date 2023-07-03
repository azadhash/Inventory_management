class Issue < ApplicationRecord
  include Searchable
  belongs_to :user
  belongs_to :item
  settings do
    mappings dynamic: false do
      indexes :description, type: :text
      indexes :id, type: :keyword
    end
  end
  def self.index_data
    self.__elasticsearch__.create_index! force: true
    self.__elasticsearch__.import
  end
  def as_indexed_json(options = {}){
    id: id,
    description: description
    # category_name: category.items,
    # sub_category_name: sub_category.items,
  }
  end
  index_data
end
