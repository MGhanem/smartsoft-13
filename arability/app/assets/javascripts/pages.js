$(document).ready(function() {
	var slide_show = $("div#slide_show");
	$("div#main").prepend('<div id="slide_show" class="carousel slide">' + slide_show.html() + '</div>');
	slide_show.remove();
	$('.carousel').carousel();
});