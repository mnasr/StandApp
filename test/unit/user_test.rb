require 'test_helper'

class UserTest < ActiveSupport::TestCase
  setup do
    @user = users(:three)
  end

  test "At least one user is assigned as an admin" do
    user = User.destroy(@user.id)
    assert_equal ['Cant delete the last user that is also an admin'], user.errors.full_messages
  end 

end
