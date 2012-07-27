class Entry < ActiveRecord::Base
  CATEGORIES = ["Bug", "Chore", "Feature", "Support", "R&D"]
  attr_accessible :category, :description, :ticket_id, :user_id
  belongs_to :user

  validates :description, :presence => true
  validates :category, :presence => true
  validates :user_id, :presence => true

  validates :user_id, :uniqueness => {:message => 'has already an entry for today. Come back tomorrow'}, :unless => :records_for_today?

  private
  def records_for_today?
    Entry.exists?(:user_id => self.user_id, :created_at => Time.now.day)
  end
end
