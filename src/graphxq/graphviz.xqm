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
: folder for temp files \=windows
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
   let $params:=("-Tsvg")
    for $d in $dot 
    return if(fn:not($d))
           then $gr:empty
           else let $r:=dot-execute($d,$params)
                return dot-svg($r)
};

(:~ run dot command :)
declare %private function dot-execute( $dot as xs:string, $params as xs:string*) as element(result){
    let $fname:=$gr:tmpdir || random:uuid()
    let $junk:=file:write-text($fname,$dot)
    let $r:=proc:execute($gr:dotpath , ($params,$fname))
    let $junk:=file:delete($fname)
    return if($r/code!="0")
           then  fn:error(xs:QName('gr:dot1'),$r/error) 
           else $r
};

(:~ run dot command  returning binary :)
declare %private function dot-executeb( $dot as xs:string, $params as xs:string*) as xs:base64Binary{
    let $fname:=$gr:tmpdir || random:uuid()
    let $oname:=$fname || ".o"
    let $junk:=file:write-text($fname,$dot)
    let $r:=proc:execute($gr:dotpath , ($params,"-o"|| $oname,$fname))
    let $junk:=file:delete($fname)
    return if($r/code!="0")
           then  fn:error(xs:QName('gr:dot1'),$r/error) 
           else  let $d:=file:read-binary($oname)
                 (: let $junk:=file:delete($oname) :) 
                 return $d                  
};

(:~ cleanup dot svg result :)
declare %private function dot-svg( $r as element(result)) as element(svg:svg){ 
    let $s:=fn:parse-xml($r/output)  (: o/p  has comment nodes :) 
    let $ver:=$s/comment()[1]/fn:normalize-space()
    let $title:=$s/comment()[2]/fn:normalize-space()
    let $svg:=$s/* 				
    return   <svg xmlns="http://www.w3.org/2000/svg" 
    xmlns:xlink="http://www.w3.org/1999/xlink" >
  {$svg/@* ,
   <metadata>
    <rdf:RDF
           xmlns:rdf = "http://www.w3.org/1999/02/22-rdf-syntax-ns#"
           xmlns:rdfs = "http://www.w3.org/2000/01/rdf-schema#"
           xmlns:dc = "http://purl.org/dc/elements/1.1/" >
        <rdf:Description about="https://github.com/apb2006/graphxq"
             dc:title="{$title}"
             dc:description="A graph visualization"
             dc:date="{fn:current-dateTime()}"
             dc:format="image/svg+xml">
          <dc:creator>
            <rdf:Bag>
              <rdf:li>{$ver}</rdf:li>
              <rdf:li resource="https://github.com/apb2006/graphxq"/>
            </rdf:Bag>
          </dc:creator>
        </rdf:Description>
      </rdf:RDF>
	  </metadata>,
  $svg/*}
  </svg>
 
};


(:~
: set svg to autosize 100%
:)
declare function autosize($svg as node()) as node(){
  <svg xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink"
  width="100%" height="100%" preserveAspectRatio="xMidYMid meet">
  {$svg/@* except ($svg/@width,$svg/@height,$svg/@preserveAspectRatio),
  $svg/*}
  </svg>
};

(:~
: set svg to autosize 100%
:)
declare function autosize-old($svg as node()) as node(){
  xslt:transform($svg , fn:resolve-uri("dotml/dotpatch.xsl"))
};

