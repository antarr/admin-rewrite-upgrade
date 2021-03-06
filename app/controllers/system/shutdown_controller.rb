# frozen_string_literal: true

class System::ShutdownController < ApplicationController
  skip_before_action :verify_authenticity_token

  def shutdown
    system_info.shutdown
    reset_session
    render nothing: true
  end

  def reboot
    system_info.reboot
    reset_session
    render nothing: true
  end
end
