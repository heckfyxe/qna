class AnswerSerializer < ActiveModel::Serializer
  attributes :id, :body, :the_best, :created_at, :updated_at
  belongs_to :author
end
