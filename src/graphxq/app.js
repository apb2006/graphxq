// common app js
// sidebar
$(function() { $("time.relative-date").prettyDate(); });
$(document).ready(function(){
   $("#bnup").on("click",getsvg);
   $("#bnsvg").on("click",function(){ $("#dotForm").submit()});
   $("#bndn").on("click",function(){alert("down")});
   $("#dot").on("keyup",getsvg);
});

function getsvg(){
	 $.post(
             'svg',
             $("#dotForm").serialize(),
              function(data){
               // console.log(data)
                // http://stackoverflow.com/questions/3346106/accessing-a-dom-object-defined-in-an-external-svg-file
                var n = document.importNode(data.documentElement,true);              
                $("#svgdiv").empty().append(n);
              }
            );
};


