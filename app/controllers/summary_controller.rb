class SummaryController < ApplicationController
	def show 
    @users_without_entries = Entry.check_for_users_with_no_entries
    @users_with_entries = User.all - @users_without_entries
    @absence = Absence.today
	end
	def index
	end
end
