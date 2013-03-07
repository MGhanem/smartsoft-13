from django.http import HttpResponse
from django.template import Context, loader, RequestContext
from django.shortcuts import render, render_to_response
from django.contrib.auth import authenticate, login
from lists.models import List
from django.contrib.auth.models import User


# def list_manage(request):
# 	template = loader.get_template('lists/list_manage.html')
# 	context = Context({
# 			'error': 'The email you have entered is already in use.',
# 			'user': request.user
# 		})
# 	return HttpResponse(template.render(context))

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

# s5 create list action from the new list view form
def create_list(request):
# 	# if user is not authenticated
	# return HttpResponse("FUCK!")
	if not request.user.is_authenticated():
		# redirect to the sign in page and send error with it
		context = Context({ 'errors': "You need to sign in before creating a list"})
		return render_to_response('accounts/signin.html', context, RequestContext(request))
	# else the user is authenticated
	else:
		title = request.POST['list_name']
		# if the title is empty redirect to create_list page and state error
		if not title:
			context = Context({ 'list_errors': "You can't enter an empty list name."})
			return render_to_response('lists/new_list.html', context, RequestContext(request))

		# else if the title is not empty
		else:
			# check if the user has a list already by that name
			if request.user.list_set.filter(title=title):
				context = Context({ 'list_errors': "You can't enter an empty list name."})
				return render_to_response('lists/new_list.html', context, RequestContext(request))
			# else if the user doesn't have a list by that name
			else:
				new_list = List(title=title, user=request.user)
				new_list.save()
				return HttpResponse("You have succesffuly created the list %s" % new_list.title)
				# send a dummy response saying that here we will create a list by
				# --- by that name


#s4
def view_lists(request):
	if not request.user.is_authenticated():
		# redirect to the sign in page and send error with it
		context = Context({ 'errors': "You need to sign in before viewing your lists."})
		return render_to_response('accounts/signin.html', context, RequestContext(request))

	if request.user.is_authenticated():
		user = request.user
		list_name_set = user.owner.all()
		shared_list_set=user.shared.all()
		context = Context({'list_name_set': list_name_set, 'shared_list_set': shared_list_set})
		#return HttpResponse(list_name_set.all())
		# return render(request, 'lists/list_manage.html', context)
		return render_to_response('lists/list_manage.html', context, RequestContext(request))

# redirects to the list view page 
# where the list will be viewed there
# will live @ /lists/<list_id>
def list_details(request, list_id):
	return HttpResponse("List id %s " % list_id)
	# will add later if the user is a member in the list
	# or not when we add list members attribute
	if not request.user.is_authenticated():
		# redirect to the sign in page and send error with it
		context = Context({ 'errors': "You need to sign in before viewing this page."})
		return render_to_response('accounts/signin.html', context, RequestContext(request))

	else:
		user = request.user
		list = List.objects.get(pk=list_id)
		if not list:
			# redirect to all lists page
			user = request.user
			list_name_set = user.list_set.all()
			detail_error = "The list you're trying to access does not exist."
			context = Context({'list_name_set': list_name_set,})
			return render_to_response('lists/list_manage.html', context, RequestContext(request))


def edit_list(request, list_id):
	if request.user.is_authenticated():
		new_title = request.POST['list_title']
		l = List.objects.get(pk=list_id)
		if(len(new_title) < 1):
			context = Context({
				'errors': "please make sure you enter a new list name",
				'list': l,
			})
			return render_to_response('lists/edit.html', context, RequestContext(request))
		else:
			user = request.user
			list_name_set = user.owner.all()
			shared_list_set=user.shared.all()
			l = List.objects.get(pk=list_id)
			l.title = new_title
			l.save()
			# will change this later to redirect to
			# the list page actually where
			# the tasks will exist
			# todo
			context = Context({
				'list': l,
				'success': "You have succesfuly changed the list name.",
				'list_name_set': list_name_set,
				'shared_list_set': shared_list_set,
				'user': user
			})
			return render_to_response('lists/list_manage.html', context, RequestContext(request))
	else:
		l = List.objects.get(pk=list_id)
		context = Context({
			'errors': "please Signin before you can edit a list",
			'list': l,
		})
		return render_to_response('lists/edit.html', context, RequestContext(request))

# lists/1/edit redirects to the form where 
# he can edit the list name of id 1
def edit(request, list_id):
	l = List.objects.get(pk=list_id)
	context = Context({
		'list': l,
	})
	return render_to_response('lists/edit.html', context, RequestContext(request))


#s6 deleting lists
def delete_list(request, list_id):
	if not request.user.is_authenticated():
		errors = "You must be logged in to delete a list"
		context = Context({
			'errors': errors,
		})
		return render_to_response('accounts/signin.html', context, RequestContext(request))
	else:
		if (List.objects.filter(pk=list_id).count()<1):
			errors = "List does not exist."
			context = Context({
				'detail_error': errors,
				})
			return render_to_response('lists/list_manage.html', context, RequestContext(request))
		else:
			l = List.objects.get(pk=list_id)
			if(l.owner.id == request.user.id):
				user = request.user
				list_name_set = user.list_set.all()
				l_name = l.title
				l.delete()
				success = "You have successfuly deleted the list %s" % l_name
				context = Context({
					'list_name_set': list_name_set,
					'user': user,
					'success': success	
					})
				return render_to_response('lists/list_manage.html', context, RequestContext(request))
			else:
				errors = "You cannot delete a list that's not yours"
				context = Context({
					'detail_error': errors,
					})
				return render_to_response('lists/list_manage.html', context, RequestContext(request))

def share_list(request, list_id):
	if not request.user.is_authenticated():
		errors = "You must be logged in to share lists"
		context = Context({
			'errors': errors,
			})
		return render_to_response('accounts/signin.html', context, RequestContext(request))
	else:
		if (List.objects.filter(pk=list_id).count()<1):
			errors="List does not exist."
			context= Context({
				'detail_error': errors,
				})
			return render_to_response('lists/list_manage.html', context, RequestContext(request))
		else:
			new_user = request.POST['shared_user']
			if (User.objects.filter(username= new_user).count()<1):
				errors="User does not exist."
			else:
				l = List.objects.get(pk=list_id)
				if (l.user.id != request.user.id):
					errors = "You cannot share a list that's not yours"
					context = Context({
						'detail_error': errors,
						})
					return render_to_response('lists/list_manage.html', context, RequestContext(request))
				else:
					# if (List.objects.filter(pk=list_id).members.filter(username=new_user).count<1):
					u=request.user
					list_name_set = u.owner.all()
					l = List.objects.get(pk=list_id)
					l.members.add(u)
					l.save()
					context = Context({
						'list': l,
						'success': "You have succesfuly shared the list.",
						'list_name_set': list_name_set,
						'user': u
						})
					return render_to_response('lists/list_manage.html', context, RequestContext(request))
					# else:
					# 	errors = "List already shared with this user"
					# context = Context({
					# 	'detail_error': errors,
					# 	})
					# return render_to_response('lists/list_manage.html', context, RequestContext(request))

def share(request, list_id):
	l = List.objects.get(pk=list_id)
	context = Context({
		'list': l,
	})
	return render_to_response('lists/share.html', context, RequestContext(request))