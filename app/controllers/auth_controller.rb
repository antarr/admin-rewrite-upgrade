class AuthController < ApplicationController
  # skip_before_filter :authenticate

  def new
    @admin = Admin.new
    render layout: nil
  end

  def create
    reset_session # Make sure everything is cleared up before logging in
    if admin = Admin.authenticate(params[:admin][:username], params[:admin][:password])
      session[:admin_id] = admin.id
      redirect_to dashboard_index_path
    else
      flash[:error] = "Incorrect username or password"
      render "new"
    end
  end

  def logout
    session[:admin] = nil
    reset_session
    redirect_to root_path
  end
end
