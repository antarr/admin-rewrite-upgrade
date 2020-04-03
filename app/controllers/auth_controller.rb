# frozen_string_literal: true

class AuthController < ApplicationController
  skip_before_action :authenticate

  def new
    redirect_to("/getting_started") && return unless Admin.any?
    @admin = Admin.new
    render layout: nil
  end

  def create
    reset_session

    if admin = Admin.authenticate(params[:admin][:username], params[:admin][:password])
      session[:admin_id] = admin.id
      redirect_to dashboard_index_path
    else
      @admin = Admin.new
      flash[:error] = 'Incorrect username or password'
      render 'new'
    end
  end

  def logout
    session[:admin] = nil
    reset_session
    redirect_to root_path
  end
end
