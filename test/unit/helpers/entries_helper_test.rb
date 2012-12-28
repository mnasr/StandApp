require 'test_helper'

class EntriesHelperTest < ActionView::TestCase
	test "format redmine ticket id into full url" do
		assert_equal "http://dev.nuserv.com/issues/1234", format_ticket_id_to_url(1234)
	end

	test "ticket url is empty if redmine ticket_id is empty" do
		assert_equal "", format_ticket_id_to_url
		assert_equal "", format_ticket_id_to_url(nil)
		assert_equal "", format_ticket_id_to_url("")
	end

	test "should return the working days considering the absences of a user" do
		entry = entries(:three)
		assert_equal 20, working_days(entry)
	end

	test "should return working days without absences if user has no absences" do
		entry = entries(:two)
		assert_equal 21, working_days(entry)
	end
end
