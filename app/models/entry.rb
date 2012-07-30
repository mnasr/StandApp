class Entry < ActiveRecord::Base
  CATEGORIES = ["Bug", "Chore", "Feature", "Support", "R&D"]
  attr_accessible :category, :description, :ticket_id, :user_id
  belongs_to :user

  validates :description, :presence => true
  validates :category, :presence => true
  validates :user_id, :presence => true

  validates :user_id, :uniqueness => {:message => 'has already an entry for today. Come back tomorrow'}, :unless => :records_for_today?


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
    users = User.pluck(:id)
    users.each do |user|
      entry = Entry.exists?(created_at: Time.now.day)
       if (entry == false)
        users_we = users
        puts users
      end
    end 
  end

  def records_for_today?
    Entry.exists?(:user_id => self.user_id, :created_at => Time.now.day)
  end
end
