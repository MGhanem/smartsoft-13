class SharedProject < ActiveRecord::Base
	belongs_to :project
	belongs_to :developer
end