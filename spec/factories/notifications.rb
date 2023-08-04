# frozen_string_literal: true

FactoryBot.define do
  factory :notification do
    association :recipient, factory: :user
    priority { 'high' }  # You can set other values as needed
    read { false }
    message { 'Notification message' }
  end
end
