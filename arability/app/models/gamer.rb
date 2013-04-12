#encoding:utf-8
class Gamer < ActiveRecord::Base

  has_and_belongs_to_many :trophies
  has_and_belongs_to_many :prizes
  # Include default devise modules. Others available are:
  # :token_authenticatable, :encryptable, :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
         # :omniauthable, :omniauth_providers => [:google_oauth2]

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me, 
                  :username, :country, :education_level, :date_of_birth

  #author: kareem ali
  def self.check
    if I18n.locale==:ar
      return "انت غبي؟"
    else
      return "Kareem"
    end
  end

  validates :username, :presence => true, :length => { :minimum => 3 }
  validates :username, :format => { :with => /^[A-Za-z][A-Za-z0-9]*(?:_[A-Za-z0-9]+)*$/i, 
    :message => check }
  validates :country, :presence => true, :length => { :minimum => 2 }
  validates :country, :format => { :with => /\A[a-zA-Z]+\z/,
    :message => "can't be anything except letters." }
  validates :education_level, :format => { :with => /\A^(low|medium|high|منخفض|متوسط|عالي)\Z/i }
  validates :gender , :presence => true  
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
    

  def get_available_trophies
    return Trophy.all - self.trophies
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

