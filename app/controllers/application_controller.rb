# frozen_string_literal: true

class ApplicationController < ActionController::Base
  before_action :authenticate

  rescue_from ActionController::InvalidAuthenticityToken, with: :session_expired

  private

    def authenticate
      return if session[:admin_id]

      # If there's no session recorded, the user isn't logged in so
      # we redirect the user to the login page.
      session['return_to'] = request.fullpath
      flash[:error] = 'You are not logged in! Please Log in first.'
      redirect_to root_path
      false
    end

    def session_expired
      flash[:notice] = 'Session has expired.'
      redirect_to logout_path
    end

    def current_user
      @current_user ||= Admin.find(session[:admin_id])
    end

    def system_info
      @system_info ||= System.new
    end
end
