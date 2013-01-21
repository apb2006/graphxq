(:~
: dotml module
: @see http://www.martin-loetzsch.de/DOTML/
:)

module namespace dotml="http://www.martin-loetzsch.de/DOTML";
declare default function namespace 'http://www.martin-loetzsch.de/DOTML';

import module namespace xslt="http://basex.org/modules/xslt";

(:~ 
: @return graphviz dot string
: note xslt:transform can not return output text so result is wrapped
:)
declare function generate($dotml)  as xs:string
{
 let $d:=xslt:transform($dotml, fn:resolve-uri( "dotml/dotml2dot.xsl"))
 return $d/fn:string() 
};

