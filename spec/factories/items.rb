# frozen_string_literal: true

# rubocop:disable all
FactoryBot.define do
  factory :item do
    sequence(:name) { |n| "Item #{n}" }
    status { true }
    notes { "Some notes about the item" }
    association :brand
    association :category

    trait :with_user do
      association :user
    end
  end
end
