<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

	<xsl:output method="text" omit-xml-declaration="yes"/>

	<xsl:strip-space elements="*"/>

	<xsl:param name="direction"/>

	<xsl:template match="dictionary">
		<xsl:text>&#xA;</xsl:text>
		<xsl:text>#bookname=HunNor közösségi szótár </xsl:text>
		<xsl:value-of select="upper-case($direction)"/>
		<xsl:text>&#xA;</xsl:text>
		<xsl:text>&#xA;</xsl:text>
		<xsl:apply-templates/>
	</xsl:template>

	<xsl:template match="entry">
		<xsl:for-each select="distinct-values(forms/form | inflections/inflection)">
			<xsl:sort select="."/>
			<xsl:value-of select="."/>
			<xsl:if test="position() > 0 and position() != last()">|</xsl:if>
		</xsl:for-each>
		<xsl:text>&#xA;</xsl:text>
		<xsl:apply-templates select="forms-html"/>
		<xsl:text> </xsl:text>
		<xsl:apply-templates select="translations-html"/>
		<xsl:text>&#xA;</xsl:text>
		<xsl:text>&#xA;</xsl:text>
	</xsl:template>

</xsl:stylesheet>
