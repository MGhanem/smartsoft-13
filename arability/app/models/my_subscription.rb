class MySubscription < ActiveRecord::Base
  attr_accessible :developer, :word_add, :word_follow, :word_search
  belongs_to :developer
end
