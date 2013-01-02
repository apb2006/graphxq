(:~ 
: restxq interface for graphviz
: @author andy bunce
: @since sept 2012
:)

module namespace grxq = 'apb.graphviz.web';
declare default function namespace 'apb.graphviz.web'; 

import module namespace gr = 'apb.graphviz' at "graphviz.xqm";
import module namespace dotui = 'apb.graphxq.dotui' at "dotui.xqm";
import module namespace txq = 'apb.txq' at "lib/txq.xqm";
import module namespace request = "http://exquery.org/ns/request";
declare namespace rest = 'http://exquery.org/ns/restxq';

declare variable $grxq:layout:=fn:resolve-uri("views/layout.xml");

declare 
%rest:GET %rest:path("graphxq") 
%output:method("html") %output:version("5.0")
%rest:form-param("dot","{$dot}","")
%rest:form-param("url","{$url}") 
function graphxq($dot,$url) {
    let $edot:=if($url) then "" else fn:encode-for-uri($dot)
    let $dot2:=getdot($dot,$url)
	let $svg:=get-svg($dot)
	let $map:=map{"dot":=$dot,"url":=$url,"svg":=$svg,"edot":=$edot}
	let $page:=render("views/page1.xml",$map)
	 return $page
};

(:~
: return svg for dot, with download option  
:)
declare 
%rest:path("graphxq/svg")
%rest:form-param("dot","{$dot}")
%rest:form-param("url","{$url}")  
%rest:form-param("dl","{$dl}")
%output:media-type("image/svg+xml")
function graphxq-svg($dot,$url,$dl) {
	let $dot2:=getdot($dot,$url)
	let $svg:=get-svg($dot2)
		let $resp:=<rest:response>
					<http:response>
						<http:header name="Access-Control-Allow-Origin" value="*"/>
						{if($dl)
						then <http:header name="Content-Disposition" value='attachment;filename="graphxq.svg"'/>
						else ()}
					</http:response>
				</rest:response>
	
	return ($resp,$svg) 
};

(:~
: display dot edit form
: @param src load from url
:)
declare 
%rest:GET %rest:path("graphxq/dot")
%output:method("html") %output:version("5.0")
%rest:form-param("src","{$src}")
function dotform($src){
    let $dot:= getdot("digraph {{a -> b}}",$src)
    let $svgwidget:=fn:doc("views/widget.svg")
	let $map:=map{"list-shapes":=dotui:shapes(""),
	              "list-colors":=dotui:colors(""),
	              "svgwidget":=$svgwidget,
				  "dot":=$dot}
	return render("views/dotform.xml",$map)
};

declare 
%rest:GET %rest:path("graphxq/dotml")
%output:method("html") %output:version("5.0")
function dotmlform(){
	render("views/dotmlform.xml",map{})
};

declare 
%rest:GET %rest:path("graphxq/about")
%output:method("html") %output:version("5.0")
function about(){
	render("views/about.xml",map{})
};

declare 
%rest:GET %rest:path("graphxq/search")
%output:method("html") %output:version("5.0")
%rest:form-param("q", "{$q}")
function search($q ) {
 let $map:=map{"q":=$q}
 return render("views/search.xml",$map)
};
declare 
%rest:GET %rest:path("graphxq/library")
%output:method("html") %output:version("5.0")
 
function library( ) {
 let $map:=map{ }
 return render("views/library.xml",$map)
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
    return   gr:autosize($svgx) 
};         			

declare function render($template,$locals){
 let $sidebar:=<div>
 <a href="/graphxq/viewbox/viewBox.svg">viewbox work</a>
 <ul>
 <div>Samples:</div>
    <li> <a href="dot?src=samples/dot/process.gv">process</a></li>
    <li><a href="/restxq/graphxq/dot?src=samples/dot/unix.gv">unix</a></li>
     <li> <a href="/restxq/graphxq/dot?src=samples/dot/root.gv">root (slow)</a></li>
     </ul> 
    </div>
	let $default:=map{"sidebar":=$sidebar ,
                       "usermenu":=<div>users</div>,
                       "title":=request:path(),
					   "messages":=()}
	let $locals:=map:new(($default,$locals))				   
	return txq:render(fn:resolve-uri($template),$locals,$grxq:layout)
};	   