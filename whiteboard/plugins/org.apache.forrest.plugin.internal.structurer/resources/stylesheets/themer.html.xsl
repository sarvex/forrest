<?xml version="1.0"?>
<!--
  Copyright 2002-2005 The Apache Software Foundation or its licensors,
  as applicable.

  Licensed under the Apache License, Version 2.0 (the "License");
  you may not use this file except in compliance with the License.
  You may obtain a copy of the License at

      http://www.apache.org/licenses/LICENSE-2.0

  Unless required by applicable law or agreed to in writing, software
  distributed under the License is distributed on an "AS IS" BASIS,
  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
  See the License for the specific language governing permissions and
  limitations under the License.
-->

<xsl:stylesheet version="1.0" xmlns:alias="http://www.w3.org/1999/XSL/TransformAlias" xmlns:forrest="http://apache.org/forrest/templates/1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
    <xsl:namespace-alias result-prefix="xsl" stylesheet-prefix="alias"/>
    <!--Include forrest:hook matchers-->
    <xsl:include href="hooksMatcher.xsl"/>
    <xsl:param name="request"/>
    <xsl:param name="forrestContext" select="'test'"/>
    <xsl:key name="head-template" match="forrest:property[@format='xhtml']" use="@name" />
    <xsl:key name="css-includes" match="forrest:css" use="@url" />
    <xsl:key name="contract-name" match="forrest:contract" use="@name" />
    <xsl:template match="/">
      <!--Create the final stylesheet (alias:) resources/stylesheets/structurer-tiles-root-strip.xsl -->
        <alias:stylesheet version="1.0">
            <alias:import href="file:{$forrestContext}/skins/common/xslt/html/dotdots.xsl"/>
            <alias:import href="file:{$forrestContext}/skins/common/xslt/html/pathutils.xsl"/>
            <alias:import href="file:{$forrestContext}/skins/common/xslt/html/renderlogo.xsl"/>
            <!--NOTE:
              contracts are allowed only to be importet once! Thx to
              http://www.jenitennison.com/xslt/grouping/muenchian.html-->
            <xsl:for-each 
              select="/*/forrest:view[@type='html']//forrest:contract[count(. | key('contract-name', @name)[1]) = 1]">
              <xsl:sort select="@name" />
              <alias:include>
                <xsl:attribute name="href">
                  <xsl:value-of 
                    select="concat('cocoon://prepare.contract.html.', @name)"/>
                </xsl:attribute>
              </alias:include>  
            </xsl:for-each>
            <alias:param name="path"/>
