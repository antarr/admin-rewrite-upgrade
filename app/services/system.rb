# frozen_string_literal: true

class System
  attr_reader :os_version, :version, :cpu_type, :memory, :needs_update

  def initialize
    @os_version       = `uname -sr`.strip
    @cpu_type         = `machine`.strip
    @memory           = `sysctl hw.usermem | sed 's/=/ /' | awk '{print $2}'`.to_i / 1_048_576 + 1
  end

  def hostname
    `hostname`.strip
  end

  def uptime
    uptime = `uptime`
    if uptime =~ /up\s+([\d:]+),/
      Regexp.last_match(1)
    elsif uptime =~ /up\s+([\d]+\s+[a-z]+),/
      Regexp.last_match(1)
    end
  end

  def disk_utilization
    output = []
    `df -h`.split("\n").each_with_index do |line, index|
      next if index == 0

      filesystem, size, used, avail, capacity, mounted_on = line.split
      output << {
        filesystem: filesystem,
        size: size,
        used: used,
        avail: avail,
        capacity: capacity,
        mounted_on: mounted_on
      }
    end
    output
  end

  #
  # System Commands
  #

  def reboot
    Sudo.exec('reboot')
  end

  def shutdown
    Sudo.exec('halt -p')
  end
end
