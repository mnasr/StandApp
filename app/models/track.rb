class Track < ActiveRecord::Base
  attr_accessible :end_date, :start_date, :user_id
  belongs_to :user
end
