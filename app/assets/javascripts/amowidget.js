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
        , 5000);
   });
});
//
// function getUserTenders(){
//   $.getJSON("/amowidget.json", function(data) {
//     event.preventDefault();
//     return data
//   });
// }
//
//
// function listener(event) {
//   if (event.origin != 'https://24tender.amocrm.ru') {
//     console.log( "что-то прислали с неизвестного домена - откуда получено: " + event.origin );
//     // что-то прислали с неизвестного домена - проигнорируем..
//     return;
//   }
//
//   console.log( "получено: " + event.data );
//   console.log(event);
// }
//
// if (window.addEventListener) {
//   window.addEventListener("message", listener);
// } else {
//   // IE8
//   window.attachEvent("onmessage", listener);
// }


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




// AMOWIDGET for iframe messages functions

$(document).ready(function(){

    window.addEventListener("message", receiveMessage);

    function fitToWindow(customHeight) {

        customHeight = customHeight || 0;

        var scrollHeight = Math.max(
            document.body.scrollHeight, document.documentElement.scrollHeight,
            document.body.offsetHeight, document.documentElement.offsetHeight,
            document.body.clientHeight, document.documentElement.clientHeight
        );

        if (!scrollHeight) {
            scrollHeight = 300;
        }

        if (customHeight) scrollHeight = customHeight;

        sendMessage('fitToWindow', {height: scrollHeight});
    }

    var messageInterface = {

        hello: function() {
            return 'hello';
        },
        getHeight: function(data, cb) {
            var scrollHeight = Math.max(
                document.body.scrollHeight, document.documentElement.scrollHeight,
                document.body.offsetHeight, document.documentElement.offsetHeight,
                document.body.clientHeight, document.documentElement.clientHeight
            );

            runCallback(cb, scrollHeight);
        },
        showAuthForm: function(data, cb) {

            var form = $('#authForm');
            form.show();
            fitToWindow();

            form.find('form').unbind('submit').submit(function(e) {

                e.preventDefault();
                var params = {};
                params.method = 'api.amo_pair';
                params.login = form.find('input[name="login"]').val();
                params.password = form.find('input[name="password"]').val();
                params.user = data.user;
                params.key = data.key;
                params.subdomain = data.subdomain;

                $.post('/ajax', params, function(result) {

                    var data = {};
                    if (result.response && result.response.status == 'ok') {
                        data.status = 'ok';
                        data.key = result.response.key;
                    }
                    else {
                        data.status = 'error';
                        if (result.msg) {
                            data.msg = result.msg;
                        }
                    }

                    runCallback(cb, data);
                });
            });
        },
        getApiKey: function(data, cb) {

            var params = {};
            params.login = data.login;
            params.password = data.password;
            params.method = 'api.amo_get_api_key';

            $.post('/ajax', params, function(result) {

                var data = {};
                if (result.response && result.response.status == 'ok') {
                    data.status = 'ok';
                    data.key = result.response.key;
                }
                else {
                    data.status = 'error';
                    if (result.msg) {
                        data.msg = result.msg;
                    }
                }

                runCallback(cb, data);
            });
        },
        isPair: function(data, cb) {

            var params = {};
            params.method = 'api.amo_is_pair';
            params.user = data.user;

            $.post('/ajax', params, function(result) {
                runCallback(cb, result.response);
            });
        },
        hideAuthForm: function(data, cb) {
            $('#authForm').hide();
            fitToWindow();
            runCallback(cb, {});
        },
        getUserTenders: function(data, cb) {

            var params = {};
            params.user = data.user;
            params.key = data.key;

            $.getJSON("/amowidget.json", params, function(result) {
                event.preventDefault();

                var data = {};

                if (result.tenders) {

                    data.status = 'ok';
                    data.data = result;
                }
                else {
                    data.status = 'error';
                    if (result.msg) {
                        data.msg = result.msg;
                    }
                }

                runCallback(cb, data);
            });
        },
        showScriptList: function(data, cb) {

            var box = $('#scriptList');
            box.find('li').remove();

            var params = {};
            params.method = 'api.amoGetUserScripts';
            params.user = data.user;
            params.key = data.key;

            $.post('/ajax', params, function(result){

                if (result.response) {

                    var scripts = result.response;

                    for (var i = 0; i < scripts.length; i++) {
                        box.append('<li><a class="script-item" data-id="' + scripts[i].id + '" href="#">' + scripts[i].name + '</a></li>');
                    }

                    box.show();
                    box.css({display: 'block'});
                    fitToWindow();

                    $('.script-item').unbind('click').on('click', function(){
                        runCallback(cb, {status: 'ok', id: $(this).attr('data-id')});
                    });

                }
                else {
                    runCallback(cb, {status: 'error', msg: result.msg })
                }
            });
        },
        hideScriptList: function(data, cb) {
            $('#scriptList').hide();
            fitToWindow();
            runCallback(cb, {});
        },
        showMaximize: function(data, cb) {

            var maximize = $('#maximize');
            var scriptList = $('#scriptList');

            maximize.find('.current-script').text('Скрипт "' + data.name + '" активен и свернут');

            scriptList.hide();
            maximize.show();
            fitToWindow(150);

            $('.do-maximize').unbind('click').on('click', function(){
                maximize.hide();
                scriptList.show();
                fitToWindow();
                runCallback(cb, {});
            });
        },
        showScript: function(data, cb) {

            var self = this;

            var params = {};
            params.method = 'api.amoGetScript';
            params.id = data.id;
            params.user = data.user;
            params.key = data.key;
            params.entity_type = data.entity_type;
            params.entity_id = data.entity_id;

            if (data.skipStart) {
                $('body').addClass('hs');
            }
            else $('body').removeClass('hs');

            jQuery.ajax({
                'type' : 'POST',
                'dataType' : 'json',
                'url' : '/ajax',
                'data' : params,
                'cache' : false,
                'timeout' : 20000,
                'success' : function(result) {

                    $.app.script.view_notes = [];
                    $.app.notes.formulas = [];

                    if (result.response) {

                        $.app.addField.setFields(result.response.fields);

                        if (result.response.static_fields) {
                            $.app.addField.setStaticFields(result.response.static_fields);
                        }

                        if (result.response.view_notes) {
                            $.app.script.view_notes = result.response.view_notes;
                        }

                        if (result.response.formulas) {
                            $.app.notes.formulas = result.response.formulas;
                        }

                        var box = $('.js_box');
                        var view = $.app.script.view;
                        box.removeClass('js_box_alert');
                        box.show();

                        view.scriptUser = data.user;
                        view.scriptUserKey = data.key;
                        view.scriptDomain = data.subdomain;
                        view.entityType = data.entity_type;
                        view.entityId = data.entity_id;

                        if (data.withoutSaving == true) {
                            box.addClass('js_box_alert');
                            view.withoutSaving = true;
                        }
                        else {
                            box.removeClass('js_box_alert');
                            view.withoutSaving = false;
                        }

                        view.openAndLaunchScript(result.response.id, result.response.ver, result.response.name,
                            result.response.data, result.response.target);

                        runCallback(cb, {status: 'ok'});
                    }
                    else {

                        if (result.msg == 'User not found' || result.msg == 'Username is empty' ||
                            result.msg == 'Wrong api key') {
                            self.raiseError(Translator.trans('authentication_error'));
                        }
                        else if (result.msg == 'Script not found') {
                            self.raiseError(Translator.trans('script_not_found_error'));
                        }
                        else if (result.msg == 'forbidden') {
                            self.raiseError(Translator.trans('access_error'));
                        }
                        else {
                            self.raiseError(Translator.trans('internal_error'));
                        }

                        runCallback(cb, {status: 'error', msg: result.msg});
                    }
                }
            });
        },
        hideScript: function(data, cb) {
            $('.js_box').hide();
            runCallback(cb, {});
        },
        checkAccess: function(data, cb) {

            var params = {};
            params.method = 'api.amoCheckAccess';
            params.user = data.user;
            params.key = data.key;
            params.id = data.id;

            $.post('/ajax', params, function(result) {
                if (result.response) {
                    runCallback(cb, result.response.status);
                }
                else runCallback(cb, result.msg);
            });
        },
        raiseError: function(text) {

            var box = $('#error_box');
            box.find('.alert').text(text);
            box.show();
        }
    };

    function runCallback(cb, data) {
        sendMessage('runCallback', {data: data, callback: cb});
    }

    function sendMessage(cmd, params) {
        cmd += ':' + (!!params ? JSON.stringify(params) : '');
        top.postMessage(cmd, '*');
    }

    function receiveMessage(event)
    {
        var cmd = event.data.split(/:(.+)?:(.+)?/),
            args = [];

        var name = cmd[0],
            cb = cmd[2];

        if (cmd[1])
            args = JSON.parse(cmd[1]);

        var result;
        if (messageInterface[name]) {
            result = messageInterface[name](args, cb);

            if (cb && result) {
                runCallback(cb, result);
            }
        }
    }

});
