# frozen_string_literal: true
#rubocop:disable all
require 'rails_helper'

RSpec.describe Issue, type: :model do
  subject(:issue) { build(:issue) }

  describe 'associations' do
    it 'belongs to a user' do
      expect(issue.user).to be_an_instance_of(User)
    end

    it 'belongs to an item' do
      expect(issue.item).to be_an_instance_of(Item)
    end
  end

  describe 'validations' do
    it 'is valid with valid attributes' do
      user = create(:user)
      item = create(:item, user: user) # Associate the item with the user
      issue = build(:issue, user: user, item: item)
      expect(issue).to be_valid
    end

    it 'is not valid without an item' do
      issue.item = nil
      expect(issue).not_to be_valid
      expect(issue.errors[:item_id]).to include('Please select an item')
    end

    it 'is not valid without a description' do
      issue.description = nil
      expect(issue).not_to be_valid
      expect(issue.errors[:description]).to include('Please write some description')
    end

    it 'is not valid with a description exceeding 250 characters' do
      issue.description = 'a' * 251
      expect(issue).not_to be_valid
      expect(issue.errors[:description]).to include('Description should be less than 250 characters')
    end
  end
end
