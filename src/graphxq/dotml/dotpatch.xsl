<?xml version="1.0"?>
<!--
  tidy up graphviz svg o/p  
-->
<xsl:stylesheet version="1.0" xmlns="http://www.w3.org/2000/svg" 
xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
xmlns:svg="http://www.w3.org/2000/svg" 
xmlns:xlink="http://www.w3.org/1999/xlink" >
	<xsl:param name="filter">MyFilter</xsl:param>
	<xsl:param name="rotate" select="false()"/>
	<xsl:output method="xml" encoding="UTF-8" indent="yes" omit-xml-declaration="yes"/>
	<xsl:template match="/svg:svg">
		<xsl:variable name="w" select="substring-before(@width,'pt')"/>
		<xsl:variable name="aa" select="string(@width)"/>
		<xsl:variable name="h" select="substring-before(@height,'pt')"/>
		<xsl:variable name="filters">
			<defs xmlns="http://www.w3.org/2000/svg">
				<filter id="Drop_Shadow" filterUnits="objectBoundingBox" x="-10%" y="-10%" width="150%" height="150%">
					<feGaussianBlur in="SourceAlpha" stdDeviation="3" result="blurredAlpha"/>
					<feOffset in="blurredAlpha" dx="3" dy="3" result="offsetBlurredAlpha"/>
					<feFlood result="flooded" style="flood-color:rgb(0,0,0);flood-opacity:0.65"/>
					<feComposite in="flooded" operator="in" in2="offsetBlurredAlpha" result="coloredShadow"/>
					<feComposite in="SourceGraphic" in2="coloredShadow" operator="over"/>
				</filter>
				<filter id="Bevel" filterUnits="objectBoundingBox" x="-10%" y="-10%" width="150%" height="150%">
					<feGaussianBlur in="SourceAlpha" stdDeviation="3" result="blur"/>
					<feSpecularLighting in="blur" surfaceScale="5" specularConstant="0.5" specularExponent="10" result="specOut" style="lighting-color:rgb(255,255,64)">
						<fePointLight x="-5000" y="-10000" z="20000"/>
					</feSpecularLighting>
					<feComposite in="specOut" in2="SourceAlpha" operator="in" result="specOut2"/>
					<feComposite in="SourceGraphic" in2="specOut2" operator="arithmetic" k1="0" k2="1" k3="1" k4="0" result="litPaint"/>
				</filter>
				<filter id="grey_bevel_shadow" filterUnits="objectBoundingBox" x="-10%" y="-10%" width="150%" height="150%">
					<feGaussianBlur result="blurredAlpha" in="SourceAlpha" stdDeviation="3"/>
					<feOffset result="offsetBlurredAlpha" in="blurredAlpha" dx="2" dy="1"/>
					<feDiffuseLighting result="bumpMapDiffuse" in="blurredAlpha" surfaceScale="5" diffuseConstant="0.5" style="lighting-color:rgb(255,255,255)">
						<feDistantLight azimuth="135" elevation="60"/>
					</feDiffuseLighting>
					<feComposite result="litPaint" in="bumpMapDiffuse" operator="arithmetic" k1="1" k2="0" k3="0" k4="0" in2="SourceGraphic"/>
					<feSpecularLighting result="bumpMapSpecular" in="blurredAlpha" surfaceScale="5" specularConstant="0.5" specularExponent="10" style="lighting-color:rgb(255,255,255)">
						<feDistantLight azimuth="135" elevation="60"/>
					</feSpecularLighting>
					<feComposite result="litPaint" in="litPaint" operator="arithmetic" k1="0" k2="1" k3="1" k4="0" in2="bumpMapSpecular"/>
					<feComposite result="litPaint" in="litPaint" operator="in" in2="SourceAlpha"/>
					<feMerge>
						<feMergeNode in="offsetBlurredAlpha"/>
						<feMergeNode in="litPaint"/>
					</feMerge>
				</filter>
				<filter id="Bumpy" filterUnits="objectBoundingBox" x="-10%" y="-10%" width="150%" height="150%">
					<feTurbulence type="turbulence" baseFrequency="0.15" numOctaves="1" result="image0"/>
					<feGaussianBlur stdDeviation="3" in="image0" result="image1"/>
					<feDiffuseLighting in="image1" surfaceScale="10" diffuseConstant="1" result="image3" style="lighting-color:rgb(255,255,255)">
						<feDistantLight azimuth="0" elevation="45"/>
					</feDiffuseLighting>
					<feComposite in="image3" in2="SourceGraphic" operator="arithmetic" k2="0.5" k3="0.5" result="image4"/>
					<feComposite in="image4" in2="SourceGraphic" operator="in" result="image5"/>
				</filter>
				<filter id="MyFilter" filterUnits="objectBoundingBox" x="-10%" y="-10%" width="150%" height="150%">
					<desc>Produces a 3D lighting effect suitable for pies and lines</desc>
					<feGaussianBlur in="SourceAlpha" stdDeviation="4" result="blur"/>
					<feOffset in="blur" dx="3" dy="5" result="offsetBlur"/>
					<feSpecularLighting in="blur" surfaceScale="5" specularConstant="1" specularExponent="30" style="lighting-color:White" result="specOut">
						<fePointLight x="-5000" y="-10000" z="20000"/>
					</feSpecularLighting>
					<feComposite in="specOut" in2="SourceAlpha" operator="in" result="specOut"/>
					<feComposite in="SourceGraphic" in2="specOut" operator="arithmetic" k1="0" k2="1" k3="1" k4="0" result="litPaint"/>
					<feMerge>
						<feMergeNode in="offsetBlur"/>
						<feMergeNode in="litPaint"/>
					</feMerge>
				</filter>
				<filter id="MyShadow" filterUnits="objectBoundingBox" x="-20%" y="-20%" width="180%" height="180%">
					<desc>Simple blurred shadow (ideal for headings)</desc>
					<feGaussianBlur in="SourceAlpha" stdDeviation="6" result="blur"/>
					<feOffset in="blur" dx="12" dy="10" result="offsetBlur"/>
					<feMerge>
						<feMergeNode in="offsetBlur"/>
						<feMergeNode in="SourceGraphic"/>
					</feMerge>
				</filter>
			</defs>
		</xsl:variable>
		<svg xmlns="http://www.w3.org/2000/svg" width="100%" height="100%" aa="{$aa}"
		preserveAspectRatio="xMidYMid meet" viewBox="0 0 {$w} {$h}" text-rendering="optimizeLegibility">
			 
			<xsl:copy-of select="$filters"/>
			 
			<xsl:choose>
				<xsl:when test="rotate">
					<g transform="rotate(90 {$w div 2} {$h div 2} )">
						<xsl:call-template name="copy-content"/>
					</g>
				</xsl:when>
				<xsl:otherwise>
				 <xsl:apply-templates select="*"/>					
				</xsl:otherwise>
			</xsl:choose>
		</svg>
	</xsl:template>
	<xsl:template name="copy-content">
		<xsl:apply-templates select="@*|processing-instruction()|*|text()"/>
	</xsl:template>
	<!--default behaviours for all nodes-->
	<xsl:template match="processing-instruction()|*|@*|text()">
		<xsl:copy>
			<xsl:call-template name="copy-content"/>
		</xsl:copy>
	</xsl:template>
	<!-- apply non text in nodes -->
	<xsl:template match="svg:g[@class='node']">
		<g>
			<g filter="url(#{$filter})">
				<xsl:apply-templates select="*[local-name()!='text']"/>
			</g>
			<g>
				<xsl:apply-templates select="svg:text"/>
			</g>
		</g>
	</xsl:template>
</xsl:stylesheet>
