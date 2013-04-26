class ApiKey < ActiveRecord::Base

  before_create :generate_access_token
  before_validation :downcase_website

  belongs_to :project
  belongs_to :developer
  attr_accessible :token, :developer_id, :project_id

  validates_presence_of :developer_id
  validates_format_of :website, with: /([a-z\-0-9]{2,}\.){1,}[a-z]{2,8}/,
    message: "The website should be in the form of www.example.com"

  # Author:
  #   Mohamed Ashraf
  # Description:
  #   retrieved approved synonyms for a keyword through the project parameters
  #   and optional overides
  # Parameters:
  #   keyword: a string representing the keyword for which the synonyms will
  #     be retrieved
  #   country: [optional] filter by country name
  #   age_from: [optional] filter by age - lower limit
  #   age_to: [optional] filter by age - upper limit
  #   gender: [optional] filter by gender
  #   education: [optional] filter by education level
  # Success:
  #   returns the best synonyms for the passed keyword given the parameters
  # Failure:
  #   returns nil if the keyword doesnt exist or no synonyms are found for it
  def get_synonym_for(keyword, country = nil, age_from = nil, age_to = nil,
        gender = nil, education = nil)
    keyword = Keyword.find_by_name(keyword)
    return nil if keyword.blank?
    if project.present?
      country = project.country unless country.present?
      age_from = project.age_from unless age_from.present?
      age_to = project.age_to unless age_to.present?
      gender = project.gender unless gender.present?
      education = project.education unless education.present?
    end
    synonym_list, votes_count =
      keyword.retrieve_synonyms(country, age_from, age_to, gender, education)
    synonym_list.first
  end

private

  def generate_access_token
    begin
      self.token = SecureRandom.hex
    end while self.class.exists?(token: token)
  end

  def downcase_website
    self.website.downcase!
  end

end
