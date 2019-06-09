<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="3.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:h="http://www.w3.org/1999/xhtml">

	<xsl:mode on-no-match="shallow-copy"/>

	<xsl:template match="h:b | h:i">
		<xsl:element name="{local-name()}" namespace="http://www.w3.org/1999/xhtml">
			<xsl:apply-templates/>
			<xsl:if test="following-sibling::node()[1] = ' '">
				<xsl:text> </xsl:text>
			</xsl:if>
		</xsl:element>
	</xsl:template>

	<xsl:template match="text()">
		<xsl:if test=". != ' '">
			<xsl:value-of select="."/>
		</xsl:if>
	</xsl:template>

</xsl:stylesheet>
