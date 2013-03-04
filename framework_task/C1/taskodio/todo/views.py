from django.http import HttpResponse
from django.template import Context, loader

def home(request):
	template = loader.get_template('todo/home.html')
	context = ({'welcome_message': "Hello, from DJango!!"})
	return HttpResponse(template.render(context))