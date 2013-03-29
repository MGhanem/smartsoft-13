class Developer < ActiveRecord::Base
  belongs_to :gamer
   attr_accessible :first_name, :last_name, :verified, :gamer_id
   validates :first_name,  :presence => true
   validates :last_name,  :presence => true
   validates_format_of :first_name, :with => /^[a-zA-Z0-9][a-zA-Z0-9_]*$/
   validates_format_of :last_name, :with => /^[a-zA-Z0-9][a-zA-Z0-9_]*$/
   validates :gamer_id, :presence => true, :uniqueness => true
end
