<?xml version="1.0" encoding="UTF-8"?>
<!--
Stylesheet takes care of page layout settings.
It must provide three named templates, all called from the root node.
- head-content provides content inside the head tag
- body-attributes provides attribute content for the body element
- body-content provides markup content for the body element
The third template, body-content may contain an <apply-templates/> to
process source document elements below the root; otherwise, the stylesheet
will process no such elements.
-->
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  <xsl:variable name="albumTitle">
    <xsl:choose>
      <xsl:when test="/album/@title">
        <xsl:value-of select="/album/@title"></xsl:value-of>
      </xsl:when>
      <xsl:when test="/image-preview/@albumTitle">
        <xsl:value-of select="/image-preview/@albumTitle"></xsl:value-of>
      </xsl:when>
      <xsl:otherwise></xsl:otherwise>
    </xsl:choose>
  </xsl:variable>
<xsl:template name="head-content">
  <link rel="stylesheet" type="text/css" href="/style/site.css"/>
</xsl:template>
    <title>
      <xsl:value-of select="$albumTitle"></xsl:value-of>
    </title>

<xsl:template name="body-content">
  <xsl:apply-templates/>
            <strong>
              <xsl:value-of select="$albumTitle"></xsl:value-of>
            </strong>
</xsl:template>

</xsl:stylesheet>
