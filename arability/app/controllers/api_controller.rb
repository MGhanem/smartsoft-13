class ApiController < BackendController
  include ApplicationHelper

  before_filter :get_api_key, only: :get_synonyms
  before_filter :authenticate_gamer!, except: :get_synonyms
  before_filter :authenticate_developer!, except: :get_synonyms

  def get_api_key
    @api_key = ApiKey.find_by_token(params[:api_key])
    head :forbidden unless @api_key
  end

  def get_synonyms
    keywords = params[:keywords]
    overrides = params[:overides]

    if keywords.blank?
      head :bad_request
      return
    end

    if overrides.present?
      country = overrides[:country]
      age_from = overrides[:age_from]
      age_to = overrides[:age_to]
      gender = overrides[:gender]
      education = overrides[:education_level]
    end

    result = []
    keywords.each do |word|
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
    @api_keys = current_developer.api_keys
    @projects = current_developer.projects
  end

  def create
    @api_key = ApiKey.new(params[:api_key])
    @api_key.developer = current_developer
    if @api_key.save
      redirect_to api_keys_list_path,
        flash: {success: "Your API key has been successfully created" }
    else
      @projects = current_developer.projects
      render :index
    end
  end

  def delete
    api_key = ApiKey.find_by_id(params[:api_key_id])
    if api_key && api_key.developer == current_developer
      api_key.destroy
      render nothing: true, :status => 200
    else
      head :forbidden
    end
  end

  def help
  end

  def test
  end

end
