# frozen_string_literal: true

class Domain < ApplicationRecord
  has_many :users
  has_many :forwardings
  has_many :administrators
  has_many :admins, through: :administrators, source: :user
  validates :name, presence: true
  validates :name, uniqueness: true
  validates :quota, :quotamax, numericality: { only_integer: true }

  def to_label
    name
  end

  def after_initialize
    if new_record?
      self.quota = 5000
      self.quotamax = 10_000
    end
  end

  def user_count
    users.count
  end

  def forwarding_counts
    forwardings.count
  end

  def after_create
    logger.info "Creating directory /var/mailserver/mail/#{name}"
    logger.info `mkdir -p -m 755 /var/mailserver/mail/#{name}`
  end

  def before_update
    @oldname = Domain.find(id).name
  end

  def name=(name)
    self[:name] = name.downcase
  end

  def after_update
    if @oldname != name
      `mv /var/mailserver/mail/#{@oldname} /var/mailserver/mail/#{name}`
    end
  end

  def after_save
    if Rails.env.production?
      system('/usr/local/bin/rake RAILS_ENV=production -f /var/mailserver/admin/Rakefile mailserver:configure:domains &')
     end
  end

  def before_destroy
    begin
      begin
         logger.info "Deleting domain: #{name}"
      rescue StandardError
        ''
       end
      @oldname = name
      users.each(&:destroy)
      forwardings.each(&:destroy)
      true
    rescue StandardError
    end
    true
  end

  def after_destroy
    `rm -rf /var/mailserver/mail/#{@oldname}` if @oldname.present?
  end
end
