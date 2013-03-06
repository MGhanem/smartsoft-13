from django.conf.urls import patterns, include, url

from accounts import views

urlpatterns = patterns('',
    # Examples:
    # url(r'^$', 'taskodio.views.home', name='home'),
    # url(r'^taskodio/', include('taskodio.foo.urls')),
    # Uncomment the admin/doc line below to enable admin documentation:
    # url(r'^admin/doc/', include('django.contrib.admindocs.urls')),
    # Uncomment the next line to enable the admin:
    # url(r'^admin/', include(admin.site.urls)),
    url('', include('lists.urls', namespace="lists")),
    url(r'^accounts/', include('accounts.urls', namespace="accounts")),
    url(r'^register/', views.register, name="register"),
    url(r'^signin/', views.signin, name="signin"),
    url(r'^signout/', views.log_out, name='logout'),
    url(r'^profile/', views.profile, name='profile'),

)
