from django.http import HttpResponse
from django.template import Context, loader
from django.shortcuts import render
from django.contrib.auth import authenticate, login
from django.template import Context, loader, RequestContext
from django.contrib.auth.models import User

def list_manage(request):
	list_name=request.POST.get('list_name')
	user=request.user
	return HttpResponse('wra;fdsd')


		
