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

  def get_visual_stats_country(synonym_id)
        voters = Gamer.joins(:synonyms).where("synonym_id = ?", synonym_id)
        groups = voters.count(group: :country)
        sum = groups.sum{|v| v.last}
        return groups.map {|key, value| [key,((value.to_f/sum)*100).to_i]}
  end 

  def get_visual_stats_gender(synonym_id)
      voters = Gamer.joins(:synonyms).where("synonym_id = ?", synonym_id)
      groups = voters.count(group: :gender)
      sum = groups.sum{|v| v.last}
      return groups.map {|key, value| [key,((value.to_f/sum)*100).to_i]}
  end 


  def get_visual_stats_age(synonym_id)
        voters = Gamer.joins(:synonyms).where("synonym_id = ?", synonym_id)
        
         groupOne = voters.select('date_of_birth').group("date_of_birth")
        .having("date_of_birth <= ? AND date_of_birth >= ?", 10.years.ago.to_date, 25.years.ago.to_date).count
         one = groupOne.sum{|v| v.last}

         groupTwo = voters.select('date_of_birth').group("date_of_birth")
        .having("date_of_birth < ? AND date_of_birth >= ?", 25.years.ago.to_date, 45.years.ago.to_date).count
         two = groupTwo.sum{|v| v.last}

         groupThree = voters.select('date_of_birth').group("date_of_birth")
        .having("date_of_birth < ?", 45.years.ago.to_date).count
         three = groupThree.sum{|v| v.last}

         sum = one + two + three
         list = [["10-25", one], ["26-45", two], ["46+", three]]
         return list.map {|key, value| [key,((value.to_f/sum)*100).to_i]}
  end 

  def get_visual_stats_education(synonym_id)
        voters = Gamer.joins(:synonyms).where("synonym_id = ?", synonym_id)
        groups = voters.count(group: :education_level)
        sum = groups.sum{|v| v.last}
        return groups.map {|key, value| [key,((value.to_f/sum)*100).to_i]}
  end 

 end
end

