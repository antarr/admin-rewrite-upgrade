class ApplicationController < ActionController::Base
  layout proc{ |c| c.request.xhr? ? false : "application" }

  before_filter :authenticate

  protect_from_forgery
  filter_parameter_logging :password, :authenticity_token if Rails.env.production?

  rescue_from ActionController::InvalidAuthenticityToken, :with => :session_expired

  private

  def authenticate
    unless session[:admin_id]
      # If there's no session recorded, the user isn't logged in so
      # we redirect the user to the login page.
      session['return_to'] = request.request_uri
      flash[:error] = 'You are not logged in! Please Log in first.'
      redirect_to root_path
      return false
    end
  end

  def session_expired
    flash[:notice] = "Session has expired."
    redirect_to logout_path
  end

  def current_user
    @current_user ||= Admin.find(session[:admin_id])
  end

  def system_info
    @system_info ||= System.new
  end

  def default_url_options(options = nil)
    { :protocol => "https" } if Rails.env == "production"
  end
end
