// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// the compiled file.
//
// WARNING: THE FIRST BLANK LINE MARKS THE END OF WHAT'S TO BE PROCESSED, ANY BLANK LINE SHOULD
// GO AFTER THE REQUIRES BELOW.
//
//= require jquery
//= require jquery_ujs
//= require bootstrap
//= require highcharts
//= require game
//= require gameRelated
//= require yamli


// author:
//   Mohamed Tamer
// description:
//   takes id of a form contaning checkboxes and the limit of checked boxes and limits the number of selected check boxes to the limit
// params:
//   checkgroup: id of checkboxes form
//   limit: the limit os selected checkboxes  
// success:
//   doesn't allow more slected checkboxes than the limit  
// failure:
//   none
function checkboxlimit(checkgroup, limit, locale){
	var checkgroup = checkgroup;
	var limit = limit;
	for (var i=0; i<checkgroup.length; i++){
		checkgroup[i].onclick=function(){
		var checkedcount = 0;
		for (var i = 0; i < checkgroup.length; i++)
			checkedcount += (checkgroup[i].checked)? 1 : 0
		  if (checkedcount > limit){
		  	if (locale == "en") {
		  	  alert("You can only select a maximum of " + limit + " checkboxes");
		  	} else {
		  	  alert("ليس بإمكانك الإختيار أكثر من " + limit + " خانات");
		  	}
			  this.checked=false;
			}
		}
	}
}