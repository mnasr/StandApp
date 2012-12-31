require 'test_helper'

class UsersHelperTest < ActionView::TestCase
	test "should return the working days considering the absences of a user" do
		user = users(:three)
		assert_equal 0, working_days(user)
	end

	test "should return working days without absences if user has no absences" do
		user = users(:two)
		assert_equal 1, working_days(user)
	end
end
