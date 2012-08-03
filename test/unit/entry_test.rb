require 'test_helper'

class EntryTest < ActiveSupport::TestCase
  setup do
    @user = users(:one)
    @user_two = users(:two)
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
    entry.update_attribute(:created_at, 2.days.ago)
    assert_equal [users(:three)], Entry.check_for_users_with_no_entries
  end

  test "should return a list of users who did not create entries today" do
    User.all.each {|user| user.entries.delete_all }
    assert Entry.check_for_users_with_no_entries.include?(@user_two)
  end
  
  test "should send an email for late users" do
    Entry.send_email_on_late_submission
    assert_equal 0, MailReminder.deliveries.size
  end
  
  test "Should send only 1 email" do
    entry = users(:three).entries.first
    entry.update_attribute(:created_at, 2.days.ago)
    Entry.send_email_on_late_submission
    assert_equal 1, MailReminder.deliveries.size
  end
endw