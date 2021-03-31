class BadgesController < ApplicationController
  before_action :authenticate_user!

  def index; end

  private

  helper_method :badges

  def badges
    current_user.badges
  end
end
