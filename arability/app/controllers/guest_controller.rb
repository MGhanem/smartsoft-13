class GuestController < ApplicationController
  
  # Author:
  #   Mohamed Tamer
  # Description
  #   renders guest sign up form and any errors
  # Params:
  #   errors: errors resulting from trying to save
  # Success: 
  #   renders form
  # Failure:
  #   none
  def sign_up
  	@errors = params[:errors]
  end

  # Author:
  #   Mohamed Tamer
  # Description
  #   renders guest continue sign up form and any errors
  # Params:
  #   errors: errors resulting from trying to save
  # Success: 
  #   renders form
  # Failure:
  #   none
  def continue_sign_up
    @errors = params[:errors]
  end


  # Author:
  #   Mohamed Tamer
  # Description
  #   tries to creat a guest gamer with the given data
  # Params:
  #   gamer: a resource containing the data entered from the form
  # Success: 
  #   creates guest gamer and redirects to gamer
  # Failure:
  #   redirects to sign up form with the errors
  def continue_signing_up
    email = params[:gamer][:email]
    password = params[:gamer][:password]
    password_confirmation = params[:gamer][:password_confirmation]
    username = params[:gamer][:username]
    errors = []
    if username.size == 0
      errors << "#{t(:guest_error5)}"
    end
    if email.size == 0
      errors << "#{t(:guest_error6)}"
    end
    flag1 = false
    if password.size == 0
      errors << "#{t(:guest_error7)}"
    else
      flag1 = true
    end
    flag2 = false
    if password_confirmation.size == 0
      errors << "#{t(:guest_error8)}"
    else
      flag2 = true
    end
    if flag1 && flag2
      if password_confirmation != password
        errors << "#{t(:guest_error9)}"
      end
    end
    if errors.size == 0
      gamer, flag = create_gamer(email, password, username)
      if flag == false 
        redirect_to action: "continue_sign_up", errors: gamer.errors.messages     
        return
      end
      sign_in gamer
      redirect_to ("/game")
      return
    end
    redirect_to action: "continue_sign_up", errors: errors
  end


  # Author:
  #   Mohamed Tamer
  # Description
  #   tries to creat a guest gamer with the given data
  # Params:
  #   gamer: a resource containing the data entered from the form
  # Success: 
  #   creates guest gamer and redirects to gamer
  # Failure:
  #   redirects to sign up form with the errors
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
  		errors << "#{t(:guest_error1)}"
  	end
  	if country.size == 0
  		errors << "#{t(:guest_error2)}"
  	end
  	if gender.size == 0
  		errors << "#{t(:guest_error3)}"
  	end
  	if year.size == 0 || month.size == 0 || day.size == 0 
  		errors << "#{t(:guest_error4)}"
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
