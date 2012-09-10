class Entry < ActiveRecord::Base

  default_scope :order => 'created_at DESC'

  CATEGORIES = ['bug', 'chore', 'feature', 'support', 'R&D']

  attr_accessible :category, :description, :ticket_id, :user_id, :created_at, :updated_at
  belongs_to :user


  validates :description, :presence => true

  validate :records_for_today?, :on => :create

  scope :today, where('created_at >= ? AND created_at <= ?', Time.now.beginning_of_day, Time.now.end_of_day)

  validate :check_entry_update_time?, :on => :update

  def self.send_email_on_late_submission
    if Time.now.hour > Settings.deadline_time
      users = Entry.check_for_users_with_no_entries - Absence.today
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

  def extract_category_from_description
    category = description[Regexp.union(CATEGORIES)]
  end

  def extract_ticket_number_from_description
    ticket_id = description.gsub(/\D+/,'').gsub(/.{4}/, ' \0')
    if ticket_id.present?
      ticket_id = ticket_id[1..-1]
      ticket_ids = ticket_id.scan(/\d\d\d\d/)
      return ticket_ids
    end
  end

  def check_entry_update_time?
   self.errors.add :base, "User can\'t update his entry anymore." unless
       self.updated_at < self.created_at + 12.hours
  end

  def records_for_today?
    if self.user_id.present?
      if self.created_at
        entry = Entry.where("user_id = ? AND created_at >= ? AND created_at <= ?", self.user_id, self.created_at, self.created_at)
      else
        entry = Entry.where("user_id = ?", self.user_id).today
      end

      unless entry.blank?
        self.errors.add :base, 'User has already an entry for today. Come back tomorrow'
        return false
      end
    end
    true
  end
end
 
