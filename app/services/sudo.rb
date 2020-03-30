# frozen_string_literal: true

require 'tempfile'
class Sudo
  def self.install(sourcefile, destinationfile, options = {})
    if Rails.env.production? || `uname -s`.strip == 'OpenBSD'
      user  = options[:user]  || 'root'
      group = options[:group] || 'wheel'
      mode  = options[:mode]  || 644
      `install -o #{user} -g #{group} -m #{mode} #{sourcefile} #{destinationfile}`
    else
      mode = options[:mode] || 644
      `install -m #{mode} #{Rails.root}/tmp/root/#{Rails.env}/#{sourcefile} #{Rails.root}/tmp/root/#{Rails.env}/#{destinationfile}`
    end
  end

  def self.tempfile(data)
    datafile = Tempfile.new('_temp')
    datafile.puts data
    datafile.close
    datafile.path
  end

  def self.write(destination, data, options = {})
    f = Tempfile.new('_write')
    f.puts data
    f.close

    if Rails.env.production? || `uname -s`.strip == 'OpenBSD'
      user  = options[:user]  || 'root'
      group = options[:group] || 'wheel'
      mode  = options[:mode]  || 644
      `install -o #{user} -g #{group} -m #{mode} #{f.path} #{destination}`
    elsif Rails.env.development? || Rails.env.test?
      mode = options[:mode] || 644
      `install -m #{mode} #{f.path} #{Rails.root}/tmp/root/#{Rails.env}/#{destination}`
    end
  end

  def self.exec(command, options = {})
    if Rails.env.production? || `uname -s`.strip == 'OpenBSD'
      user = options[:user] || 'root'
      `#{command}`
    elsif Rails.env.development?
      `#{command}`
    elsif Rails.env.test?
      command.to_s
    end
  end

  def self.rake(command, options = {})
    options[:rails_env] ||= Rails.env
    args = options.map { |n, v| "#{n.to_s.upcase}='#{v}'" }
    if Rails.env.production? || `uname -s`.strip == 'OpenBSD'
      user = options[:user] || 'root'
      system("/usr/local/bin/rake #{command} #{args.join(' ')} --trace 2>&1 >> #{Rails.root}/log/production.log &")
    elsif Rails.env.development?
      system("/usr/local/bin/rake #{command} #{args.join(' ')} --trace 2>&1 >> #{Rails.root}/log/development.log &")
    elsif Rails.env.test?
      "/usr/local/bin/rake #{command} #{args.join(' ')} --trace 2>&1 >> /var/log/rails.log &"
    end
  end

  def self.killall(application)
    if Rails.env.production? || `uname -s`.strip == 'OpenBSD'
      `pkill -1 -f #{application}`
    end
  end

  def self.read(filename)
    if Rails.env.production? || `uname -s`.match(/OpenBSD/)
      `cat #{filename} 2>/dev/null`.strip
    else
      `cat #{Rails.root}/tmp/root/#{Rails.env}/#{filename}`.strip
    end
  end

  def self.file_exists?(filename)
    if Rails.env.production? || `uname -s`.strip == 'OpenBSD'
      File.exist?(filename)
    else
      File.exist?("#{Rails.root}/tmp/root/#{Rails.env}/#{filename}")
    end
  end

  def self.rm(filename)
    if Rails.env.production? || `uname -s`.strip == 'OpenBSD'
      `rm #{filename} 2>/dev/null`.strip
    else
      `rm #{Rails.root}/tmp/root/#{Rails.env}/#{filename}`
    end
  end

  def self.rm_rf(filename)
    if Rails.env.production? || `uname -s`.strip == 'OpenBSD'
      `rm -rf #{filename} 2>/dev/null`.strip
    else
      `rm -rf #{Rails.root}/tmp/root/#{Rails.env}/#{filename}`
    end
  end

  def self.ln_s(source, destination, options = {})
    flags  = '-s'
    flags  = ''  if options[:hard]
    flags += 'f' if options[:force]
    if Rails.env.production? || `uname -s`.strip == 'OpenBSD'
      `ln #{flags} #{source} #{destination} 2>/dev/null`
    else
      `ln #{flags} #{Rails.root}/tmp/root/#{Rails.env}/#{source} #{Rails.root}/tmp/root/#{Rails.env}/#{destination}`
    end
  end

  def self.symlink?(filename)
    if Rails.env.production? || `uname -s`.strip == 'OpenBSD'
      File.symlink?(filename)
    else
      File.symlink?("#{Rails.root}/tmp/root/#{Rails.env}/#{filename}")
    end
  end

  def self.readlink(filename)
    if Rails.env.production? || `uname -s`.strip == 'OpenBSD'
      File.readlink(filename)
    else
      File.readlink("#{Rails.root}/tmp/root/#{Rails.env}/#{filename}")
    end
  end

  def self.ls(filename)
    if Rails.env.production? || `uname -s`.strip == 'OpenBSD'
      `ls #{filename}`
    else
      `ls #{Rails.root}/tmp/root/#{Rails.env}/#{filename}`
    end
  end

  def self.directory?(directory)
    if Rails.env.production? || `uname -s`.strip == 'OpenBSD'
      File.directory?(directory)
    else
      File.directory?("#{Rails.root}/tmp/root/#{Rails.env}/#{directory}")
    end
  end

  def self.initialize_test
    if `which rsync; echo $?`.to_i.zero?
      `rsync -a --delete #{Rails.root}/test/fixtures/filesystem/ #{Rails.root}/tmp/root/test/`
    else
      `
        rm -rf #{Rails.root}/tmp/root/test
        cp -rp #{Rails.root}/test/fixtures/filesystem/ #{Rails.root}/tmp/root/test/
      `
    end
  end

  def self.init_dev_from_test
    if `which rsync; echo $?`.to_i.zero?
      `rsync -a --delete #{Rails.root}/test/fixtures/filesystem/ #{Rails.root}/tmp/root/development/`
    else
      `
        rm -rf #{Rails.root}/tmp/root/test
        cp -rp #{Rails.root}/test/fixtures/filesystem/ #{Rails.root}/tmp/root/development/
      `
    end
  end
end
