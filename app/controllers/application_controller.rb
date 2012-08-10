class ApplicationController < ActionController::Base
  protect_from_forgery
  
  before_filter :authenticate_user!
  before_filter :check_valid_user
  before_filter :set_user_time_zone


  def check_valid_user
    if user_signed_in?
      current_user.check_and_assign_if_date_expired
    end
  end

  def set_user_time_zone
    Time.zone = current_user.timezone if user_signed_in?
  end
  private

  # Overwriting the sign_out redirect path method
  def after_sign_in_path_for(user)
    if current_user.admin? || current_user.is_scrum_master?
      summary_path
    else
      entries_path
    end
  end
end