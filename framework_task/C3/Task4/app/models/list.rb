class List < ActiveRecord::Base
	attr_accessible :name, :oid
	serialize :thearray,Array
	validates :name,  :presence => true
	has_many :tasks, :dependent => :destroy
end
