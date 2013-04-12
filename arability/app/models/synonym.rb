#encoding: UTF-8
class Synonym < ActiveRecord::Base
  belongs_to :keyword
  attr_accessible :approved, :name
  has_many :votes

  def self.find_loacle
    if I18n.locale == :ar 
      "هذا المعنى ليس باللغة العربية"
    elsif I18n.locale == :en 
      "This synonym in not in arabic"
    end
  end

  validates_format_of :name, :with => /^([\u0621-\u0652 ])+$/,
    :message => Synonym.find_loacle

  # Author:
  #  Mirna Yacout
  # Description:
  #  This method is to record the aproval of the admin to a certain synonym in the database
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
  #   an unavaialable keyword in database.
  def self.record_synonym(synonym_name, keyword_id, approved = false)
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
end