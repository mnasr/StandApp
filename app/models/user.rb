class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  DAYS_OF_WEEK = ["Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday", "Sunday"]
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable

  # Setup accessible (or protected) attributes for your model

  attr_accessible :email, :password, :password_confirmation, :remember_me, :fullname, :admin, :week_pattern, :timezone


  validates :fullname, uniqueness: true
  validates :fullname, presence: true
  validates :email, uniqueness: true
  validates :email, presence: true
  validates :email, format: { :with => /^([^@\s]+)@((?:[monaqasat]+\.)+[a-z]{2,})$/i }
  validates_presence_of :week_pattern, :on => :update
  validates_presence_of :timezone, :on => :update

  before_destroy :ensure_an_admin_remains

  has_many :entries, :dependent => :destroy
  has_many :tracks
  has_many :absences, :dependent => :destroy

  def self.scrum_master
    track = Track.where("start_date >= ? AND end_date <= ?", Time.now.beginning_of_week, Time.now + Settings.scrum_master_period.to_i.week).first
    track.user if track.present?
  end


  def check_and_assign_if_date_expired
    track = self.tracks.first
    if track.present? && track.end_date <= DateTime.now
      new_scrum_master_id = pick_user_as_new_scrum_master
      Track.create(:start_date => track.end_date, :end_date => (track.end_date + Settings.scrum_master_period.to_i.week), :user_id => new_scrum_master_id)
    end
  end

  def self.absent
    absences = Absence.today
    if absences.present?
      user_ids = absences.collect {|absence| absence.user_id}
      User.where("id IN (?)", user_ids)
    end
  end

  def pick_user_as_new_scrum_master
    users = User.all - [User.scrum_master]
    user_ids = users.map {|user| user.id}
    user_ids.sample
  end

  def is_scrum_master?
    self == User.scrum_master
  end

  def working_days_count_per_month
    user_starting_day = Date.new( self.created_at.year, self.created_at.month, self.created_at.day )
    until_today = Date.new( Time.now.year, Time.now.month, Time.now.day)

    if self.week_pattern == "Sunday"
      wdays = [5,6]
      weekdays = (user_starting_day..until_today).reject { |days| wdays.include? days.wday}
    else
      wdays = [0,6]
      weekdays = (user_starting_day..until_today).reject { |days| wdays.include? days.wday}
    end
    weekdays.count if weekdays.present?
  end

  def count_of_entries
    unless self.entries.empty?
      count = Entry.where("user_id = ? AND created_at <= ?", self.id, last_entry.created_at).count
    else
      count = 0
    end
  end

  def self.get_all_users
    today = Time.zone.now.strftime("%A").downcase
    case today
    when 'sunday' || 'monday'
      User.where("week_pattern = ? OR week_pattern IS NULL", today).all
    when 'friday'
      User.where("week_pattern = ? OR week_pattern IS NULL", 'monday').all
    else
      User.all
    end
  end

  private

  def ensure_an_admin_remains
    if !User.count.zero? && self.admin == true
      self.errors.add(:base, "Cant delete the last user that is also an admin")
    end
  end

  def last_entry
    self.entries.first
  end
end
