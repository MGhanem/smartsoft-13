class PreferedSynonym < ActiveRecord::Base
  belongs_to :project
  belongs_to :keyword
  belongs_to :synonym
  # attr_accessible :title, :body
end
