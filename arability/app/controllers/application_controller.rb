class ApplicationController < ActionController::Base
  protect_from_forgery
  include ApplicationHelper
  before_filter :set_locale
  require 'csv'
  rescue_from Exception, :with => :error_render_method

  # Author:
  #   Mohamed Ashraf
  # Desciption:
  #   This function sets the locale to the default locale of ar or the
  #   whichever locale stored in the session. If a locale is chosen it is
  #   automatically stored in the session.
  # params:
  #   locale: from the url if exists
  # success:
  #   sets the current locale for all views
  # failure:
  #   --
  def set_locale
    if params[:locale].nil?
      I18n.locale = session[:locale].nil? ? :ar : session[:locale]
    else
      I18n.locale = params[:locale]
      session[:locale] = params[:locale]
    end
  end

  # Author:
  #   Mohamed Ashraf
  # Description:
  #   It adds the current locale to the url if not specified
  # params:
  #   locale: from the url if exists
  # success:
  #   adds current locale to the urls if not specified
  # failure:
  #   --
  def default_url_options(options={})
    { locale: I18n.locale }
  end

  def get_root
    if request.fullpath.match /\/^((ar|en)\/)?developers\//
      path = backend_home_path
    else
      path = root_path
    end
  end

  # author:
  #   Mostafa Hassaan
  # description:
  #   this method catches routing errors
  # params:
  #   --
  # success:
  #   Redirects to 404
  # failure:
  #   --
  def routing_error
    redirect_to "/404"
  end
  
  # author:
  #   Mostafa Hassaan
  # description:
  #   this method catches all exceptions
  # params:
  #   exception: The exception thrown
  # success:
  #   Redirects to home page if exception was thrown in projects page or
  #   game page.
  #   Redirects to projects page if exception was thrown in either list
  #   followed or search pages.
  #   After redirecting, it sends an email to "arability.smartsoft@gmail.com"
  #   with the thrown exception.
  # failure:
  #   --
  def error_render_method(exception)
    path = request.path
    UserMailer.generic_email("mostafa.a.hassaan@gmail.com", 
        exception, exception.backtrace.join("\n")).deliver
    if path.include? "developers/"
      redirect_to projects_path, flash: { error: t(:exception) } 
      return
    end
    if path.include? "developers/projects"
      redirect_to get_root, flash: { error: t(:exception) }
      return 
    end
    if path.include? "game"
      redirect_to get_root, flash: { error: t(:exception) }
      return 
    end
  end
  
  # author:
  #   Amr Abdelraouf
  # description:
  #   this method takes a csv file and parses it into an array of arrays
  # params:
  #   csvfile: a file in csv format
  # success:
  #   file is parsed, words are saved, array_of_arrays is returned and the return message is '0'
  # failure:
  #   the file is nil, nil is returned and message is '1'
  #   the file is not UTF-8 encoded, nil is returned and message is '2'
  #   the csv file is malformed, nil is returned and message is '3'
  #   the file extension is not .csv, nil is returned and message is '4'
  def parseCSV(csvfile)
    begin
      if csvfile != nil
        file_ext = File.extname(csvfile.original_filename)
        if file_ext == ".csv"
          content = File.read(csvfile.tempfile)
          arr_of_arrs = CSV.parse(content)
          return arr_of_arrs, 0
        else
          return nil, 4
        end
      else
        return nil, 1
      end
    rescue ArgumentError
      return nil, 2
    rescue CSV::MalformedCSVError
      return nil, 3
    end
  end

  # auther
  #   Amr Abdelraouf
  # description:
  #   method takes an array of arrays and inserts the fisrt word in each row as a keyword
  #   and the rest of the row as its corresponding synonyms
  # params:
  #   arr_of_arrs is an array of arrays, rows are keywords and coloumns are corresponding synonyms
  # success:
  #   row contains a new keyword and is addd to the database
  #   row contains a keyword that already exists and its corresponding keywords are added to the original keyword
  # failure:
  #   row contains an invalid keyword and is ignored
  def uploadCSV(arr_of_arrs)
    arr_of_arrs.each do |row|
      wasSaved, keywrd = Keyword.add_keyword_to_database(row[0])
      if wasSaved
        for index in 1..row.size
          Synonym.record_synonym(row[index], keywrd.id)
        end
      end
    end
  end

  private

  # Author:
  #   Mohamed Tamer
  # Description
  #   Handles what should happen when a guest becomes a user
  # Params:
  #   id: id of the user
  #   guest_gamer: the guest gamer
  # Success: 
  #   Changes ids of the votes where the id was of the guest_gamer to the id from the parameters
  # Failure:
  #   None
  def logging_in(id)
    guest_votes = Vote.where(gamer_id: guest_gamer.id)
      guest_votes.each do |vote|
      vote.gamer_id = id
      vote.save!
    end
  end

  # Author:
  #   Mohamed Tamer
  # Description
  #   Creates a gamer with the given data
  # Params:
  #   email: the email of a the gamer
  #   password: the password of the gamer
  #   username: the username of the gamer
  # Success: 
  #   Returns the created gamer and true
  # Failure:
  #   Returns the gamer instance that wasn't created and false
  def create_gamer(email, password, username)
    gamer = Gamer.new
    gamer.username = username
    gamer.country = guest_gamer.country
    gamer.education_level = guest_gamer.education_level
    gamer.gender = guest_gamer.gender
    gamer.date_of_birth = guest_gamer.date_of_birth
    gamer.email = email
    gamer.password = password
    gamer.show_tutorial = guest_gamer.show_tutorial
    gamer.highest_score = guest_gamer.highest_score 
    if gamer.save
      logging_in(gamer.id)
      session[:guest_gamer_id] = nil
      return gamer, true
    else
      return gamer, false
    end
  end

  # Author:
  #   Mohamed Tamer
  # Description
  #   Creates a guest with the given data
  # Params:
  #   education: the education level of a the guest
  #   country: the country of the guest
  #   gender: the gender of the guest
  #   dob: the date of birth
  # Success: 
  #   Returns the created guest and true
  # Failure:
  #   Returns the gamer instance that wasn't created and false
  def create_guest_gamer(education, country, gender, dob)
    gamer = Gamer.new
    gamer.username = "Guest_#{Time.now.to_i}#{rand(99)}"
    gamer.country = country
    gamer.education_level = education
    gamer.gender = gender
    gamer.date_of_birth = dob
    gamer.email = "guest_#{Time.now.to_i}#{rand(99)}@example.com"
    gamer.password = "1234567"
    gamer.is_guest = true
    gamer.confirmed_at = Time.now
    if gamer.save
      session[:guest_gamer_id] = gamer.id
      return gamer, true
    else
      return gamer, false
    end
  end

  # Author:
  #   Mohamed Tamer
  # Description
  #   Checks if there is a gamer signed in or not
  # Params:
  #   gamer_session: the session of a signed up regular user
  #   session[:guest_gamer_id]: the session of the guest gamer
  # Success: 
  #   Continues as normal to the page requested if the user is a guest or gamer 
  # Failure:
  #   Redirects to sign up as guest
  def authenticate_gamer_or_guest!
    if gamer_session == nil && session[:guest_gamer_id] == nil
      redirect_to guest_sign_up_path
    end
  end
end
