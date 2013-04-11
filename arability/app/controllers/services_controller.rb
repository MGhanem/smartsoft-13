class ServicesController < ApplicationController
	before_filter :authenticate_gamer!, :except => [:create]
  
	def index
		@services = current_gamer.services.all
	end

	def destroy
		@service = current_gamer.services.find(params[:id])
		@service.destroy
		redirect_to services_path
	end

 	def create
 omniauth = request.env['omniauth.auth']
  if omniauth
    omniauth['extra']['gamer_hash']['email'] ? email =  omniauth['extra']['gamer_hash']['email'] : email = ''
    omniauth['extra']['gamer_hash']['name'] ? name =  omniauth['extra']['gamer_hash']['name'] : name = ''
    omniauth['extra']['gamer_hash']['id'] ?  uid =  omniauth['extra']['gamer_hash']['id'] : uid = ''
    omniauth['provider'] ? provider =  omniauth['provider'] : provider = ''
    
    render :text => uid.to_s + " - " + name + " - " + email + " - " + provider
  else
    render :text => 'Error: Omniauth is empty'
  end
  params[:service] ? service_route = params[:service] : service_route = 'no service (invalid callback)'

  # get the full hash from omniauth
  omniauth = request.env['omniauth.auth']

  # continue only if hash and parameter exist
  if omniauth and params[:service]
    
    # map the returned hashes to our variables first - the hashes differ for every service
    if service_route == 'facebook'
      omniauth['extra']['gamer_hash']['email'] ? email =  omniauth['extra']['gamer_hash']['email'] : email = ''
      omniauth['extra']['gamer_hash']['name'] ? name =  omniauth['extra']['gamer_hash']['name'] : name = ''
      omniauth['extra']['gamer_hash']['id'] ?  uid =  omniauth['extra']['gamer_hash']['id'] : uid = ''
      omniauth['provider'] ? provider =  omniauth['provider'] : provider = ''
    elsif service_route == 'github'
      omniauth['gamer_info']['email'] ? email =  omniauth['gamer_info']['email'] : email = ''
      omniauth['gamer_info']['name'] ? name =  omniauth['gamer_info']['name'] : name = ''
      omniauth['extra']['gamer_hash']['id'] ?  uid =  omniauth['extra']['gamer_hash']['id'] : uid = ''
      omniauth['provider'] ? provider =  omniauth['provider'] : provider = ''
    elsif service_route == 'twitter'
      email = ''    # Twitter API never returns the email address
      omniauth['gamer_info']['name'] ? name =  omniauth['gamer_info']['name'] : name = ''
      omniauth['uid'] ?  uid =  omniauth['uid'] : uid = ''
      omniauth['provider'] ? provider =  omniauth['provider'] : provider = ''
    else
      # we have an unrecognized service, just output the hash that has been returned
      render :text => omniauth.to_yaml
      #render :text => uid.to_s + " - " + name + " - " + email + " - " + provider
      return
    end
  
    # continue only if provider and uid exist
    if uid != '' and provider != ''
        
      # nobody can sign in twice, nobody can sign up while being signed in (this saves a lot of trouble)
      if !gamer_signed_in?
        
        # check if gamer has already signed in using this service provider and continue with sign in process if yes
        auth = Service.find_by_provider_and_uid(provider, uid)
        if auth
          flash[:notice] = 'Signed in successfully via ' + provider.capitalize + '.'
          sign_in_and_redirect(:gamer, auth.gamer)
        else
          # check if this gamer is already registered with this email address; get out if no email has been provided
          if email != ''
            # search for a gamer with this email address
            existinggamer = Gamer.find_by_email(email)
            if existinggamer
              # map this new login method via a service provider to an existing account if the email address is the same
              existinggamer.services.create(:provider => provider, :uid => uid, :uname => name, :uemail => email)
              flash[:notice] = 'Sign in via ' + provider.capitalize + ' has been added to your account ' + existinggamer.email + '. Signed in successfully!'
              sign_in_and_redirect(:gamer, existinggamer)
            else
              # let's create a new gamer: register this gamer and add this authentication method for this gamer
              name = name[0, 39] if name.length > 39             # otherwise our gamer validation will hit us

              # new gamer, set email, a random password and take the name from the authentication service
              gamer = Gamer.new :email => email, :password => SecureRandom.hex(10), :fullname => name

              # add this authentication service to our new gamer
              gamer.services.build(:provider => provider, :uid => uid, :uname => name, :uemail => email)

              # do not send confirmation email, we directly save and confirm the new record
              gamer.skip_confirmation!
              gamer.save!
              gamer.confirm!

              # flash and sign in
              flash[:myinfo] = 'Your account on CommunityGuides has been created via ' + provider.capitalize + '. In your profile you can change your personal information and add a local password.'
              sign_in_and_redirect(:gamer, gamer)
            end
          else
            flash[:error] =  service_route.capitalize + ' can not be used to sign-up on CommunityGuides as no valid email address has been provided. Please use another authentication provider or use local sign-up. If you already have an account, please sign-in and add ' + service_route.capitalize + ' from your profile.'
            redirect_to new_gamer_session_path
          end
        end
      else
        # the gamer is currently signed in
        
        # check if this service is already linked to his/her account, if not, add it
        auth = Service.find_by_provider_and_uid(provider, uid)
        if !auth
          current_gamer.services.create(:provider => provider, :uid => uid, :uname => name, :uemail => email)
          flash[:notice] = 'Sign in via ' + provider.capitalize + ' has been added to your account.'
          redirect_to services_path
        else
          flash[:notice] = service_route.capitalize + ' is already linked to your account.'
          redirect_to services_path
        end  
      end  
    else
      flash[:error] =  service_route.capitalize + ' returned invalid data for the gamer id.'
      redirect_to new_gamer_session_path
    end
  else
    flash[:error] = 'Error while authenticating via ' + service_route.capitalize + '.'
    # redirect_to (new_gamer_session_path) and return
  end
end
end