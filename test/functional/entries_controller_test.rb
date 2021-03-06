require 'test_helper'

class EntriesControllerTest < ActionController::TestCase
  setup do
    @entry = entries(:one)
    @user = User.create(:email => "example@monaqasat.com", :fullname => "Bryan Adams", :password => "12345678", :password_confirmation => "12345678")
    sign_in @user
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:entries)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create entry with the user ID being passed in the params" do
    assert_difference('Entry.count') do
      post :create, :entry => { :description => @entry.description, :user_id => @user.id, :created_at => @entry.created_at }
    end

    assert_redirected_to entry_path(assigns(:entry))
  end
  
  test "should create entry and assign the user ID from the logged in user details" do
    assert_difference('Entry.count') do
      post :create, :entry => { :description => @entry.description, :created_at => @entry.created_at }
    end
    entry = assigns(:entry)
    assert_equal @user.id, entry.user_id 
    assert_redirected_to entry_path(assigns(:entry))
  end
  

  test "should not be able to create an entry for the same user" do
    assert_difference('Entry.count', 0) do
      post :create, :entry => { :description => @entry.description, :user_id => @entry.user_id, :created_at => @entry.created_at }
    end
    assert_response :success
  end

  test "should show entry" do
    get :show, :id => @entry
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => @entry
    assert_response :success
  end

  test "should update entry" do
    put :update, :id => @entry, entry: {:description => @entry.description, :user_id => @user.id, :created_at => @entry.created_at }
    assert_redirected_to entry_path(assigns(:entry))
  end

  test "should destroy entry" do
    assert_difference('Entry.count', -1) do
      delete :destroy, :id => @entry
    end

    assert_redirected_to entries_path
  end
end 
 