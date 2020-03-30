# frozen_string_literal: true

class Mailserver
  def processes
    {
      clamd: `ps -ax | egrep clamd | grep -v grep | wc -l`.to_i > 0,
      postfix: `ps -ax | egrep postfix\/master | grep -v grep | wc -l`.to_i > 0,
      dovecot: `ps -ax | egrep dovecot$ | grep -v grep | wc -l`.to_i > 0,
      mysqld: `ps -ax | egrep "mysqld " | grep -v grep | wc -l`.to_i > 0,
      spamd: `ps -ax | egrep "spamd " | grep -v grep | wc -l`.to_i > 0,
      freshclam: `ps -ax | egrep "freshclam " | grep -v grep | wc -l`.to_i > 0
    }
  end

  def updates
    {
      spamassassin: File.ctime('/var/db/spamassassin/' + `ls -t /var/db/spamassassin/ | head -1`.strip),
      clam: File.ctime('/var/db/clamav/' + `ls -t /var/db/clamav/ | head -1`.strip)
    }
  rescue StandardError
    { spamassassin: Date.today, clam: Date.today }
  end
end
