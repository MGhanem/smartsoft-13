$(document).ready(function() {

	$("div.alert").removeClass("row");

	$('a[data-toggle="tab"]').on('click', function(e) {
		history.pushState(null, null, $(this).attr('href'));
	});

	window.addEventListener("popstate", function(e) {
		var activeTab = $('[href=' + location.hash + ']');
		if (activeTab.length) {
			activeTab.tab('show');
		} else {
			$('.nav-tabs a:first').tab('show');
		}
	});

	window.setTimeout(function() {
		$(".alert-info, .alert-success").fadeTo(500, 0).slideUp(500, function(){
			$(this).remove(); 
		});
	}, 5000);

	$("a.edit-link-trophy").click(function(ev) {
		$("div#myModalTrophy a").attr("href", $(this).attr("data-href"));
		$("div#myModalTrophy div.prize-view").html("<div class='trophy well'>" + $(this).parent().parent()
				.html() + "</div>");
		$("div#myModalTrophy div.prize-view a").remove();
	});

	$("a.edit-link-prize").click(function(ev) {
		$("div#myModalPrize a").attr("href", $(this).attr("data-href"));
		$("div#myModalPrize div.prize-view").html("<div class='trophy well'>" + $(this).parent().parent()
				.html() + "</div>");
		$("div#myModalPrize div.prize-view a").remove();
	});
	
});

function readURL(input, previewID) {
    if (input.files && input.files[0]) {
        var reader = new FileReader();

        reader.onload = function (e) {
            $(previewID).attr('src', e.target.result);
        }
	    reader.readAsDataURL(input.files[0]);
    } else {
    	$(previewID).attr('src', '/assets/noimage.gif');
    }
}