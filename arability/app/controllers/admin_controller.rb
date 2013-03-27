class AdminController < ApplicationController
  require 'csv'
  
  def import_csv
  end

  def upload
  	@csvfile = params[:csvfile]
    @content = File.read(@csvfile.tempfile)
    CSV.parse(@content) do |row|
       array = row.split(",")
    end
    #File.open(Rails.root.join('public', 'uploads', csvfile.original_filename), 'w:UTF-8') do |file|
    #  file.write(csvfile.read)
    #end
    #CSV.foreach(Rails.root.join('public', 'uploads', csvfile.original_filename)) do |row|

    #end
  end

end

