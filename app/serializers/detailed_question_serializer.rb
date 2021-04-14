class DetailedQuestionSerializer < ActiveModel::Serializer
  include Rails.application.routes.url_helpers

  attributes :id, :title, :short_title, :body, :created_at, :updated_at, :files
  has_many :comments
  has_many :links
  belongs_to :author

  def short_title
    object.title.truncate(7)
  end

  def files
    object.files.map do |file|
      rails_blob_path(file, only_path: true) if file.persisted?
    end
  end
end
