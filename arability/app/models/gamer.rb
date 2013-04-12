class Gamer < ActiveRecord::Base

  has_and_belongs_to_many :trophies
  has_and_belongs_to_many :prizes
  
  # Include default devise modules. Others available are:
  # :token_authenticatable, :encryptable, :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  attr_accessible :email, :password, :password_confirmation, :remember_me, 
                  :username, :country, :education_level, :date_of_birth, :gender

  validates :gender , :presence => true, :format => { :with => /\a^(male|female)\z/i }
                  
  validates :username, :presence => true, :length => { :minimum => 3 }
  


  validates :username, :format => { :with => /^[A-Za-z][A-Za-z0-9]*(?:_[A-Za-z0-9]+)*$/i, 
     }

  validates :country, :presence => true, :length => { :minimum => 2 }


  validates :education_level, :format => { :with => /\A^(School|University|Graduate)\Z/i }
  
  validates :date_of_birth, :date => { :after_or_equal_to => 95.years.ago, 
    :before_or_equal_to => 10.years.ago }
  
  
 # Description:
  #   Takes in a trophy id and adds it the gamers trophies array
  # Author:
  #   Adam Ghanem
  # @params:
  #   trophy_id
  # returns:
  #   success:
  #     returns true validating that the gamer has received
  #     this trophy_id
  #   failure:
  #     returns false validating that the gamer has either
  #     failed to get rewarded this trophy
  def receive_trophy(trohpy_id)
    trophy = Trophy.find(trophy_id)
    
    if trophy == nil
      return false
    end
    
    if self.trophies.include? trophy
      return false
    else
      self.trophies << trophy
    end
  end
  
  # Description:
  #   Takes in a prize id and adds it the gamers prizes array
  # Author:
  #   Adam Ghanem
  # @params:
  #   prize_id
  # returns:
  #   success:
  #     returns true validating that the gamer has received
  #     this trophy_id
  #   failure:
  #     returns false validating that the gamer has either
  #     failed to get rewarded this prize
  def receive_prize(prize_id)
    prize = Prize.find(prize_id)
    
    if prize == nil
      return false
    end
    
    if self.prizes.include? prize
      return false
    else
      self.prizes << prize
      return true
    end
  end
  
  # Description:
  #   returns a list of the gamers won prizes
  # Author:
  #   Adam Ghanem
  # @params:
  #   none
  # returns:
  #   success:
  #     an array of the prizes that the gamer has won
  #   failure:
  #     no failure
  def get_won_prizes
    return self.prizes
  end


  # Description:
  #   returns a list of the gamers prizes
  # Author:
  #   Adam Ghanem
  # @params:
  #   none
  # returns:
  #   success:
  #     an array of the prizes that the gamer can win
  #   failure:
  #     no failure
  def get_available_prizes
    return Prize.all - self.prizes
  end
  
  def get_won_trophies
    return self.trophies
  end

  def get_available_trophies
    return Trophy.all - self.trophies
  end
end
