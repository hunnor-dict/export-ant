<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

	<xsl:template match="forms-html | translations-html">
		<xsl:copy>
			<xsl:text disable-output-escaping="yes">&lt;![CDATA[</xsl:text>
			<xsl:apply-templates/>
			<xsl:text disable-output-escaping="yes">]]&gt;</xsl:text>
		</xsl:copy>
	</xsl:template>

	<xsl:template match="span[@class='form']">
		<base>
			<xsl:apply-templates/>
		</base>
		<xsl:apply-templates mode="inflections" select="i[@class='infl']"/>
	</xsl:template>

	<xsl:template match="span[@class='senseGrp'] | span[@class='senseGrp numbered']">
		<xsl:apply-templates select="span"/>
	</xsl:template>

	<xsl:template match="span[@class='sense'] | span[@class='sense numbered']">
		<translation>
			<xsl:if test="ancestor::span/b">
				<xsl:copy-of select="ancestor::span/b"/>
				<xsl:if test="not(preceding-sibling::span)">
					<xsl:text> </xsl:text>
				</xsl:if>
			</xsl:if>
			<xsl:apply-templates select="node()"/>
		</translation>
	</xsl:template>

	<xsl:template match="span[@class='senseGlue']">
		<xsl:if test="ancestor::span[@class='senseGrp numbered']">
			<xsl:apply-templates/>
		</xsl:if>
	</xsl:template>

	<xsl:template match="i">
		<xsl:choose>
			<xsl:when test="@class = 'infl'"/>
			<xsl:otherwise>
				<i>
					<xsl:apply-templates/>
				</i>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template match="i" mode="inflections">
		<xsl:if test="@class = 'infl'">
			<inflections>
				<xsl:apply-templates/>
			</inflections>
		</xsl:if>
	</xsl:template>

	<xsl:template match="@* | node()">
		<xsl:copy>
			<xsl:apply-templates select="@* | node()"/>
		</xsl:copy>
	</xsl:template>

</xsl:stylesheet>
