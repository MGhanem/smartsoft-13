#encoding:utf-8
class Gamer < ActiveRecord::Base

  has_one :authentication
  has_and_belongs_to_many :prizes
  has_and_belongs_to_many :trophies

  # Include default devise modules. Others available are:
  # :token_authenticatable, :encryptable, :confirmable, :lockable, :timeoutable and :omniauthable

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :omniauthable, omniauth_providers: [:facebook]

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation,
                  :remember_me, :gender, :provider, :uid, :highest_score,
                  :username, :country, :education_level, :date_of_birth

  validates :gender , :presence => true, :format => { :with => /\A^(male|female)\Z/i }

  validates :username, :presence => true, :length => { :minimum => 3, :maximum => 20 }

  #author: kareem ali
  def self.check
    if I18n.locale == :ar
      "اسم المستخدم يجب ان يكون بحوف او ارقام انجليزية فقط"
    end
    if I18n.locale == :en
      "username must be made up of english letters or digits"
    end
  end
  validates :gender , :presence => true, :format => { :with => /\a^(male|female)\z/i }

  validates :username, :presence => true, :length => { :minimum => 3 }
  validates :username, :format => { :with => /^[A-Za-z][A-Za-z0-9]*(?:_[A-Za-z0-9]+)*$/i, 
    :message => check }
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
      return true
    end
  end

  # :
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

  # Description:
  #   returns a list of the trophies that the gamer won
  # Author:
  #   Adam Ghanem
  # @params:
  #   none
  # returns:
  #   success:
  #     an array of the trophies that the gamer has won
  #   failure:
  #     no failure
  def get_won_trophies
    return self.trophies
  end

  # Author:
  #   Kareem Ali
  # Description:
  #   invokes record_synonym method of the Vote class
  # Params:
  #   synonym_id: which is the synonym id of the synonym for which 
  #               the gamer is voting.
  # Success:
  #   returns true when a vote is saved for the selected synonym
  # Failure:
  #   returns false when the vote is not saved
  def select_synonym(synonym_id)
    if Vote.record_vote(self.id,synonym_id)[0]
      return true
    else
      return false
    end
  end

  # Author:
  #   Kareem Ali
  # Description:
  #   invokes record_suggested_synonym method of the Synonym class
  # Params:
  #   synonym_name: which is the synonym name the gamer suggested in the  
  #                 vote form.
  # Success:
  #   returns 0 returned by the invoked method meaning saved new synonym
  # Failure:
  #   returns 1,2,3 according to the invoked method failure scenario
  def suggest_synonym(synonym_name, keyword_id)
    return Synonym.record_suggested_synonym(synonym_name, keyword_id)
  end
    

  # Description:
  #   returns a list of the gamers prizes
  # Author:
  #   Adam Ghanem
  # @params:
  #   none
  # returns:
  #   success:
  #     an array of the prizes that the gamer has won
  #   failure:
  #     no failure
  def get_available_trophies
    return Trophy.all - self.trophies
  end

  # Author:
  #   Amr Abdelraouf
  # Description:
  #   Takes the values from the input authentication token and inserts it
  # Params:
  #   auth: an omniauth authentication hash coming form Facebook
  # Success:
  #   The values are saved into the database
  # Failure:
  #   None
  def connect_to_facebook(auth)
    self.provider = auth["provider"]
    self.uid = auth["uid"]
    self.token = auth["credentials"]["token"]
    self.save
  end

  # Author:
  #   Amr Abdelraouf
  # Description:
  #   Disconnects the user's facebook information
  # Params:
  #   None
  # Success:
  #   The user's facebook uid and token are deleted from the database 
  # Failure:
  #   None
  def disconnect_from_facebook
    self.provider = nil
    self.uid = nil
    self.token = nil
    self.save
  end

  # Author:
  #   Amr Abdelraouf
  # Description:
  #   Updates the user's token field
  # Params:
  #   auth: an omniauth authentication hash coming form Facebook
  # Success:
  #   The values are saved into the database
  # Failure:
  #   None
  def update_access_token(auth)
    self.uid = auth["uid"]
    self.token = auth["credentials"]["token"]
    self.save
  end

  # Author:
  #   Amr Abdelraouf
  # Description:
  #   Checks whether the user is connected to Facebook
  # Params:
  #   None
  # Success:
  #   Boolean value is returned indicating whether or not the user
  #   has a saved token
  # Failure:
  #   None
  def is_connected_to_facebook
    token != nil
  end

  # Author:
  #   Amr Abdelraouf
  # Description:
  #   Returns the user's facebook access token
  # Params:
  #   None
  # Success:
  #   Returns the user's access token
  # Failure:
  #   None
  def get_token
    token
  end

  def won_prizes?(score, level)
    if Prize.get_new_prizes_for_gamer(self.id, score, level).count > 0
      return true
    else
      return false
    end
  end

  #scopes defined for advanced search aid
  scope :filter_by_country, lambda { |country| where(:country.casecmp(country) == 0) }
  scope :filter_by_dob, lambda { |from, to| where :date_of_birth => to.years.ago..from.years.ago }
  scope :filter_by_gender, lambda { |gender| where :gender => gender }
  scope :filter_by_education, lambda { |education| where :education_level => education }

  has_many :services, :dependent => :destroy
  has_many :synonyms, :through => :votes
  has_many :votes

  class << self

  # Author:
  #  Mirna Yacout
  # Description:
  #  This method is to retrieve the list of common arability friends and Facebook friends
  # Parameters:
  #  current_gamer: the record in Gamer table for the current user
  # Success:
  #  returns the list of common followers
  # Failure:
  #  returns nil if no gamer token is found
  def get_common_facebook_friends(current_gamer)
    if (current_gamer.token.nil?)
      return nil
    end
    @graph = Koala::Facebook::API.new(current_gamer.get_token)
    friends = @graph.get_connections("me", "friends")
    common = Array.new
    i = 0
    while i<friends.count
      if Gamer.exists?(:uid => friends.at(i)["id"], :provider => "facebook")
        common.push(Gamer.find_by_uid_and_provider(friends.at(i), "facebook").id)
        common.push(current_gamer.id)
      end
      i = i + 1
      return common
    end
  end

  end  
end

