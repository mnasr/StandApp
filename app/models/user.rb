class User < ActiveRecord::Base
  attr_accessible :email, :fullname
end
