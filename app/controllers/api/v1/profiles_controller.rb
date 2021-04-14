class Api::V1::ProfilesController < Api::V1::BaseController
  def me
    render json: current_resource_owner, root: 'me'
  end

  def index
    @profiles = User.where.not(id: current_resource_owner_id)
    render json: @profiles, root: 'profiles'
  end
end