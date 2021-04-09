module HasParentModel
  extend ActiveSupport::Concern

  private

  def parent_model
    model_name = request.fullpath.split('/')[1].singularize
    key = "#{model_name}_id".to_sym
    model = model_name.classify.constantize
    model.find(params[key])
  end
end