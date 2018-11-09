<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:saxon="http://saxon.sf.net/" exclude-result-prefixes="saxon">

	<xsl:param name="direction"/>

	<xsl:output doctype-system="xdxf_lousy.dtd" method="xml" indent="yes" saxon:suppress-indentation="def"/>

	<xsl:strip-space elements="*"/>

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

	<xsl:template match="entry">
		<ar>
			<xsl:apply-templates select="forms"/>
			<xsl:if test="forms-html|translations-html">
				<def>
					<xsl:apply-templates select="forms-html|translations-html"/>
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

	<xsl:template match="b|i">
		<xsl:copy>
			<xsl:apply-templates/>
		</xsl:copy>
	</xsl:template>

	<xsl:template match="span">
		<xsl:apply-templates/>
	</xsl:template>

	<xsl:template match="*"/>

</xsl:stylesheet>
