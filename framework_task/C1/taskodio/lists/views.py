from django.http import HttpResponse
from django.template import Context, loader

# /lists
def index(request):
	title = 'All Lists'
	template = loader.get_template('lists/index.html')
	context = Context({
		'title': title,
	})
	return HttpResponse(template.render(context))

# s5 create list view redirect
def new_list(request):
	title = 'Create a new list'
	context = Context({
		'title': title
	})
	template = loader.get_template('lists/new_list.html')
	return HttpResponse(template.render(context))

