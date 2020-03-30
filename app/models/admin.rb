# frozen_string_literal: true

class Admin < ApplicationRecord
  validates :username, presence: true
  validates :username, uniqueness: true
  validates :password, confirmation: true
  validates :password, presence: true
  # validates_format_of :email, :with => /^([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})$/, :allow_blank => true
  validates :password, length: { minimum: 6 }
  attr_accessor :pass, :pass_confirmation

  def to_label
    username
  end

  def pass=(password)
    self.password = password if password.present?
  end

  def self.authenticate(username, password)
    find_by(username: username, password: password)
  end

  def self.emails
    Admin.all.collect(&:email).join(',')
  end
end
