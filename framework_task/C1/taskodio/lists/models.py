from django.db import models

class List(models.Model):
	title = models.CharField(max_length=200)
