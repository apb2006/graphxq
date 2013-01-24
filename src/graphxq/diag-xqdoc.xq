declare namespace doc="http://www.xqdoc.org/1.0";
declare namespace dotml="http://www.martin-loetzsch.de/DOTML";

<dotml:graph  file-name="graphs/bgcolor" rankdir="LR" bgcolor="#80FF80">
<dotml:cluster>
{for $f in //doc:function
 return <dotml:node id="{generate-id($f)}" label="{$f/doc:name}" fillcolor="red"  style="filled"/>,
for $v in //doc:variable
 return <dotml:node id="{generate-id($v)}" label="{$v/doc:name}"  fillcolor="green"  style="filled"/>
}
</dotml:cluster>
</dotml:graph>