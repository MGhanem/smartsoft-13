#encoding: UTF-8
class PreferedSynonym < ActiveRecord::Base
  attr_accessible :project_id, :synonym_id, :keyword_id
  belongs_to :project
  belongs_to :keyword
  belongs_to :synonym
  class << self
    
    # Author:
    #   Mohamed Tamer
    # Description
    #   add keyword id and synonym id and a project id into a new record of PreferedSynonym
    # Params:
    #   synonym_id: synonym id
    #   keyword_id: keyword id
    #   project_id: the project id
    # Success: 
    #   returns true if the word is saved
    # Failure:
    #   if the word isn't saved returns false
  	def add_keyword_and_synonym_to_project(synonym_id, keyword_id, project_id)
      keyword = Keyword.where(id: keyword_id).first
      if keyword != nil && keyword.synonyms.where(:synonym_id => synonym_id) != nil
        entry = PreferedSynonym.new
        entry.project_id = project_id
        entry.synonym_id = synonym_id
        entry.keyword_id = keyword_id
        return entry.save
      end
      return false
  	end
    
    # Author:
    #   Mohamed Tamer
    # Description:
    #   finds if a keyword exists in a project
    # Params:
    #   keyword_id: keyword id
    #   project_id: the project id
    # Success:
    #   returns true if the word exists
    # Failure:
    #   if the word doesn't exist returns false

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
