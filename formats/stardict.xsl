<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="3.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

	<xsl:param name="direction"/>

	<xsl:output method="xml" indent="yes" encoding="us-ascii" suppress-indentation="definition"/>

	<xsl:template match="dictionary">
		<stardict>
			<info>
				<version>3.0.0</version>
				<bookname>
					<xsl:text>HunNor közösségi szótár </xsl:text>
					<xsl:value-of select="upper-case($direction)"/>
				</bookname>
				<author>Ádám Z. Kövér</author>
				<website>http://dict.hunnor.net/</website>
			</info>
			<contents type="h">
				<xsl:apply-templates/>
			</contents>
		</stardict>
	</xsl:template>

	<xsl:template match="entry">
		<article>
			<key>
				<xsl:value-of select="forms/form[1]"/>
			</key>
			<xsl:call-template name="synonyms">
				<xsl:with-param name="key" select="forms/form[1]"/>
				<xsl:with-param name="synonyms" select="distinct-values(forms/form | inflections/inflection)"/>
			</xsl:call-template>
			<definition>
				<xsl:text disable-output-escaping="yes"><![CDATA[<![CDATA[]]></xsl:text>
				<xsl:apply-templates select="forms-html"/>
				<xsl:text> </xsl:text>
				<xsl:apply-templates select="translations-html"/>
				<xsl:text disable-output-escaping="yes"><![CDATA[]]]]><![CDATA[>]]></xsl:text>
			</definition>
		</article>
	</xsl:template>

	<xsl:template name="synonyms">
		<xsl:param name="key"/>
		<xsl:param name="synonyms"/>
		<xsl:for-each select="$synonyms">
			<xsl:sort select="."/>
			<xsl:if test=". != $key">
				<synonym>
					<xsl:value-of select="."/>
				</synonym>
			</xsl:if>
		</xsl:for-each>
	</xsl:template>

	<xsl:template match="i[@class='pos']">
		<xsl:apply-templates/>
	</xsl:template>

	<xsl:template match="b|i">
		<xsl:copy>
			<xsl:apply-templates/>
		</xsl:copy>
	</xsl:template>

</xsl:stylesheet>
