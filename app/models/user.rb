class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable



  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me, :fullname, :admin
  before_destroy :ensure_an_admin_remains
  has_many :entries 

  private 

  def ensure_an_admin_remains
    if !User.count.zero? && self.admin == true
      self.errors.add(:base, "Cant delete the last user that is also an admin")
    end
  end
end   
