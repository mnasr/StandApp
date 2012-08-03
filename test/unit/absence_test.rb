require 'test_helper'

class AbsenceTest < ActiveSupport::TestCase

	setup do
		@absence = absences(:one)
		@description_absence = Absence.new(:description => "holiday")
    @nodescription_absence = Absence.new(:description => "")
  end

	test "should return [] if all users are present" do
	    assert_equal [], User.absent
	end

	test "should return list of users who are absent" do
		  assert_equal absences,User.absent
	end

	test "User Absence's description should be present" do
    assert @description_absence.description.present?
  end

  test "User Absence's description should not be empty" do
    assert ! @nodescription_absence.description.present?
  end

end
