# frozen_string_literal: true

require "test_helper"

class GettingStartedControllerTest < ActionDispatch::IntegrationTest
  test "visiting getting started page" do
    get "/getting_started"

    assert_response :ok
    assert_match(/Getting Started/, response.body)
  end
end
