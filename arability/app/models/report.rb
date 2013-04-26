class Report < ActiveRecord::Base
  # attr_accessible :title, :body
  belongs_to :reported_word, :polymorphic => true 
  belongs_to :gamer
end
