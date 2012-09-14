class Entry < ActiveRecord::Base

  default_scope :order => 'created_at DESC'

  CATEGORIES = ['bug', 'chore', 'feature', 'support', 'R&D']

  attr_accessible :description, :ticket_id, :user_id, :created_at, :updated_at
  belongs_to :user


  validates :description, :presence => true

  validate :records_for_today?, :on => :create

  scope :today, where('created_at >= ? AND created_at <= ?', Time.now.beginning_of_day, Time.now.end_of_day)


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

  def formatted_description
    extract_ticket_ids
    extract_categories
    self.description
  end

  def extract_ticket_ids
    ticket_ids = self.description.scan(/\#\d+/).map{|id| id.gsub(/#/,'')}

    ticket_ids.each do |tid|
      self.description.gsub!(/#{tid}/,"<a href=\'http://dev.nuserv.com/issues/#{tid}\'>#{tid}</a>")
    end
    self.description
  end

  def extract_categories
    categories = self.description.scan(/\(([^\)]+)\)/).collect { |element| element.count() ==  1 ? element[0] : element }
    categories.each do |category|
      self.description.gsub!(/#{category}/,"<a href=\'http://localhost:3000/search?search[]=#{category}\'>#{category}</a>")
    end
    self.description
  end
end 
 
