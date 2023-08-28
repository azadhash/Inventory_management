# frozen_string_literal: true

# this is the homes controller
class HomesController < ApplicationController
  before_action :current_user?
  before_action :fetch_user
  def welcome; end

  def profile; end

  def fetch_user
    @user = current_user
  end
end
