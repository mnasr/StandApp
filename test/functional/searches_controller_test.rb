require 'test_helper'

class SearchesControllerTest < ActionController::TestCase
   setup do
    @user = users(:one)
    sign_in @user
  end

  test "search should return results matching a keyword" do
    post :create, :search => "nasr@monaqasat.com"
    @results = assigns(:results)
    assert @results.present?
  end

  test "search result should not be empty" do
  	post :create, :search => ""
    assert_response :success
    assert_template "search"
  end
end