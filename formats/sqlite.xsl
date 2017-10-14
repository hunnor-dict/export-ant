<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

	<xsl:template match="forms-html | translations-html">
		<xsl:copy>
			<xsl:text disable-output-escaping="yes">&lt;![CDATA[</xsl:text>
			<xsl:apply-templates/>
			<xsl:text disable-output-escaping="yes">]]&gt;</xsl:text>
		</xsl:copy>
	</xsl:template>

	<xsl:template match="@* | node()">
		<xsl:copy>
			<xsl:apply-templates select="@* | node()"/>
		</xsl:copy>
	</xsl:template>

</xsl:stylesheet>
