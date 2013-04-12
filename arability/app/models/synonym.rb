class Synonym < ActiveRecord::Base
  belongs_to :keyword
  attr_accessible :approved, :name, :keyword_id
  has_many :votes
  has_many :gamers, :through => :vote
  validates_format_of :name, :with => /^([\u0621-\u0652 ])+$/,
    :message => "The synonym is not in the correct form"

  class << self
    # Author:
    #  Mirna Yacout
    # Description:
    #  This method is to record the aproval of the admin to a certain synonym 
    #   in the database
    # Parameters:
    #  id: the id of the synonym to be approved
    # Success:
    #  returns true on saving the approval correctly in the database
    # Failure:
    #  returns false if the synonym doesnot exist in the database
    #  or if the approval failed to be saved in the database 
      def approve_synonym(synonym_id)
        if Synonym.exists?(id: synonym_id)
          synonym = Synonym.find(synonym_id)
          synonym.approved = true
          return synonym.save
        end
        return false
      end

    # author:
    #   Omar Hossam
    # description:
    #   feature adds synonym to database and returns a boolean result 
    #   indicatiing success or failure of saving
    # parameters:
    #   syn: string input parameter that represents the synonym name
    #   key_id: integer input parameter representing the keyword id
    #     the synonym points to
    #   approved: an optional boolean input parameter with a default false
    #     represents if an admin has approved a synonym on database or not
    # success:
    #   Output is boolean -- this method returns true if the vote has been 
    #   recorded.
    # failure: 
    #   returns false if word not saved to database due to incorrect expression 
    #   of synonym name or an incorrect keyword id for an unavaialable keyword 
    #   in database
      def recordsynonym(syn, key_id, approved = false)
        if syn == ""
          return false
        else if Keyword.exists?(id: key_id)
              synew = Synonym.new
              synew.name = syn
              synew.keyword_id = key_id 
              return synew.save
            else
              return false
            end
        end
      end
  end

  # Author: Nourhan Zakaria
  # Description:
  #  This method is used to get the countries of voters who voted for certain 
  #  synonym along with the percentage of voters belonging to each country
  # Parameters: --
  # Returns:
  #  On Success: a list of lists, each one of the inner lists consists of  
  #  a key and value.
  #  The key represents the country and the value is the percentage of voters 
  #  that belong to this country
  #  On failure: returns an empty list if no gamers voted for this synonym yet.
  def get_visual_stats_country
    voters = Gamer.joins(:synonyms).where("synonym_id = ?", self.id)
    groups = voters.count(group: :country)
    sum = groups.sum{|v| v.last}
    mapping = groups.map {|key, value| [key.downcase.tr(" ", "_"),value]}
    return mapping.map {|key, value| [I18n.t(key),((value.to_f/sum)*100).to_i]}

  end 

  # Author: Nourhan Zakaria
  # Description:
  #  This method is used to get the percentage of females and males who voted 
  #  for certain synonym
  # Parameters: --
  # Returns:
  #  On Success: a list of lists, each one of the inner lists consists of 
  #  a key and value.
  #  The key represents the gender and the value is the percentage of voters 
  #  belonging to this gender.
  #  On failure: returns an empty list if no gamers voted for this synonym yet.
  def get_visual_stats_gender
    voters = Gamer.joins(:synonyms).where("synonym_id = ?", self.id)
    groups = voters.count(group: :gender)
    sum = groups.sum{|v| v.last}
    mapping = groups.map {|key, value| [key.downcase.tr(" ", "_"),value]}
    return mapping.map {|key, value| [I18n.t(key),((value.to_f/sum)*100).to_i]}
  end 

  # Author: Nourhan Zakaria
  # Description:
  #  This method is used to get the percentage of gamers, who voted for 
  #  certain synonym, belonging to each age groups 
  # Parameters: --
  # Returns:
  #  On Success: a list of lists, each one of the inner lists consists of 
  #  a key and value.
  #  The key represents the age group and the value is the percentage of 
  #  voters belong to this age group.
  #  On failure: returns an empty list if no gamers voted for this synonym yet.
  def get_visual_stats_age
    voters = Gamer.joins(:synonyms).where("synonym_id = ?", self.id)
    
    groupOne = voters.select('date_of_birth').group("date_of_birth")
    .having("date_of_birth <= ? AND date_of_birth >= ?", 
    10.years.ago.to_date, 25.years.ago.to_date).count
    one = groupOne.sum{|v| v.last}

    groupTwo = voters.select('date_of_birth').group("date_of_birth")
    .having("date_of_birth < ? AND date_of_birth >= ?", 
    25.years.ago.to_date, 45.years.ago.to_date).count
    two = groupTwo.sum{|v| v.last}

    groupThree = voters.select('date_of_birth').group("date_of_birth")
    .having("date_of_birth < ?", 45.years.ago.to_date).count
    three = groupThree.sum{|v| v.last}

    sum = one + two + three
    if sum != 0
      list = [["10-25", one], ["26-45", two], ["46+", three]]
      return list.map {|key, value| [key,((value.to_f/sum)*100).to_i]}
    else
      return []
    end
  end 

  # Author: Nourhan Zakaria
  # Description:
  #  This method is used to get the percentage of gamers, who voted for 
  #  certain synonym, belonging to each educational level.
  # Parameters: --
  # Returns:
  #  On Success: a list of lists, each one of the inner lists consists of 
  #  a key and value.
  #  The key represents the education level and the value is the percentage 
  #  of voters having this education level.
  #  On failure: returns an empty list if no gamers voted for this synonym yet.
  def get_visual_stats_education
    voters = Gamer.joins(:synonyms).where("synonym_id = ?", self.id)
    groups = voters.count(group: :education_level)
    sum = groups.sum{|v| v.last}
    mapping = groups.map {|key, value| [key.downcase.tr(" ", "_"),value]}
    return mapping.map {|key, value| [I18n.t(key),((value.to_f/sum)*100).to_i]}
  end 
end

