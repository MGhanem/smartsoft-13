from django.conf.urls import patterns, url, include
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
	url(r'^new_list/$', views.new_list, name='new_list'),
	url(r'^new_list$', views.new_list, name='new_list'),
	url('new_list/create_list/', views.create_list, name='create_list'),
	# url('', views.view_lists, name='list_manage'),
	url('lists/create_list/', views.create_list, name='create_list'),
	url('lists/view_lists/', views.view_lists, name='view_lists'),
	url(r'^(?P<list_id>\d+)/$', views.list_details, name='list_detail'),
	url(r'^(?P<list_id>\d+)/edit/$', views.edit, name="edit_list_form"),
	url(r'^(?P<list_id>\d+)/edit_list/$', views.edit_list, name="edit_list_action"),
	url(r'^(?P<list_id>\d+)/delete/', views.delete_list, name='delete_list'),
)