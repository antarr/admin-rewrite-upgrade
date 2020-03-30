# frozen_string_literal: true

class System::LogsController < ApplicationController
  LOGSIZE = 20_000
  def index
    @logs = [
      { path: '/var/log/clam-update.log', logdata: '', accessible: false },
      { path: '/var/log/maillog', logdata: '', accessible: false },
      { path: '/var/log/httpd.err', logdata: '', accessible: false },
      { path: '/var/log/httpd.log', logdata: '', accessible: false },
      { path: '/var/mailserver/admin/log/production.log', logdata: '', accessible: false }
    ]
    @logs.each do |log|
      next unless File.exist?(log[:path]) && File.readable?(log[:path])

      File.open(log[:path]) do |file|
        file.seek(-LOGSIZE, IO::SEEK_END) if File.size(log[:path]) > LOGSIZE
        log[:logdata] = file.read
        log[:accessible] = true
      end
    end
  rescue StandardError
    flash[:error] = $ERROR_INFO
  end
end
