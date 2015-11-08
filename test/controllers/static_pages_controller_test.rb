require 'test_helper'

class StaticPagesControllerTest < ActionController::TestCase
  test "should get gate" do
    get :gate
    assert_response :success
  end

end
