<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  <!-- <xsl:template match="album[position()=1]" mode="head">
    <link rel="stylesheet" type="text/css" href="/style/album.css" />
  </xsl:template>
  <xsl:template match="image-preview[position()=1]" mode="head">
    <link rel="stylesheet" type="text/css" href="/style/album.css" />
  </xsl:template> -->
  <xsl:template match="image-preview">
    <div class="row">
      <div class="col-md-3">
        <xsl:apply-templates select="previous" />
        <xsl:apply-templates select="next" />
      </div>
      <div class="col-md-9">
        <xsl:apply-templates select="image" />
      </div>
    </div>
    <div class="row">
      <div class="col-md-9 offset-md-3 controls">
        <a>
          <xsl:attribute name="href">
            <xsl:value-of select="index/@loc" />
          </xsl:attribute>
          <i class="flaticon-home">&#8204;</i>
        </a>
        <a target="_blank">
          <xsl:attribute name="href">
            <xsl:value-of select="full-size/@src" />
          </xsl:attribute>
          <i class="flaticon-download">&#8204;</i>
        </a>
      </div>
    </div>
  </xsl:template>
  <xsl:template name="navigation">
    <a class="preview-navigation">
      <xsl:attribute name="href">
        <xsl:value-of select="@loc" />
      </xsl:attribute>
      <xsl:apply-templates select="thumbnail" />
    </a>
  </xsl:template>
  <xsl:template match="previous">
    <div class="preview-previous-navigation card mb-3 shadow-sm">
      <xsl:call-template name="navigation" />
    </div>
  </xsl:template>
  <xsl:template match="next">
    <div class="preview-next-navigation card mb-3 shadow-sm">
      <xsl:call-template name="navigation" />
    </div>
  </xsl:template>
  <xsl:template match="thumbnail">
    <img class="thumbnail">
      <xsl:attribute name="src">
        <xsl:value-of select="@src" />
      </xsl:attribute>
      <xsl:if test="string-length(normalize-space(text())) > 0">
        <xsl:attribute name="alt">
          <xsl:value-of select="normalize-space(text())" />
        </xsl:attribute>
      </xsl:if>
    </img>
    <xsl:if test="string-length(normalize-space(text())) > 0 or @credit">
      <div class="card-body">
        <xsl:value-of select="normalize-space(text())" />
        <xsl:text></xsl:text>
        <xsl:if test="@credit">
          <div class="thumbnail-credit">
            <xsl:text> by </xsl:text>
            <xsl:value-of select="@credit" />
          </div>
        </xsl:if>
      </div>
    </xsl:if>
  </xsl:template>
  <xsl:template match="image">
    <div class="image-preview">
      <img class="image-preview">
        <xsl:attribute name="src">
          <xsl:value-of select="@src" />
        </xsl:attribute>
        <xsl:if test="string-length(normalize-space(text())) > 0">
          <xsl:attribute name="alt">
            <xsl:value-of select="normalize-space(text())" />
          </xsl:attribute>
        </xsl:if>
      </img>
      <xsl:if test="string-length(normalize-space(text())) &gt; 0">
        <div class="image-decor">
          <xsl:value-of select="string-length(normalize-space(text()))" />
          <div class="image-caption">
            <xsl:value-of select="normalize-space(text())" />
          </div>
        </div>
      </xsl:if>
      <xsl:if test="@credit">
        <div class="image-credit">
          <xsl:value-of select="@credit" />
        </div>
      </xsl:if>
    </div>
  </xsl:template>
  <xsl:template match="album">
    <xsl:apply-templates select="parent" />
    <xsl:apply-templates select="sub-album" />
    <xsl:apply-templates select="preview" />
  </xsl:template>
  <xsl:template match="preview">
    <div class="col-md-3">
      <div class="card mb-3 shadow-sm">
        <a class="thumbnail-link">
          <xsl:attribute name="name">
            <xsl:value-of select="@id" />
          </xsl:attribute>
          <xsl:attribute name="href">
            <xsl:value-of select="@loc" />
          </xsl:attribute>
          <div class="thumbnail">
            <xsl:apply-templates select="thumbnail" />
          </div>
        </a>
      </div>
    </div>
  </xsl:template>
  <xsl:template match="sub-album">
    <div class="directory-thumbnail">
      <a class="thumbnail-link">
        <xsl:attribute name="href">
          <xsl:value-of select="@loc" />
        </xsl:attribute>
        <div class="thumbnail">
          <xsl:apply-templates select="thumbnail" />
        </div>
      </a>
    </div>
  </xsl:template>
</xsl:stylesheet>