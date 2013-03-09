from django.http import HttpResponse
from django.template import Context, loader, RequestContext
from django.shortcuts import render, render_to_response
from django.contrib.auth import authenticate, login
from lists.models import List,Task
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
			if request.user.owner.filter(title=title):
				context = Context({ 'list_errors': "You can't enter an empty list name."})
				return render_to_response('lists/new_list.html', context, RequestContext(request))
			# else if the user doesn't have a list by that name
			else:
				new_list = List(title=title, user=request.user)
				new_list.save()
				user = request.user
				list_name_set = user.owner.all()
				shared_list_set=user.shared.all()
				success = "you have successfully created the list %s" % new_list.title
				context = Context({
					'list_name_set': list_name_set, 'shared_list_set': shared_list_set,
					'success': success,
				})
				return render_to_response('lists/list_manage.html', context, RequestContext(request))
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
		return render_to_response('lists/list_manage.html', context, RequestContext(request))

# redirects to the list view page 
# where the list will be viewed there
# will live @ /lists/<list_id>
def list_details(request, list_id):
	# return HttpResponse("List id %s " % list_id)
	# will add later if the user is a member in the list
	# or not when we add list members attribute
	#return HttpResponse("awrsgdf4e")
	if not request.user.is_authenticated():
		# redirect to the sign in page and send error with it
		context = Context({ 'errors': "You need to sign in before viewing this page."})
		return render_to_response('accounts/signin.html', context, RequestContext(request))
	else:
		if (List.objects.filter(pk=list_id).count() < 1):
			user = request.user
			list_name_set = user.owner.all()
			shared_list_set=user.shared.all()
			detail_error = "This list does not Exists"
			context = Context({
			'list_name_set': list_name_set, 'shared_list_set': shared_list_set,
			'detail_error': detail_error,
			})
			return render_to_response('lists/list_manage.html', context, RequestContext(request))
			
		user = request.user
		#list1 = user.list_set.all().get(pk=list_id)
		list1 = List.objects.all().get(pk=list_id)
		if(list1.user.id == request.user.id or list1.members.filter(username=request.user.username).count()>0):
			if list1:
				# redirect to all lists page
				tasks_set = list1.task_set.all()
				shared_users_set = list1.members.all()
				owner = list1.user
				context = Context({'tasks_set': tasks_set,'shared_users_set': shared_users_set,'owner':owner,'list1':list1})
				#context = Context({'list1':list1})
				return render_to_response('lists/view_list.html', context, RequestContext(request))
				tasks_set = list1.task_set.all()
				shared_users_set = list1.members.all()
				owner = list1.user
				context = Context({'tasks_set': tasks_set,'shared_users_set': shared_users_set,'owner':owner,'list1':list1})
				#context = Context({'list1':list1})
				return render_to_response('lists/view_list.html', context, RequestContext(request))
			else :
				context = Context({'errors': "There are no tasks in this list.",
					})
				return render_to_response('lists/view_list.html',context,RequestContext(request)) 
		else:
			list_name_set = user.owner.all()
			shared_list_set=user.shared.all()
			context=Context({'detail_error':"You cannot access a list that is not yours.",'user':request.user,
				'list_name_set': list_name_set, 'shared_list_set': shared_list_set})
			return render_to_response('lists/list_manage.html',context,RequestContext(request))


def save_edit_task(request,list_id,task_id):
	#return HttpResponse("dsfmncejs")
	if request.user.is_authenticated():
		list1=List.objects.all().get(pk=list_id)
		if(list1.user.id == request.user.id or list1.members.filter(username=request.user.username).count()>0):
			tasks_set = list1.task_set.all()
			shared_users_set = list1.members.all()
			owner = list1.user
			new_name=request.POST['new_name']
			new_desc=request.POST['new_desc']
			if not new_name or not new_desc:
				context=({'list1':list1,'shared_users_set': shared_users_set,'owner':owner,'tasks_set':tasks_set,
					'detail':"enter a valid info.",})
				return render_to_response('lists/view_list.html',context,RequestContext(request))
			else:
				edited_task=Task.objects.all().get(pk=task_id)
				edited_task.title=new_name
				edited_task.desc=new_desc
				edited_task.save()
				context=({'list1':list1,'shared_users_set': shared_users_set,'owner':owner,'tasks_set':tasks_set,'detail':"Your Task has been edited successfully."})
				return render_to_response('lists/view_list.html',context
					,RequestContext(request))
		else:
			user = request.user
			list_name_set = user.owner.all()
			shared_list_set=user.shared.all()
			detail_error="this list has not been shared with you, why are you trying to edit it?!"
			context = Context({'detail_error': detail_error,'list_name_set': list_name_set, 'shared_list_set': shared_list_set})
			return render_to_response('lists/list_manage.html', context, RequestContext(request))
	else:
		return HttpResponse("Your not even authenticated, how the hell you got here.")
