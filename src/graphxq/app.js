// common app js
// sidebar

// http://stackoverflow.com/questions/4583703/jquery-post-request-not-ajax
jQuery(function($) { $.extend({
    form: function(url, data, method) {
        if (method == null) method = 'POST';
        if (data == null) data = {};

        var form = $('<form>').attr({
            method: method,
            action: url
         }).css({
            display: 'none'
         });

        var addData = function(name, data) {
            if ($.isArray(data)) {
                for (var i = 0; i < data.length; i++) {
                    var value = data[i];
                    addData(name + '[]', value);
                }
            } else if (typeof data === 'object') {
                for (var key in data) {
                    if (data.hasOwnProperty(key)) {
                        addData(name + '[' + key + ']', data[key]);
                    }
                }
            } else if (data != null) {
                form.append($('<input>').attr({
                  type: 'hidden',
                  name: String(name),
                  value: String(data)
                }));
            }
        };

        for (var key in data) {
            if (data.hasOwnProperty(key)) {
                addData(key, data[key]);
            }
        }

        return form.appendTo('body');
    }
}); });


$(document).ready(function(){
   $("#bnup").on("click",getsvg);
   $("#bnsvg").on("click",function(){ $("#dotForm").submit()});
   $("#bndn").on("click",function(){getsvg(true)});
   $("#dot").on("keyup",getsvg);
   var resize=function(){
     var h=$(window).height();
     $('.extend').each(function(){
	  var j=$(this)
	   var top=j.offset();
	   j.height(h-top.top-10)
	 });
	};  
    $(window).resize(resize);
    resize();	
});

function getsvg(dl){
     var f=$("#dotForm").serializeArray()
     var d=$("#frm-defaults").serializeArray()
     console.log("#frm-default",d)
	// if(dl)f.push({"name":"dl","value":1})
	 $.ajax({
             type:"POST",
			 url:"svg",
             data:f,
			 dataType: "text",
             success: function(str){
               // console.log(data)
			   var oParser = new DOMParser();
               var data = oParser.parseFromString(str, "text/xml");
                // http://stackoverflow.com/questions/3346106/accessing-a-dom-object-defined-in-an-external-svg-file
                var n = document.importNode(data.documentElement,true);              
                $("#cuthere").empty().append(n);
				$("#svgsrc").empty().text(str);
              },
 			 error:function(jqXHR, textStatus, errorThrown){
 				console.log("ajax error: "+textStatus + errorThrown);
 			}			
            });
};

function dotit(){
//	xsvg.innerText="";
	var sdot="digraph G {\n";
	var t=f1.lstBgcolors.value;
	if(t){ sdot+="bgcolor="+t+"\n"};
	var t=f1.lstShapes.value;
	if(t){ sdot+="node[shape="+t+",style=filled,fillcolor="+f1.lstColors.value+"]\n"};
	var t=f1.dotTitle.value;
	if(t) sdot+='label="'+t+'"\n';
	var t=f1.dotRankDir.value;
	if(t) sdot+=t+'\n';
	var t=f1.dotBody.value;
	sdot+=t+"\n}";
	update(sdot,f1.filter.value);
}
