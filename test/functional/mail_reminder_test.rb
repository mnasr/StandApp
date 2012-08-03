require 'test_helper'

class MailReminderTest < ActionMailer::TestCase
  test "late" do
    mail = MailReminder.late(users(:one))
    assert_equal "StandApp Reminder", mail.subject
    assert_equal ["nasr@monaqasat.com"], mail.to
    assert_equal ["careers@beirutrb.org"], mail.from
    assert_match /2012-08-03/, mail.body.encoded
  end
end
