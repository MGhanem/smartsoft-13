class Developer < ActiveRecord::Base
  belongs_to :gamer
  # attr_accessible :title, :body
end
