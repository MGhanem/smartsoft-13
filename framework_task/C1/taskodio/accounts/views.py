from django.http import HttpResponse
from django.template import Context, loader
from django.contrib.auth import authenticate

def signin(request):
	title = 'this is the signin page'
	template = loader.get_template('accounts/signin.html')
	context = Context({
		'title': title,
	})
	return HttpResponse(template.render(context))

def register(request):
	title = 'this is the signup page'
	template = loader.get_template('accounts/register.html')
	context = Context({
		'title': title,
	})
	return HttpResponse(template.render(context))

def login(request):
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
		return HttpResponse("you are a valid user (you are in database)")
	else:
		context=Context({'errors':"Username , or password are not in database"})
		return HttpResponse(template.render(context))