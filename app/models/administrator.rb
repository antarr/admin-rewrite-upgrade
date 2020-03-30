# frozen_string_literal: true

class Administrator < ApplicationRecord
  belongs_to :user
  belongs_to :domain
end
