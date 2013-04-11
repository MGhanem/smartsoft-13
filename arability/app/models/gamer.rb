class Gamer < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :encryptable, :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  attr_accessible :email, :password, :password_confirmation, :remember_me, 
                  :username, :country, :education_level, :date_of_birth, :gender

  validates :gender , :presence => true, :format => { :with => /\A^(male|female)\Z/i }
                  
  validates :username, :presence => true, :length => { :minimum => 3 }
  


  validates :username, :format => { :with => /^[A-Za-z][A-Za-z0-9]*(?:_[A-Za-z0-9]+)*$/i, 
     }

  validates :country, :presence => true, :length => { :minimum => 2 }


  validates :education_level, :format => { :with => /\A^(School|University|graduate)\Z/i }
  
  validates :date_of_birth, :date => { :after_or_equal_to => 95.years.ago, 
    :before_or_equal_to => 10.years.ago }
  
end
