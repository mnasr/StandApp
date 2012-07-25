require 'test_helper'

class UserTest < ActiveSupport::TestCase
 
	setup do
 		@good_user = User.create(:email => 'mark@monaqasat.com', :fullname => "Mark Anthony", :password => "12345678", :password_confirmation => "12345678")
 		@bad_user = User.create(:email => 'bill@microsoft.com', :fullname => "Bill Gates", :password => "12345678", :password_confirmation => "12345678")
	end

	test "User should use monaqasat email address" do
		assert @good_user.valid?
	end

	test "User should not be allowed to use non-monaqasat email address" do
		assert ! @bad_user.valid?
	end
end