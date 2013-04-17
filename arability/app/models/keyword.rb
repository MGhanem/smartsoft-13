class Keyword < ActiveRecord::Base
  has_many :synonyms
  has_and_belongs_to_many :developers
  attr_accessible :approved, :is_english, :name
  has_many :synonyms
  has_and_belongs_to_many :categories
  validates_presence_of :name 
  validates_format_of :name, :with => /^([\u0621-\u0652 ]+|[a-zA-z ]+)$/
  validates_uniqueness_of :name

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
        gender = nil, education = nil)
    return [], {} if !self.approved
    keyword_id = self.id
    filtered_data = Gamer
    filtered_data = filtered_data
      .filter_by_country(country) unless country.blank?
    filtered_data = filtered_data
      .filter_by_dob(age_from,age_to) unless age_from.blank? || age_to.blank?
    filtered_data = filtered_data
      .filter_by_gender(gender) unless gender.blank?
    filtered_data = filtered_data
      .filter_by_education(education) unless education.blank?
    filtered_data = filtered_data.joins(:synonyms)
    filtered_data = filtered_data
      .where(synonyms: { keyword_id: keyword_id, approved: true })
    votes_count = filtered_data.count(group: "synonyms.id")
    synonym_list = []
    filtered_data.each { |gamer| synonym_list += gamer.synonyms
      .where(keyword_id: keyword_id, approved: true) }
    synonym_list.uniq!
    synonym_list = synonym_list.sort_by { |synonym| votes_count[synonym.id] }
      .reverse!
    synonyms_with_no_votes = self.synonyms
      .where(synonyms: { approved: true }) - synonym_list
    synonym_list = synonym_list + synonyms_with_no_votes
    return synonym_list, votes_count
  end  

  class << self
    require "string_helper"
    include StringHelper
  end
  # Author:
  #   Mohamed Ashraf
  # Description:
  #   adds a new keyword to the database or returns it if it exists
  # params:
  #   name: the actual keyword string
  #   approved: is the created keyword is automatically approved
  #   is_english: is the keyword string in English
  #   categories: a list of categories to tag the keyword with
  # success:
  #   the first return is true and the second is the saved keyword
  # failure:
  #   the first return is false and the second is the unsaved keyword
  def self.add_keyword_to_database(name, approved = false, is_english = nil, categories = [])
    name.strip!
    keyword = where(name: name).first_or_create
    keyword.approved = approved
    name.downcase! if is_english_string(name)
    if is_english != nil
      keyword.is_english = is_english
    else
      keyword.is_english = is_english_string(name)
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

  # Author:
  #   Mohamed Ashraf
  # Description:
  #   finds a keyword by name from the database
  # params:
  #   name: the search string
  # success:
  #   An instance of Keyword
  # failure:
  #   nil
  def self.find_by_name(name)
    name.strip!
    name.downcase!
    keyword = Keyword.where(name: name).first
    return keyword
  end

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
  def self.diapprove_keyword(keyword_id)
    if Keyword.exists?(id: keyword_id)
      keyword = Keyword.find(keyword_id)
      keyword.approved = false
      return keyword.save
    end
    return false
  end
  
  class << self

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
  end
    # Author:
    #   Nourhan Mohamed, Mohamed Ashraf
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
    def self.get_similar_keywords(search_word, categories = [])
  		return [] if search_word.blank?
      search_word.downcase!
      search_word.strip!
      search_word = search_word.split(" ").join(" ")
    	keyword_list = self.where("keywords.name LIKE ?", "%#{search_word}%")
        .where(approved: true)
      if categories != []
        keyword_list = 
          keyword_list.joins(:categories)
            .where("categories.name" => categories)
      end
    	relevant_first_list = keyword_list
        .sort_by { |keyword| [keyword.name.downcase.index(search_word),
          keyword.name.downcase] }
    	relevant_first_list
    end
  class << self
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

  # author:
  #   Mostafa Hassaan
  # description:
  #   function created for high charts to get model information. 
  #   It returns a hash with the name of each synonym and a the 
  #   percentage of total votes
  # params:
  #   keyword_id: id of the keyword needed
  # success:
  #   returns a hash contating each synonym name in a string with a 
  #   percentage of vote, ie. {["synonym", 75], ["synonymtwo", 25]}
  # failure:
  #   returns empty hash if the synonyms of the given keyword have no votes
    def get_keyword_synonym_visual(keyword_id)
      votes = Synonym.where(keyword_id: keyword_id)
        .joins(:votes).count(group: "synonym_id")
      sum = votes.sum{|v| v.last}
      v = votes.map {|key, value| [Synonym.find(key).name, value]}
      return v.map {|key, value| [key,((value.to_f/sum)*100).to_i]}
    end
  end

  # author:
  #   Mostafa Hassaan
  # description:
  #   functioni is used to notify developers of new synonyms or 
  #   updated keywords
  # params:
  #   synonym_id: the synonym that has been changed or added.
  # success:
  #   sends an email to all developers following the word that has 
  #   the synonym
  # failure:
  #   --
  def notify_developer(synonym_id)
      keyword = Keyword.find(self.id)
      synonym = Synonym.find(synonym_id)
      developers = keyword.developers
      developers.each do |dev|
        UserMailer.follow_notification(dev, keyword, synonym).deliver
      end
    end
end
