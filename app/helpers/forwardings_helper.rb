# frozen_string_literal: true

module ForwardingsHelper
  def source_form_column(record, _options)
    text_field_tag('record[source]', record.source.gsub(/@.*/, ''), size: 22, class: 'title-input text-input as-form-wide', style: 'text-align: right;') + " @#{record.domain.name}"
  end
end
