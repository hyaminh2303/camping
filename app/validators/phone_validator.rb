class PhoneValidator < ActiveModel::EachValidator
  ## VALIDATION = /\A(?:\+?\d{1,3}\s*-?)?\(?(?:\d{3})?\)?[- ]?\d{3}[- ]?\d{4}\z/
  ## example: +1-541-754-3010 || 754-3010, (541) 754-3010 || +1-541-754-3010 || 1-541-754-3010 || 001-541-754-3010 || 191 541 754 3010

  VALIDATION = /\A^\+?[0-9-]+\Z/ # example: +84-123-456-7890 || 0123456789

  def validate_each(record, attribute, value)
    if value.present?
      unless value.match(VALIDATION)
        record.errors.add attribute, (options[:message] || I18n.t('activerecord.errors.messages.phone_format'))
      end
    end
  end

end
