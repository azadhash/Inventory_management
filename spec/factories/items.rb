FactoryBot.define do
  factory :item do
    sequence(:name) { |n| "Item #{n}" }
    notes { 'Sample notes' }
    association :category, factory: :category
    association :brand, factory: :brand

    after(:build) do |item|
      item.category_id = item.category.id
      item.brand_id = item.brand.id
    end
  end
end
