<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="3.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

	<xsl:output method="text" omit-xml-declaration="yes"/>

	<xsl:strip-space elements="dictionary letter forms-html translations-html span"/>

	<xsl:param name="direction"/>

	<xsl:template match="dictionary">
		<xsl:text># HunNor közösségi szótár&#xA;</xsl:text>
		<xsl:text># SDictionary formátum&#xA;</xsl:text>
		<xsl:text>&lt;header&gt;&#xA;</xsl:text>
		<xsl:text>title = HunNor közösségi szótár </xsl:text>
		<xsl:value-of select="upper-case($direction)"/>
		<xsl:text>&#xA;</xsl:text>
		<xsl:text>copyright = GNU Általános Nyilvános Licenc&#xA;</xsl:text>
		<xsl:text>version = </xsl:text><xsl:value-of select="@updated"/><xsl:text>&#xA;</xsl:text>
		<xsl:text>w_lang = </xsl:text>
		<xsl:choose>
			<xsl:when test="$direction = 'nh'">
				<xsl:text>no</xsl:text>
			</xsl:when>
			<xsl:otherwise>
				<xsl:text>hu</xsl:text>
			</xsl:otherwise>
		</xsl:choose>
		<xsl:text>&#xA;</xsl:text>
		<xsl:text>a_lang = </xsl:text>
		<xsl:choose>
			<xsl:when test="$direction = 'nh'">
				<xsl:text>hu</xsl:text>
			</xsl:when>
			<xsl:otherwise>
				<xsl:text>no</xsl:text>
			</xsl:otherwise>
		</xsl:choose>
		<xsl:text>&#xA;</xsl:text>
		<xsl:text>&lt;/header&gt;&#xA;</xsl:text>
		<xsl:apply-templates/>
	</xsl:template>

	<xsl:template match="letter">
		<xsl:apply-templates/>
	</xsl:template>

	<xsl:template match="entry">
		<xsl:value-of select="forms/form[1]"/>
		<xsl:text>___</xsl:text>
		<xsl:apply-templates select="forms-html"/>
		<xsl:text>&lt;br/&gt;</xsl:text>
		<xsl:apply-templates select="translations-html"/>
		<xsl:text>&#xA;</xsl:text>
		<xsl:call-template name="references">
			<xsl:with-param name="to" select="forms/form[1]"/>
			<xsl:with-param name="from" select="distinct-values(forms/form | inflections/inflection)"/>
		</xsl:call-template>
	</xsl:template>

	<xsl:template name="references">
		<xsl:param name="to"/>
		<xsl:param name="from"/>
		<xsl:for-each select="$from">
			<xsl:sort select="."/>
			<xsl:if test=". != $to">
				<xsl:value-of select="."/>
				<xsl:text>___ld. &lt;r&gt;</xsl:text>
				<xsl:value-of select="$to"/>
				<xsl:text>&lt;/r&gt;&#xA;</xsl:text>
			</xsl:if>
		</xsl:for-each>
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
