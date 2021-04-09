class VotesController < ApplicationController
  include HasParentModel

  before_action :authenticate_user!

  def vote_up
    parent_model.vote_up(current_user)
    render json: json_response(parent_model)
  end

  def vote_down
    parent_model.vote_down(current_user)
    render json: json_response(parent_model)
  end

  private

  def json_response(resource)
    { resource_id: resource.id, rating: resource.rating, my_vote: resource.user_vote(current_user) }
  end
end
