# frozen_string_literal: true

module Greylist::WhitelistHelper
  def description_form_column(_record, _options)
    text_area(:record, :description, size: '60x2', class: 'accepted_filetypes-input text-input as-form-wide')
  end
end
