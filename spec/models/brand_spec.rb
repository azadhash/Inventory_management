# frozen_string_literal: true
#rubocop:disable all
require 'rails_helper'

RSpec.describe Brand, type: :model do
  describe 'validations' do
    it 'validates presence of name' do
      brand = Brand.new(name: nil)
      expect(brand).not_to be_valid
      expect(brand.errors[:name]).to include("can't be blank")
    end

    it 'validates maximum length of name' do
      brand = Brand.new(name: 'a' * 51)
      expect(brand).not_to be_valid
      expect(brand.errors[:name]).to include('is too long (maximum is 50 characters)')
    end

    it 'validates uniqueness of name (case-insensitive)' do
      Brand.create(name: 'Example Brand')
      brand = Brand.new(name: 'example brand')
      expect(brand).not_to be_valid
      expect(brand.errors[:name]).to include('has already been taken')
    end
  end
end
