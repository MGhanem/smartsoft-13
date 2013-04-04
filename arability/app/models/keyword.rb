class Keyword < ActiveRecord::Base
  attr_accessible :approved, :is_english, :name
  has_many :synonyms
  has_and_belongs_to_many :categories
  validates_presence_of :name, 
    :message => "You need to enter a keyword to save"
  validates_format_of :name, :with => /^([\u0621-\u0652 ]+|[a-zA-z ]+)$/,
    :message => "The keyword may contain only english or only arabic characters"
  validates_uniqueness_of :name,
    :message => "This keyword is already in the database"


  class << self
  include StringHelper
    # adds a new keyword to the database or returns it if it exists
    # Author:
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
      name.strip!
      keyword = where(name: name).first_or_create
      keyword.approved = approved
      if is_english_string(name) 
        name.downcase!
      end
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

  	#Description:
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
        .sort_by {|keyword| [keyword.name.downcase.index(search_word),
          keyword.name.downcase] }
    	return relevant_first_list
    end

    # finds a keyword by name from the database
    # @author Mohamed Ashraf
    # @params name [string] the search string
    # ==returns
    #   success: An instance of Keyword
    #   failure: nil
    def find_by_name(name)
      name.strip!
      keyword = Keyword.where(name: name).first
      return keyword
    end
  end
end
