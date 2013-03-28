class AdminController < ApplicationController
  require 'csv'
  
  # author:
  #   Amr Abdelraouf
  # description:
  #   this function loads a view which allows the user to import a csv file and lists the rules for uploading
  #   in addition when a file is uploaded it gives the user feedback whether the file was successfully
  #   uploaded or not and gives the reason why not
  # params:
  #   GET message is feedback message
  # success:
  #   displays upload button, rules and feedback message (if applicable)
  # failure:
  #   no failure
  def import_csv
    @message = params[:message]
  end

  # author:
  #   Amr Abdelraouf
  # description:
  #   this function takes a csvfile as a parameter, parses it as an array of arrays
  #   saves the first word of each arrays as a Keyword and the rest of the array as its
  #   corresponding synonyms
  # params:
  #   POST csvfile is the csvfile to be parsed
  # success:
  #   file is parsed, words are saved and the return message is '0'
  # failure:
  #   the file is nil and message is '1'
  #   the file is not UTF-8 encoded and message is '2'
  def upload
    begin
      @csvfile = params[:csvfile]
      if @csvfile != nil
        @content = File.read(@csvfile.tempfile)
        arr_of_arrs = CSV.parse(@content)
        arr_of_arrs.each do |row|
          @isSaved, keywrd = Keyword.add_keyword_to_database(row[0])
          if @isSaved
            for i in 1..row.size
              Synonym.recordsynonym(row[i],keywrd.id)
            end
          end
      end
        redirect_to action: "import_csv", message: "0"
      else 
        redirect_to action: "import_csv", message: "1"
      end
    rescue ArgumentError
        redirect_to action: "import_csv", message: "2"
    end
  end
end

