class ContentTypeValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    return unless value.attached?
    return if value.content_type.in?(content_types)

    value.purge if value.persisted?
    record.errors.add(attribute, :content_type, options)
  end

  private

  def content_types
    options.fetch(:in)
  end
end
