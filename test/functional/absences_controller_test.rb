require 'test_helper'

class AbsencesControllerTest < ActionController::TestCase
  setup do
    @absence = absences(:one)
    @user = users(:one)
    @admin_user = users(:three)
  end

  test "should get index" do
    sign_in @user
    get :index
    assert_response :success
    assert_not_nil assigns(:absences)
  end

  test "should get today" do
    sign_in @user
    get :today
    assert_response :success
    assert_not_nil assigns(:absences)
  end

  test "should show absence" do
    sign_in @user
    get :show, id: @absence
    assert_response :success
  end

  test "should get new" do
    sign_in @admin_user
    get :new
    assert_response :success 
  end

  test "should create absence" do
    sign_in @admin_user
    assert_difference('Absence.count') do
      post :create, absence: {:description => @absence.description, :user_id => @user.id, :created_at => @absence.created_at}
    end

    assert_redirected_to absence_path(assigns(:absence))
  end

  test "should get edit" do
    sign_in @admin_user
    get :edit, id: @absence
    assert_response :success
  end

  test "should update absence" do
    sign_in @admin_user
    put :update, id: @absence, absence: {:description => "Sick", :user_id => @user.id, :created_at => @absence.created_at}
    assert_redirected_to absence_path(assigns(:absence))
  end

  test "should destroy absence" do
    sign_in @admin_user
    assert_difference('Absence.count', -1) do
      delete :destroy, id: @absence
    end

    assert_redirected_to absences_path
  end
end
