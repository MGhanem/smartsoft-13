class Project < ActiveRecord::Base
  attr_accessible :name
  belongs_to :developer
end
