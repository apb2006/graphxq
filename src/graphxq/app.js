// common app js
var resize;
 
$(document).ready(function(){
    if($("#editForm").length){
    setupEdit()
    };
    $("#infotip").popover({"html":true,
    	  template: '<div class="popover popwidth"><div class="arrow"></div><div class="popover-inner popwidth" ><h3 class="popover-title"></h3><div class="popover-content"><p></p></div></div></div>'
    });
    resize=function(){
     var h=$(window).height();
     $('.extend').not(':hidden').each(function(){
	  var j=$(this)
	   var top=j.offset();
	   j.height(h-top.top-10)
       console.log("resize",j)
	 });
      $('.ace').each(function(){
      
      console.log("acerrrr",$(this))
      ace.edit($(this).attr('id'))
      }) 
	};  
    $(window).resize(resize);
    resize();
});
function setupEdit(){
    // toolbar buttons
    $('a[data-action="lDom"]').click(function (){
        $("#leftPane").css('display','inline').removeAttr('class').addClass("span12");
        $("#rightPane").removeAttr('class').css("display","none");
        resize();

    });
    $('a[data-action="equality"]').click(function (){
        $("#leftPane").css('display','inline').removeAttr('class').addClass("span6");
        $("#rightPane").css('display','inline').removeAttr('class').addClass("span6");
        resize();
    });
    $('a[data-action="rDom"]').click(function (){
        $("#rightPane").css('display','inline').removeAttr('class').addClass("span12");
        $("#leftPane").removeAttr('class').css("display","none");
        resize();
    });
    acediv("svgsrc2","svg",true);
   var sub=function(download){
       $('input[name=dl]').attr('checked', download);
       $("#editForm").submit();       
    };   
   $("#bnRefresh").on("click",getsvg);
   $("#bnsvg").on("click",function(){sub(false)});
   $("#bndn").on("click",function(){sub(true)});
   $("#data").on("keyup",throttle(getsvg,250));
   $("#bnxml").on("click",function(){
                            $("#svgdiv,#svgsrc").toggle()
                            resize();
                            });
    $("#bnclear").on("click",function(){
                              $("#dot").val(
                              "digraph title {\n bgcolor=seashell\n node[shape=circle,style=filled,fillcolor=lightblue]\n\n}"
                              )
           });
    getsvg()	
};

function getsvg(){
     var f=$("#editForm").serializeArray()
     var d0=+new Date()
	 $.ajax({
             type:"POST",
			 url:$("#editForm").attr("action"),
             data:f,
			 dataType: "text",
             success: function(str){
               // console.log(data)
               var d=(new Date())-d0;
               console.log("svg time:",d);
			   var oParser = new DOMParser();
               var data = oParser.parseFromString(str, "text/xml");
                // http://stackoverflow.com/questions/3346106/accessing-a-dom-object-defined-in-an-external-svg-file
                var n = document.importNode(data.documentElement,true);              
                $("#gInsertSVG").empty().append(n);
				ace.edit("svgsrc2").setValue(str,1);
                //ace.edit("svgsrc2").selection.clear();
				$("#infotip").attr("data-content","SVG returned in: "+d +" ms.");
              },
 			 error:function(jqXHR, textStatus, errorThrown){
 				console.log("ajax error: "+textStatus + jqXHR.responseText);
 				$("#infotip").attr("data-content","<pre>"+jqXHR.responseText+"</pre>");
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
};
// make div 3id to ace
function acediv(id,mode,readonly){
  // https://github.com/ajaxorg/ace/issues/1161
    ace.config.set("workerPath", "/graphxq/ace-worker");
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