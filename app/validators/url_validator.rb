class UrlValidator < ActiveModel::EachValidator
  def self.compliant?(value)
    uri = URI.parse(value)
    uri.kind_of?(URI::HTTPS) && !uri.host.nil?
  rescue URI::InvalidURIError
    false
  end

  def validate_each(record, attribute, value)
    unless value.present? && self.class.compliant?(value)
      record.errors.add(attribute, "is not a valid HTTP(S) URL")
    end
  end
end
