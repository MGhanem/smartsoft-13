class ApiController < BackendController
  include ApplicationHelper
  before_filter :get_api_key, only: :get_synonyms

  def get_api_key
    @api_key = ApiKey.find_by_token(params[:api_key])
    head :forbidden unless @api_key
  end

  def get_synonyms
    keywords = params[:keywords]

    result = []
    keywords.each do |index, keyword|
      word = keyword[:word]
      overrides = keyword[:overrides]

      country = overrides[:country]
      age_from = overrides[:age_from]
      age_to = overrides[:age_to]
      gender = overrides[:gender]
      education = overrides[:education_level]

      synonym = @api_key.get_synonym_for(word, country, age_from,
        age_to, gender, education)

      entry = {}
      entry[:word] = word
      if synonym.present?
        entry[:translation] = synonym.name
        entry[:found] = true
      else
        entry[:translation] = word
        entry[:found] = false
      end

      result.append(entry)
    end
    render json: result, layout: false
  end

  def index
    @api_key = ApiKey.new
    @projects = current_developer.projects
  end

  def create
    api_key = ApiKey.new(params[:api_key])
    api_key.developer = current_developer
    api_key.save
  end

  def help
  end

  def test
    render :test
  end

end
