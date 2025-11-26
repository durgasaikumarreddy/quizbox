require 'test_helper'

class AdminControllerTest < ActionDispatch::IntegrationTest
  def setup
    @admin = admins(:one)
  end

  test "should login with valid credentials" do
    post '/admin/login', params: {
      email: 'admin@example.com',
      password: 'password'
    }

    assert_response :ok
    assert_includes response.content_type, 'application/json'
    json_response = JSON.parse(response.body)
    assert json_response.key?('token')
  end

  test "should not login with invalid email" do
    post '/admin/login', params: {
      email: 'nonexistent@example.com',
      password: 'password'
    }

    assert_response :unauthorized
    json_response = JSON.parse(response.body)
    assert_equal 'Invalid credentials', json_response['error']
  end

  test "should not login with invalid password" do
    post '/admin/login', params: {
      email: 'admin@example.com',
      password: 'wrongpassword'
    }

    assert_response :unauthorized
    json_response = JSON.parse(response.body)
    assert_equal 'Invalid credentials', json_response['error']
  end
end