<!-- FIXME: extract the following part to a stylesheet on its own START -->
              <!-- Path (..'s) to the root directory -->
            <alias:variable name="root">
              <alias:call-template name="dotdots">
                <alias:with-param name="path" select="$path"/>
              </alias:call-template>
            </alias:variable>
            <alias:variable name="filename-noext">
              <alias:call-template name="filename-noext">
                <alias:with-param name="path" select="$path"/>
              </alias:call-template>
            </alias:variable>
            <!-- Source filename (eg 'foo.xml') of current page -->
            <alias:variable name="filename">
              <alias:call-template name="filename">
                <alias:with-param name="path" select="$path"/>
              </alias:call-template>
            </alias:variable>
            <alias:variable name="skin-img-dir" select="concat(string($root), 'themes/images')"/>
            <alias:variable name="spacer" select="concat($root, 'themer/images/spacer.gif')"/>
<!-- FIXME: extract the following part to a stylesheet on its own END -->
            <xsl:comment>All xhtml head elements requested by the forrest:template</xsl:comment>
            <alias:template name="getHead">
                <xsl:for-each 
                  select="/*/forrest:properties/*[@head='true' and count(. | key('head-template', @name)[1]) = 1]">
                  <xsl:variable name="name" select="@name"/>
                  <xsl:apply-templates mode="head"
                    select="//forrest:contract[@name=$name]"/>
                </xsl:for-each>
            </alias:template>
            <xsl:comment>All xhtml body elements requested by the forrest:template</xsl:comment>
            <alias:template name="getBody">
                <xsl:apply-templates select="/*/forrest:view"/>
            </alias:template>
          <!--default entry point into the presentation model 'site'-->
            <alias:template match="/">
                <html>
                    <head>
                      <!--Test whether there is an own css implemention requested by the view-->
                      <!--*No* forrest:css found in the view-->
                        <xsl:if test="not(/*/forrest:view/forrest:css)">
                            <link rel="stylesheet" type="text/css">
                                <xsl:attribute name="href">{$root}themes/default.css</xsl:attribute>
                            </link>
                        </xsl:if>
                      <!-- forrest:css *found* in the view-->
                        <xsl:if test="/*/forrest:view/forrest:css">
                            <xsl:apply-templates select="/*/forrest:view/forrest:css"/>
                        </xsl:if>
                        <alias:call-template name="getHead"/>
                    </head>
                    <body>
                        <alias:call-template name="getBody"/>
                    </body>
                </html>
            </alias:template>
        </alias:stylesheet>
    </xsl:template>
    <xsl:template match="forrest:view">
        <xsl:apply-templates select="*[local-name()!='css']"/>
    </xsl:template>
    <xsl:template match="forrest:css[@url and count(. | key('css-includes', @url)[1]) = 1]">
      <xsl:copy-of select="@rel"/>
        <link type="text/css">
            <xsl:choose>
              <xsl:when test="@rel">
                <xsl:attribute name="rel"><xsl:value-of select="@rel"/></xsl:attribute>
              </xsl:when>
              <xsl:otherwise>
                <xsl:attribute name="rel">stylesheet</xsl:attribute>
              </xsl:otherwise>
            </xsl:choose>
            <xsl:choose>
              <xsl:when test="@theme">
                <xsl:attribute name="title"><xsl:value-of select="@theme"/></xsl:attribute>
              </xsl:when>
              <xsl:otherwise>
                <xsl:attribute name="title"><xsl:value-of select="@url"/></xsl:attribute>
              </xsl:otherwise>
            </xsl:choose>
            <xsl:attribute name="href">{$root}themes/<xsl:value-of select="@url"/>
            </xsl:attribute>
            <xsl:if test="@media">
              <xsl:attribute name="media"><xsl:value-of select="@media"/></xsl:attribute>
            </xsl:if>
        </link>
    </xsl:template>
    <xsl:template match="forrest:css[not(@url)]">
        <style type="text/css">
          <xsl:value-of select="."/>
        </style>
    </xsl:template>
    <xsl:template match="forrest:contract" mode="head">
      <xsl:variable name="name" select="@name"/>
      <xsl:if test="/*/forrest:properties/*[@head='true' and @name=$name]">
            <!--If next son is not forrest:properties go on-->
            <xsl:choose>
                <xsl:when test="not(forrest:properties[@contract=$name])">
                    <alias:call-template name="{@name}-head"/>
                </xsl:when>
                <xsl:when test="forrest:properties[@contract=$name]">
                    <alias:call-template name="{@name}-head"  xmlns:forrest="http://apache.org/forrest/templates/1.0">
                        <xsl:for-each select="forrest:properties[@contract=$name]/forrest:property">
                          <xsl:variable name="xpath">
                            <xsl:call-template name="generateXPath"/>
                          </xsl:variable>
                          <alias:with-param name="{@name}" select="{normalize-space($xpath)}"/>
                        </xsl:for-each>
                    </alias:call-template>
                </xsl:when>
            </xsl:choose>
        </xsl:if>
    </xsl:template>
    
    <xsl:template match="forrest:contract">
        <xsl:variable name="name" select="@name"/>
        <!--Test whether there is a body template needed-->
        <xsl:if test="/*/forrest:properties/*[@body='true' and @name=$name]">
            <!--If next son is not forrest:properties go on-->
            <xsl:choose>
                <xsl:when test="not(forrest:properties[@contract=$name])">
                    <xsl:apply-templates/>
                    <alias:call-template name="{@name}-body"/>
                </xsl:when>
                <xsl:when test="forrest:properties[@contract=$name]">
                    <alias:call-template name="{@name}-body">
                        <xsl:for-each select="forrest:properties[@contract=$name]/forrest:property">
                          <xsl:variable name="xpath">
                            <xsl:call-template name="generateXPath"/>
                          </xsl:variable>
                          <alias:with-param name="{@name}" select="{normalize-space($xpath)}" />
                        </xsl:for-each>
                    </alias:call-template>
                </xsl:when>
            </xsl:choose>
        </xsl:if>
    </xsl:template>
    <xsl:template name="generateXPath">
      <xsl:for-each select="ancestor::*[name()!='filter']">
        /<xsl:value-of select="name()"/>[<xsl:number/>]
      </xsl:for-each>
      /<xsl:value-of select="name()"/>[<xsl:number/>]
    </xsl:template> 
</xsl:stylesheet>
