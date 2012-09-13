xquery version "3.0";
(:~ 
:  dot UI lists
: @author andy bunce
: @since sept 2012
:)

module namespace dotui = 'apb.graphxq.dotui';
declare default function namespace 'apb.graphxq.dotui';
declare variable $dotui:config:=fn:doc("dotui.xml")/graphviz; 

declare function list($items,$select as xs:string){
  for $i in $items
  let $name:=$i/fn:string()
  order by $name
  return <option>
      {if($name=$select)
       then attribute {"selected"} {"selected"}
       else (),
       $name}
      </option>
};

declare function shapes($select as xs:string){
  list($dotui:config/shapes/option,$select)
};
declare function colors($select as xs:string){
  list($dotui:config/colors/option,$select)
};