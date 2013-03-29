class Vote < ActiveRecord::Base
  belongs_to :synonym
  belongs_to :gamer
  attr_accessible :title, :body, :id
 
end
