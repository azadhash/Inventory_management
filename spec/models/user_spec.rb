# frozen_string_literal: true

#rubocop:disable all
require 'rails_helper'

require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'associations' do
    it 'has many items' do
      user = create(:user)
      expect(user.items).to be_empty
      item1 = create(:item, user: user)
      item2 = create(:item, user: user)

      expect(user.items).to eq([item1, item2])
    end

    it 'has many issues with dependent destroy' do
      user = create(:user)
      issue1 = create(:issue, user: user)
      issue2 = create(:issue, user: user)

      expect(user.issues).to eq([issue1, issue2])

      expect { user.destroy }.to change { Issue.count }.by(-2)
    end

    it 'has many notifications with foreign key recipient_id and dependent destroy' do
      user = create(:user)
      notification1 = create(:notification, recipient: user)
      notification2 = create(:notification, recipient: user)

      expect(user.notifications).to eq([notification1, notification2])

      expect { user.destroy }.to change { Notification.count }.by(-2)
    end
  end

  describe 'validations' do
    it 'validates presence and length of name' do
      user = create(:user)
      expect(user).to be_valid

      user.name = 'John Doe'
      expect(user).to be_valid

      user.name = 'a' * 51
      expect(user).not_to be_valid
    end

    it 'validates presence, length, format, and uniqueness of email' do
      user2 = User.new(email: 'john@example.com',name: 'aads')
      expect(user2).not_to be_valid

      user2.email = 'JOHN@example.com'
      expect(user2).not_to be_valid

      user2.email = 'jane@example.com'
      expect(user2).to be_valid

      user2.email = 'jane@example'
      expect(user2).not_to be_valid

      user2.email = 'jane@example.com'
      expect(user2).to be_valid

      user2.email = 'j' * 61 + '@example.com'
      expect(user2).not_to be_valid
    end
  end
end
