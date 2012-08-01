class Entry < ActiveRecord::Base
  CATEGORIES = ["Bug", "Chore", "Feature", "Support", "R&D"]
  attr_accessible :category, :description, :ticket_id, :user_id
  belongs_to :user

  validates :description, :presence => true
  validates :category, :presence => true
  validates :user_id, :presence => true

  validates :user_id, :uniqueness => {:message => 'has already an entry for today. Come back tomorrow'}, :unless => :records_for_today?

  scope :today, where('created_at >= ? AND created_at <= ?', Date.today.beginning_of_day, Date.today.end_of_day)

  def self.send_email_on_late_submission
    if Time.now.hour > Settings.deadline_time
      late_users = User.all 
      late_users = late_users.check_for_users_with_no_entries
      late_users.each do |v|
        MailReminder.late(v).deliver
      end 
    end
  end

  def self.check_for_users_with_no_entries
    User.all.select do |user|
      user.entries.today.blank?
    end
  end

  def records_for_today?
    Entry.exists?(:user_id => self.user_id, :created_at => Date.today)
  end
end
