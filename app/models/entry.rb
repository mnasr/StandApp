class Entry < ActiveRecord::Base

  default_scope :order => 'created_at DESC'

  CATEGORIES = ["Bug", "Chore", "Feature", "Support", "R&D"]
  attr_accessible :category, :description, :ticket_id, :user_id, :created_at
  belongs_to :user

  validates :description, :presence => true
  validates :category, :presence => true
  validates :user_id, :presence => true

  validate :records_for_today?

  scope :today, where('created_at >= ? AND created_at <= ?', Time.now.beginning_of_day, Time.now.end_of_day)

  def self.send_email_on_late_submission
    if Time.now.hour > Settings.deadline_time
      users = Entry.check_for_users_with_no_entries
      users.each do |user|
        MailReminder.late(user).deliver
      end 
    end
  end

  def self.check_for_users_with_no_entries
    User.all.select do |user|
      user.entries.today.blank?
    end
  end

  def records_for_today?
    if self.user_id.present?
      entry = Entry.scoped
      if self.created_at
        entry = entry.where("user_id = ? AND created_at >= ? AND created_at <= ?", self.user_id, self.created_at, self.created_at)
      else
        entry = entry.today
      end

      unless entry.empty?
        self.errors.add :base, 'User has already an entry for today. Come back tomorrow'
        return false
      end
    end
    true
  end
  
end
 
