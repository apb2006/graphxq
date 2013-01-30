declare namespace doc="http://www.xqdoc.org/1.0";
declare namespace dotml="http://www.martin-loetzsch.de/DOTML";

declare variable $ns-ignore:=("http://www.w3.org/2005/xpath-functions",
                              "http://www.w3.org/2010/xslt-xquery-serialization",
                              "http://www.w3.org/2001/XMLSchema",
                              "http://www.w3.org/2005/xpath-functions/math" );
declare function local:sid($s as xs:string){
  "A" || xs:hexBinary(hash:md5($s)) 
};
declare function local:fid($uri as xs:string  ,$name as xs:string,$arity as xs:string){
  let $a:=fn:trace(($uri || "*" || $name || "*" || $arity),"fid: ")
  return "A" || xs:hexBinary(hash:md5($uri || $name ||$arity))
};

declare function local:foo($dml){
  let $moduri:=$dml/doc:xqdoc/doc:module/doc:uri/fn:string()
  return 
  <dotml:graph  file-name="graphs/bgcolor" rankdir="LR" label="a test" >
  
{for $import in $dml//doc:import
 let $ns:=$import/doc:uri/fn:string()
 where some $call in $dml//doc:invoked satisfies $call/doc:uri=$import/doc:uri
       
 return <dotml:cluster id="{local:sid($ns)}" 
                       label="{$ns}"
                       bgcolor="#FF8080" >

         {for $call in $dml//doc:invoked[doc:uri=$import/doc:uri] 
          return <dotml:node 
                  id="{local:fid($call/doc:name/@uri,$call/doc:name/@localname,$call/@arity)}" 
                  label="{$call/doc:name/fn:string()}"
                  fillcolor="lightblue"  style="filled"/>
        }
        </dotml:cluster> 
}
<dotml:cluster id="main" rankdir="LR"
     label="main"
      bgcolor="seashell"
     >
{for $f in $dml//doc:function
 return <dotml:node id="{local:fid($moduri,$f/doc:name,$f/@arity)}" label="{$f/doc:name}" fillcolor="yellow"  style="filled"/>,
for $v in $dml//doc:variable
 return <dotml:node id="{generate-id($v)}" label="{$v/doc:name}"  fillcolor="green"  style="filled"/>
}
</dotml:cluster>

{for $call in $dml//doc:invoked
 let $f:=$call/..
 where not($call/doc:name/@uri/fn:string()=$ns-ignore)
 return <dotml:edge 
            from="{local:fid($moduri,$f/doc:name,$f/@arity)}" 
            to="{local:fid($call/doc:name/@uri,$call/doc:name/@localname,$call/@arity)}"/> }
</dotml:graph>
};

let $a:=local:foo(/)

(: 
let $req:=<http:request method="POST" >
<http:body  media-type="application/x-www-form-urlencoded">data={fn:encode-for-uri(fn:serialize($a))}</http:body>
</http:request>
let $ws:= http:send-request($req,"http://localhost:8984/restxq/graphxq/api/dotml")
return file:write("aa.svg",$ws[2])
:)
return $a 