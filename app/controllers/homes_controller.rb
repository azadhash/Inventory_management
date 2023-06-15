class HomesController < ApplicationController
  before_action :has_current_user
  def welcome
    @user = current_user
  end
end
