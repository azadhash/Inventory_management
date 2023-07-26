# frozen_string_literal: true
#rubocop:disable all
require 'rails_helper'

RSpec.describe Category, type: :model do
  describe 'validations' do
    it 'is valid with valid attributes' do
      category = Category.new(name: 'Example Category',
                              required_quantity: 10,
                              buffer_quantity: 5)
      expect(category).to be_valid
    end

    it 'is invalid without a name' do
      category = Category.new(name: nil,
                              required_quantity: 10,
                              buffer_quantity: 5)
      expect(category).not_to be_valid
      expect(category.errors[:name]).to include("can't be blank")
    end

    it 'is invalid with a name exceeding the maximum length' do
      category = Category.new(name: 'a' * 51,
                              required_quantity: 10,
                              buffer_quantity: 5)
      expect(category).not_to be_valid
      expect(category.errors[:name]).to include('is too long (maximum is 50 characters)')
    end

    it 'is invalid with a non-integer required_quantity' do
      category = Category.new(name: 'Example Category',
                              required_quantity: 2.5,
                              buffer_quantity: 5)
      expect(category).not_to be_valid
      expect(category.errors[:required_quantity]).to include('must be an integer')
    end

    it 'is invalid with a negative required_quantity' do
      category = Category.new(name: 'Example Category',
                              required_quantity: -1,
                              buffer_quantity: 5)
      expect(category).not_to be_valid
      expect(category.errors[:required_quantity]).to include('must be greater than 0')
    end

    it 'is invalid with a non-integer buffer_quantity' do
      category = Category.new(name: 'Example Category',
                              required_quantity: 10,
                              buffer_quantity: 2.5)
      expect(category).not_to be_valid
      expect(category.errors[:buffer_quantity]).to include('must be an integer')
    end

    it 'is invalid with a negative buffer_quantity' do
      category = Category.new(name: 'Example Category',
                              required_quantity: 10,
                              buffer_quantity: -1)
      expect(category).not_to be_valid
      expect(category.errors[:buffer_quantity]).to include('must be greater than 0')
    end

    it 'is invalid when buffer_quantity is greater than required_quantity' do
      category = Category.new(name: 'Example Category',
                              required_quantity: 10,
                              buffer_quantity: 15)
      expect(category).not_to be_valid
      expect(category.errors[:buffer_quantity]).to include("must be less than or equal to #{category.required_quantity}")
    end
    it 'is valid when buffer_quantity is less than required_quantity' do
      category = Category.new(name: 'Example Category',
                              required_quantity: 10,
                              buffer_quantity: 5)
      expect(category).to be_valid
    end
    it 'is valid when buffer_quantity is equal to required_quantity' do
      category = Category.new(name: 'Example Category',
                              required_quantity: 5,
                              buffer_quantity: 5)
      expect(category).to be_valid
    end
    it 'is invalid when updating required_quantity to be less than the number of associated items' do
      category = Category.create(name: 'Example Category',
                                 required_quantity: 10,
                                 buffer_quantity: 5)
      brand1 = Brand.create(name: 'Hp')
      8.times { |n| category.items.create(name: "Item #{n + 1}",brand: brand1) }
      category.required_quantity = 7
      expect(category).not_to be_valid
      expect(category.errors[:required_quantity]).to include("should be greater than the total number of items in this category (#{category.items.count})")
    end

    it 'is valid when updating required_quantity to be greater than the number of associated items' do
      category = Category.create(name: 'Example Category',
                                 required_quantity: 10,
                                 buffer_quantity: 5)
      brand1 = Brand.create(name: 'Hp')
      8.times { |n| category.items.create(name: "Item #{n + 1}",brand: brand1) }
      category.required_quantity = 12
      expect(category).to be_valid
    end

    it 'is valid when updating required_quantity to be equal to the number of associated items' do
      category = Category.create(name: 'Example Category',
                                 required_quantity: 10,
                                 buffer_quantity: 5)
      brand1 = Brand.create(name: 'Hp')
      10.times { |n| category.items.create(name: "Item #{n + 1}", brand: brand1) }
      category.required_quantity = 10
      expect(category).to be_valid
    end
  end
end
