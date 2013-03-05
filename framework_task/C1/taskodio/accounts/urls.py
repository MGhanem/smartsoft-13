from django.conf.urls import patterns, include, url
from accounts import views


urlpatterns = patterns('',
	# url('signin/', views.signin,),
	# url('register/', views.register),
	url('signup/', views.signup),
)