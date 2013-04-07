class Gamer < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :encryptable, :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me, 
                  :username, :age, :country, :education_level
                  
  # attr_accessible :title, :body
  validates :username, :presence => true, :length => { :minimum => 2 }
  validates :username, :format => { :with => /\A[a-zA-Z]+\z/,:message => "can't be anything except letters." }
  validates :age, :numericality => { :greater_than_or_equal_to => 0, :less_than_or_equal_to => 100, :only_integer => true }
  validates :country, :presence => true, :length => { :minimum => 2 }
  validates :country, :format => { :with => /\A[a-zA-Z]+\z/,:message => "can't be anything except letters." }
  validates :education_level, :presence => true, :length => { :minimum => 2 }
  validates :education_level, :format => { :with => /\A^(low|medium|high)\Z/i,:message => "can't be except low, medium or high" }

  has_many :authentications


end
