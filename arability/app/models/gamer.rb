class Gamer < ActiveRecord::Base
  has_many :votes
  has_many :synonyms, :through => :votes
  # Include default devise modules. Others available are:
  # :token_authenticatable, :encryptable, :confirmable, :lockable, :timeoutable and :omniauthable

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  attr_accessible :email, :password, :password_confirmation, :remember_me,
                  :username, :country, :education_level, :date_of_birth, :gender

  validates :gender , :presence => true, :format => { :with => /\A^(male|female)\Z/i }

  validates :username, :presence => true, :length => { :minimum => 3, :maximum => 20 }

  validates :username, :format => { :with => /^[A-Za-z][A-Za-z0-9]*(?:_[A-Za-z0-9]+)*$/i, 
     }

  validates :country, :presence => true, :length => { :minimum => 2 }


  validates :education_level, :format => { :with => /\A^(School|University|Graduate)\Z/i }
  
  validates :date_of_birth, :date => { :after_or_equal_to => 95.years.ago, 
    :before_or_equal_to => 10.years.ago }
  #scopes defined for advanced search aid
  scope :filter_by_country, lambda { |country| where 'country LIKE ?', country }
  scope :filter_by_dob, lambda { |from, to| where :date_of_birth => to.years.ago..from.years.ago }
  scope :filter_by_gender, lambda { |gender| where :gender => gender }
  scope :filter_by_education, lambda { |education| where :education_level => education }
  
end
