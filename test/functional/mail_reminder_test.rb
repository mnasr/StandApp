require 'test_helper'

class MailReminderTest < ActionMailer::TestCase
  test "late" do
    mail = MailReminder.late
    assert_equal "Late", mail.subject
    assert_equal ["to@example.org"], mail.to
    assert_equal ["depot@example.com"], mail.from
    assert_match "Dear\r\nThis is to remind you to submit an entry on StandApp.", mail.body.encoded
  end
end
