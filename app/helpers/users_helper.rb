# frozen_string_literal: true

module UsersHelper
  def quota_column(record)
    (record.quota.blank? ? '-' : record.quota.to_s + ' MB')
  end

  def admin_for_column(record)
    admin_for = (record&.admin_for ? record.admin_for : [])
    if admin_for.count > 3
      begin
        admin_for[0..2].collect(&:domain).join(', ') + " +#{(admin_for.count - 3)}"
      rescue StandardError
        ''
      end
    else
      begin
        admin_for.collect(&:domain).join(', ')
      rescue StandardError
        ''
      end
    end
  end
end
