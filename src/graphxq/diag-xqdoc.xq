declare namespace doc="http://www.xqdoc.org/1.0";
declare namespace dotml="http://www.martin-loetzsch.de/DOTML";
declare function local:foo($dml){
<dotml:graph  file-name="graphs/bgcolor" rankdir="LR" bgcolor="seashell">
<dotml:cluster>
{for $f in $dml//doc:function
 return <dotml:node id="{generate-id($f)}" label="{$f/doc:name}" fillcolor="lightblue"  style="filled"/>,
for $v in $dml//doc:variable
 return <dotml:node id="{generate-id($v)}" label="{$v/doc:name}"  fillcolor="green"  style="filled"/>
}
</dotml:cluster>
</dotml:graph>
};
let $a:=local:foo(/)
let $req:=<http:request method="POST" >
<http:body  media-type="application/x-www-form-urlencoded">dotml={fn:encode-for-uri(fn:serialize($a))}</http:body>
</http:request>
let $ws:= http:send-request($req,"http://localhost:8984/restxq/graphxq/api/dotml")
return file:write("aa.svg",$ws[2])