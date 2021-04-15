class CommentSerializer < ActiveModel::Serializer
  attributes :id, :body, :created_at, :updated_at, :author
  belongs_to :author
end
