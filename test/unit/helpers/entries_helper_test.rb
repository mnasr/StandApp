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

	test "link to ticket id in the description field"  do
		assert_equal "<a href=\"http://dev.nuserv.com/issues/\">2345</a>", linkify("my ticket is #2345 ")
		assert_equal "<a href=\"http://dev.nuserv.com/issues/\">2345</a><a href=\"http://dev.nuserv.com/issues/\">5421</a>", linkify("my ticket is #2345 and #5421")
	end
end
