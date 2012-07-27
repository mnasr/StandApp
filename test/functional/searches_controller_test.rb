require 'test_helper'

class SearchesControllerTest < ActionController::TestCase
   setup do
    @user = users(:one)
    sign_in @user
  end

  test "search should return the convenient keywords" do
    post :create, :search => "nasr@monaqasat.com"
    assert assigns(:results)
  end
    test "search result should not be empty" do
  	post :create, :search => ""
    assert_equal 0, results.size
    
    end
end 
