<?xml version="1.0"?>
<!--
  Copyright 2002-2004 The Apache Software Foundation or its licensors,
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
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

  <xsl:param name="config-file"/>
  <xsl:variable name="config" select="document($config-file)/skinconfig"/>

  <xsl:template match="status">

    <xsl:variable name="changes-url"
      select="concat($config/project-url, 'changes.html')"/>

    <rss version="0.91">
      <channel>
        <title><xsl:value-of select="$config/project-name"/> Changes</title>

        <link><xsl:value-of select="$changes-url"/></link>

        <description><xsl:value-of select="$config/project-name"/> Changes</description>

        <language>en-us</language>

        <xsl:for-each select="changes/release[1]/action">
          <item>
            <title>
              <xsl:value-of select="@context" />
              <xsl:text> </xsl:text>
              <xsl:value-of select="@type" />

              <xsl:if test="@type='fix' and @fixes-bug">
                (bug <xsl:value-of select="@fixes-bug" />)
              </xsl:if>

            </title>

            <link><xsl:value-of select="$changes-url"/></link>

            <description>
              <xsl:value-of select="@context" />
              <xsl:text> </xsl:text>
              <xsl:value-of select="@type" />
              by 
              <xsl:value-of select="@dev" />
              <xsl:if test="@type='fix' and @fixes-bug">
                (fixes bug <xsl:value-of select="@fixes-bug" />)
              </xsl:if>
              :
              <xsl:value-of select="." />
              <xsl:if test="@due-to"> Thanks to <xsl:value-of select="@due-to" />.</xsl:if> 
            </description>
          </item>
        </xsl:for-each>
      </channel>
    </rss>
  </xsl:template>
</xsl:stylesheet>

