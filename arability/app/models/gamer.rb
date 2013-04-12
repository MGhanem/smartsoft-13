#encoding:utf-8
class Gamer < ActiveRecord::Base

  has_one :authentication
  has_and_belongs_to_many :prizes
  has_and_belongs_to_many :trophies

  # Include default devise modules. Others available are:
  # :token_authenticatable, :encryptable, :confirmable, :lockable, :timeoutable and :omniauthable

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :omniauthable, :omniauth_providers => [:facebook]

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me, :gender,
                  :username, :country, :education_level, :date_of_birth, :provider, :uid


  #author: kareem ali
  def self.check
    if I18n.locale == :ar
      "اسم المستخدم يجب ان يكون بحوف او ارقام انجليزية فقط"
    end
    if I18n.locale == :en
      "username must be made up of english letters or digits"
    end
  end

  validates :username, :presence => true, :length => { :minimum => 3 }
  validates :username, :format => { :with => /^[A-Za-z][A-Za-z0-9]*(?:_[A-Za-z0-9]+)*$/i, 
    :message => check }
  validates :country, :presence => true, :length => { :minimum => 2 }

  validates :gender , :presence => true  


  validates :education_level, :format => { :with => /\A^(School|University|graduate|مدرسة|جامعة|خريج)\Z/i }
  
  validates :date_of_birth, :date => { :after_or_equal_to => 95.years.ago, 
    :before_or_equal_to => 10.years.ago }
  
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
  
  def get_won_prizes
    return self.prizes
  end

  def get_available_prizes
    return Prize.all - self.prizes
  end
  
  def get_won_trophies
    return self.trophies
  end


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

    #Author: Kareem ALi
      def suggest_synonym(synonym_name, keyword_id)
        return Synonym.record_suggested_synonym(synonym_name, keyword_id)
      end

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
  #   Return's the user's facebook access token
  # Params:
  #   None
  # Success:
  #   Return's the user's access token
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
end

