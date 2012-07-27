require 'test_helper'

class EntryTest < ActiveSupport::TestCase
  setup do
    @current_time = Time.now
    @user = users(:one)
    @entry = entries(:one)
    @entry.update_attribute(:user, @user)
  end

  test "A user should not be able to have more than one entry for the same day" do
    entry = Entry.create(user_id: @user.id, category: 1, description: "hello Ghina and Mona")
    assert_equal ['User has already an entry for today. Come back tomorrow'], entry.errors.full_messages
  end
  
  test "should not allow an empty entry" do
    entry = Entry.create
    assert_equal ["Description can't be blank", "Category can't be blank", "User can't be blank"], entry.errors.full_messages
  end
end 

