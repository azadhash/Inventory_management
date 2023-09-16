# frozen_string_literal: true
# rubocop:disable all
# spec/models/item_spec.rb

require 'rails_helper'

RSpec.describe Item, type: :model do
  subject(:item) { build(:item) }

  describe 'associations' do
    it 'belongs to a user (optional)' do
      expect(item.user).to be_nil
    end

    it 'belongs to a brand' do
      expect(item.brand).to be_an_instance_of(Brand)
    end

    it 'belongs to a category' do
      expect(item.category).to be_an_instance_of(Category)
    end

    it 'destroys associated issues when item is destroyed' do
      user = create(:user)
      item = create(:item, user: user)
      issues = create_list(:issue, 3, item: item)
      expect(item.issues).to eq(issues)
      expect(Issue.count).to eq(3)
      expect { item.destroy }.to change { Issue.count }.by(-3)
      expect(item.issues).to be_empty
    end

    it 'has many attached documents and dependent destroy' do
      expect(item.documents).to be_an_instance_of(ActiveStorage::Attached::Many)
      expect(item.documents).to be_empty
    end
  end

  describe 'validations' do
    it 'is valid with valid attributes' do
      brand = create(:brand)
      category = create(:category)
      user = create(:user)
      item = build(:item, brand: brand, category: category, user: user)
      expect(item).to be_valid
    end

    it 'is not valid without a name' do
      item.name = nil
      expect(item).not_to be_valid
      expect(item.errors[:name]).to include("can't be blank")
    end

    it 'is not valid with a name exceeding 50 characters' do
      item.name = 'a' * 51
      expect(item).not_to be_valid
      expect(item.errors[:name]).to include('is too long (maximum is 50 characters)')
    end

    it 'is not valid without a category' do
      item.category_id = nil
      expect(item).not_to be_valid
    end

    it 'is not valid without a brand' do
      item.brand = nil
      expect(item).not_to be_valid
    end

    it 'is valid without user (optional)' do
      brand = create(:brand)
      category = create(:category)
      item = build(:item, brand: brand, category: category)
      item.user = nil
      expect(item).to be_valid
    end
    it 'is not valid with wrong user' do
      brand = create(:brand)
      category = create(:category)
      item = build(:item, brand: brand, category: category)
      item.user_id = 234
      expect(item).not_to be_valid
    end
    it 'is not valid with notes exceeding 100 characters' do
      item.notes = 'a' * 101
      expect(item).not_to be_valid
      expect(item.errors[:notes]).to include('is too long (maximum is 100 characters)')
    end
  end
end


