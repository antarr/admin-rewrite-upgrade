# frozen_string_literal: true

require "test_helper"

class AuthControllerTest < ActionDispatch::IntegrationTest
  test "visiting home page when not authenticated shows login page" do
    get "/"

    assert_response :success
    assert_match(/Mailserver Administration/, response.body)
  end
end
