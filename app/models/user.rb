# frozen_string_literal: true

# this is the User model
class User < ApplicationRecord
  include Searchable
  EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i

  validates :name, presence: true, length: { maximum: 50 }
  validates :email, presence: true, length: { maximum: 60 }, uniqueness: { case_sensitive: false },
                    format: { with: EMAIL_REGEX, message: 'must be a valid email address' }
  has_many :items
  has_many :issues, dependent: :destroy
  has_many :notifications, foreign_key: 'recipient_id', dependent: :destroy

  scope :get_admins, -> { where(admin: true) }
  settings do
    mappings dynamic: false do
      indexes :name, type: :text
      indexes :id, type: :keyword
      indexes :email, type: :keyword
    end
  end
  # rubocop:disable Metrics/Style/HashSyntax
  def as_indexed_json(_options = {})
    {
      id: id,
      name: name,
      email: email
    }
  end

  # rubocop:enable Metrics/Style/HashSyntax
  def self.search_result(query)
    search({
             "query": {
               "query_string": {
                 "query": "*#{query}",
                 "fields": %w[id email name]
               }
             }
           })
  end
end
