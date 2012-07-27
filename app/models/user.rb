class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable



  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me, :fullname, :admin
  validates_format_of :email, :with => /^([^@\s]+)@((?:[monaqasat]+\.)+[a-z]{2,})$/i
  before_destroy :ensure_an_admin_remains
  has_many :entries
  has_many :tracks

  def self.scrum_master
    track = Track.where("start_date > ? AND end_date < ?", Time.now.beginning_of_week, Time.now.end_of_week + Settings.scrum_master_period.to_i.week).first
    track.user if track.present?
  end

  def check_and_assign_if_date_expired
    track = self.tracks.first
    if track.present? && track.end_date <= DateTime.now
      new_scrum_master_id = pick_user_as_new_scrum_master
      Track.create(:start_date => track.end_date, :end_date => (track.end_date + Settings.scrum_master_period.to_i.week), :user_id => new_scrum_master_id)
    end 
  end

  def pick_user_as_new_scrum_master
    users = User.all - [User.scrum_master]
    user_ids = users.map {|user| user.id}
    user_ids.sample
  end

  private 

  def ensure_an_admin_remains
    if !User.count.zero? && self.admin == true
      self.errors.add(:base, "Cant delete the last user that is also an admin")
    end
  end
end