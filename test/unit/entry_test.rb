require 'test_helper'

class EntryTest < ActiveSupport::TestCase
  setup do
    @user = users(:one)
    @user_two = users(:two)
    ActionMailer::Base.deliveries.clear
  end

  test "A user should not be able to have more than one entry for the same day" do
    entry = Entry.create(user_id: @user.id, category: 1, description: "hello Ghina and Mona")
    assert_equal ['User has already an entry for today. Come back tomorrow'], entry.errors.full_messages
  end
  
  test "should not allow an empty entry" do
    entry = Entry.create
    assert_equal ["Description can't be blank", "Category can't be blank", "User can't be blank"], entry.errors.full_messages
  end

  test "should return [] if all users created entries today" do
    assert_equal [], Entry.check_for_users_with_no_entries
  end

  test "should return a single user when all other users have created entries today" do
    entry = users(:three).entries.first
    entry.created_at = 2.days.ago
    entry.save
    assert_equal [users(:three)], Entry.check_for_users_with_no_entries
  end

  test "should return a list of users who did not create entries today" do
    User.all.each {|user| user.entries.delete_all }
    assert Entry.check_for_users_with_no_entries.include?(@user_two)
  end
  
  test "should send an email for late users" do
    User.all.each { |user| user.entries.delete_all }

    Timecop.travel(Time.local(2012, 9, 1, (Settings.deadline_time + 1), 0, 0)) do
      Entry.send_email_on_late_submission
      assert_equal User.count, MailReminder.deliveries.size
    end
  end
  
  test "Should send only 1 email" do 

    Timecop.travel(Time.local(2012, 9, 1, (Settings.deadline_time + 1), 0, 0)) do
      entry = users(:three).entries.first
      entry.created_at = 2.days.ago
      entry.save
      Entry.send_email_on_late_submission
      assert_equal Entry.check_for_users_with_no_entries.size, MailReminder.deliveries.size
    end
  end
end
