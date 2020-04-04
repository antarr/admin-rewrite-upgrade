# frozen_string_literal: true

module User::Authentication
  extend ActiveSupport::Concern
  include BCrypt

  def password
    @password ||= Password.new(password_hash)
  end

  def password=(new_password)
    @password = Password.create(new_password)
    self.password_hash = @password
  end

  # included do
    
  # end
end
