# frozen_string_literal: true

FactoryBot.define do
  factory :issue do
    association :user
    association :item
    description { 'Some description for the issue' }
  end
end
