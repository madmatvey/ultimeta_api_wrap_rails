$(document).on("click","#import_button",function() {
   event.preventDefault();
   $("#circleG").show();
   console.log("Click Handled!");
   $("#import_button").prop("disabled",true);
   $.getJSON('/imports/new', function(data){
     console.log("JOB ID: ");
     console.log(data.job_id);
     var updatedCheck = window.setInterval(
        function(){$.getJSON("/imports/status",
                    {
                       job_id: data.job_id
                    },
                    function(status){
                       if (status !== "working") {
                         window.clearInterval(updatedCheck);
                           console.log(status);
                           console.log("work finished");
                           $("#import_button").prop('disabled',false);
                           setLastImportData();
                       }
                       else {
                         console.log(status);
                       }
                })}
        , 3000);
   });
});





function setLastImportData(){
  $.getJSON("/imports/last.json", function(data) {
    data_string = JSON.stringify(data);
    console.log(data_string);
    var b = new Date(data_string * 1000);
    var month = new Array();
    month[0] = "Jan";
    month[1] = "Feb";
    month[2] = "Mar";
    month[3] = "Apr";
    month[4] = "May";
    month[5] = "Jun";
    month[6] = "Jul";
    month[7] = "Aug";
    month[8] = "Sep";
    month[9] = "Oct";
    month[10] = "Nov";
    month[11] = "Dec";
    minutes = b.getMinutes();
    if (minutes < 10){
      val = "Импорт от: " + b.getDate() + " " + month[b.getMonth()] + " " + b.getHours() + ":" + "0" + b.getMinutes();
    }
    else {
      val = "Импорт от: " + b.getDate() + " " + month[b.getMonth()] + " " + b.getHours() + ":" + b.getMinutes();
    }

    $("#import_button").text(val);
    $("#circleG").hide();
  });
}
