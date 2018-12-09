<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="3.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

	<xsl:output doctype-system="xdxf_lousy.dtd" method="xml" indent="yes" suppress-indentation="def"/>

	<xsl:strip-space elements="*"/>

	<xsl:param name="direction"/>

	<xsl:template match="dictionary">
		<xdxf>
			<full_name>
				<xsl:text>HunNor </xsl:text>
				<xsl:value-of select="upper-case($direction)"/>
			</full_name>
			<description>
				<xsl:text>HunNor közösségi szótár </xsl:text>
				<xsl:value-of select="upper-case($direction)"/>
			</description>
			<xsl:apply-templates/>
		</xdxf>
	</xsl:template>

	<xsl:template match="letter">
		<xsl:apply-templates/>
	</xsl:template>

	<xsl:template match="entry">
		<ar>
			<xsl:apply-templates select="forms"/>
			<xsl:if test="forms-html | translations-html">
				<def>
					<xsl:apply-templates select="forms-html | translations-html"/>
				</def>
			</xsl:if>
		</ar>
	</xsl:template>

	<xsl:template match="forms">
		<xsl:apply-templates/>
	</xsl:template>

	<xsl:template match="form">
		<k>
			<xsl:apply-templates/>
		</k>
	</xsl:template>

	<xsl:template match="forms-html">
		<xsl:apply-templates/>
	</xsl:template>

	<xsl:template match="translations-html">
		<xsl:if test="preceding-sibling::forms-html">
			<xsl:text> </xsl:text>
		</xsl:if>
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
				<xsl:apply-templates/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template name="formatting">
		<xsl:param name="element"/>
		<xsl:element name="{$element}">
			<xsl:apply-templates/>
		</xsl:element>
	</xsl:template>

	<xsl:template match="*"/>

</xsl:stylesheet>
