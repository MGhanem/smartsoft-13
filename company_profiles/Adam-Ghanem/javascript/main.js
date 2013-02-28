$(document).ready(function() {
    $("#tweet").text("Fetching Latest Tweet...");

    var user = "Adam_Ghanem";

    $.ajax({
        type: "GET",
        dataType: "json",
        url: "http://search.twitter.com/search.json?q=from:"+user+"&rpp=1&callback=?",
        success: function(data){
            $("#tweet").text("\"" + data.results[0].text + "\"");
        }
    });
});

 WebFontConfig = {
    google: { families: [ 'Lato:400,300italic,700:latin' ] }
  };
  (function() {
    var wf = document.createElement('script');
    wf.src = ('https:' == document.location.protocol ? 'https' : 'http') +
      '://ajax.googleapis.com/ajax/libs/webfont/1/webfont.js';
    wf.type = 'text/javascript';
    wf.async = 'true';
    var s = document.getElementsByTagName('script')[0];
    s.parentNode.insertBefore(wf, s);
  })();

   WebFontConfig = {
    google: { families: [ 'Open+Sans:400,300italic,400italic,700:latin' ] }
  };
  (function() {
    var wf = document.createElement('script');
    wf.src = ('https:' == document.location.protocol ? 'https' : 'http') +
      '://ajax.googleapis.com/ajax/libs/webfont/1/webfont.js';
    wf.type = 'text/javascript';
    wf.async = 'true';
    var s = document.getElementsByTagName('script')[0];
    s.parentNode.insertBefore(wf, s);
  })();
