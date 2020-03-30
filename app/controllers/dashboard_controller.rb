# frozen_string_literal: true

class DashboardController < ApplicationController
  def index
    @proc = Mailserver.new.processes
    @updates = Mailserver.new.updates
  end

  def dns_test
    begin
      @test = NetTest.dns
    rescue StandardError
      @test = false
    end
    render partial: 'display_enabled'
  end

  def http_test
    begin
      @test = NetTest.http
    rescue StandardError
      @test = false
    end
    render partial: 'display_enabled'
  end

  def https_test
    begin
      @test = NetTest.https
    rescue StandardError
      @test = false
    end
    render partial: 'display_enabled'
  end
end
