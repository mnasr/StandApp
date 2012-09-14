require 'test_helper'

class UserTest < ActiveSupport::TestCase
  
	setup do
		@user = users(:three)
		@track = tracks(:two)
		@user.tracks << @track
 		@good_user = User.create(:email => 'mark@monaqasat.com', :fullname => "Mark Anthony", :password => "12345678", :password_confirmation => "12345678", :week_pattern => "Tuesday", :timezone => "(GMT+00:00) UTC")
 		@bad_user = User.create(:email => 'bill@microsoft.com', :fullname => "Bill Gates", :password => "12345678", :password_confirmation => "12345678")
    @fullname_user = User.new(:email => 'nasr@monaqasat.com', :fullname => "Mona Nasr", :password => "12345678", :password_confirmation => "12345678")
    @nofullname_user = User.new(:email => 'mnasr@monaqasat.com', :fullname => "", :password => "12345678", :password_confirmation => "12345678")
    @email_user = User.new(:email => 'mn@monaqasat.com', :fullname => "MONA NASR", :password => "12345678", :password_confirmation => "12345678")
    @noemail_user = User.new(:email => '', :fullname => "MONA NASR", :password => "12345678", :password_confirmation => "12345678")
	end

	test "User should use monaqasat email address" do
    assert @good_user.valid? 
	end

	test "User should not be allowed to use non-monaqasat email address" do
		assert ! @bad_user.valid?
	end

  test "User's fullname should be present" do
    assert @fullname_user.fullname.present?
  end

  test "User's fullname should not be empty" do
    assert ! @nofullname_user.fullname.present?
  end

  test "User's email should be present" do
    assert @email_user.email.present?
  end

  test "User's email should not be empty" do
    assert ! @noemail_user.email.present?
  end

  test "should validate unique email" do
    user1 = User.new(:email => "mona@monaqasat.com", :fullname => "Mona Nasr", :password => "secret", :password_confirmation => "secret")
    user2 = User.new(:email => "mona@monaqasat.com", :fullname => "M Nasr", :password => "secret", :password_confirmation => "secret")
    user2.errors[:email]
  end

  test "should validate unique fullname" do
    user1 = User.new(:email => "mona@monaqasat.com", :fullname => "Mona Nasr", :password => "secret", :password_confirmation => "secret")
    user2 = User.new(:email => "nasr@monaqasat.com", :fullname => "Mona Nasr", :password => "secret", :password_confirmation => "secret")
    user2.errors[:fullname]
  end

  test "At least one user is assigned as an admin" do
    user = User.destroy(@user.id)
    assert_equal ['Cant delete the last user that is also an admin'], user.errors.full_messages
  end 

  test "A random user is selected as a scrum master" do
    assert_include(User.all.map{|user| user.id}, @user.pick_user_as_new_scrum_master)
  end

  test "return the user who is the current scrum master" do
  	assert_equal @user, User.scrum_master
  	assert_equal User, User.scrum_master.class
  end
  
  test "return nil if there are no scrum masters assigned" do
    @track.update_attributes(start_date: Time.now - 2.weeks, end_date: Time.now - 1.weeks)
  	assert_equal nil, User.scrum_master
  end

  test "assign new scrum master if expired" do
  	@track.update_attributes(:start_date => Time.now - 3.weeks, :end_date => Time.now - 2.weeks, :user_id => @user.id)

  	assert_difference("Track.count") do
  	  @user.check_and_assign_if_date_expired
  	end

  	assert_not_equal @user, User.scrum_master
 
  end

  test "Entries should be deleted when corresponding user is deleted" do
    user2 = users(:two)
    entry = user2.entries.create(user_id: user2.id, description: "hello Ghina and Mona")
    assert_not_equal [], user2.entries

    User.destroy(user2)

    assert_nil User.where(id: user2).first
    assert_nil Entry.where(id: entry).first
  end

  test "user is scrum master" do
    assert @user.is_scrum_master?
  end

  test "user is not scrum master" do
    assert ! users(:one).is_scrum_master?
  end

  test "should return users who are absent" do
    users(:one).absences.create(description: "hey there")
    assert_equal 1, User.absent.size
    assert User.absent.include?(users(:one))
  end
end