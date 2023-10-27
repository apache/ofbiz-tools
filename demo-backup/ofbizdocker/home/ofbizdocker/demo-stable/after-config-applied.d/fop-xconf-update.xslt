<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  <xsl:template match="/fop">
    <xsl:element name="fop">
      <xsl:copy-of select="@*"/>
      <base>https://demo-stable.ofbiz.apache.org</base>
      <xsl:copy-of select="node()[not(self::base)]"/>
    </xsl:element>
  </xsl:template>
</xsl:stylesheet>
