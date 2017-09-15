<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:dict="http://dict.hunnor.net" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" exclude-result-prefixes="dict">

	<xsl:template match="dict:lbl"/>

	<xsl:template match="dict:eg">
		<xsl:if test="position() > 1">
			<xsl:text>;</xsl:text>
		</xsl:if>
		<xsl:text> </xsl:text>
		<xsl:apply-templates/>
	</xsl:template>

</xsl:stylesheet>
