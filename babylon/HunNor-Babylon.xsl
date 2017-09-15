<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:dict="http://dict.hunnor.net" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

	<xsl:include href="../common/flat-html.xsl"/>

	<xsl:output method="text" omit-xml-declaration="yes"/>

	<xsl:strip-space elements="*"/>

	<xsl:param name="sourceLanguage"/>

	<xsl:template match="dict:hnDict">
		<xsl:text>&#xA;</xsl:text>
		<xsl:text>#bookname=HunNor közösségi szótár </xsl:text>
		<xsl:value-of select="upper-case($sourceLanguage)"/>
		<xsl:text>&#xA;</xsl:text>
		<xsl:text>&#xA;</xsl:text>
		<xsl:apply-templates/>
	</xsl:template>

	<xsl:template match="dict:entryGrp">
		<xsl:apply-templates/>
	</xsl:template>

	<xsl:template match="dict:entry">
		<xsl:apply-templates/>
		<xsl:text>&#xA;</xsl:text>
		<xsl:text>&#xA;</xsl:text>
	</xsl:template>

	<xsl:template match="dict:formGrp">
		<xsl:for-each select="distinct-values(dict:form/dict:orth|dict:form/dict:inflPar/dict:inflSeq)">
		<xsl:if test="position() > 1">
			<xsl:text>|</xsl:text>
		</xsl:if>
		<xsl:value-of select="."/>
		</xsl:for-each>
		<xsl:text>&#xA;</xsl:text>
		<xsl:value-of select="dict:form[@primary='yes']/dict:pos"/>
		<xsl:if test="dict:form[@primary='yes']/dict:inflCode[@type='suff']">
			<xsl:text> </xsl:text>
			<xsl:value-of select="dict:form[@primary='yes']/dict:inflCode[@type='suff']"/>
		</xsl:if>
	</xsl:template>

	<xsl:template match="dict:senseGrp">
		<xsl:if test="count(../dict:senseGrp) > 1">
			<xsl:text> &lt;b&gt;</xsl:text>
			<xsl:number value="position()-1" format="I"/>
			<xsl:text>&lt;/b&gt;</xsl:text>
		</xsl:if>
		<xsl:apply-templates/>
	</xsl:template>

	<xsl:template match="dict:sense">
		<xsl:if test="count(../dict:sense) > 1">
			<xsl:text> &lt;b&gt;</xsl:text>
			<xsl:number value="position()"/>
			<xsl:text>&lt;/b&gt;</xsl:text>
		</xsl:if>
		<xsl:apply-templates/>
	</xsl:template>

	<xsl:template match="dict:trans">
		<xsl:if test="preceding-sibling::dict:trans">
			<xsl:text>,</xsl:text>
		</xsl:if>
		<xsl:text> </xsl:text>
		<xsl:apply-templates/>
	</xsl:template>

	<xsl:template match="dict:q">
		<xsl:text>&lt;i&gt;</xsl:text>
			<xsl:apply-templates/>
		<xsl:text>&lt;/i&gt;</xsl:text>
	</xsl:template>

	<xsl:template match="*"/>

	<xsl:template match="*" mode="references"/>

</xsl:stylesheet>
