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

<xsl:stylesheet
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:tag="http://forrest.apache.org/TagExpansion/0.1"
    xmlns:resume="http://xmlresume.sourceforge.net/resume/0.0"
    version="1.0">
    
  <xsl:import href="resume2xdoc.xsl"/>
  
  <xsl:param name="candidateSkill"/>
  
  <xsl:template match="/">
    <xsl:apply-templates select="resumes"/>
  </xsl:template>
  
  <xsl:template match="resumes">
    <document>
      <header>
          <xsl:choose>
            <xsl:when test="$candidateSkill = ''">
              <title>All Resumes on File</title>
            </xsl:when>
            <xsl:otherwise>
              <title>All Candidates on File With '<xsl:value-of select="$candidateSkill"/>' Skill</title>
            </xsl:otherwise>
          </xsl:choose>
      </header>
      <body>
        <xsl:for-each select="file/resume:resume">
          <xsl:choose>
            <xsl:when test="$candidateSkill = ''">
              <xsl:apply-templates select="."/>
            </xsl:when>
            <xsl:when test="descendant::resume:skill[contains(., $candidateSkill)]">
              <xsl:apply-templates select="."/>
            </xsl:when>
          </xsl:choose>
        </xsl:for-each>
      </body>
    </document>
  </xsl:template>
  
  <xsl:template match="file">
    <xsl:apply-templates/>
  </xsl:template>
  
  <xsl:template match="resume:resume">
    <section>
        <xsl:apply-templates select="resume:header"/>
        <xsl:apply-templates select="resume:skillarea"/>
    </section>
  </xsl:template>
  
  <xsl:template match="resume:header">
      <title><xsl:apply-templates select="resume:name"/></title>
  </xsl:template>
  
  
</xsl:stylesheet>