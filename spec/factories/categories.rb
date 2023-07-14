# frozen_string_literal: true

FactoryBot.define do
  factory :category do
    sequence(:name) { |n| "Category #{n}" }
    required_quantity { rand(0..100) }
    buffer_quantity { rand(0..100) }
  end
end
