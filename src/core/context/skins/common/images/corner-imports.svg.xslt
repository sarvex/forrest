<?xml version="1.0"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

    <xsl:param name="orientation-tb"/>
    <xsl:param name="orientation-lr"/>
    <xsl:param name="size"/>
    <xsl:param name="bg-color-name"/>
    <xsl:param name="stroke-color-name"/>
    <xsl:param name="fg-color-name"/>    

   <!-- if not all colors are present, don't even try to render the corners -->
    <xsl:variable name="size"><xsl:choose>
    	<xsl:when test="$bg-color-name and $stroke-color-name and $fg-color-name"><xsl:value-of select="$size"/></xsl:when>
    	<xsl:otherwise>0</xsl:otherwise>
    </xsl:choose></xsl:variable>
    <xsl:variable name="smallersize" select="number($size)-1"/>
    <xsl:variable name="biggersize" select="number($size)+1"/>     
    <xsl:variable name="bg"><xsl:if test="skinconfig/colors/color[@name=$bg-color-name]">fill:<xsl:value-of select="skinconfig/colors/color[@name=$bg-color-name]/@value"/>;</xsl:if></xsl:variable>
    <xsl:variable name="fill"><xsl:if test="skinconfig/colors/color[@name=$stroke-color-name]">fill:<xsl:value-of select="skinconfig/colors/color[@name=$stroke-color-name]/@value"/>;</xsl:if></xsl:variable>
    <xsl:variable name="stroke"><xsl:if test="skinconfig/colors/color[@name=$fg-color-name]">stroke:<xsl:value-of select="skinconfig/colors/color[@name=$fg-color-name]/@value"/>;</xsl:if></xsl:variable>
        
	<xsl:template match="skinconfig">

        	

<svg width="{$size}" height="{$size}">
    <!-- background-->
    <rect x="-1" y="-1" width="{$biggersize}" height="{$biggersize}" style="{$bg}stroke-width:0"/>
<!-- 0,0 0,-4 4,0 4,-4-->

    <xsl:variable name="flip-tb-scale">
      <xsl:choose>
    	<xsl:when test="$orientation-tb='t'">1</xsl:when>
    	<xsl:otherwise>-1</xsl:otherwise>
      </xsl:choose>
    </xsl:variable>

    <xsl:variable name="flip-lr-scale">
      <xsl:choose>
    	<xsl:when test="$orientation-lr='l'">1</xsl:when>
    	<xsl:otherwise>-1</xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    
    <xsl:variable name="flip-tb-translate">
      <xsl:choose>
    	<xsl:when test="$orientation-tb='t'">0</xsl:when>
    	<xsl:otherwise>-<xsl:value-of select="$size" /></xsl:otherwise>
      </xsl:choose>
    </xsl:variable>

    <xsl:variable name="flip-lr-translate">
      <xsl:choose>
    	<xsl:when test="$orientation-lr='l'">0</xsl:when>
    	<xsl:otherwise>-<xsl:value-of select="$size" /></xsl:otherwise>
      </xsl:choose>
    </xsl:variable>    
    
    <!-- flip transform -->
    <g transform="scale({$flip-lr-scale},{$flip-tb-scale}) translate({$flip-lr-translate}, {$flip-tb-translate})"> 
      <xsl:call-template name = "figure" >
     	<xsl:with-param name="size"><xsl:value-of select="$size" /></xsl:with-param>
     	<xsl:with-param name="smallersize"><xsl:value-of select="$smallersize" /></xsl:with-param>
     	<xsl:with-param name="biggersize"><xsl:value-of select="$biggersize" /></xsl:with-param>
     	<xsl:with-param name="bg"><xsl:value-of select="$bg" /></xsl:with-param>
     	<xsl:with-param name="fill"><xsl:value-of select="$fill" /></xsl:with-param>
     	<xsl:with-param name="stroke"><xsl:value-of select="$stroke" /></xsl:with-param>
      </xsl:call-template>   
    </g>
</svg>
</xsl:template>

        
  <xsl:template name="figure">
       <!-- Just change shape here -->     
		<g transform="translate(0.5 0.5)">
			<ellipse cx="{$smallersize}" cy="{$smallersize}" rx="{$smallersize}" ry="{$smallersize}"
				 style="{$fill}{$stroke}stroke-width:1"/>
		</g>
	   <!-- end -->	
  </xsl:template>
    
  
  <xsl:template match="*"></xsl:template>
  <xsl:template match="text()"></xsl:template>
  
</xsl:stylesheet>
