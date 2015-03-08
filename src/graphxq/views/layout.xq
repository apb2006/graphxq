declare  variable $body external :="{body}";
declare  variable $title external :="{title}";
declare  variable $bodyclass external :="{$bodyclass}";
declare  variable $active-link external :=function($_){$_};

<html >
	<head id="head">
		<meta charset="utf-8" />
		<title id="title">{$title}</title>
		<meta http-equiv="X-UA-Compatible" content="IE=Edge,chrome=1" />
		<meta name="viewport" content="width=device-width, initial-scale=1.0" />
		<meta name="description" content="graphviz tool" />
		<meta name="author" content="andy bunce" />
		<link href="//cdnjs.cloudflare.com/ajax/libs/twitter-bootstrap/2.2.2/css/bootstrap.css" rel="stylesheet"
			type="text/css" />


		<link href="//cdnjs.cloudflare.com/ajax/libs/twitter-bootstrap/2.2.2/css/bootstrap-responsive.min.css"
			rel="stylesheet" type="text/css" />
		
		<!-- Le fav and touch icons -->
		<link rel="shortcut icon" href="/static/graphxq/graphxq2.png" />

		<script src="//cdnjs.cloudflare.com/ajax/libs/jquery/1.8.1/jquery.min.js" type="text/javascript"></script>
		<script src="//cdnjs.cloudflare.com/ajax/libs/twitter-bootstrap/2.2.2/bootstrap.min.js" type="text/javascript"></script>
        <script src="https://cdnjs.cloudflare.com/ajax/libs/ace/1.1.8/ace.js" type="text/javascript" charset="utf-8"></script>
        <link href="/static/graphxq/app.css" rel="stylesheet" type="text/css" />
        <script src="/static/graphxq/app.js" type="text/javascript"></script>
    <script type="text/javascript"><![CDATA[
          var _gaq = _gaq || [];
          _gaq.push(['_setAccount', 'UA-34544921-1']);
          _gaq.push(['_setDomainName', 'rhcloud.com']);
          _gaq.push(['_trackPageview']);

          (function() {
            var ga = document.createElement('script'); ga.type = 'text/javascript'; ga.async = true;
            ga.src = ('https:' == document.location.protocol ? 'https://ssl' : 'http://www') + '.google-analytics.com/ga.js';
            var s = document.getElementsByTagName('script')[0]; s.parentNode.insertBefore(ga, s);
          })();
        ]]></script>
	</head>
	<body class="{$bodyclass}">
		<div class="navbar navbar-fixed-top navbar-inverse" data-dropdown="dropdown">
			<div class="navbar-inner">
				<div class="container">
					<a class="btn btn-navbar" data-toggle="collapse" data-target=".nav-collapse">
						<span class="icon-bar"></span>
						<span class="icon-bar"></span>
						<span class="icon-bar"></span>
					</a>
					<a href="about" class="brand" title="Version 0.5.0">
						<img src="/static/graphxq/graphxq2.png" />
						graphXQ
					</a>
					
					 <div class="nav-collapse collapse">
            <ul class="nav">               
                <li class="{$active-link('dot')}">
                    <a href="dot" rel="tooltip" title="Define a graph in Dot notation" ><i class="icon-edit"></i> Dot</a>
                </li>

                <li class="{$active-link('dotml')}">
                    <a href="dotml"><i class="icon-align-center"
                    title="Define a graph using DotML XML"
                    ></i> DotML</a>
                </li>

               <li class="{$active-link('library')}">
                <a href="library"
                title="Examples"
                ><i class="icon-book"></i> Library</a>
              </li> 

              <li class="{$active-link('api')}">
                  <a href="api"  title="About the API"
                  ><i class="icon-wrench"></i> API</a>
              </li>
      
            <li class="{$active-link('ace')}">
                  <a href="ace"  title="Xquery editor (just for fun)"
                  ><i class="icon-wrench"></i> Ace</a>
              </li>                  
            </ul>         
            
          </div>
        
        
				</div>
			</div>
		</div>
       <!-- Modal http://jsfiddle.net/matt_hwy1/hRq82/1/ -->
<div id="myModal" class="modal hide fade" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
  <div class="modal-header">
    <button type="button" class="close" data-dismiss="modal" aria-hidden="true">×</button>
    <h3 id="myModalLabel">Modal Test Header</h3>
  </div>
  <div class="modal-body">
    <p>One fine body…</p>
  </div>
  <div class="modal-footer">
    <button class="btn" data-dismiss="modal" aria-hidden="true">Close</button>
    <button class="btn btn-primary">Save changes</button>
  </div>
</div>
		<div class="container-fluid">
				{$body}
		</div>

	</body>
</html>