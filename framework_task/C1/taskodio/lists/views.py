from django.http import HttpResponse
from django.template import Context, loader
from django.shortcuts import render, render_to_response
from django.contrib.auth import authenticate, login
from django.template import Context, loader, RequestContext
from django.contrib.auth.models import User


def list_manage(request):
	template = loader.get_template('lists/list_manage.html')
	context = Context({
			'error': 'The email you have entered is already in use.',
			'user': request.user
		})
	return HttpResponse(template.render(context))

def create_list(request):
	list_name=request.POST['list_name']
	if request.user.is_authenticated:
		user=request.user
		if user.list_set.filter(title=list_name):
			return HttpResponse("same list name")
		else:
			return HttpResponse("name gded")

	#return HttpResponse(list_name)
#s4
def view_lists(request):
	if request.user.is_authenticated():
		user = request.user
		list_name_set = user.list_set.all()
		context = Context({'list_name_set': list_name_set,})
		#return HttpResponse(list_name_set.all())
		# return render(request, 'lists/list_manage.html', context)
		return render_to_response('lists/list_manage.html', context, RequestContext(request))
	else:
		context = Context({
			'list_name_set': list_name_set,'user':user
		})
		return render(request,'lists/list_manage.html',context)



		
