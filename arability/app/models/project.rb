class Project < ActiveRecord::Base
  belongs_to :developer
  # attr_accessible :title, :body
end
