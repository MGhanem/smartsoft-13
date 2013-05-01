class ApiController < BackendController
  include ApplicationHelper

  before_filter :get_api_key, only: :get_synonyms
  before_filter :authenticate_gamer!, except: :get_synonyms
  before_filter :authenticate_developer!, except: :get_synonyms

  # Author:
  #   Mohamed Ashraf
  # Description:
  #   makes sure that there is a valid api key in the request
  # Params:
  #   api_key: the api token
  # Success:
  #   stores the api key model instance in a class variable
  # Failure:
  #   returns http status code 403 forbidden
  def get_api_key
    @api_key = ApiKey.find_by_token(params[:api_key])
    head :forbidden unless @api_key
  end

  # Author:
  #   Mohamed Ashraf
  # Description:
  #   gets the correct synonym according to the correct filters
  # Params:
  #   keywords: the list of keywords to be translated
  #   overrides: a hash of the overrides to the project filters
  # Success:
  #   returns a list of hashes JSON encoded with the translations of the
  #   keywords
  # Failure:
  #   returns a list of hashes that have found set to false
  def get_synonyms
    keywords = params[:keywords]
    overrides = params[:overrides]

    if keywords.blank?
      head :bad_request
      return
    end

    country = request.location.country

    if overrides.present?
      country = overrides[:country]
      age_from = overrides[:age_from]
      age_to = overrides[:age_to]
      gender = overrides[:gender]
      education = overrides[:education_level]
    end

    country = get_valid_country country

    @result = []
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

      @result.append(entry)
    end
    render json: @result, layout: false
  end

  # Author:
  #   Mohamed Ashraf
  # Description:
  #   display the list of api keys used
  # Params:
  #   --
  # Success:
  #   Lists the api keys
  # Failure:
  #   --
  def index
    @api_key = ApiKey.new
    @api_keys = current_developer.api_keys
    @projects = current_developer.projects
    @location = request.location.inspect
  end

  # Author:
  #   Mohamed Ashraf
  # Description:
  #   create a new api key
  # Params:
  #   api_key: a hash containing a website and a project id
  # Success:
  #   creates the api and redirects to project page
  # Failure:
  #   shows the form again to check validations
  def create
    @api_key = ApiKey.new(params[:api_key])
    @api_key.developer = current_developer

    if @api_key.save
      redirect_to api_keys_list_path,
        flash: {success: "#{ t :api_created }" }
    else
      @projects = current_developer.projects
      @api_keys = current_developer.api_keys
      @projects = current_developer.projects

      render :index
    end
  end

  # Author:
  #   Mohamed Ashraf
  # Description:
  #   delete an api key
  # Params:
  #   api_key_id: the id of the api key you want deleted
  # Success:
  #   deletes the api and returns status code 200 success
  # Failure:
  #   returns status code 403 forbidden
  def delete
    api_key = ApiKey.find_by_id(params[:api_key_id])

    if api_key && api_key.developer == current_developer
      api_key.destroy
      render nothing: true, :status => 200
    else
      head :forbidden
    end
  end

  # Author:
  #   Mohamed Ashraf
  # Description:
  #   display the help pages of the api
  # Params:
  #   --
  # Success:
  #   Displays the help pages
  # Failure:
  #   --
  def help
  end

  def test
  end

private
  # Author:
  #   Mohamed Ashraf
  # Description:
  #   return a valid country from a country string
  # Params:
  #   country: the country string
  # Success:
  #   returns a country string that is one of the ones stored in the database
  # Failure:
  #   returns nil if the country is not one we store
  def get_valid_country country
    country.strip!
    country.downcase!

    return nil if country.blank?

    countries = ["Egypt", "Lebanon", "Jordan", "Saudi Arabia", "Libya",
                 "United Arab Emirates", "Qatar", "Kuwait", "Iraq", "Algeria",
                 "Morocco", "Bahrain", "Mauritania", "Somalia", "Sudan",
                 "Tunisia"]

    country = capitalize_sentence country

    countries.include?(country) ? country : nil
  end

  # Author:
  #   Mohamed Ashraf
  # Description:
  #   capitalizes all words in a sentence
  # Params:
  #   text: a string of words
  # Success:
  #   returns a string of words that are capitalized
  # Failure:
  #   --
  def capitalize_sentence text
    words = text.split(" ").map { |word| word.capitalize }
    words.join(" ")
  end

end
