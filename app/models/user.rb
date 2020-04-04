# frozen_string_literal: true

class User < ApplicationRecord
  include User::Authentication

  belongs_to :domain
  has_many :administrators
  has_many :admin_for, through: :administrators, source: :domain
  validates :name, :domain_id, :fullname, presence: true
  validates :name, format: { with: /^[a-zA-Z0-9_\.\-]+$/ }
  validates :name, uniqueness: { scope: :domain_id, case_sensitive: false }
  # validates :password1, length: { minimum: 6, allow_blank: true }
  # validates :password1, confirmation: { allow_blank: true }
  validates :quota, numericality: { only_integer: true, allow_blank: true }
  attr_accessor :password1, :password1_confirmation

  def before_create
    self.quota = domain.quota if domain&.quota && !quota
    if User.count.zero?
      ActiveRecord::Base.connection.execute('ALTER TABLE users AUTO_INCREMENT = 2000;')
    end
  end

  def before_save
    name.downcase!
    self.email = name + '@' + domain.name
    self.home = '/var/mailserver/mail/' + domain.name + '/' + name + '/home'
    self.quota = domain.quota if domain&.quota && !quota
  end

  def password1=(password)
    @password1 = password
    self.password = @password1 if @password1.present?
  end

  def after_create
    WebmailUser.create!(
      username: email,
      last_login: Time.zone.now.strftime('%F %T'),
      created: Time.zone.now.strftime('%F %T'),
      language: 'fr_FR',
      mail_host: 'localhost',
      preferences: 'a:2:{s:16:"message_sort_col";s:4:"date";s:18:"message_sort_order";s:4:"DESC";}'
    )
    vm = WebmailUser.find_by(username: email)
    WebmailIdentity.create!(
      :user_id => vm.user_id,
      :name => fullname,
      :email => email,
      :del => '0',
      :standard => '1',
      :html_signature => '0',
      :organization => '',
      :bcc => '',
      :signature => '',
      'reply-to' => email
    )
    `
      cp -r /var/mailserver/install/gui/default_maildir /var/mailserver/mail/#{domain.name}/#{name}
      chown -R #{id}:#{id} /var/mailserver/mail/#{domain.name}/#{name}
      find /var/mailserver/mail/#{domain.name}/#{name} -type f -name .gitignore | xargs rm
      find /var/mailserver/mail/#{domain.name}/#{name} -type d | xargs chmod 750
    `
    end

  def before_update
    @oldname = User.find(id).name
  end

  def after_update
    `mv /var/mailserver/mail/#{domain.name}/#{@oldname} /var/mailserver/mail/#{domain.name}/#{name}`
  end

  def before_destroy
    logger.info "Deleting user: #{name_and_email}"
    vm = WebmailUser.find_by(username: email)
    if vm
      uid = vm.user_id
      uid = WebmailUser.find_by(username: email).user_id
      if WebmailContact.find(:first, conditions: ['user_id = ?', uid])
        WebmailContact.delete_all ['user_id = ?', uid]
      end
      if WebmailIdentity.find(:first, conditions: ['user_id = ?', uid])
        WebmailIdentity.delete_all ['user_id = ?', uid]
      end
      if WebmailUser.find(:first, conditions: ['user_id = ?', uid])
        WebmailUser.delete_all ['user_id = ?', uid]
      end
    end
    @oldname = User.find(id).name
  end

  def name_and_email
    (fullname.present? ? "#{fullname} <#{email}>" : email)
  rescue StandardError
    ''
  end

  def after_destroy
    `rm -rf /var/mailserver/mail/#{domain.name}/#{@oldname}`
  end

  def validate
    if quota.to_i > domain.quotamax.to_i
      errors.add('quota', "exceeds domain maximum #{domain.quotamax} Mb")
    end
  end

  private

    def validate_on_create
      if password.blank? && password1.blank?
        errors.add('password1', 'cannot be empty')
    end
    end
end