def edit_task(request,list_id,task_id):
	#return HttpResponse(task_id)
	#return HttpResponse(Task.objects.all().get(id=task_id).id)
	if request.user.is_authenticated():
		list1=List.objects.all().get(id=list_id)
		if(list1.user.id == request.user.id or list1.members.filter(username=request.user.username).count()>0):
			tasks_set=list1.task_set.all()
			shared_users_set = list1.members.all()
			owner = list1.user
			context=Context({'list1':list1,'shared_users_set': shared_users_set,'owner':owner,'tasks_set':tasks_set,
				'detail':"",'edited_task_id':task_id,})
			return render_to_response('lists/view_list.html',context,RequestContext(request))
		else:
			user = request.user
			list_name_set = user.owner.all()
			shared_list_set=user.shared.all()
			detail_error="this list has not been shared with you, why are you trying to edit it?!"
			context = Context({'detail_error': detail_error,'list_name_set': list_name_set, 'shared_list_set': shared_list_set})
			return render_to_response('lists/list_manage.html', context, RequestContext(request))
	else:
		return HttpResponse("error")

def delete_task(request,list_id,task_id):
	#return HttpResponse("editing")
	if request.user.is_authenticated():
		list1=List.objects.all().get(id=list_id)
		if(list1.user.id == request.user.id or list1.members.filter(username=request.user.username).count()>0):
			Task.objects.all().get(pk=task_id).delete()
			tasks_set=list1.task_set.all()
			shared_users_set = list1.members.all()
			owner = list1.user
			context = Context({'detail': "Your task has been deleted successfully",
				'list1':list1,'shared_users_set': shared_users_set,'owner':owner,'tasks_set':tasks_set
				})
			return  render_to_response('lists/view_list.html',context,RequestContext(request))
		else:
			user = request.user
			list_name_set = user.owner.all()
			shared_list_set=user.shared.all()
			detail_error="this list has not been shared with you, why are you trying to edit it?!"
			context = Context({'detail_error': detail_error,'list_name_set': list_name_set, 'shared_list_set': shared_list_set})
			return render_to_response('lists/list_manage.html', context, RequestContext(request))
	else:
		return HttpResponse("you are not even authenticated, how the hell have you got here.")

def change_state(request,list_id,task_id):
	if request.user.is_authenticated():
		list1=List.objects.all().get(id=list_id)
		if(list1.user.id == request.user.id or list1.members.filter(username=request.user.username).count()>0):
			tasks_set=list1.task_set.all()
			shared_users_set = list1.members.all()
			owner = list1.user
			edited_task=Task.objects.all().get(pk=task_id)
			edited_task.done= not edited_task.done
			edited_task.save()
			context = Context({'detail': "Your task has been edited successfully",
				'list1':list1,'shared_users_set': shared_users_set,'owner':owner,'tasks_set':tasks_set
				})
			return  render_to_response('lists/view_list.html',context,RequestContext(request))
		else:
			user = request.user
			list_name_set = user.owner.all()
			shared_list_set=user.shared.all()
			detail_error="this list has not been shared with you, why are you trying to edit it?!"
			context = Context({'detail_error': detail_error,'list_name_set': list_name_set, 'shared_list_set': shared_list_set})
			return render_to_response('lists/list_manage.html', context, RequestContext(request))
	else:
		return HttpResponse("you are not even authenticated, how the hell have you got here.")

