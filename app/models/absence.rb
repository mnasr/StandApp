class Absence < ActiveRecord::Base
  attr_accessible :description, :user

  belongs_to :user
end
