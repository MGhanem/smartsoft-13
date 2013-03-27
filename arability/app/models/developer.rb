class Developer < ActiveRecord::Base
  belongs_to :gamer 
  has_one :my_subscription



  
  # attr_accessible :title, :body
  
end
