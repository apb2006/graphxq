(:~ 
:  A(nother) templating Engine for XQuery  (BaseX 7.5 specific)
:  
: @author andy bunce
: @since sept 2012
:)

module namespace txq = 'apb.txq';
declare default function namespace 'apb.txq'; 
import module namespace xquery = "http://basex.org/modules/xquery";

(:~
: template function
: @param template url to fill
: @param map name and value to apply
: @return updated doc from map
:)
declare function render($template as xs:string,$map as map(*)){    
   let $map:=map:new(($map,map{"partial":=partial(?,?,?,$map,$template)}))
   return xquery:invoke($template,$map)  
};

(:~
: template function with wrapping layout
: @param layout
: @return updated doc from map
:)
declare function render($template as xs:string,$map as map(*),$layout as xs:string){
    let $content:=render($template,$map)
    let $map:=map:new(($map,map{"body":=$content}))
    return render($layout,$map)  
};



(:~
: partial template function: evaluate part for each value in sequence
: @return updated doc from map
:)
declare function partial($part as xs:string,$name,$seq,$map,$base){
  for $s in $seq
  let $map:=map:new(($map,map{$name:=$s}))
  return render($map,fn:resolve-uri($part,$base))  
};

