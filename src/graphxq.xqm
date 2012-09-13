(:~ 
: restxq interface for graphviz
: @author andy bunce
: @since sept 2012
:)

module namespace grxq = 'apb.graphviz.web';
declare default function namespace 'apb.graphviz.web'; 

import module namespace gr = 'apb.graphviz' at "graphxq/graphviz.xqm";
import module namespace dotui = 'apb.graphxq.dotui' at "graphxq/dotui.xqm";
import module namespace txq = 'apb.txq' at "graphxq/lib/txq.xqm";
import module namespace request = "http://exquery.org/ns/request";
declare namespace rest = 'http://exquery.org/ns/restxq';

declare variable $grxq:layout:=fn:resolve-uri("graphxq/views/layout.xml");

declare 
%rest:GET %rest:path("graphxq") 
%output:method("html5")
%rest:form-param("dot","{$dot}","")
%rest:form-param("url","{$url}") 
function graphxq($dot,$url) {
    let $edot:=if($url) then "" else fn:encode-for-uri($dot)
    let $dot2:=getdot($dot,$url)
	let $svg:=get-svg($dot)
	let $map:=map{"dot":=$dot,"url":=$url,"svg":=$svg,"edot":=$edot}
	let $page:=render("graphxq/views/page1.xml",$map)
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
	let $down:=<rest:response> 
            <http:response>
            <http:header name="Content-Disposition" value='attachment;filename="graphxq.svg"'/>              
           </http:response>
       </rest:response>
	return ($down[$dl],$svg) 
};

declare 
%rest:GET %rest:path("graphxq/dot")
%output:method("html5")
function dotform(){
	let $map:=map{"list-shapes":=dotui:shapes(""),
	              "list-colors":=dotui:colors("")}
	return render("graphxq/views/dotform.xml",$map)
};

declare 
%rest:GET %rest:path("graphxq/dotml")
%output:method("html5")
function dotmlform(){
	render("graphxq/views/dotmlform.xml",map{})
};

declare 
%rest:GET %rest:path("graphxq/about")
%output:method("html5")
function about(){
	render("graphxq/views/about.xml",map{})
};

declare 
%rest:GET %rest:path("graphxq/search")
%output:method("html5")
%rest:form-param("q", "{$q}")
function search($q ) {
 let $map:=map{"q":=$q}
 return render("graphxq/views/search.xml",$map)
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

declare function render($template,$locals){
	let $default:=map{"sidebar":="Sidebar..." ,
                       "usermenu":=<div>users</div>,
                       "title":=request:path(),
					   "messages":=()}
	let $locals:=map:new(($default,$locals))				   
	return txq:render(fn:resolve-uri($template),$locals,$grxq:layout)
};	   