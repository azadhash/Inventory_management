# frozen_string_literal: true

FactoryBot.define do
  factory :brand do
    sequence(:name) { |n| "Model #{n}" }
  end
end
