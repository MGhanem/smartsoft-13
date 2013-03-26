class AdminController < ApplicationController
  require 'csv'
  
  def import_csv
  end

  def upload
  	csvfile = params[:csvfile]
 	File.open(Rails.root.join('public', 'uploads', csvfile.original_filename), 'w') do |file|
    	file.write(csvfile.read)
  	end
  	CSV.foreach(Rails.root.join('public', 'uploads', csvfile.original_filename)) do |row|
  		array = row.split(",")
  	end
  end

end

