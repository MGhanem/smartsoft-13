class MySubscription < ActiveRecord::Base
  attr_accessible :word_add, :word_follow, :word_search
  belongs to :developer
  has many :developers
end
