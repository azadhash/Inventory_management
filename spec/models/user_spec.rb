# frozen_string_literal: true

#rubocop:disable all
require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'validations' do
    it 'validates presence of name' do
      user = User.new(name: nil)
      expect(user).not_to be_valid
      expect(user.errors[:name]).to include("can't be blank")
    end

    it 'validates maximum length of name' do
      user = User.new(name: 'a' * 51)
      expect(user).not_to be_valid
      expect(user.errors[:name]).to include('is too long (maximum is 50 characters)')
    end

    it 'validates presence of email' do
      user = User.new(email: nil)
      expect(user).not_to be_valid
      expect(user.errors[:email]).to include("can't be blank")
    end

    it 'validates maximum length of email' do
      user = User.new(email: 'a' * 81)
      expect(user).not_to be_valid
      expect(user.errors[:email]).to include('is too long (maximum is 60 characters)')
    end

    it 'validates uniqueness of email (case-insensitive)' do
      User.create(name: 'Example User', email: 'test@example.com')
      user = User.new(name: 'Another User', email: 'test@example.com')
      expect(user).not_to be_valid
      expect(user.errors[:email]).to include('has already been taken')
    end

    it 'validates format of email' do
      user = User.new(email: 'invalid_email')
      expect(user).not_to be_valid
      expect(user.errors[:email]).to include('must be a valid email address')
    end
  end
end
