#encoding: UTF-8
class Keyword < ActiveRecord::Base
  has_many :synonyms
  has_and_belongs_to_many :developers, uniq: true
  attr_accessible :approved, :is_english, :name
  has_and_belongs_to_many :categories, uniq: true
  validates_presence_of :name
  validates_format_of :name, with: /^([\u0621-\u0652 ]+|[a-zA-Z ]+)$/
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
  #   is_formal: [optional] filter synonyms by being formal or slang
  # Success:
  #   returns a list of synonyms for the passed keyword
  # Failure:
  #   returns an empty list if the keyword doesn't exist or if no approved
  #   synonyms where found for the keyword  
  def retrieve_synonyms(country = nil, age_from = nil, age_to = nil, 
        gender = nil, education = nil, is_formal = nil)
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

    synonym_list = synonym_list
      .reject { |synonym| synonym.is_formal != is_formal } if is_formal != nil

    synonym_list = synonym_list.sort_by { |synonym| votes_count[synonym.id] }
      .reverse!

    synonyms_with_no_votes = self.synonyms
      .where(synonyms: { approved: true }) - synonym_list
    synonyms_with_no_votes
      .reject! { |synonym| synonym.is_formal != is_formal } unless is_formal == nil
    synonym_list = synonym_list + synonyms_with_no_votes

    [synonym_list, votes_count]
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
  def self.add_keyword_to_database(name, approved = true, is_english = nil, categories = [])
    name.strip!
    name.downcase!
    name = name.split(" ").join(" ")

    keyword = where(name: name).first_or_create
    keyword.approved = approved
    keyword.is_english = is_english != nil ? is_english : is_english_string(name)

    if keyword.save
      categories.each do |category|
        category.keywords << keyword
      end
      [true, keyword]
    else
      [false, keyword]
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
    name = name.split(" ").join(" ")
    Keyword.where(name: name).first
  end

  # Author:
  #   Mirna Yacout
  # Description:
  #   This method is to record the disapproval of the admin to a certain keyword in the database
  # Parameters:
  #   id: the id of the keyword to be disapproved
  # Success:
  #   returns true on saving the disapproval correctly in the database
  # Failure:
  #   returns false if the keyword doesnot exist in the database
  #   or if the disapproval failed to be saved in the database 
  def self.disapprove_keyword(keyword_id)
    if Keyword.exists?(id: keyword_id)
      keyword = Keyword.find(keyword_id)
      keyword.approved = false
      return keyword.save
    end
    return false
  end

  # author:
  #   Omar Hossam
  # Description:
  #   feature takes no input and returns a list of all unapproved keywords.
  # Parameters:
  #   None.
  # Success: 
  #   takes no arguments and returns to the admin a list containing the keywords
  #   that are pending for approval in the database.
  # Failure:
  #   returns an empty list if no words are pending for approval.
  def self.list_unapproved_keywords
    return Keyword.where(approved: false).all
  end

  # author:
  #   Omar Hossam
  # Description:
  #   function takes no input and returns a list of all approved keywords.
  # Parameters:
  #   None.
  # Success: 
  #   takes no arguments and returns to the admin a list containing the keywords
  #   that are approved in the database.
  # Failure:
  #   returns an empty list if no words are approved.
  def self.list_approved_keywords
    Keyword.where(approved: true).all
  end

  # Author:
  #   Omar Hossam
  # Description:
  #   function takes no input and returns a list of all reported keywords.
  # Parameters:
  #   None.
  # Success: 
  #   takes no arguments and returns to the admin a list containing the keywords
  #   that are reported by users in the database.
  # Failure:
  #   returns an empty list if no words are reported.
  def self.list_reported_keywords
    reports = Report.where(reported_word_type: "Keyword").all
    reported_keywords = []
    reports.each do |report|
      reported_keywords << Keyword.find_by_id(report.reported_word_id)
    end
    reported_keywords
  end

    # Author:
    #   Nourhan Mohamed, Mohamed Ashraf
    # Description:
    #   gets words similar to a search keyword (in a certain category) and sorts 
    #   result by relevance
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
            .where("categories.id" => categories.map{ |c| c.id })
      end

    	relevant_first_list = keyword_list
        .sort_by { |keyword| [keyword.name.downcase.index(search_word),
          keyword.name.downcase] }
    	relevant_first_list.uniq
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
end
