class Entry < ActiveRecord::Base
  attr_accessible :category, :description, :ticket_id, :user_id
end
