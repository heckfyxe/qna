module HasAuthor
  extend ActiveSupport::Concern

  included do
    belongs_to :author, class_name: 'User', foreign_key: :author_id
  end
end