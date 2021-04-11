class BadgesController < ApplicationController
  before_action :authenticate_user!

  authorize_resource

  def index; end

  private

  helper_method :badges

  def badges
    current_user.badges
  end
end
