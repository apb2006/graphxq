// common app js
var resize;
 
$(document).ready(function(){
    resize=function(){
     var h=$(window).height();
     $('.extend').not(':hidden').each(function(){
	  var j=$(this)
	   var top=j.offset();
	   j.height(h-top.top-10)
       //resize any aces
       j.find(".ace").each(function(){
            var id=$(this).attr('id')
            ace.edit(id).resize();
        });
     
	})};  
    $(window).resize(resize);
    resize();
    // init ace where ace class
    $('.ace').each(function(){
  	  acediv($(this).attr('id'))
  	  });
     if($("#editForm").length){
    setupEdit()
    }; 
   
});
function setupEdit(){
    $("#infotip").popover({"html":true,
    	  template: '<div class="popover popwidth"><div class="arrow"></div><div class="popover-inner popwidth" ><h3 class="popover-title"></h3><div class="popover-content"><p></p></div></div></div>'
    });
    // toolbar buttons
    $('a[data-action="lDom"]').click(function (){
        $("#leftPane").css('display','inline').removeAttr('class').addClass("col-md-12");
        $("#rightPane").removeAttr('class').css("display","none");
        resize();

    });
    $('a[data-action="equality"]').click(function (){
        $("#leftPane").css('display','inline').removeAttr('class').addClass("col-md-6");
        $("#rightPane").css('display','inline').removeAttr('class').addClass("col-md-6");
        resize();
    });
    $('a[data-action="rDom"]').click(function (){
        $("#rightPane").css('display','inline').removeAttr('class').addClass("col-md-12");
        $("#leftPane").removeAttr('class').css("display","none");
        resize();
    });

   var submit=function(download){
       $('input[name=dl]').attr('checked', download);
       $("#editForm").submit();       
    };   
   $("#bnRefresh").on("click",getsvg);
//   $("#bnOpts").on("click",function(){alert("not yet")});
   $("#bnsvg").on("click",function(){submit(false)});
   $("#bndn").on("click",function(){submit(true)});
   $("#bnxml").on("click",function(){
                            $("#svgdiv, #svgsrc").toggle(0,resize)
                             
                            //resize();
                            });
    $("#bnclear").on("click",function(){
                              ace.edit("acedata").setValue($("#cleartext").val(),1)
           });
    var editor= ace.edit("acedata");
    editor.getSession().on('change',throttle(getsvg,250));
    editor.setValue($("#data").val(),1);       	
};

function getsvg(){
     $("#data").val(ace.edit("acedata").getValue());
     var f=$("#editForm").serializeArray()
     var d0=+new Date()
     $("#infotip").removeClass("btn-danger").addClass("btn-warning");
	 $.ajax({
             type:"POST",
			 url:$("#editForm").attr("action"),
             data:f,
			 dataType: "text",
             success: function(str){
               // console.log(data)
               var d=(new Date())-d0;
               $("#infotip").removeClass("btn-danger btn-warning");
			   var oParser = new DOMParser();
               var data = oParser.parseFromString(str, "text/xml");
                // http://stackoverflow.com/questions/3346106/accessing-a-dom-object-defined-in-an-external-svg-file
                var n = document.importNode(data.documentElement,true);              
                replaceItem(n);
				ace.edit("svgsrc2").setValue(str,1);
                //ace.edit("svgsrc2").selection.clear();
				$("#infotip").attr("data-content","SVG returned in: "+d +" ms.");
              },
 			 error:function(jqXHR, textStatus, errorThrown){
 				console.log("ajax error: "+textStatus + jqXHR.responseText);
 				$("#infotip").attr("data-content","<pre>"+jqXHR.responseText+"</pre>");
                $("#infotip").addClass("btn-danger");
 			}			
            });
};

// make div with id to ace
function acediv(id){
  // https://github.com/ajaxorg/ace/issues/1161
	var mode=$("#"+id).attr("data-mode");
	var readonly=!!$("#"+id).attr("data-readonly");
  //  ace.config.set("workerPath", "/static/graphxq/ace-worker");
    var editor = ace.edit(id);
    editor.setTheme("ace/theme/textmate");
    editor.getSession().setMode("ace/mode/"+mode);
    editor.getSession().setUseWrapMode(true);
    editor.setReadOnly(readonly);
};

function throttle(fn, delay) {
  var timer = null;
  return function () {
    var context = this, args = arguments;
    clearTimeout(timer);
    timer = setTimeout(function () {
      fn.apply(context, args);
    }, delay);
  };
};