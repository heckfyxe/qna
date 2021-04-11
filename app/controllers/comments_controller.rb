class CommentsController < ApplicationController
  include HasParentModel

  before_action :authenticate_user!

  after_action :publish_comment, only: :create

  authorize_resource

  def create
    @comment = parent_model.comments.build(comment_params)
    @comment.author = current_user
    if @comment.save
      render @comment
    else
      render partial: 'shared/errors', locals: { resource: @comment }, status: :unprocessable_entity
    end
  end

  private

  def comment_params
    params.require(:comment).permit(:body)
  end

  def publish_comment
    return if @comment.errors.present?

    message = ->(user) {
      { type: parent_model.class.to_s,
        id: parent_model.id,
        content: CommentsController.render(partial: 'comments/comment', locals: { comment: @comment })
      }.to_json
    }
    question = parent_model.kind_of?(Question) ? parent_model : parent_model.question
    CommentsChannel.broadcast_except_user(current_user, { question_id: question.id }, &message)
  end
end
