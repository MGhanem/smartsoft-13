from django.conf.urls import patterns, url
from lists import views

# urlpatterns = patterns('',
# 	# /polls/
#     url(r'^$', views.index, name='index'),
#     # /polls/5
#     url(r'^(?P<poll_id>\d+)/$', views.detail, name='detail'),
#     # /polls/5/results
#     url(r'^(?P<poll_id>\d+)/results/$', views.results, name='results'),
#     # /polls/5/vote
#     url(r'^(?P<poll_id>\d+)/vote/$', views.vote, name='vote'),
# )
urlpatterns = patterns('',
	 url('', views.view_lists, name='list_manage'),
	 url('lists/create_list/', views.create_list, name='create_list'),
	 url('lists/view_lists/', views.view_lists, name='view_lists'),

)