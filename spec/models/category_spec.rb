# frozen_string_literal: true
#rubocop:disable all
require 'rails_helper'

RSpec.describe Category, type: :model do
  subject(:category) { build(:category) }

  describe 'validations' do
    it 'is valid with valid attributes' do
      expect(category).to be_valid
    end

    it 'is not valid without a name' do
      category.name = nil
      expect(category).not_to be_valid
    end

    it 'is valid if name length is less than 50 characters' do
      category.name = 'a' * 49
      expect(category).to be_valid
    end

    it 'is not valid with a name exceeding 50 characters' do
      category.name = 'a' * 51
      expect(category).not_to be_valid
    end

    it 'is not valid without a required_quantity' do
      category.required_quantity = nil
      expect(category).not_to be_valid
    end

    it 'is not valid without a buffer_quantity' do
      category.buffer_quantity = nil
      expect(category).not_to be_valid
    end

    it 'is not valid without a priority' do
      category.priority = nil
      expect(category).not_to be_valid
    end

    it 'is valid if buffer_quantity is less than required_quantity' do
      category.buffer_quantity = 3
      expect(category).to be_valid
    end

    it 'is  valid if buffer_quantity is greater than required_quantity' do
      category.buffer_quantity = 20
      expect(category).to be_valid
    end
  end

  describe 'associations' do
    it 'has many items' do
      should respond_to(:items)
    end
  end
end
