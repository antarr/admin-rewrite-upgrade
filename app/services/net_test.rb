# frozen_string_literal: true

class NetTest
  require 'timeout'
  require 'socket'

  def self.http
    Timeout.timeout(2) do
      `/usr/bin/nc -z www.google.com 80; echo $?`.to_i.zero?
    end
  rescue Timeout::Error
    false
  end

  def self.https
    Timeout.timeout(2) do
      `/usr/bin/nc -z www.google.com 443; echo $?`.to_i.zero?
    end
  rescue Timeout::Error
    false
  end
end
