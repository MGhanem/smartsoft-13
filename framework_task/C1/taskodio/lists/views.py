from django.http import HttpResponse
from django.template import Context, loader, RequestContext
from django.shortcuts import render_to_response

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
	if not request.user.is_authenticated():
		errors = "To create a new list you have to sign up first."
		context = Context({
			'errors': errors,
		})
		# template = loader.get_template('accounts/siginin.html')
		return render_to_response('accounts/signin.html', context, RequestContext(request))
	else:
		title = 'Create a new list'
		context = Context({
			'title': title,
		})
		return render_to_response('lists/new_list.html', context, RequestContext(request))

