require 'test_helper'

class UsersControllerTest < ActionController::TestCase
  setup do
    @user = users(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:users)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create user" do
    assert_difference('User.count') do
      post :create, :user => {:email => "costa@monaqasat.com", :fullname => @user.fullname, :password => "12345678", :password_confirmation => "12345678"}
    end

    assert_redirected_to user_path(assigns(:user))
  end

  test "should show user" do
    get :show, :id => @user
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => @user
    assert_response :success
  end

  test "should update user" do
    put :update, :id => @user, :user => { :email => "mnasr@monaqasat.com" }
    assert_redirected_to user_path(assigns(:user))
  end

  test "should not be able to update user" do
    put :update, :id => @user, :user => { :email => "mnasr@hotmail.com" }
    assert ! @user.valid?
    assert_equal ["Email is invalid"], @user.errors.full_messages
  end

  test "should destroy user" do
    assert_difference('User.count', -1) do
      delete :destroy, :id => @user
    end

    assert_redirected_to users_path
  end
end
