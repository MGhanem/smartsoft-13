#encoding:utf-8
class Synonym < ActiveRecord::Base
  belongs_to :keyword
  attr_accessible :approved, :name, :keyword_id
  has_many :votes


  # Author:
  #   Nourhan Mohamed
  # Description:
  #   gets the vote count for a certain synonym
  # Parameters:
  #   filter: optional parameter used for vote count filtering
  # Success:
  #   returns vote count for the given synonym
  # Failure:
  #   returns -1 if the synonym or the keyword to which the synonym belongs
  #   is not approved
    def get_votes(filter = [])
      if(filter.blank?)
        keyword_model = Keyword.find(self.keyword_id)
        if(self.approved && keyword_model.approved)
          return Synonym.joins(:votes).where(:id => self.id).count
        else
          return -1
        end
      # else
        #Handling filters reside here
      end
    end

  class << self
    # author:
    #   Omar Hossam
    # description:
    #   feature adds synonym to database and returns a boolean result
    #   indicatiing success or failure of saving
    # parameters:
    #   synonym_name: string input parameter that represents the synonym name
    #   keyword_id: integer input parameter representing the keyword id
    #     the synonym points to
    #   approved: an optional boolean input parameter with a default false
    #     represents if an admin has approved a synonym on database or not
    # success:
    #   Output is boolean -- this method returns true if
    #     the vote has been recorded
    # failure: 
    #   returns false if word not saved to database due to incorrect expression
    #   of synonym name or an incorrect keyword id for
    #   an unavaialable keyword in database
      def record_synonym(synonym_name, keyword_id, approved = false)
        if synonym_name.blank?
          return false
        elsif Synonym.exists?(name: synonym_name, keyword_id: keyword_id)
          return false
        elsif Keyword.exists?(id: keyword_id)
          new_synonym = Synonym.new
          new_synonym.name = synonym_name
          new_synonym.keyword_id = keyword_id
          return new_synonym.save
        else
          return false
        end
      end

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
      end

    # Author: 
    #   Nourhan Mohamed
    # Description:
    #   retrieved approved synonyms for a given keyword
    # Parameters:
    #   keyword: a string representing the keyword for which the synonyms will
    #     be retrieved
    # Success:
    #   returns a list of synonyms for the passed keyword
    # Failure:
    #   returns an empty list if the keyword doesn't exist or if no approved
    #   synonyms where found for the keyword  
      def retrieve_synonyms(keyword)
        if(Keyword.is_english_keyword(keyword))
          keyword.downcase!
        end
        keyword_model = Keyword.where(:name => keyword, :approved => true)
        if(!keyword_model.exists?)
          return []
        end
        keyword_id = keyword_model.first.id
        synonym_list = Synonym
          .where(:keyword_id => keyword_id, :approved => true)
        synonym_list = synonym_list.sort_by { |synonym| synonym.get_votes }
          .reverse!
        return synonym_list
      end


  # author:
  #   kareem ali
  #  blanck => 1
  #  synonyms exists => 2
  #  synonym not saved in database => 3
  #  synonym saved successfully => 0
    def record_suggested_synonym(synonym_name, keyword_id, approved= false)
      if synonym_name.blank?
        return  1
      elsif Synonym.exists?(name: synonym_name, keyword_id: keyword_id)
        return  2
      elsif Keyword.exists?(id: keyword_id)
          new_synonym = Synonym.new
          new_synonym.name = synonym_name
          new_synonym.keyword_id = keyword_id
          new_synonym.approved = approved
          if new_synonym.save
            return 0
          else
            return 3
          end
      end
    end
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
#   Output is boolean -- this method returns true if the vote has been recorded.
# failure: 
#   returns false if word not saved to database due to incorrect expression of
#   synonym name or an incorrect keyword id for an unavaialable keyword in database

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
