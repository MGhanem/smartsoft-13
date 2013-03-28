class Developer < ActiveRecord::Base
  belongs_to :gamer
   attr_accessible :first_name, :last_name, :verified, :gamer_id
   validates :first_name,  :presence => true
   validates :last_name,  :presence => true
   # validates :gamer_id, :presence => true, :uniqueness => true
end
