class Gamer < ActiveRecord::Base
  has_many :votes
  has_many :synonyms, :through => :votes
  # Include default devise modules. Others available are:
  # :token_authenticatable, :encryptable, :confirmable, :lockable, :timeoutable and :omniauthable

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me, 
                  :username, :country, :education_level, :date_of_birth

  validates :username, :presence => true, :length => { :minimum => 3 }
  validates :username, :format => { :with => /^[A-Za-z][A-Za-z0-9]*(?:_[A-Za-z0-9]+)*$/i, 
    :message => " can only start with a letter, 
    and have no 2 successive \"_\"" }
  validates :country, :presence => true, :length => { :minimum => 2 }
  validates :country, :format => { :with => /\A[a-zA-Z]+\z/,
    :message => "can't be anything except letters." }
  validates :education_level, :format => { :with => /\A^(low|medium|high)\Z/i }
  validates :date_of_birth, :date => { :after_or_equal_to => 95.years.ago, 
    :before_or_equal_to => 10.years.ago }

  #scopes defined for advanced search aid
  scope :filter_by_country, lambda { |country| where(:country.casecmp(country) == 0) }
  scope :filter_by_dob, lambda { |from, to| where :date_of_birth => to.years.ago..from.years.ago }
  scope :filter_by_gender, lambda { |gender| where :gender => gender }
  scope :filter_by_education, lambda { |education| where :education_level => education }

  has_many :synonyms, :through => :votes
  has_many :votes
end
