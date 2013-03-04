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