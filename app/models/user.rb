class User < ApplicationRecord
  include Searchable
  has_many :items
  has_many :issues
  has_many :notifications, foreign_key: "recipient_id"
  
  scope :get_admins, -> { where(admin: true) }
  settings do
    mappings dynamic: false do
      indexes :name, type: :text
      indexes :id, type: :keyword
      indexes :email, type: :keyword
    end
  end
  def as_indexed_json(options = {}){
    id: id,
    name: name,
    email: email
    # category_name: category.items,
    # sub_category_name: sub_category.items,
  }
  end

  def self.search_user(query)
    self.search({
      "query": {
        "query_string": {
          "query": "*#{query}",
          "fields": ["id","email","name"]
        }
      }
    })
  end
end
