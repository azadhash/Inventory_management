# frozen_string_literal: true
#rubocop:disable all
require 'rails_helper'

RSpec.describe Brand, type: :model do
  subject(:brand) { build(:brand) }

  describe 'validations' do
    it 'is valid with a name' do
      expect(brand).to be_valid
    end

    it 'is not valid without a name' do
      brand.name = nil
      expect(brand).not_to be_valid
    end

    it 'is valid if name length is less than 50 characters' do
      brand.name = 'a' * 49
      expect(brand).to be_valid
    end

    it 'is not valid if name length exceeds 50 characters' do
      brand.name = 'a' * 51
      expect(brand).not_to be_valid
    end

    it 'is not valid with a duplicate case-insensitive name' do
      create(:brand, name: 'Test Model')

      brand.name = 'test model'
      expect(brand).not_to be_valid
    end

    it 'is valid with different case-insensitive name' do
      create(:brand, name: 'Test Model')

      brand.name = 'secest model'
      expect(brand).to be_valid
    end
  end

  describe 'associations' do
    it 'has many items' do
      should respond_to(:items)
    end
  end

  describe 'factory' do
    it 'is valid' do
      expect(build(:brand)).to be_valid
    end
  end
end
