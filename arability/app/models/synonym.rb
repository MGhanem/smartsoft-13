class Synonym < ActiveRecord::Base
  belongs_to :keyword
  attr_accessible :approved, :name

end
