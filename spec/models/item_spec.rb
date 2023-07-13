# frozen_string_literal: true
#rubocop:disable all
require 'rails_helper'

RSpec.describe Item, type: :model do


  describe 'validations' do
    it 'is valid with valid attributes' do
      category = Category.create(name: 'Example Category', required_quantity: 10, buffer_quantity: 5)
      brand = Brand.create(name: 'Example Brand')
      item = Item.new(name: 'Example Item', category: category, brand: brand)
      expect(item).to be_valid
    end

    it 'is invalid without a name' do
      category = Category.create(name: 'Example Category', required_quantity: 10, buffer_quantity: 5)
      brand = Brand.create(name: 'Example Brand')
      item = Item.new(name: nil, category: category, brand: brand)
      expect(item).not_to be_valid
      expect(item.errors[:name]).to include("can't be blank")
    end

    it 'is invalid with a name exceeding the maximum length' do
      category = Category.create(name: 'Example Category', required_quantity: 10, buffer_quantity: 5)
      brand = Brand.create(name: 'Example Brand')
      item = Item.new(name: 'a' * 51, category: category, brand: brand)
      expect(item).not_to be_valid
      expect(item.errors[:name]).to include('is too long (maximum is 50 characters)')
    end

    it 'is valid without notes' do
      category = Category.create(name: 'Example Category', required_quantity: 10, buffer_quantity: 5)
      brand = Brand.create(name: 'Example Brand')
      item = Item.new(name: 'Example Item', notes: nil, category: category, brand: brand)
      expect(item).to be_valid
    end

    it 'is invalid with notes exceeding the maximum length' do
      category = Category.create(name: 'Example Category', required_quantity: 10, buffer_quantity: 5)
      brand = Brand.create(name: 'Example Brand')
      item = Item.new(name: 'Example Item', notes: 'a' * 101, category: category, brand: brand)
      expect(item).not_to be_valid
      expect(item.errors[:notes]).to include('is too long (maximum is 100 characters)')
    end

    it 'is invalid without a category' do
      brand = Brand.create(name: 'Example Brand')
      item = Item.new(name: 'Example Item', category: nil, brand: brand)
      expect(item).not_to be_valid
      expect(item.errors[:category]).to include("must exist")
    end

    it 'is invalid without a brand' do
      category = Category.create(name: 'Example Category', required_quantity: 10, buffer_quantity: 5)
      item = Item.new(name: 'Example Item', category: category, brand: nil)
      expect(item).not_to be_valid
      expect(item.errors[:brand]).to include("must exist")
    end

    it 'is valid without a user' do
      category = Category.create(name: 'Example Category', required_quantity: 10, buffer_quantity: 5)
      brand = Brand.create(name: 'Example Brand')
      item = Item.new(name: 'Example Item', category: category, brand: brand, user: nil)
      expect(item).to be_valid
    end

    it 'is invalid with an invalid user_id' do
      category = Category.create(name: 'Example Category', required_quantity: 10, buffer_quantity: 5)
      brand = Brand.create(name: 'Example Brand')
      item = Item.new(name: 'Example Item', category: category, brand: brand, user_id: 123)
      expect(item).not_to be_valid
      expect(item.errors[:user_id]).to include('is not a valid user')
    end
  end
end
