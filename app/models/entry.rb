class Entry < ActiveRecord::Base
  include Rails.application.routes.url_helpers

  default_scope :order => 'created_at DESC'

  CATEGORIES = ['bug', 'chore', 'feature', 'support', 'R&D']

  attr_accessible :description, :user_id, :created_at, :updated_at
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

  def extract_category_from_description
    categories = description.scan(/\[(.*?)\]/).flatten
    local_categories = []
    categories.each do |category|
      local_categories << category.split(",").map(&:strip).each(&:downcase)
    end
    local_categories.uniq.flatten
  end

  def extract_ticket_number_from_description
    ticket_id = description.scan(/\#\d+/)
    ticket_id.map{|id| id.gsub(/#/,'')}.uniq
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
    extract_category
    extract_ticket_ids
    self.description
  end

  def extract_ticket_ids
    extract_ticket_number_from_description.each do |tid|
      self.description.gsub!(/##{tid}/,"[##{tid}](#{Settings.redmine_url}#{tid})")
    end
    self.description
  end

  def extract_category
    extract_category_from_description.each do |category|
      self.description.gsub!(/#{category}/, "[#{category}](http://#{Settings.application_url}/search/search?search=#{category})")
    end
    self.description
  end
end 

