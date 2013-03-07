class Task < ActiveRecord::Base
  attr_accessible :name, :done
  belongs_to :list
  validates :name,  :presence => true
end
