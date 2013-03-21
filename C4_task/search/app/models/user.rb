class User < ActiveRecord::Base
  attr_accessible :age, :name
  belongs_to :country
end
