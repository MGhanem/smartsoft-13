from django.conf.urls import patterns, include, url



urlpatterns = patterns('',
    # Examples:
    # url(r'^$', 'taskodio.views.home', name='home'),
    # url(r'^taskodio/', include('taskodio.foo.urls')),
    # Uncomment the admin/doc line below to enable admin documentation:
    # url(r'^admin/doc/', include('django.contrib.admindocs.urls')),
    # Uncomment the next line to enable the admin:
    # url(r'^admin/', include(admin.site.urls)),
    url(r'^lists/', include('lists.urls', namespace="lists")),
    url(r'^accounts/', include('accounts.urls', namespace="accounts")),

)
