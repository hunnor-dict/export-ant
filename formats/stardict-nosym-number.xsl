<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:dict="http://dict.hunnor.net" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" exclude-result-prefixes="dict">

	<xsl:output method="xml" indent="yes" cdata-section-elements="definition" encoding="us-ascii"/>

	<xsl:template match="key">
		<key>
			<xsl:variable name="currentKey" select="."/>
			<xsl:variable name="currentCount" select="count(preceding::key[text()=$currentKey])"/>
			<xsl:value-of select="."/>
			<xsl:if test="$currentCount > 0">
				<xsl:text> (</xsl:text>
				<xsl:value-of select="$currentCount + 1"/>
				<xsl:text>)</xsl:text>
			</xsl:if>
		</key>
	</xsl:template>

	<xsl:template match="*">
		<xsl:copy>
			<xsl:apply-templates/>
		</xsl:copy>
	</xsl:template>

</xsl:stylesheet>
