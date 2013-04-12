class Gamer < ActiveRecord::Base
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

    #Author: Kareem ALi
    #This method is used to select a synonym 
    #by a certain gamer
    #Parameters:
    #  synonym_id: the synonym ID that the gamer voted for
    #Returns:
    #  On success: returns true if selecting synonym is true, when 
    #  Vote.record_vote returns true
    #  On failure: returns false if no new vote was created 
    def select_synonym(synonym_id)
      if Vote.record_vote(self.id,synonym_id)[0]
        return true
      else
        return false
      end
    end

end