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
end
 

