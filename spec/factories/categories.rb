# frozen_string_literal: true

FactoryBot.define do
  factory :category do
    sequence(:name) { |n| "Category #{n}" }
    required_quantity { 10 }
    buffer_quantity { 5 }
    priority { 'low' }
  end
end
