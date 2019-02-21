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
  <xsl:variable name="albumTitle" select="/*/@albumTitle" />
  <xsl:variable name="albumPath" select="/*/@pathName" />
  <xsl:template name="head-content">
    <meta charset="utf-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no" />
    <!-- Bootstrap CSS -->
    <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.3.1/css/bootstrap.min.css" integrity="sha384-ggOyR0iXCbMQv3Xipma34MD+dH/1fQ784/j6cY/iJTQUOhcWr7x9JvoRxT2MZw1T" crossorigin="anonymous" />
    <link rel="stylesheet" href="/assets/style.css" />
    <title>
      <xsl:value-of select="$albumTitle"></xsl:value-of>
    </title>
  </xsl:template>
  <xsl:template name="body-attributes" />
  <xsl:template name="body-content">
    <header>
      <div class="navbar navbar-dark bg-dark shadow-sm">
        <div class="container d-flex justify-content-between">
          <a href="/" class="navbar-brand d-flex align-items-center">
            <svg xmlns="http://www.w3.org/2000/svg" width="20" height="20" fill="none" stroke="currentColor" stroke-linecap="round" stroke-linejoin="round" stroke-width="2" aria-hidden="true" class="mr-2" viewBox="0 0 24 24" focusable="false">
              <path d="M23 19a2 2 0 0 1-2 2H3a2 2 0 0 1-2-2V8a2 2 0 0 1 2-2h4l2-3h6l2 3h4a2 2 0 0 1 2 2z" />
              <circle cx="12" cy="13" r="4" />
            </svg>
            <strong>
              <xsl:value-of select="$albumTitle"></xsl:value-of>
            </strong>
          </a>
          <a href="/{$albumPath}/{$albumPath}.zip" class="btn btn-primary my-2">Télécharger toutes les photos</a>
        </div>
      </div>
    </header>
    <main role="main">
      <xsl:choose>
        <xsl:when test="/album">
          <div class="album py-5 bg-light">
            <div class="container-fluid">
              <div class="row">
                <xsl:apply-templates />
              </div>
            </div>
          </div>
        </xsl:when>
        <xsl:otherwise>
          <div class="album py-5 bg-light">
            <div class="container-fluid">
              <xsl:apply-templates />
            </div>
          </div>
        </xsl:otherwise>
      </xsl:choose>
    </main>
  </xsl:template>
</xsl:stylesheet>