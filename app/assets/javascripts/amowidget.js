$(document).on("click","#import_last",function() {
   event.preventDefault();
   console.log("Click Handled!");

  //  $.getJSON('/imports/new.json', function(data){
  //    var items = [];
   //
  //    $.each(data, function(key, val){
  //      items.push('<li id="' + key + '">' + val + '</li>');
  //    });
   //
  //    $('<ul/>', {
  //      'class': 'my-new-list',
  //      html: items.join('')
  //    }).appendTo('body');
  //  });
});




//       success: function(data) {
//          $('#main').html($(data).find('#main *'));
//          $('#notification-bar').text('The page has been successfully loaded');
//       },
//       error: function() {
//          $('#notification-bar').text('An error occurred');
//       }
//    });
// });
