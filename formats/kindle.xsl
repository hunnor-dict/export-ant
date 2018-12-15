<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="3.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:idx="http://www.mobipocket.com/idx" xmlns:mbp="http://www.mobipocket.com/mbp">

	<xsl:output method="xml" indent="yes" suppress-indentation="span"/>

	<xsl:template match="dictionary">
		<html>
			<head>
				<meta charset="UTF-8"/>
				<title>HunNor közösségi szótár</title>
			</head>
			<body>
				<h1>HunNor közösségi szótár</h1>
				<h2>Norvég - Magyar</h2>
				<h2>http://dict.hunnor.net/</h2>
				<mbp:pagebreak/>
				<xsl:apply-templates/>
			</body>
		</html>
	</xsl:template>

	<xsl:template match="letter">
		<xsl:apply-templates/>
	</xsl:template>

	<xsl:template match="entry">
		<idx:entry name="word" scriptable="yes">
			<xsl:if test="forms/form">
				<idx:orth>
					<xsl:attribute name="value" select="forms/form[1]"/>
					<xsl:if test="count(distinct-values(forms/form[position() > 1] | inflections/inflection)) > 0">
						<idx:infl>
							<xsl:for-each select="distinct-values(forms/form[position() > 1] | inflections/inflection)">
								<idx:iform>
									<xsl:attribute name="value">
										<xsl:value-of select="."/>
									</xsl:attribute>
								</idx:iform>
							</xsl:for-each>
						</idx:infl>
					</xsl:if>
				</idx:orth>
			</xsl:if>
			<xsl:apply-templates/>
		</idx:entry>
	</xsl:template>

	<xsl:template match="forms-html">
		<span>
			<xsl:apply-templates/>
		</span>
	</xsl:template>

	<xsl:template match="translations-html">
		<xsl:if test="preceding-sibling::forms-html">
			<br/>
		</xsl:if>
		<span>
			<xsl:apply-templates/>
		</span>
	</xsl:template>

	<xsl:template match="span">
		<xsl:choose>
			<xsl:when test="@class = 'infl'"/>
			<xsl:when test="@class = 'orth' or @class = 'q' or @class = 'senseGrp-nr' or @class = 'sense-nr'">
				<b>
					<xsl:apply-templates/>
				</b>
			</xsl:when>
			<xsl:when test="@class='pos'">
				<i>
					<xsl:apply-templates/>
				</i>
			</xsl:when>
			<xsl:otherwise>
				<xsl:apply-templates/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template match="*"/>

</xsl:stylesheet>
