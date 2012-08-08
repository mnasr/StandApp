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
end