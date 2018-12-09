<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="3.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

	<xsl:output indent="yes" suppress-indentation="forms-html translations-html"/>

	<xsl:template match="letter">
		<xsl:apply-templates/>
	</xsl:template>

	<xsl:template match="forms-html | translations-html">
		<xsl:copy>
			<xsl:text disable-output-escaping="yes">&lt;![CDATA[</xsl:text>
			<xsl:apply-templates/>
			<xsl:text disable-output-escaping="yes">]]&gt;</xsl:text>
		</xsl:copy>
	</xsl:template>

	<xsl:template match="span">
		<xsl:choose>
			<xsl:when test="@class = 'form'">
				<base>
					<xsl:apply-templates/>
				</base>
				<xsl:apply-templates mode="inflections" select="span[@class = 'infl']"/>
			</xsl:when>
			<xsl:when test="@class = 'infl' or @class = 'senseGrp-nr'">
			</xsl:when>
			<xsl:when test="@class = 'pos'">
				<i>
					<xsl:apply-templates/>
				</i>
			</xsl:when>
			<xsl:when test="@class = 'sense-nr'">
				<b>
					<xsl:apply-templates/>
				</b>
			</xsl:when>
			<xsl:when test="@class = 'senseGrp' or @class = 'senseGrp numbered'">
				<xsl:apply-templates select="span"/>
			</xsl:when>
			<xsl:when test="@class = 'sense' or @class = 'sense numbered'">
				<translation>
					<xsl:if test="ancestor::span/span[@class='senseGrp-nr']">
						<b>
							<xsl:value-of select="ancestor::span/span[@class='senseGrp-nr']"/>
						</b>
						<xsl:if test="not(preceding-sibling::span)">
							<xsl:text> </xsl:text>
						</xsl:if>
					</xsl:if>
					<xsl:apply-templates select="node()"/>
				</translation>
			</xsl:when>
			<xsl:when test="@class = 'senseGlue'">
				<xsl:if test="ancestor::span[@class='senseGrp numbered']">
					<xsl:apply-templates/>
				</xsl:if>
			</xsl:when>
		</xsl:choose>
	</xsl:template>

	<xsl:template match="span[@class='infl']" mode="inflections">
		<inflections>
			<xsl:apply-templates/>
		</inflections>
	</xsl:template>

	<xsl:template match="@* | node()">
		<xsl:copy>
			<xsl:apply-templates select="@* | node()"/>
		</xsl:copy>
	</xsl:template>

</xsl:stylesheet>
