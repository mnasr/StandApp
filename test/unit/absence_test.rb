require 'test_helper'

class AbsenceTest < ActiveSupport::TestCase

	setup do
		@absence_one = absences(:one)
		@absence = Absence.create
  end

	test "should belong to a user" do
	  assert_equal users(:one), @absence_one.user 
	end

	test "should return today's absences" do
		absence = absences(:two)
		absence.update_attributes(created_at: Time.now)
		assert Absence.today.include?(absence)
		assert_equal 1, Absence.today.size
	end

	test "should not save if description is not present" do
    assert ! @absence.valid?
    assert_not_equal [], @absence.errors
  end

  test "should create a new record" do
    @absence.description = "I'm very sick"
    assert @absence.save
  end
end
