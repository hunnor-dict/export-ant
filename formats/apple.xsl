<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="3.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns="http://www.w3.org/1999/xhtml" xmlns:d="http://www.apple.com/DTDs/DictionaryService-1.0.rng">

	<xsl:output indent="yes" suppress-indentation="span"/>

	<xsl:param name="direction"/>

	<xsl:template match="dictionary">
		<d:dictionary>
			<xsl:apply-templates/>
		</d:dictionary>
	</xsl:template>

	<xsl:template match="letter">
		<xsl:apply-templates/>
	</xsl:template>

	<xsl:template match="entry">
		<d:entry>
			<xsl:attribute name="id">
				<xsl:value-of select="concat($direction, '_', @id)"/>
			</xsl:attribute>
			<xsl:if test="forms/form">
				<xsl:attribute name="d:title">
					<xsl:for-each select="forms/form">
						<xsl:if test="position() != 1">
							<xsl:text>/</xsl:text>
						</xsl:if>
						<xsl:value-of select="."/>
					</xsl:for-each>
				</xsl:attribute>
			</xsl:if>
			<xsl:apply-templates/>
		</d:entry>
	</xsl:template>

	<xsl:template match="forms">
		<xsl:apply-templates/>
	</xsl:template>

	<xsl:template match="form">
		<d:index>
			<xsl:attribute name="d:value">
				<xsl:value-of select="."/>
			</xsl:attribute>
		</d:index>
	</xsl:template>

	<xsl:template match="inflections">
		<xsl:apply-templates/>
	</xsl:template>

	<xsl:template match="inflection">
		<d:index>
			<xsl:attribute name="d:value">
				<xsl:value-of select="."/>
			</xsl:attribute>
			<xsl:attribute name="d:title">
				<xsl:value-of select="."/>
				<xsl:for-each select="../../forms/form">
					<xsl:choose>
						<xsl:when test="position() = 1">
							<xsl:text> (</xsl:text>
						</xsl:when>
						<xsl:otherwise>
							<xsl:text>/</xsl:text>
						</xsl:otherwise>
					</xsl:choose>
					<xsl:value-of select="."/>
					<xsl:if test="position() = last()">
						<xsl:text>)</xsl:text>
					</xsl:if>
				</xsl:for-each>
			</xsl:attribute>
		</d:index>
	</xsl:template>

	<xsl:template match="forms-html | translations-html">
		<xsl:apply-templates/>
	</xsl:template>

	<xsl:template match="span">
		<xsl:choose>
			<xsl:when test="@class = 'orth' or @class = 'q' or @class = 'senseGrp-nr' or @class = 'sense-nr'">
				<xsl:call-template name="formatting">
					<xsl:with-param name="element" select="'b'"/>
				</xsl:call-template>
			</xsl:when>
			<xsl:when test="@class = 'infl' or @class = 'lbl' or @class = 'pos'">
				<xsl:call-template name="formatting">
					<xsl:with-param name="element" select="'i'"/>
				</xsl:call-template>
			</xsl:when>
			<xsl:otherwise>
				<xsl:element name="{local-name()}" namespace="http://www.w3.org/1999/xhtml">
					<xsl:apply-templates/>
				</xsl:element>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template name="formatting">
		<xsl:param name="element"/>
		<xsl:element name="{$element}" namespace="http://www.w3.org/1999/xhtml">
			<xsl:apply-templates/>
		</xsl:element>
	</xsl:template>

</xsl:stylesheet>
