<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
xmlns="http://www.w3.org/2000/svg" 
xmlns:graphml2svg="http://www.sample.org/graphml2svg" 
>  
<!-- 
http://www.svgopen.org/2003/papers/ComparisonXML2SVGTransformationMechanisms
 -->
  <xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes"/>
  <!-- for a 'graph' element, creates an 'svg' element -->
  <xsl:template match="graph">
    <!-- first give a CSS reference for the generated SVG -->
   <xsl:processing-instruction name="xml-stylesheet">type="text/css" href="default.css"</xsl:processing-instruction> 
    <svg>
      <!-- defs section for the arrow -->
      <!-- ... -->
      <xsl:apply-templates select="graphml2svg:getroot()"/>
    </svg>
  </xsl:template>
  <!-- transform a 'node' to SVG -->
  <xsl:template match="node">
    <xsl:variable name="x1">0</xsl:variable>
    <xsl:variable name="y1">0</xsl:variable>
    <!-- some helpers -->
    <xsl:variable name="level" select="graphml2svg:getlevel()"/>
    <xsl:variable name="count" select="graphml2svg:getindex()"/>
    <xsl:variable name="edge" select="graphml2svg:getedge()"/>
    <xsl:variable name="side" select="1-2*($count mod 2)"/>
    <xsl:variable name="x" select="$level*150"/>
    <xsl:variable name="y" select="$y1 - 50+$side*ceiling($count div 2)*150"/>
    <!-- create the 'node' itself and position it -->
    <g class="node">
      <rect x="{$x}" y="{$y}" width="100" height="100"/>
      <text text-anchor="middle" x="{$x+50}" y="{$y+55}">
        <xsl:value-of select="./@id"/>
      </text>
    </g>
    <!-- if there is an 'edge' ($edge) to draw it -->
    <xsl:if test="$edge!='null'">
      <!-- the 'edge' position goes from previous 'node' position to $n one -->
      <line class="edge" x1="{$x1}" y1="{$y1}" x2="{$x}" y2="{$y+50}">
        <xsl:attribute name="style">marker-end:url(#arrow)</xsl:attribute>
      </line>
    </xsl:if>
    <!-- now that the 'node' is created, go to children -->
    <xsl:apply-templates select="graphml2svg:getchildren()">
      <xsl:with-param name="x1" select="$x+100"/>
      <xsl:with-param name="y1" select="$y+50"/>
    </xsl:apply-templates>
  </xsl:template>
  <xsl:function name="graphml2svg:getroot">
  </xsl:function>
   <xsl:function name="graphml2svg:getchildren">
  </xsl:function>
   <xsl:function name="graphml2svg:getlevel">
  </xsl:function>
   <xsl:function name="graphml2svg:getindex">
  </xsl:function>
    <xsl:function name="graphml2svg:getedge">
  </xsl:function>
</xsl:stylesheet>