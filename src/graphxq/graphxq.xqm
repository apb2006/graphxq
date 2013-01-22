(:~ 
: RESTXQ interface for graphviz
: @author andy bunce
: @since sept 2012
:)

module namespace grxq = 'apb.graphviz.web';
declare default function namespace 'apb.graphviz.web'; 

import module namespace gr = 'apb.graphviz' at "graphviz.xqm";
import module namespace dotml = 'http://www.martin-loetzsch.de/DOTML' at "dotml.xqm";
import module namespace dotui = 'apb.graphxq.dotui' at "dotui.xqm";
import module namespace txq = 'apb.txq' at "lib/txq.xqm";
import module namespace request = "http://exquery.org/ns/request";

declare namespace svg= "http://www.w3.org/2000/svg";
declare namespace rest = 'http://exquery.org/ns/restxq';

(:~ shared page wrapper :)
declare variable $grxq:layout:=fn:resolve-uri("views/layout.xml");

(:~
: Home page for app
:)
declare 
%rest:GET %rest:path("graphxq") 
%output:method("html") %output:version("5.0")
function about(){
    render("views/about.xml",map{"title":="GraphXQ"})
};

(:~
: GET or POST return svg for dot, with download option 
:)
declare 
%rest:path("graphxq/svg")
%rest:form-param("dot","{$dot}")
%rest:form-param("url","{$url}")  
%rest:form-param("dl","{$dl}")
%output:media-type("image/svg+xml")
function graphxq-svg($dot,$url,$dl) {
    let $dot2:=getdot($dot,$url)
    let $svg:=dot2svg($dot2)
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
    let $toolbar:=fn:doc("views/toolbar.xml")
    let $map:=map{"list-shapes":=dotui:shapes(""),
                  "list-colors":=dotui:colors(""),
                  "svgwidget":=$svgwidget,
                  "toolbar":=$toolbar,
                  "title":="DOT editor",
                  "dot":=$dot}
    return render("views/dotform.xml",$map)
};

declare 
%rest:GET %rest:path("graphxq/dotml")
%output:method("html") %output:version("5.0")
%rest:form-param("src","{$src}")
function dotmlform($src){
    let $svgwidget:=fn:doc("views/widget.svg")
    let $toolbar:=fn:doc("views/toolbar.xml")
    let $default:=<graph xmlns="http://www.martin-loetzsch.de/DOTML"><node id="test"/></graph>
    let $dotml:= getdotml($default ,$src)
    let $dotml:= fn:serialize($dotml)
    let $v:=map{ "svgwidget":=$svgwidget,
                 "toolbar":=$toolbar,
                 "title":="DOTML editor",
                 "dotml":=$dotml}
    return render("views/dotmlform.xml",$v)
};



(:~ static api page :)
declare 
%rest:GET %rest:path("graphxq/api")
%output:method("html") %output:version("5.0")
function api(){
    render("views/api.xml",map{"title":="API information"})
};

declare 
%rest:GET %rest:path("graphxq/library")
%output:method("html") %output:version("5.0")
function library( ) {
 let $map:=map{"title":="Samples"}
 return render("views/library.xml",$map)
};

(:~ 
: @return svg from dotml
:)
declare 
%rest:POST %rest:path("graphxq/api/dotml")
%rest:form-param("dotml","{$dotml}")
function api-dotml($dotml ) as node()
{
 let $dotml:=fn:parse-xml($dotml)
 let $y:=fn:trace($dotml,"ff")
 let $x:=dotml:generate($dotml)
 let $svg:=dot2svg($x)  
 return $svg
 
};

(:~  if url is defined then treat as url and fetch else use dot  :)
declare %private function getdot($dot as xs:string,$url) as xs:string{
 if($url) then
    try{fn:unparsed-text(fn:resolve-uri($url))} catch * { "digraph {{ failed to load remote }}" }
  else    
    $dot         
};
 
(:~  if url is defined then treat as url and fetch else use dotml  :)
declare %private function getdotml($dotml as node(),$url) as node()
{
 if($url) then
    try{
       fn:doc(fn:resolve-uri($url))
    } catch * {
       <graph xmlns="http://www.martin-loetzsch.de/DOTML">
            <node id="fail"/>
        </graph>   }
  else    
    $dotml         
};
 
(:~ Generate svg from dot :)
declare %private function dot2svg($dot as xs:string) as node(){
    let $svgx:=gr:dot($dot,())
    return   gr:autosize($svgx) 
};                     

(:~ 
: Render html page
: @param template path to page template 
: @params locals map of page variables
:)
declare function render($template as xs:string,$locals){

    let $default:=map{"usermenu":=<div>users</div>,
                       "title":=request:path(),
                       "messages":=()}
    let $locals:=map:new(($default,$locals))                   
    return txq:render(fn:resolve-uri($template),$locals,$grxq:layout)
};       