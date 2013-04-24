class GuestController < ApplicationController
  def sign_up
  	@errors = params[:errors]
  end

  def signing_up
  	year = params[:gamer]["date_of_birth(1i)"]
  	month = params[:gamer]["date_of_birth(2i)"]
  	day = params[:gamer]["date_of_birth(3i)"]
  	dob = ""
  	dob << year
  	dob << "-"
  	dob << month
  	dob << "-"
  	dob << day
  	education = params[:gamer]["education_level"]
  	country = params[:gamer]["country"]
  	gender = params[:gamer]["gender"]
  	errors = []
  	if education.size == 0
  		errors << "Education can't be blank"
  	end
  	if country.size == 0
  		errors << "Country can't be blank"
  	end
  	if gender.size == 0
  		errors << "Gender can't be blank"
  	end
  	if year.size == 0 || month.size == 0 || day.size == 0 
  		errors << "Date Of Birth can't be blank"
  	end
  	if errors.size == 0
       gamer, flag = create_guest_gamer(education, country, gender, dob)
       if flag == false 
         redirect_to action: "sign_up", errors: gamer.errors.messages   	
         return
       end
  	  redirect_to ("/game")
  	  return
  	end
  	redirect_to action: "sign_up", errors: errors
  end
end
