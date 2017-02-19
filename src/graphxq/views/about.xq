declare variable $version external ;
<div class="row-fluid">		
<div class="hero-unit">
    <h1>GraphXQ <span class="label label-default">{$version}</span></h1>
	<p>A web interface for <a href="http://www.graphviz.org/" target="_blank">Graphviz</a>.
        Graph descriptions can be entered in the 
        <a href="http://www.graphviz.org/content/dot-language" target="_blank">Dot</a> 
        or  <a href="http://www.martin-loetzsch.de/DOTML" target="_blank">DotML</a> languages and the corresponding
        SVG viewed or downloaded. 
        A <a href="api">REST interface</a> enables the SVG generation to be used as a service.</p>
    </div>
    <div class="container-fluid">
 <div class="fluid-row">
        <div class="span4">
          <h2>Client</h2>
 <p>The client side targets modern browsers with SVG support. It was tested against Firefox 51 and Chrome 56.
    </p>
    
    <p><a href="http://twitter.github.com/bootstrap/index.html"
            target="_blank">Twitter Bootstrap</a> is used for the client side styling. 
            The <a href="http://ace.ajax.org/">Ace editor</a> is used to provide rich editing functionality.
    </p>
    <p>Javascript libraries are loaded from CDN where possible. In particular
    <a href="http://cdnjs.com"  target="_blank">cdnjs.com</a> is used.</p>
    <p>The resultant SVG is viewed in an interface that provides pan and zoom functionality built on top of 
    <a href="http://d3js.org" target="_blank">D3</a>. 
        The SVG may also be viewed standalone or downloaded.</p>
       </div>
               <div class="span4">
          <h2>Server</h2>
  <p>The server side is written in XQuery. It uses the 
        <a href="http://basex.org" target="_blank">BaseX</a> implementation. <a
            href="http://docs.basex.org/wiki/RESTXQ" target="_blank">RestXQ</a>
        is used to map XQuery annotations to web server behavior.
    </p>
     <p> The graphviz <code>dot</code> executable is used to generate SVG from the DOT source.
      </p>
    <p>This application includes an XSLT transform to convert <code>DotML</code> to 
    <code>dot</code> developed by Martin Loetzsch.
     <a href="http://www.martin-loetzsch.de/DOTML" target="_blank">DotML</a>
     is a XML based syntax for the input language of the 'Dot'.</p>
        </div>
        
      </div>
      </div>
      <hr/>
<a href="https://github.com/apb2006/graphxq">
   <img style="position: absolute; top: 50px; right: 0; border: 0;" src="https://s3.amazonaws.com/github/ribbons/forkme_right_orange_ff7600.png" alt="Fork me on GitHub"/>
   </a>
      <footer>
        <p>&#169; Andy Bunce 2013 -2017</p>
        <ul class="quick-links">

     </ul>
      </footer>
	
</div>