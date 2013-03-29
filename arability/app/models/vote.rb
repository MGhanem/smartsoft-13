class Vote < ActiveRecord::Base
  belongs_to :synonym
  belongs_to :gamer
  
end
