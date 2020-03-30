# frozen_string_literal: true

class Forwarding < ApplicationRecord
  belongs_to :domain
  validates :source, :destination, presence: true
  validates :source, uniqueness: { case_sensitive: false }

  def before_validation
    self.source = source + '@' + domain.name unless /@/.match?(source)
  end

  def validate
    source =~ /^([^@\s]*)@((?:[-a-z0-9]+\.)+[a-z]{2,})$/
    unless Regexp.last_match(2) == domain.name
      errors.add('source', "needs to be in the #{domain.name} domain")
    end
  end

  def to_label
    source
  end
end
