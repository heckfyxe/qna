class VotesController < ApplicationController
  before_action :authenticate_user!

  def vote_up
    resource.vote_up(current_user)
    render json: json_response(resource)
  end

  def vote_down
    resource.vote_down(current_user)
    render json: json_response(resource)
  end

  private

  def json_response(resource)
    { resource_id: resource.id, rating: resource.rating, my_vote: resource.user_vote(current_user) }
  end

  def resource
    model_name = request.fullpath.split('/')[1].singularize
    key = "#{model_name}_id".to_sym
    model = model_name.classify.constantize
    model.find(params[key])
  end
end
