# frozen_string_literal: true

$stdout.sync = true
namespace :mailserv do
  desc 'Fix the filsystem permissions for all users'
  task fix_permissions: :environment do
    `chmod 755 /var/mailserver/mail/*`
    User.all.each do |user|
      mail_dir = "/var/mailserver/mail/#{user.domain.name}/#{user.name}"
      `
        chown -R #{user.id}:#{user.id} "#{mail_dir}"
        find "#{mail_dir}" -type d -exec chmod 750 {} \\\;
      `
      putc '.'
    end
    puts "\nfixed permissions\n"
  end
end
