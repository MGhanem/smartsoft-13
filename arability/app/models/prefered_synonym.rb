#encoding: UTF-8
class PreferedSynonym < ActiveRecord::Base
  attr_accessible :keyword_id, :synonym_id, :keyword_id
  belongs_to :project
  belongs_to :keyword
  belongs_to :synonym
  # attr_accessible :title, :body
  class << self

    # add keyword id and synonym id and a project id into a new record of PreferedSynonym
    #
    # == Parameters:
    # synonym_id::
    #   synonym id
    #
    # keyword_id::
    #   keyword id
    #
    # project_id::
    #   the project id
    #
    # == Success return:
    #  returns true if the word is saved
    #
    # == Failure return :  
    # if the word isn't saved returns false
    #
    # @author Mohamed Tamer
  	def add_keyword_and_synonym_to_project(synonym_id, keyword_id, project_id)
      keyword = Keyword.find(keyword_id)
      if keyword != nil and keyword.synonyms.where(:synonym_id => synonym_id) != nil
        entry = PreferedSynonym.new
        entry.project_id = project_id
        entry.synonym_id = synonym_id
        entry.keyword_id = keyword_id
        return entry.save
      end
  	end
    
    # finds if a keyword exists in a project
    #
    # == Parameters:
    # keyword_id::
    #   keyword id
    #
    # project_id::
    #   the project id
    #
    # == Success return:
    #  returns true if the word exists
    #
    # == Failure return :  
    # if the word doesn't exist returns false
    #
    # @author Mohamed Tamer
    def find_word_in_project(project_id, keyword_id)
      keyword = PreferedSynonym.where("project_id = ? AND keyword_id = ?", project_id, keyword_id).first
      if keyword != nil
        return true
      else
        return false
      end 
    end
  end
end
