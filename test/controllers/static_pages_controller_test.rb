require "test_helper"

class StaticPagesControllerTest < ActionDispatch::IntegrationTest
  test "should get login" do
    get static_pages_login_url
    assert_response :success
  end

  test "should get home" do
    get static_pages_home_url
    assert_response :success
  end

  test "should get salary" do
    get static_pages_salary_url
    assert_response :success
  end

  test "should get attendance" do
    get static_pages_attendance_url
    assert_response :success
  end

  test "should get user_management" do
    get static_pages_user_management_url
    assert_response :success
  end
end