def create_task(request,list_id):
	if request.user.is_authenticated():
		task_name=request.POST['task_name']
		task_desc=request.POST['task_desc']
		list1=List.objects.all().get(pk=list_id)
		tasks_set=list1.task_set.all()
		shared_users_set = list1.members.all()
		owner = list1.user
		if not task_name or not task_desc:
			context = Context({'detail': "Enter a valid info.",
				'list1':list1,'shared_users_set': shared_users_set,'owner':owner,'tasks_set':tasks_set
				})
			return  render_to_response('lists/view_list.html',context,RequestContext(request))
		else:
			new_task=Task(list=List.objects.get(pk=list_id),title=task_name
				,desc=task_desc)
			new_task.save()
			context = Context({'detail': "Your task is added successfully.",
				'list1':list1,'shared_users_set': shared_users_set,'owner':owner,'tasks_set':tasks_set
				})
			return  render_to_response('lists/view_list.html',context,RequestContext(request))
	return HttpResponse("there is an error ya man.")

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
	if(l.user.id == request.user.id or l.members.filter(username=request.user.username).count()>0):	
		context = Context({
			'list': l,
		})
		return render_to_response('lists/edit.html', context, RequestContext(request))
	else:
		user = request.user
		list_name_set = user.owner.all()
		shared_list_set=user.shared.all()
		detail_error="this list has not been shared with you, why are you trying to edit it?!"
		context = Context({'detail_error': detail_error,'list_name_set': list_name_set, 'shared_list_set': shared_list_set})
		return render_to_response('lists/list_manage.html', context, RequestContext(request))

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
			user = request.user
			list_name_set = user.owner.all()
			shared_list_set=user.shared.all()
			context = Context({'detail_error': errors,'list_name_set': list_name_set, 'shared_list_set': shared_list_set})
			#return HttpResponse(list_name_set.all())
			# return render(request, 'lists/list_manage.html', context)
			return render_to_response('lists/list_manage.html', context, RequestContext(request))
		else:
			l = List.objects.get(pk=list_id)
			if(l.user.id == request.user.id):
				user = request.user
				list_name_set = user.owner.all()
				shared_list_set=user.shared.all()
				l_name = l.title
				l.delete()
				success = "You have successfuly deleted the list %s" % l_name
				context = Context({
					'list_name_set': list_name_set,
					'shared_list_set':shared_list_set,
					'user': user,
					'success': success	
					})
				return render_to_response('lists/list_manage.html', context, RequestContext(request))
			else:
				#user = request.user
				# list_name_set = user.owner.all()
				# shared_list_set=user.shared.all()
				# errors = "You cannot delete a list that's not yours"
				# context = Context({
				# 	'detail_error': errors,
				# 	'list_name_set': list_name_set,
				# 	'shared_list_set': shared_list_set,
				# 	'user': user
				# 	})
				# return render_to_response('lists/list_manage.html', context, RequestContext(request))

				if(request.user.shared.filter(pk=list_id).count()<1):
					errors = "You cannot delete a list that's not yours"
					user = request.user
					list_name_set = user.owner.all()
					shared_list_set=user.shared.all()
					context = Context({'detail_error': errors,'list_name_set': list_name_set, 'shared_list_set': shared_list_set})
					#return HttpResponse(list_name_set.all())
					# return render(request, 'lists/list_manage.html', context)
					return render_to_response('lists/list_manage.html', context, RequestContext(request))
				else:
					user = request.user
					list_name_set = user.owner.all()
					shared_list_set=user.shared.all()
					l.members.remove(request.user)
					request.user.shared.remove(l)
					success = "You have successfuly removed the list %s" % l.title
					context = Context({
						'list_name_set': list_name_set,
						'shared_list_set':shared_list_set,
						'user': user,
						'success': success	
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
			user = request.user
			list_name_set = user.owner.all()
			shared_list_set=user.shared.all()
			context = Context({'detail_error': errors,'list_name_set': list_name_set, 'shared_list_set': shared_list_set})
			#return HttpResponse(list_name_set.all())
			# return render(request, 'lists/list_manage.html', context)
			return render_to_response('lists/list_manage.html', context, RequestContext(request))
		else:
			new_user = request.POST['shared_user']
			if (User.objects.filter(username= new_user).count()<1):
				errors="User does not exist."
				user = request.user
				list_name_set = user.owner.all()
				shared_list_set=user.shared.all()
				context = Context({'detail_error': errors,'list_name_set': list_name_set, 'shared_list_set': shared_list_set})
				#return HttpResponse(list_name_set.all())
				# return render(request, 'lists/list_manage.html', context)
				return render_to_response('lists/list_manage.html', context, RequestContext(request))
			else:
				l = List.objects.get(pk=list_id)
				if (l.user.id != request.user.id):
					errors = "You cannot share a list that's not yours"
					user = request.user
					list_name_set = user.owner.all()
					shared_list_set=user.shared.all()
					context = Context({'detail_error': errors,'list_name_set': list_name_set, 'shared_list_set': shared_list_set})
					#return HttpResponse(list_name_set.all())
					# return render(request, 'lists/list_manage.html', context)
					return render_to_response('lists/list_manage.html', context, RequestContext(request))
				else:
					share_with=User.objects.get(username= new_user)
					if(l.user.id == share_with.id):
						errors = "You cannot share a list with yourself"
						user = request.user
						list_name_set = user.owner.all()
						shared_list_set=user.shared.all()
						context = Context({'detail_error': errors,'list_name_set': list_name_set, 'shared_list_set': shared_list_set})
						#return HttpResponse(list_name_set.all())
						# return render(request, 'lists/list_manage.html', context)
						return render_to_response('lists/list_manage.html', context, RequestContext(request))
						# if (List.objects.filter(pk=list_id).members.filter(username=new_user).count<1):
					else:
						if(l.members.filter(username= new_user).count()<1):
							u=request.user
							list_name_set = u.owner.all()
							shared_list_set= u.shared.all()
							l = List.objects.get(pk=list_id)
							l.members.add(share_with)
							l.save()
							context = Context({
								'list': l,
								'success': "You have succesfuly shared the list.",
								'list_name_set': list_name_set,
								'user': u,
								'shared_list_set': shared_list_set
								})
							return render_to_response('lists/list_manage.html', context, RequestContext(request))
						else:
							errors = "You already shared the list with this user"
							user = request.user
							list_name_set = user.owner.all()
							shared_list_set=user.shared.all()
							context = Context({'detail_error': errors,'list_name_set': list_name_set, 'shared_list_set': shared_list_set})
							#return HttpResponse(list_name_set.all())
							# return render(request, 'lists/list_manage.html', context)
							return render_to_response('lists/list_manage.html', context, RequestContext(request))

def share(request, list_id):
	l = List.objects.get(pk=list_id)
	context = Context({
		'list': l,
	})
	return render_to_response('lists/share.html', context, RequestContext(request))

def remove_shared_user(request, list_id, removed_user):
	if not request.user.is_authenticated():
		errors = "You must be logged in to remove a user from a list"
		context = Context({
			'errors': errors,
		})
		return render_to_response('accounts/signin.html', context, RequestContext(request))
	else:
		if (List.objects.filter(pk=list_id).count()<1):
			errors = "List does not exist."
			user = request.user
			list_name_set = user.owner.all()
			shared_list_set=user.shared.all()
			context = Context({'detail_error': errors,'list_name_set': list_name_set, 'shared_list_set': shared_list_set})
			#return HttpResponse(list_name_set.all())
			# return render(request, 'lists/list_manage.html', context)
			return render_to_response('lists/list_manage.html', context, RequestContext(request))
		else:
			l = List.objects.get(pk=list_id)
			if(l.user.id == request.user.id):
				tasks_set = l.task_set.all()
				shared_users_set = l.members.all()
				owner = l.user
				removed= User.objects.get(pk=removed_user)
				l.members.remove(removed)
				removed.shared.remove(l)
				success = "You have successfuly removed the user %s from this list" % removed.username 
				context = Context({'success':success,'tasks_set': tasks_set,'shared_users_set': shared_users_set,'owner':owner,'list1':l})
				#context = Context({'list1':list1})
				return render_to_response('lists/view_list.html', context, RequestContext(request))
			else:
				l = List.objects.get(pk=list_id)
				errors = "You cannot remove a user from a list that's not yours"
				tasks_set = l.task_set.all()
				shared_users_set = l.members.all()
				owner = l.user
				context = Context({
					'error': errors,
					'tasks_set': tasks_set,'shared_users_set': shared_users_set,'owner':owner,'list1':l
					})
				return render_to_response('lists/view_list.html', context, RequestContext(request))
