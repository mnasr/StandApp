module UsersHelper
	def working_days(user)
    if user.absences.present?
      total_working_days = user.working_days_count_per_month - user.absences.count
    else
      total_working_days = user.working_days_count_per_month
    end
  end
end
