class Absence < ActiveRecord::Base
  attr_accessible :description, :user_id, :created_at

  belongs_to :user
  validates :description, :presence => true

  scope :today, where('created_at >= ? AND created_at <= ?', Date.today.beginning_of_day, Date.today.end_of_day)
end 