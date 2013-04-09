class ApplicationController < ActionController::Base
  require 'csv'
  protect_from_forgery
  before_filter :set_locale

  def set_locale
    if params[:locale].nil?
      if session[:locale].nil?
        I18n.locale = :ar
      else
        I18n.locale = session[:locale]
      end
    else
      I18n.locale = params[:locale]
      session[:locale] = params[:locale]
    end
  end

  def default_url_options(options={})
    logger.debug "default_url_options is passed options: #{options.inspect}\n"
    { :locale => I18n.locale }
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
        fileext = File.extname(csvfile.original_filename)
        if fileext == ".csv"
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
          Synonym.recordsynonym(row[index], keywrd.id)
        end
      end
    end
  end

end
