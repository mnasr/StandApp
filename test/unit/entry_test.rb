require 'test_helper'

class EntryTest < ActiveSupport::TestCase

  setup do
    @user_four = users(:four)
    @user = users(:one)
    @user_two = users(:two)
    @entry = @user.entries.create(user_id: @user.id, description: "hello Ghina and Mona")
    ActionMailer::Base.deliveries.clear
  end

  test "A user should not be able to have more than one entry for the same day" do
    entry = Entry.create(user_id: @user.id, description: "hello Ghina and Mona")
    assert_equal ['User has already an entry for today. Come back tomorrow'], entry.errors.full_messages
  end

  test "A user should be able to have more than one entry not for the same day" do
    entry_2 = Entry.new(user_id: @user.id, description: "hello Ghina and Mona")
    entry_2.created_at = (Time.now - 10.days)
    entry_2.save
    assert_equal [], entry_2.errors.full_messages
  end

  test "should not allow an empty entry" do
    entry = Entry.create
    assert_equal ["Description can't be blank"], entry.errors.full_messages
  end

  test "should return [] if all users created entries today" do
    assert_equal [], Entry.check_for_users_with_no_entries
  end

  test "shoud_extract_one_ticket_number" do
    entry_3 = Entry.create(user_id: @user.id, description: "I have been working on ticket (#1234)")
    number = entry_3.extract_ticket_number_from_description
    assert_equal ["1234"], number
  end


  test "should_extract_more_than_one_ticket_number" do
    entry_4 = Entry.create(user_id: @user.id, description: "I have been working on tickets (#1234) and (#3456)")
    number = entry_4.extract_ticket_number_from_description
    assert_equal ["1234", "3456"], number
  end

  test "should_extract_category_from the_description" do
    entry_4 = Entry.create(user_id: @user.id, description: "I have been working on a [bug]")
    category = entry_4.extract_category_from_description
    assert_equal ["bug"], category
  end

  test "should_extract_more_than_one_category_from the_description" do
    entry_4 = Entry.create(user_id: @user.id, description: "I have been working on a [bugs] and [feature]")
    category = entry_4.extract_category_from_description
    assert_equal ["bugs","feature"], category
  end

  test "should return a single user when all other users have created entries today" do
    entry = Entry.where(user_id: users(:two).id).first
    entry.update_attributes(created_at: 2.days.ago)
    assert_equal [users(:two)], Entry.check_for_users_with_no_entries
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

  test "logged in user should see a list of his or her entry, ordered by newest entries, by default" do
     entry1 = @user_four.entries.create(description: "MyText", created_at: Time.now )
     entry2 = @user_four.entries.create(description: "MyText", created_at: Time.now - 3.days)
     assert_equal [entries(:four), entry1 , entry2], users(:four).entries
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

  test "should detect and substitute ticket names" do
    entry = Entry.create(user_id: @user.id, description: "I have been working on ticket #1234 ")
    assert_match  /http:/, entry.formatted_description
  end

  test "should detect and substitute all ticket names" do
    entry = Entry.create(user_id: @user.id, description: "I have been working on ticket #1234 and she is working on #2445")
    assert_match  /http:/, entry.formatted_description
    assert_match  /http:/, entry.formatted_description
  end

  test "should detect and substitute all categories names" do
    entry = Entry.create(user_id: @user.id, description: "I have been working on ticket #1234 this is a [chore]")
    assert_equal "I have been working on ticket [#1234](http://dev.nuserv.com/issues/1234) this is a [[chore](http://localhost:3000/search/search?search=chore)]", entry.formatted_description
  end

   test "should detect and substitute the whole url" do
    entry = Entry.create(user_id: @user.id, description: "I have been working on ticket #1234")
    assert_equal  "I have been working on ticket [#1234](http://dev.nuserv.com/issues/1234)", entry.extract_ticket_ids
  end

  test "should detect and substitute all categories and ticket names with the whole url" do
    entry = Entry.create(user_id: @user.id, description: "I have been working on a [chore]")
    assert_equal  "I have been working on a [[chore](http://localhost:3000/search/search?search=chore)]", entry.extract_category
  end

  test "should detect and substitute all categories" do
    entry = Entry.create(user_id: @user.id, description: "I have been working on a [chore,feature]")
    assert_equal  "I have been working on a [[chore](http://localhost:3000/search/search?search=chore),[feature](http://localhost:3000/search/search?search=feature)]", entry.extract_category
  end
end
