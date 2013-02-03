(: generate thumbnail :)
import module namespace gr = 'apb.graphviz' at "graphviz.xqm" ;
import module namespace dotml = 'http://www.martin-loetzsch.de/DOTML' at "dotml.xqm";
declare variable $src:=resolve-uri("data/samples/");
declare variable $dest:=resolve-uri("data/thumbs/");
declare variable $opts:=("-Tgif","-Gsize=1.2,1.2",'-Gfill=auto');


declare function local:thumb($dot,$name){
 let $a:=gr:dot-executeb($dot,$opts)
 return  file:write-binary( $name,$a) 
};
 

for $f in file:list($src)
let $ext:=substring-after($f,".")
where $ext=('dot','gv','xml')
return let $g:= if($ext=('gv','dot')) 
                then file:read-text($src || $f)
                else dotml:generate(doc($src || $f))
       return local:thumb($g,$dest || $f ||".gif")
