# frozen_string_literal: true

# this is the Notification model
class Notification < ApplicationRecord
  validates :recipient_id, presence: true
  validates :priority, presence: true
  validates :message, presence: true
  belongs_to :recipient, class_name: 'User'
  scope :unread, ->(user) { where(read: false, recipient_id: user) }
  scope :update_unread, ->(user) { unread(user).update_all(read: true) }
end
