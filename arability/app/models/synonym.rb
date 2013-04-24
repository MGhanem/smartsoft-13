#encoding: UTF-8
class Synonym < ActiveRecord::Base
  belongs_to :keyword
  attr_accessible :approved, :name, :keyword_id
  has_many :votes, uniq: true
  has_many :gamers, :through => :vote, uniq: true

  def self.find_loacle
    if I18n.locale == :ar 
      "هذا المعنى ليس باللغة العربية"
    elsif I18n.locale == :en 
      "This synonym in not in arabic"
    end
  end

  def existing?
    if !Keyword.exists?(id: keyword_id)
      errors.add(:keyword_id, "#{I18n.t(:omar_error1)}")
    end
  end

  validates_format_of :name, with: /^([\u0621-\u0652 ])+$/,
    message: Synonym.find_loacle 

  validates_presence_of :name, message: "#{I18n.t(:omar_error2)}"

  validate :existing?

  validates_uniqueness_of :name, scope: :keyword_id,
    message: "#{I18n.t(:omar_error3)}"

  class << self
    include StringHelper
  end

  # author:
  #   kareem ali
  # Description:
  #   records a synonym for a specific keyword with approved = false by default
  # Params:
  #   synonym_name: the string name of the new synonym
  #   keyword_id: the id of the keyword for which the synonym is suggested
  #   approved: whether the syonnym is approved or not , by default is not approved 
  # Success:
  #   returns 0 when the synonym is saved
  # Failure:
  #   returns 1 when the synonym written by the gamer is blank
  #   returns 2 when the synonym is already existing
  def self.record_suggested_synonym(synonym_name, keyword_id, approved= false)
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

  
  # Author:
  #   Mirna Yacout
  # Description:
  #   This method is to record the disapproval of the admin to a certain synonym in the database
  # Parameters:
  #   id: the id of the synonym to be disapproved
  # Success:
  #   returns true on saving the disapproval correctly in the database
  # Failure:
  #   returns false if the synonym doesnot exist in the database
  #   or if the disapproval failed to be saved in the database     
	def self.disapprove_synonym(synonym_id)
    if Synonym.exists?(id: synonym_id)
      synonym = Synonym.find(synonym_id)
      synonym.approved = false
      return synonym.save
    end
    return false
  end

  class << self

    def find_by_name(synonym_name, keyword_id)
      word = Keyword.find(keyword_id)
      synonym = Synonym.where("name = ? AND keyword_id = ?", synonym_name, keyword_id).first
    end


  def get_visual_stats_country(synonym_id)
        voters = Gamer.joins(:synonyms).where("synonym_id = ?", synonym_id)
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
  end

  # Author:
  #   Omar Hossam
  # Description:
  #   This is the modified function of "recordsynonym". Feature adds synonym to
  #   database and returns a boolean result
  #   indicatiing success or failure of saving.
  # Parameters:
  #   synonym_name: string input parameter that represents the synonym name.
  #   keyword_id: integer input parameter representing the keyword id
  #     the synonym points to.
  #   approved: an optional boolean input parameter with a default false
  #     represents if an admin has approved a synonym on database or not.
  # Success:
  #   Output is boolean -- this method returns true if
  #     the vote has been recorded.
  # Failure: 
  #   returns false if word not saved to database due to incorrect expression
  #   of synonym name or an incorrect keyword id for
  #   an unavaialable keyword in database or a dupplicate synonym for the same
  #   keyword.
  def self.record_synonym(synonym_name, keyword_id, approved = true)
    new_synonym = Synonym.new
    new_synonym.name = synonym_name
    new_synonym.keyword_id = keyword_id
    return new_synonym.save
  end

  # Author:
  #   Omar Hossam
  # Description:
  #   This is the modified function of "record_synonym". Feature adds synonym to
  #   database and returns a boolean result and the new synonym model
  #   indicatiing success or failure of saving, and the synonym model to look
  #   for reason of saving failure.
  # Parameters:
  #   synonym_name: string input parameter that represents the synonym name.
  #   keyword_id: integer input parameter representing the keyword id
  #     the synonym points to.
  #   approved: an optional boolean input parameter with a default false
  #     represents if an admin has approved a synonym on database or not.
  # Success:
  #   this method returns true and the new synonym model if
  #     the vote has been recorded.
  # Failure: 
  #   returns false and uncompleted model for the new synonym if word not saved
  #   to database due to synonym name not being in arabic or an incorrect
  #   keyword id for an unavaialable keyword in database or a dupplicate synonym
  #   for the same keyword.
  def self.record_synonym_full_output(synonym_name, keyword_id, approved = true)
    new_synonym = Synonym.new
    new_synonym.name = synonym_name
    new_synonym.keyword_id = keyword_id
    return new_synonym.save , new_synonym
  end

  #Author: Nourhan Zakaria
  #This method is used to get the percentage of gamers'countries who voted for 
  #certain synonym
  #Parameters: --
  #Returns:
  #  On Success: a list of lists, each one of the inner lists consists of a key and value.
  #  The key represents the country and the value is the percentage of voters that belong
  #  to this country
  #  On failure: returns an empty list if no gamers voted for this synonym yet.
  def get_visual_stats_country
        voters = Gamer.joins(:synonyms).where("synonym_id = ?", self.id)
        groups = voters.count(group: :country)
        sum = groups.sum{|v| v.last}
        return groups.map {|key, value| [key,((value.to_f/sum)*100).to_i]}
  end 

  #Author: Nourhan Zakaria
  #This method is used to get the percentage of females and males who voted for 
  #certain synonym
  #Parameters: --
  #Returns:
  #  On Success: a list of lists, each one of the inner lists consists of a key and value.
  #  The key represents the gender and the value is the percentage of voters belong to this gender.
  #  On failure: returns an empty list if no gamers voted for this synonym yet.
  def get_visual_stats_gender
      voters = Gamer.joins(:synonyms).where("synonym_id = ?", self.id)
      groups = voters.count(group: :gender)
      sum = groups.sum{|v| v.last}
      return groups.map {|key, value| [key,((value.to_f/sum)*100).to_i]} 
  end 

  #Author: Nourhan Zakaria
  #This method is used to get the percentage of gamers'age groups who voted for 
  #certain synonym
  #Parameters: --
  #Returns:
  #  On Success: a list of lists, each one of the inner lists consists of a key and value.
  #  The key represents the age group and the value is the percentage of voters belong to this age group.
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
        if sum !=0
          list = [["10-25", one], ["26-45", two], ["46+", three]]
          return list.map {|key, value| [key,((value.to_f/sum)*100).to_i]}
        else
          return []

        end
  end 

  #Author: Nourhan Zakaria
  #This method is used to get the percentage of gamers'education levels who voted for 
  #certain synonym
  #Parameters: --
  #Returns:
  #  On Success: a list of lists, each one of the inner lists consists of a key and value.
  #  The key represents the education level and the value is the percentage of voters having this education level.
  #  On failure: returns an empty list if no gamers voted for this synonym yet.
  def get_visual_stats_education
        voters = Gamer.joins(:synonyms).where("synonym_id = ?", self.id)
        groups = voters.count(group: :education_level)
        sum = groups.sum{|v| v.last}
        return groups.map {|key, value| [key,((value.to_f/sum)*100).to_i]}
  
  end
end
