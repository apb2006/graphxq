(:~
: graphviz module
: based on http://www.zorba-xquery.com/html/modules/zorba/image/graphviz
:)

module namespace gr="apb.graphviz";
declare default function namespace 'apb.graphviz';
import module namespace proc="http://basex.org/modules/proc";
import module namespace file="http://expath.org/ns/file";
import module namespace xslt="http://basex.org/modules/xslt";

declare namespace svg= "http://www.w3.org/2000/svg";
declare namespace  xlink="http://www.w3.org/1999/xlink";

declare %private variable $gr:dotpath:=if(fn:environment-variable("DOTPATH"))
                                      then fn:environment-variable("DOTPATH")
                                      else "dot";
(:~
: folder for temp files
:)
declare %private variable $gr:tmpdir:=if(file:dir-separator()="\")
                                      then fn:environment-variable("TEMP") || "\"
                                      else "/tmp/";
                                      
declare %private variable $gr:empty:=
<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 300 20" version="1.1" 
width="100%" height="100%" preserveAspectRatio="xMidYMid meet">
   <text x="150" y="10"  text-anchor="middle">Empty.</text>
</svg>;

(:~
:Layout one or more graphs given in the DOT language and render them as SVG.
:)
declare function dot( $dot as xs:string*, $params as xs:string*) as node()*{
    for $d in $dot 
    return if($d) 
           then dot1($d)
           else $gr:empty
};

declare %private function dot1( $dot as xs:string) as node(){
    let $fname:=$gr:tmpdir || random:uuid()
    let $junk:=file:write-text($fname,$dot)
    let $r:=proc:execute($gr:dotpath , ("-Tsvg",$fname))
    let $junk:=file:delete($fname)
   (: let $r:=fn:trace($r,"hhi"):)
    return if($r/code="0")       
           then fn:parse-xml($r/output)
           else fn:error()
};
(:~
:Layout one ore more graphs given in the GXL language and render them as SVG.
: gxl2dot Test.gxl > Test.dot
:)
declare function gxl($gxl as node()*, $params as xs:string*) as node()*{
 for $g in $gxl
  (: @TODO :)
 return fn:error()
};

(:~
: set svg to autosize 100%
:)
declare function autosize($svg as node()) as node(){
  xslt:transform($svg , fn:resolve-uri("dotml/dotpatch.xsl"))
};

