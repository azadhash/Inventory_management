# frozen_string_literal: true

FactoryBot.define do
  factory :user do
    sequence(:name) { |n| "User #{n}" }
    sequence(:email) { |n| "user#{n}@example.com" }
    active { true }
    admin { false }
    token { SecureRandom.hex(16) }
  end
end
