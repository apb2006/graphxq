
declare variable $toolbar external :="{tooolbar}";
declare variable $dot external :="{dot}";
declare variable $svgwidget external :="{svg}";

<div class="row">		
		{$toolbar}
	<div class="row">
		<div class="col-md-6" id="leftPane">	
           <div id="dsrc" class="extend ace-container" >
            <div  id="acedata" class="ace " data-mode="dot" ></div>
            </div>
			<form id="editForm" action="api/dot" method="post" target="_new" style="display:none"
				  >
					<textarea id="data" name="data" rows="100"
					style="width:100%;overflow:scroll;height:98%">{$dot}</textarea>
					<input name="dl" type="checkbox" style="display:none"/>
                    <input name="dotopt" type="text" value="a" style="display:none"/>
                    <input name="dotopt" type="text" value="bb" style="display:none"/>
			</form>
			<textarea id="cleartext" style="display: none">digraph title {{ bgcolor=seashell
node[shape=circle,style=filled,fillcolor=lightblue]

}}</textarea>	
		</div>
		<div class="col-md-6" id="rightPane" style="background-color:#F5ECCE;">
			<div id="svgdiv" class="extend">
			<div id="canvasQwpYZa" class="canvas" style="width:100%;height:100%;"></div>
			<script>
 var canvas = d3.graphxq.svgpan(d3.select("#canvasQwpYZa"));
 d3.select("#resetButtonQwpYZa").on("click", canvas.resetted);
 d3.select("#axesButton").on("click", canvas.toggleAxes);
 
//alert("canvas");
</script>
			</div>	
             <div id="svgsrc" class="extend ace-container" style="display: none">
            <div  id="svgsrc2" class="ace " data-mode="svg" data-readonly="1">(no svg loaded)</div>
            </div>
		</div>

	</div>
    
</div>