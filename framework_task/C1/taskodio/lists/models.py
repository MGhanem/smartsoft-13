from django.db import models
from django.contrib.auth.models import User

class List(models.Model):
	title = models.CharField(max_length=200)
	owner = models.ForeignKey(User)
	

class Task(models.Model):
	title = models.CharField(max_length=200)
	desc= models.CharField(max_length=300)
	list = models.ForeignKey(List)
	done =models.IntegerField(default=0)

