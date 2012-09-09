(:~ 
: restxq interface to graphviz
: @author andy bunce
: @since sept 2012
:)

module namespace grxq = 'apb.graphviz.web';
declare default function namespace 'apb.graphviz.web'; 
import module namespace gr = 'apb.graphviz' at "graphxq/graphviz.xqm";
declare namespace rest = 'http://exquery.org/ns/restxq';

declare 
%rest:GET %rest:path("graphxq") 
%output:method("html5")
%rest:form-param("dot","{$dot}","")
%rest:form-param("url","{$url}") 
function graphxq($dot,$url) {
    let $edot:=if($url) then "" else fn:encode-for-uri($dot)
    let $dot2:=getdot($dot,$url)
	let $svg:=get-svg($dot)
	 return <html>
	<head>
		<title>Graphviz</title>
		<meta http-equiv="X-UA-Compatible" content="IE=Edge,chrome=1" />
        <meta name="viewport" content="width=device-width, initial-scale=1.0" />
        <meta name="description" content="tree xquery svg" />
		<script type="text/javascript"><![CDATA[
		  var _gaq = _gaq || [];
		  _gaq.push(['_setAccount', 'UA-34544921-1']);
		  _gaq.push(['_setDomainName', 'rhcloud.com']);
		  _gaq.push(['_trackPageview']);

		  (function() {
			var ga = document.createElement('script'); ga.type = 'text/javascript'; ga.async = true;
			ga.src = ('https:' == document.location.protocol ? 'https://ssl' : 'http://www') + '.google-analytics.com/ga.js';
			var s = document.getElementsByTagName('script')[0]; s.parentNode.insertBefore(ga, s);
		  })();
		]]></script>
		<style type="text/css">pre {{background-color:#FFFFDD;}}</style>
		</head>
		<body>
		<h1>RestXQ interface to graphviz</h1>
		<p>Enter a string in the dot language 
		Examples: <a href="?dot=digraph {{ a -> b}}">digraph {{ a -> b}}</a>,
                  <a href="?hedge={{github|https://github.com/apb2006/hedgetree}}(ab({{tree|%23treexml}}))">another </a>
		.</p>
		<p> Or enter a Url to a xml document examples:
		<a href="?url=graphxq/samples/process.dot">process</a>,
	<a href="?url=hedgetree/samples/hier.dot">hedgeweb</a>
	<a href="?url=https://raw.github.com/apb2006/hedgetree/master/src/hedgetree/samples/hedgeweb.xml">remote</a>
		  </p>
		 <form method="get" action="./graphxq" style="background-color:#EEEEEE;padding:8px;">
		 
		  	      
		 <textarea name="dot" rows="2" cols="80">{$dot}</textarea>
		 <p></p>
		  <p>Or enter the url to a node XML source
		 <input name="url"  value="{$url}" style="width:30em"/></p>
		 <button type="submit">Redraw</button>
		</form >
		   <h2 id="isvg">Inline SVG</h2>
		 <div style="width:300px;height:200px">{$svg}</div>
		 
		<h2 id="svg">Object referencing <a href="graphxq/svg?dot={$edot}&amp;url={$url}">svg</a>, 
		( <a href="graphxq/svg?dl=1&amp;dot={$edot}&amp;url={$url}">download</a> svg)</h2>
		<object height="150" width="300" data="graphxq/svg?dot={$edot}&amp;url={$url}" 
		style="border:5px solid red;" type="image/svg+xml">
		SVG Here
		</object>
		<h2 id="svgxml">SVG xml</h2>
		<pre>
		 {fn:serialize($svg)}
		 </pre>
		 
		
		 <h2 id="layout">Layout xml</h2>    
		
		  <h2>About</h2>
		  <p> Source: @github:<iframe src="http://ghbtns.com/github-btn.html?user=apb2006&amp;repo=graphxq&amp;type=watch"
      allowtransparency="true" frameborder="0" scrolling="0" width="62px" height="20px"></iframe>, Twitter:
     <a href="https://twitter.com/share" class="twitter-share-button" data-via="apb1704" data-count="none">Tweet</a>
<script>!function(d,s,id){{var js,fjs=d.getElementsByTagName(s)[0];if(!d.getElementById(id)){{js=d.createElement(s);js.id=id;js.src="//platform.twitter.com/widgets.js";fjs.parentNode.insertBefore(js,fjs);}}}}(document,"script","twitter-wjs");</script>.
     </p>
</body>
	</html>
};

(:~ @return svg for hedge with download option.
:)
declare 
%rest:GET %rest:path("graphxq/svg")
%rest:form-param("dot","{$dot}")
%rest:form-param("url","{$url}")  
%rest:form-param("dl","{$dl}")
function graphxq-svg($dot,$url,$dl) {
	let $dot2:=getdot($dot,$url)
	let $svg:=get-svg($dot2)
	let $down:=<rest:response> 
            <http:response>
            <http:header name="Content-Disposition" value='attachment;filename="graphxq.svg"'/>              
           </http:response>
       </rest:response>
	return ($down[$dl],$svg) 
};

(:~  use dot or url :)
declare %private function getdot($dot,$url) as xs:string{
 if($url) then
    try{fn:unparsed-text(fn:resolve-uri($url))} catch * { "digraph {{ failed to load remote }}" }
else    
    $dot         
}; 
(:~  post process svg :)
declare %private function get-svg($dot as xs:string) as node(){
    let $svgx:=gr:dot($dot,())
    return  gr:autosize($svgx) 
};         				   