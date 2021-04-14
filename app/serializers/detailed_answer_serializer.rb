class DetailedAnswerSerializer < ActiveModel::Serializer
  include Rails.application.routes.url_helpers

  attributes :id, :body, :the_best, :created_at, :updated_at, :files
  has_many :comments
  has_many :links
  belongs_to :author
  belongs_to :question

  def files
    object.files.map do |file|
      rails_blob_path(file, only_path: true) if file.persisted?
    end
  end
end
