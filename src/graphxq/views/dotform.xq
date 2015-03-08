
declare variable $toolbar external :="{tooolbar}";
declare variable $dot external :="{dot}";
declare variable $svgwidget external :="{svg}";

<div class="row-fluid">		

	<div class="row-fluid" style="height:24px">
		{$toolbar}
	</div>
	<div class="row-fluid">
		<div class="span6  " id="leftPane">	
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
		<div class="span6" id="rightPane">
			<div id="svgdiv" class="extend"
				style="width:100%;height:30em;border: 1px solid #E3E3E3;min-height:10em;">{$svgwidget}</div>
             <div id="svgsrc" class="extend ace-container" style="display: none">
            <div  id="svgsrc2" class="ace " data-mode="svg" data-readonly="1">(no svg loaded)</div>
            </div>
		</div>

	</div>
    
</div>