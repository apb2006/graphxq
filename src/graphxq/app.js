// common app js
function throttle(fn, delay) {
  var timer = null;
  return function () {
    var context = this, args = arguments;
    clearTimeout(timer);
    timer = setTimeout(function () {
      fn.apply(context, args);
    }, delay);
  };
} 
$(document).ready(function(){
    if($("#editForm").length)setupEdit()
});
function setupEdit(){
    // toolbar buttons
    $('a[data-action="lDom"]').click(function (){
        $("#leftPane").css('display','inline').removeAttr('class').addClass("span12");
        $("#rightPane").removeAttr('class').css("display","none");

    });
    $('a[data-action="equality"]').click(function (){
        $("#leftPane").css('display','inline').removeAttr('class').addClass("span6");
        $("#rightPane").css('display','inline').removeAttr('class').addClass("span6");
    });
    $('a[data-action="rDom"]').click(function (){
        $("#rightPane").css('display','inline').removeAttr('class').addClass("span12");
        $("#leftPane").removeAttr('class').css("display","none");
    });

   var sub=function(download){
       $('input[name=dl]').attr('checked', download);
       $("#editForm").submit();       
    };   
   $("#bnup").on("click",getsvg);
   $("#bnsvg").on("click",function(){sub(false)});
   $("#bndn").on("click",function(){sub(true)});
   $("#dot").on("keyup",throttle(getsvg,300));
   $("#bnxml").on("click",function(){
                            $("#svgdiv,#svgsrc").toggle()
                            });
    $("#bnclear").on("click",function(){
                              $("#dot").val("digraph title {\n\n}")
                            });
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
