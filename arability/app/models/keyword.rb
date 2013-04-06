class Keyword < ActiveRecord::Base
  has_many :synonyms
  attr_accessible :approved, :is_english, :name
  has_and_belongs_to_many :categories
  validates_presence_of :name, 
    :message => "You need to enter a keyword to save"
  validates_format_of :name, :with => /^([\u0621-\u0652 ]+|[a-zA-z ]+)$/,
    :message => "The keyword may contain only english or only arabic characters"
  validates_uniqueness_of :name,
    :message => "This keyword is already in the database"

  # Author: 
  #   Nourhan Mohamed
  # Description:
  #   retrieved approved synonyms for a keyword through optional filters
  # Parameters:
  #   keyword: a string representing the keyword for which the synonyms will
  #     be retrieved
  #   country: [optional] filter by country name
  #   age_from: [optional] filter by age - lower limit
  #   age_to: [optional] filter by age - upper limit
  #   gender: [optional] filter by gender
  #   education: [optional] filter by education level
  # Success:
  #   returns a list of synonyms for the passed keyword
  # Failure:
  #   returns an empty list if the keyword doesn't exist or if no approved
  #   synonyms where found for the keyword  
    def retrieve_synonyms(country = nil, age_from = nil, age_to = nil, 
          gender = nil,education = nil)
      if(!self.approved)
        return [], {} 
      end
      keyword_id = self.id
      filtered_data = Gamer
      filtered_data = filtered_data
        .filter_by_country(country.downcase) unless country.blank?
      filtered_data = filtered_data
        .filter_by_dob(age_from,age_to) unless age_from.blank? || age_to.blank?
      filtered_data = filtered_data
        .filter_by_gender(gender.downcase) unless gender.blank?
      filtered_data = filtered_data
        .filter_by_education(education.downcase) unless education.blank?
      filtered_data = filtered_data.joins(:synonyms)
      synonym_list = filtered_data
        .where(:synonyms=>{:keyword_id => keyword_id, :approved => true})
      votes_count = synonym_list.count(:group => "synonyms.id")
      synonym_list = synonym_list.sort_by { |synonym, count| vote_count }
        .reverse!
      synonyms_with_no_votes = self.synonyms.where(:synonyms => {:approved => true}) - synonym_list
      synonym_list = synonym_list + synonyms_with_no_votes
      return synonym_list, votes_count
    end  

  class << self

  # Author:
  #  Mirna Yacout
  # Description:
  #  This method is to record the aproval of the admin to a certain keyword in the database
  # Parameters:
  #  id: the id of the keyword to be approved
  # Success:
  #  returns true on saving the approval correctly in the database
  # Failure:
  #  returns false if the keyword doesnot exist in the database
  #  or if the approval failed to be saved in the database 
    def approve_keyword(keyword_id)
      if Keyword.exists?(id: keyword_id)
        keyword = Keyword.find(keyword_id)
        keyword.approved = true
        return keyword.save
      end
      return false
    end

# author:
#   Omar Hossam
# description:
#   feature takes no input and returns a list of all unapproved keywords
# success: 
#   takes no arguments and returns to the admin a list containing the keywords 
#   that are pending for approval in the database
# failure:
#   returns an empty list if no words are pending for approval

  def listunapprovedkeywords

    return Keyword.where(approved: false).all

  end

    # adds a new keyword to the database
    # author:
    #   Mohamed Ashraf
    # params:
    #   name: the actual keyword string
    #   approved: is the created keyword is automatically approved
    #   is_english: is the keyword string in English
    #   categories: a list of categories to tag the keyword with
    # returns:
    #   success: the first return is true and the second is the saved keyword
    #   failure: the first return is false and the second is the unsaved keyword
    def add_keyword_to_database(name, approved = false, is_english = nil, categories = [])
      keyword = self.new(:name => name, :approved => approved)
      if is_english != nil
        keyword.is_english = is_english
      else
        keyword.is_english = self.is_english_keyword(name)
      end

      if keyword.save
        categories.each do |category_name|
          success, category =
            Category.add_category_to_database_if_not_exists(category_name)
          if success
            category.keywords << keyword
          end
        end
        return true, keyword
      else
        return false, keyword
      end
    end

    # checks if the keyword is formed of english letters only
    # author:
    #   Mohamed Ashraf
    # params:
    #   name: the string being checked
    # returns:
    #   success: returns true if the keyword is in english
    #   failure: returns false if the keyword contains non english letters
    def is_english_keyword(name)
      if name.match /^[a-zA-Z]+$/
        true
      else
        false
      end
    end

  	#Description:
    #   gets words similar to a search keyword (in a certain category) and sorts 
    #   result by relevance
    # Author:
    #   Nourhan Mohamed, Mohamed Ashraf
  	#	params:
  	#		search_word: a string representing the search keyword that should 
    #     be retrieved if found in the database
    #		categories: one or more categories to limit the search to
  	#	returns:
  	#		success:
  	#			returns a list of the keywords (optionally filtered by categories) 
    #     similar to the search keyword sorted in lexicographical order
  	#		failure:
  	#			returns an empty list if the search keyword had no matches or no 
    #     similar keywords were found
    def get_similar_keywords(search_word, categories = [])
    	if (search_word.blank?)
    		return []
    	end
      search_word.downcase!
    	keyword_list = self.where("name LIKE ?", "%#{search_word}%")
        .where(:approved => true)
      if categories != []
        keyword_list = 
          keyword_list.joins(:categories)
            .where("categories.name" => categories)
      end
    	relevant_first_list = keyword_list
        .sort_by { |keyword| [keyword.name.downcase.index(search_word),
          keyword.name.downcase] }
    	return relevant_first_list
    end

    
    # Author: Mostafa Hassaan
    # Description: Method gets the synonym of a certain word with the highest
    #               number of votes.
    # params: 
    #   word: a Keyword to get the highest voted synonym for
    # return:
    #   on success: the highest voted Synonym of word gets returned. If two 
    #               synonyms have an equal number of votes, the first synonym 
    #               entered to the list is returned.
    #   on failure: if word has no synonyms, nothing is returned
    def highest_voted_synonym(keyword)
      grouped_synonyms = Synonym.where(:keyword_id => keyword.id)
        .joins(:votes).count(:group => "synonym_id")
      highest_synonym = grouped_synonyms.max_by{ |key, count|count }
      return Synonym.where(:id => highest_synonym[0])
    end

    # Author: Mostafa Hassaan
    # Method takes no inputs and returns an array of "Keywords"
    # with "synonyms" that haven't been approved yet.
    # params: --
    # returns:
    #   on success: Array of "keywords"
    #   on failure: Empty array
    def words_with_unapproved_synonyms
      return Keyword.joins(:synonyms).where("synonyms.approved" => false).all
    end
  end
end 