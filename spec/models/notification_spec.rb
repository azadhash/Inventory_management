# frozen_string_literal: true
#rubocop:disable all
require 'rails_helper'

RSpec.describe Notification, type: :model do
  describe 'validations' do
    it 'validates presence of recipient_id' do
      notification = Notification.new(recipient_id: nil)
      expect(notification).not_to be_valid
      expect(notification.errors[:recipient_id]).to include("can't be blank")
    end

    it 'validates presence of priority' do
      notification = Notification.new(priority: nil)
      expect(notification).not_to be_valid
      expect(notification.errors[:priority]).to include("can't be blank")
    end

    it 'validates presence of message' do
      notification = Notification.new(message: nil)
      expect(notification).not_to be_valid
      expect(notification.errors[:message]).to include("can't be blank")
    end
  end
end
