declare variable $items external ;
declare variable $partial external ;

<div class="row-fluid">			
     <h2>Samples ({fn:count($items/item )})</h2>	
     <ul class=" thumbnails media-list list-inline">
     {$partial("item1.xq","item",$items/item)}
     </ul>
</div>