require 'test_helper'

class AbsencesControllerTest < ActionController::TestCase
  setup do
    @absence = absences(:three)
    @user = User.create(:email => "example@monaqasat.com", :fullname => "Bryan Adams", :password => "12345678", :password_confirmation => "12345678")
    sign_in @user
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:absences)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create absence" do
    assert_difference('Absence.count') do
      post :create, absence: {:description => @absence.description}
    end

    assert_redirected_to absence_path(assigns(:absence))
  end

  test "should show absence" do
    get :show, id: @absence
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @absence
    assert_response :success
  end

  test "should update absence" do
    put :update, id: @absence, absence: {:description => @absence.description}
    assert_redirected_to absence_path(assigns(:absence))
  end

  test "should destroy absence" do
    assert_difference('Absence.count', -1) do
      delete :destroy, id: @absence
    end

    assert_redirected_to absences_path
  end
end
