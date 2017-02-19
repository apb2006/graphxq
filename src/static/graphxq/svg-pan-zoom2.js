// svg mini map in d3 version 4
// d3.graphxq.svgpan(d3.selection)
// d3.graphxq.setsvg(url)
// d3.graphxq.resetted()
// @license  MIT
// @Copyright 2017 Andy Bunce
var url="/static/graphxq/sample.svg";
var duration=750;

d3.graphxq = {};
 d3.graphxq.svgpan=function(selection){
  var showAxes=false; 
  var base=selection;
  var width=500;
  var height=500;
  var that=this;
  var svg = selection.append("svg")
    .attr("class", "svg canvas")
     .attr("width",  "100%")
      .attr("height", "100%")
      .attr("viewBox", "0 0 "+width + " "+height) 
  .attr("shape-rendering", "auto");
  var svgDefs = svg.append("defs");

  svgDefs.append("clipPath")
      .attr("id", "wrapperClipPath_qwpyza")
      .attr("class", "wrapper clipPath")
      .append("rect")
      .attr("class", "background")
      .attr("width", width)
      .attr("height", height);

  svgDefs.append("clipPath")
      .attr("id", "minimapClipPath_qwpyza")
      .attr("class", "minimap clipPath")
      .attr("width", width)
      .attr("height", height)
      //.attr("transform", "translate(" + (width + minimapPadding) + "," + (minimapPadding/2) + ")")
      .append("rect")
      .attr("class", "background")
      .attr("width", width)
      .attr("height", height);

  var filter = svgDefs.append("svg:filter")
      .attr("id", "minimapDropShadow_qwpyza")
      .attr("x", "-20%")
      .attr("y", "-20%")
      .attr("width", "150%")
      .attr("height", "150%");

  filter.append("svg:feOffset")
      .attr("result", "offOut")
      .attr("in", "SourceGraphic")
      .attr("dx", "1")
      .attr("dy", "1");

  filter.append("svg:feColorMatrix")
      .attr("result", "matrixOut")
      .attr("in", "offOut")
      .attr("type", "matrix")
      .attr("values", "0.1 0 0 0 0 0 0.1 0 0 0 0 0 0.1 0 0 0 0 0 0.5 0");

  filter.append("svg:feGaussianBlur")
      .attr("result", "blurOut")
      .attr("in", "matrixOut")
      .attr("stdDeviation", "10");

  filter.append("svg:feBlend")
      .attr("in", "SourceGraphic")
      .attr("in2", "blurOut")
      .attr("mode", "normal");
  
  var zoom = d3.zoom()
      .scaleExtent([ .5, 60 ])
      .translateExtent([ [ -100, -100 ], [ width + 90, height + 100 ] ]);
  
  var view = svg.append("g");
// X -----------------
  var xScale = d3.scaleLinear()
      .domain([ -1, width + 1 ])
      .range([ -1, width + 1 ]);
  
  var xAxis = d3.axisBottom(xScale)
  .ticks((width + 2) / (height + 2) * 10)
  .tickSize(height)
  .tickPadding(8 - height);
  
  var gX = svg.append("g")
  .attr("class", "axis axis--x")
  .attr("opacity",showAxes?1:0)
  .call(xAxis);
// Y -------------------- 
  var yScale = d3.scaleLinear()
      .domain([ -1, height + 1 ])
      .range([ -1, height + 1 ]);

  var yAxis = d3.axisRight(yScale)
  .ticks(10)
  .tickSize(width)
  .tickPadding(8 - width);

  var gY = svg.append("g")
          .attr("class", "axis axis--y")
           .attr("opacity",showAxes?1:0)
           .call(yAxis);
  
 
/*
  var back = view.append("rect")
  .attr("class", "view")
  .attr("x", 0.5)
  .attr("y",  0.5)
  .attr("width", width - 1)
  .attr("height", height - 1)
  .attr("class", "background");
  */
  var target = view.append("g");
  var zoomed=function () {
    //console.log("zoomed: ",d3.event.transform);
    view.attr("transform", d3.event.transform); 
    gX.call(xAxis.scale(d3.event.transform.rescaleX(xScale)));
    gY.call(yAxis.scale(d3.event.transform.rescaleY(yScale)));
  };
  zoom.on("zoom", zoomed);
  
  this.resetted=function () {
    svg.transition()
        .duration(duration)
        .call(zoom.transform, d3.zoomIdentity);
  };
  d3.select("button.reset").on("click", this.resetted);
  
  var loaded=function (){
    d3.xml(url,setsvg); 
  };
  this.setsvg=function(xml){
    var tn=target.node();
    while (tn.hasChildNodes()) {
      tn.removeChild(tn.lastChild);
     };
    target.node().appendChild(xml);
  };

  this.toggleAxes=function(){   
    showAxes=!showAxes;
    gX.transition().duration(duration).attr("opacity",showAxes?1:0);
    gY.transition().duration(duration).attr("opacity",showAxes?1:0);
    //alert("Show: "+showAxes);
    //zoomed();
  };
  d3.select("button.load").on("click", loaded);
  svg.call(zoom);
  return this;
 };



