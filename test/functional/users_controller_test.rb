require 'test_helper'

class UsersControllerTest < ActionController::TestCase
  setup do
    @user = users(:three)
    sign_in @user
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
      post :create, :user => { :email => "costa@monaqasat.com", :fullname => "costa", :password => "12345678", :password_confirmation => "12345678" }
    end
    assert_redirected_to users_url
  end

  test "should show user" do
    get :show, :id => @user
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => @user
    assert_response :success
  end

  test "should not allow current user to edit other's info" do
    @user_two = users(:two) 
    sign_in @user_two
    get :edit, :id => @user
    assert_response 302
  end


  test "should only allow the admin to delete accounts" do
    @user_one = users(:one)
    assert_difference('User.count', -1) do
      session[:user_id] = @user_one.id
      delete :destroy, :id => @user_one
    end

    assert_redirected_to users_path
  end

  test "should update user" do
    put :update, :id => @user, :user => { :email => "mnasr@monaqasat.com" }
    assert_redirected_to user_path(assigns(:user))
  end

  test "should not be able to update user" do
    user_with_invalid_email = users(:two)
    
    put :update, :id => user_with_invalid_email, :user => { :email => "mnasr@hotmail.com" }
    assert ! user_with_invalid_email.valid?
    assert_equal ["Email is invalid","Timezone can't be blank"], user_with_invalid_email.errors.full_messages
  end

  test "should be able to set a timezone" do
    user_to_update_timezone = users(:one)

    put :update, :id => user_to_update_timezone, :user => { :timezone => "(GMT+02:00) Athens" } 
    assert  user_to_update_timezone.valid?
  end
  
  test "should be able to set a starting day for the week" do

    put :update, :id => @user, :user => { :week_pattern => "Monday" } 
    assert  @user.valid?
  end

  test "should destroy user" do
    assert_difference('User.count', -1) do
      session[:user_id] = @user.id
      delete :destroy, :id => @user
    end

    assert_redirected_to users_path
  end
end
