class GettingStartedController < ApplicationController
  # before_filter :authorize
  skip_before_action :authenticate

  def index
    @admin = Admin.new
    render layout: "not_logged_in"
  end

  def create
    @admin = Admin.new(admin_params)

    if @admin.save
      redirect_to root_url, notice: "Getting Started finished Successfully. You can now login to the appliance."
    else
      render "index", layout: "not_logged_in"
    end
  end

  private

  def admin_params
    params.require(:admin).permit(:username, :email, :password, :password_confirmation)
  end

  def authorize
    unless Admin.count.zero? || Rails.env == "development"
      flash[:error] = "Getting Started can only run if no admins has been configured"
      redirect_to(root_url) and return
    end
  end
end
