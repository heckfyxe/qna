class Linkable < ApplicationRecord
  self.abstract_class = true

  has_many :links, dependent: :destroy, as: :linkable
  accepts_nested_attributes_for :links, allow_destroy: true, reject_if: :all_blank

  def links
    super || super.build
  end
end