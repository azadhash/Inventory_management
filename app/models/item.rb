class Item < ApplicationRecord
  has_one_attached :document
  belongs_to :user
  belongs_to :brand
  belongs_to :category
  has_many :issues
end
