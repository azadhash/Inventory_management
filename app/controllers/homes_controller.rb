# frozen_string_literal: true

# this is the homes controller
class HomesController < ApplicationController
  before_action :current_user?
  def welcome
    @user = current_user
  end
end
