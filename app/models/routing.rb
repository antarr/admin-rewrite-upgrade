# frozen_string_literal: true

class Routing < ApplicationRecord
  validates :destination, :transport, presence: true
  validates :destination, uniqueness: true
  validates :destination, format: { with: /[a-zA-Z0-9\-_\.\*]+/ }

  def validate
    if transport =~ /^smtp\:(.*)/
      ip_or_dest = Regexp.last_match(1)
      if /^[0-9\.\:]+$/.match?(ip_or_dest)
        unless /^(\d{1,3}\.){3}\d{1,3}$/.match?(ip_or_dest)
          errors.add(:transport, 'need a valid ip address')
        end
      else
        unless /[a-zA-Z0-9\-_.]+/.match?(ip_or_dest)
          errors.add(:transport, 'need a valid domain name')
        end
      end
    end
  end
end
