<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="3.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

	<xsl:output method="text" omit-xml-declaration="yes"/>

	<xsl:strip-space elements="dictionary letter"/>

	<xsl:param name="direction"/>

	<xsl:template match="dictionary">
		<xsl:text>&#xA;</xsl:text>
		<xsl:text>#bookname=HunNor közösségi szótár </xsl:text>
		<xsl:value-of select="upper-case($direction)"/>
		<xsl:text>&#xA;</xsl:text>
		<xsl:text>&#xA;</xsl:text>
		<xsl:apply-templates/>
	</xsl:template>

	<xsl:template match="letter">
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

	<xsl:template match="span">
		<xsl:choose>
			<xsl:when test="@class = 'orth' or @class = 'q' or @class = 'senseGrp-nr' or @class = 'sense-nr'">
				<xsl:call-template name="formatting">
					<xsl:with-param name="element" select="'b'"/>
				</xsl:call-template>
			</xsl:when>
			<xsl:when test="@class = 'infl' or @class = 'lbl'">
				<xsl:call-template name="formatting">
					<xsl:with-param name="element" select="'i'"/>
				</xsl:call-template>
			</xsl:when>
			<xsl:otherwise>
				<xsl:apply-templates/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template name="formatting">
		<xsl:param name="element"/>
		<xsl:text>&lt;</xsl:text>
		<xsl:value-of select="$element"/>
		<xsl:text>&gt;</xsl:text>
		<xsl:apply-templates/>
		<xsl:text>&lt;/</xsl:text>
		<xsl:value-of select="$element"/>
		<xsl:text>&gt;</xsl:text>
	</xsl:template>

</xsl:stylesheet>
