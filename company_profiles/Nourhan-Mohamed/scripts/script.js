$(document).ready(function(){
	$("div.about").hide();
	$("div.contact_me").hide();
	$("#ab").css("color","rgba(0,0,0,0.1)");
	$("#cm").css("color","rgba(0,0,0,0.1)");
	$("#ab").css("border-bottom-color","rgba(0,0,0,0.1)");
	$("#cm").css("border-bottom-color","rgba(0,0,0,0.1)");
});

function changeTab(item) {
	$(item).css("color","rgba(0,0,0,1.0)");
	$(item).css("border-bottom-color","rgba(0,0,0,1.0)");
	if($(item).attr('id') == "bi"){
		$("div.basic_info").show();
		$("div.about").hide();
		$("div.contact_me").hide();
		$("#ab").css("color","rgba(0,0,0,0.1)");
		$("#cm").css("color","rgba(0,0,0,0.1)");
		$("#ab").css("border-bottom-color","rgba(0,0,0,0.1)");
		$("#cm").css("border-bottom-color","rgba(0,0,0,0.1)");
	}
	else if($(item).attr('id') == "ab"){
		$("div.basic_info").hide();
		$("div.about").show();
		$("div.contact_me").hide();
		$("#bi").css("color","rgba(0,0,0,0.1)");
		$("#cm").css("color","rgba(0,0,0,0.1)");
		$("#bi").css("border-bottom-color","rgba(0,0,0,0.1)");
		$("#cm").css("border-bottom-color","rgba(0,0,0,0.1)");
	}
	else if($(item).attr('id') == "cm"){
		$("div.about").hide();
		$("div.basic_info").hide();
		$("div.contact_me").show();
		$("#ab").css("color","rgba(0,0,0,0.1)");
		$("#bi").css("color","rgba(0,0,0,0.1)");
		$("#ab").css("border-bottom-color","rgba(0,0,0,0.1)");
		$("#bi").css("border-bottom-color","rgba(0,0,0,0.1)");
	}
}


// $(document).ready(function(){
// 		$("#ab").click(function(){ 
// 			$(this).animate({ 
// 				opacity: 1.0,
// 				borderWidth: 5
// 			}, 600 );
// 			$("#bi")
// 				.css({
// 					display: "none"
// 				});
// 			$("#ab")
// 				.css({
// 					display: "block"
// 				});
// 			$("#cm")
// 				.css({
// 					display: "none"
// 				});
// 			$("#bi").animate({ 
// 				opacity: 0.5,
// 				borderWidth: 1
// 			}, 600 );
// 			$("#cm").animate({ 
// 				opacity: 0.5,
// 				borderWidth: 1
// 			}, 600 );
// 		});
// 	});