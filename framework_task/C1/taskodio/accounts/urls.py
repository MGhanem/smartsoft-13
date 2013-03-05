from django.conf.urls import patterns, include, url
from accounts import views


urlpatterns = patterns('',
	 url('login/', views.log_in,),
)