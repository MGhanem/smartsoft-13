class Keyword < ActiveRecord::Base
  attr_accessible :approved, :is_english, :name
  validates_presence_of :name, 
    :message => "You need to enter a keyword to save"
  validates_format_of :name, :with => /^([\u0621-\u0652]+|[a-zA-z]+)$/,
     :message => "The keyword may contain only english or only arabic characters"
  validates_uniqueness_of :name,
    :message => "This keyword is already in the database"

  # adds a new keyword to the database
  # params:
  #   name: the actual keyword string
  #   approved: is the created keyword is automatically approved
  #   is_english: is the keyword string in English
  # returns:
  #   success: the first return is true and the second is the saved keyword
  #   failure: the first return is false and the second is the unsaved keyword
  def self.add_keyword_to_database(name, approved = false, is_english = nil)
    keyword = self.new(:name => name, :approved => approved)
    if is_english != nil
      keyword.is_english = is_english
    else
      keyword.is_english = self.is_english_keyword(name)
    end

    if keyword.save
      return true, keyword
    else
      return false, keyword
    end
  end

  # checks if the keyword is formed of english letters only
  # params:
  #   name: the string being checked
  # returns:
  #   success: returns true if the keyword is in english
  #   failure: returns false if the keyword contains non english letters
  def self.is_english_keyword(name)
    if name.match /^[a-zA-Z]+$/
      true
    else
      false
    end
  end
end
