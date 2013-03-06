from django.http import HttpResponse
from django.shortcuts import render, render_to_response
from django.contrib.auth.models import User
from django.template import Context, loader, RequestContext
from django.contrib.auth import authenticate, login, logout
from lists import views

# Just renders the sign IN page template
def signin(request):
	title = 'this is the signin page'
	template = loader.get_template('accounts/signin.html')
	context = Context({
		'title': title,
	})
	return HttpResponse(template.render(context))

# Just renders the sign UP page template
def register(request):
	title = 'this is the signup page'
	template = loader.get_template('accounts/register.html')
	context = Context({
		'title': title,
	})
	return HttpResponse(template.render(context))

def log_in(request):
	username=request.POST['username']
	password=request.POST['password']
	template = loader.get_template('accounts/signin.html')

	if not username or not password:
		context = Context({
			'errors': "Please enter a valid username and password.",
		})
		return HttpResponse(template.render(context))
	user = authenticate(username=username, password=password)
	if user is not None:
		login(request, user)
		return HttpResponse("you are a valid user (you are in database)")
	else:
		context=Context({'errors':"Username , or password are not in database"})
		return HttpResponse(template.render(context))
# s2
# actual sign up action
# cases
# 1.username might already exist
# 2.missing credentials
# 3.email already exists
def signup(request):
	username = request.POST['username']
	email = request.POST['email']
	password = request.POST['password']

	# check if the username already exists
	if User.objects.filter(username=username):
		context = Context({
			'error': 'The username you have entered is already in use.',
		})
		template = loader.get_template('accounts/register.html')
		return HttpResponse(template.render(context))
	# check if the email is already in used
	if User.objects.filter(email=email):
		context = Context({
			'error': 'The email you have entered is already in use.',
		})
		template = loader.get_template('accounts/register.html')
		return HttpResponse(template.render(context))
	# check if everything is present

	if not username or not email or not password:
		context = Context({
			'error': 'All the fields are required.',
		})
		template = loader.get_template('accounts/register.html')
		return HttpResponse(template.render(context))

	new_user = User.objects.create_user(username, email, password)
	new_user.save();

	return HttpResponse("Hello, %s" % new_user.username)
	
# s3
# method that is responsible for destroying the current user session
def log_out(request):
	username = request.user.username
	logout(request)
	return HttpResponse("You have successfully logged out, %s" % username) 
	# just a dummy redirect to test functionality
	# will change later to redirect to the landing page

def profile(request):
	if not request.user.is_authenticated():
		context = Context({
			'not_signed_in_error': "You are not signedin, please sign in to view this page.",
		})
		return render_to_response('accounts/profile.html', context, RequestContext(request))
	else:
		context = Context({
			'user': request.user,
		})
		return render_to_response('accounts/profile.html', context, RequestContext(request))