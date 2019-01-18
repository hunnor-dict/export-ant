<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="3.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

	<xsl:output method="text" omit-xml-declaration="yes"/>

	<xsl:strip-space elements="dictionary letter"/>

	<xsl:param name="direction"/>

	<xsl:variable name="sq"><xsl:text>'</xsl:text></xsl:variable>

	<xsl:template name="escape">
		<xsl:param name="value"/>
		<xsl:value-of select="replace($value, $sq, concat($sq, $sq))"/>
	</xsl:template>

	<xsl:template name="normalize">
		<xsl:param name="value"/>
		<xsl:variable name="phase1" select="replace($value, 'æ', 'ae')"/>
		<xsl:variable name="phase2" select="replace($phase1, 'Æ', 'AE')"/>
		<xsl:variable name="phase3" select="replace($phase2, 'ø', 'o')"/>
		<xsl:variable name="phase4" select="replace($phase3, 'Ø', 'O')"/>
		<xsl:value-of select="replace(normalize-unicode($phase4, 'NFKD'), '\p{IsCombiningDiacriticalMarks}', '')"/>
	</xsl:template>

	<xsl:template name="forms">
		<xsl:param name="id"/>
		<xsl:param name="form"/>
		<xsl:param name="root"/>
		<xsl:variable name="escaped">
			<xsl:call-template name="escape">
				<xsl:with-param name="value" select="$form"/>
			</xsl:call-template>
		</xsl:variable>
		<xsl:variable name="normalized">
			<xsl:call-template name="normalize">
				<xsl:with-param name="value" select="$escaped"/>
			</xsl:call-template>
		</xsl:variable>
		<xsl:choose>
			<xsl:when test="$root">
				<xsl:text expand-text="yes">INSERT INTO roots (lang, id, root, root_ascii) VALUES('{$direction}', {$id}, '{$escaped}', '{$normalized}');&#xA;</xsl:text>
			</xsl:when>
			<xsl:otherwise>
				<xsl:text expand-text="yes">INSERT INTO inflections (lang, id, inflection, inflection_ascii) VALUES('{$direction}', {$id}, '{$escaped}', '{$normalized}');&#xA;</xsl:text>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template name="element">
		<xsl:param name="name"/>
		<xsl:text expand-text="yes">&lt;{$name}&gt;</xsl:text>
		<xsl:apply-templates/>
		<xsl:text expand-text="yes">&lt;/{$name}&gt;</xsl:text>
	</xsl:template>

	<xsl:template match="dictionary">
		<xsl:text>CREATE TABLE IF NOT EXISTS entries (lang TEXT, id INTEGER, content TEXT);</xsl:text>
		<xsl:text>&#xA;</xsl:text>
		<xsl:text>CREATE TABLE IF NOT EXISTS roots (lang TEXT, id INTEGER, root TEXT, root_ascii TEXT);</xsl:text>
		<xsl:text>&#xA;</xsl:text>
		<xsl:text>CREATE TABLE IF NOT EXISTS inflections (lang TEXT, id INTEGER, inflection TEXT, inflection_ascii TEXT);</xsl:text>
		<xsl:text>&#xA;</xsl:text>
		<xsl:text>CREATE INDEX IF NOT EXISTS roots_lang ON roots(lang);</xsl:text>
		<xsl:text>&#xA;</xsl:text>
		<xsl:text>CREATE INDEX IF NOT EXISTS roots_id ON roots(id);</xsl:text>
		<xsl:text>&#xA;</xsl:text>
		<xsl:text>CREATE INDEX IF NOT EXISTS roots_root ON roots(root);</xsl:text>
		<xsl:text>&#xA;</xsl:text>
		<xsl:text>CREATE INDEX IF NOT EXISTS roots_root_ascii ON roots(root_ascii);</xsl:text>
		<xsl:text>&#xA;</xsl:text>
		<xsl:text>CREATE INDEX IF NOT EXISTS inflections_lang ON inflections(lang);</xsl:text>
		<xsl:text>&#xA;</xsl:text>
		<xsl:text>CREATE INDEX IF NOT EXISTS inflections_id ON inflections(id);</xsl:text>
		<xsl:text>&#xA;</xsl:text>
		<xsl:text>CREATE INDEX IF NOT EXISTS inflections_inflection ON inflections(inflection);</xsl:text>
		<xsl:text>&#xA;</xsl:text>
		<xsl:text>CREATE INDEX IF NOT EXISTS inflections_inflection_ascii ON inflections(inflection_ascii);</xsl:text>
		<xsl:text>&#xA;</xsl:text>
		<xsl:text>CREATE INDEX IF NOT EXISTS entries_lang ON entries(lang);</xsl:text>
		<xsl:text>&#xA;</xsl:text>
		<xsl:text>CREATE INDEX IF NOT EXISTS entries_id ON entries(id);</xsl:text>
		<xsl:text>&#xA;</xsl:text>
		<xsl:text>&#xA;</xsl:text>
		<xsl:apply-templates/>
	</xsl:template>

	<xsl:template match="letter">
		<xsl:apply-templates/>
	</xsl:template>

	<xsl:template match="entry">

		<xsl:variable name="id" select="@id"/>

		<xsl:for-each select="distinct-values(forms/form)">
			<xsl:call-template name="forms">
				<xsl:with-param name="id" select="$id"/>
				<xsl:with-param name="form" select="."/>
				<xsl:with-param name="root" select="true()"/>
			</xsl:call-template>
		</xsl:for-each>

		<xsl:for-each select="distinct-values(inflections/inflection)">
			<xsl:call-template name="forms">
				<xsl:with-param name="id" select="$id"/>
				<xsl:with-param name="form" select="."/>
				<xsl:with-param name="root" select="false()"/>
			</xsl:call-template>
		</xsl:for-each>

		<xsl:variable name="content">
			<xsl:apply-templates select="forms-html"/>
			<xsl:text> </xsl:text>
			<xsl:apply-templates select="translations-html"/>
		</xsl:variable>

		<xsl:text expand-text="yes">INSERT INTO entries (lang, id, content) VALUES('{$direction}', {@id}, '{$content}');&#xA;&#xA;</xsl:text>

	</xsl:template>

	<xsl:template match="text()">
		<xsl:call-template name="escape">
			<xsl:with-param name="value" select="."/>
		</xsl:call-template>
	</xsl:template>

	<xsl:template match="forms-html | translations-html">
		<xsl:apply-templates/>
	</xsl:template>

	<xsl:template match="span">
		<xsl:choose>
			<xsl:when test="@class = 'form'">
				<xsl:call-template name="element">
					<xsl:with-param name="name" select="'base'"/>
				</xsl:call-template>
				<xsl:apply-templates mode="inflections" select="span[@class = 'infl']"/>
			</xsl:when>
			<xsl:when test="@class = 'infl' or @class = 'senseGrp-nr'">
			</xsl:when>
			<xsl:when test="@class = 'orth'">
				<xsl:call-template name="element">
					<xsl:with-param name="name" select="'b'"/>
				</xsl:call-template>
			</xsl:when>
			<xsl:when test="@class = 'pos'">
				<xsl:call-template name="element">
					<xsl:with-param name="name" select="'i'"/>
				</xsl:call-template>
			</xsl:when>
			<xsl:when test="@class = 'sense-nr'">
				<xsl:call-template name="element">
					<xsl:with-param name="name" select="'b'"/>
				</xsl:call-template>
			</xsl:when>
			<xsl:when test="@class = 'senseGrp' or @class = 'senseGrp numbered'">
				<xsl:apply-templates select="span"/>
			</xsl:when>
			<xsl:when test="@class = 'sense' or @class = 'sense numbered'">
				<xsl:text>&lt;</xsl:text>
				<xsl:text>translation</xsl:text>
				<xsl:text>&gt;</xsl:text>
				<xsl:if test="ancestor::span/span[@class='senseGrp-nr']">
					<xsl:text>&lt;</xsl:text>
					<xsl:text>b</xsl:text>
					<xsl:text>&gt;</xsl:text>
					<xsl:value-of select="ancestor::span/span[@class='senseGrp-nr']"/>
					<xsl:text>&lt;</xsl:text>
					<xsl:text>/b</xsl:text>
					<xsl:text>&gt;</xsl:text>
					<xsl:if test="not(preceding-sibling::span)">
						<xsl:text> </xsl:text>
					</xsl:if>
				</xsl:if>
				<xsl:apply-templates select="node()"/>
				<xsl:text>&lt;</xsl:text>
				<xsl:text>translation</xsl:text>
				<xsl:text>&gt;</xsl:text>
			</xsl:when>
			<xsl:when test="@class = 'senseGlue'">
				<xsl:if test="ancestor::span[@class='senseGrp numbered']">
					<xsl:apply-templates/>
				</xsl:if>
			</xsl:when>
			<xsl:otherwise>
				<xsl:apply-templates/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template match="span[@class='infl']" mode="inflections">
		<xsl:call-template name="element">
			<xsl:with-param name="name" select="'inflections'"/>
		</xsl:call-template>
	</xsl:template>

</xsl:stylesheet>
