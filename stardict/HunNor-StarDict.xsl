<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:dict="http://dict.hunnor.net" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" exclude-result-prefixes="dict">

	<xsl:param name="sourceLanguage"/>

	<xsl:output method="xml" indent="yes" encoding="us-ascii"/>

	<xsl:strip-space elements="*"/>

	<xsl:template match="dict:hnDict">
		<stardict>
			<info>
				<version>3.0.0</version>
				<bookname>
					<xsl:text>HunNor közösségi szótár </xsl:text>
					<xsl:value-of select="upper-case($sourceLanguage)"/>
				</bookname>
				<author>Ádám Z. Kövér</author>
				<website>http://dict.hunnor.net/</website>
			</info>
			<contents type="h">
				<xsl:apply-templates/>
			</contents>
		</stardict>
		<xsl:text>&#xA;</xsl:text>
	</xsl:template>

	<xsl:template match="dict:entryGrp">
		<xsl:apply-templates/>
	</xsl:template>

	<xsl:template match="dict:entry">
		<article>
			<xsl:apply-templates select="dict:formGrp"/>
			<definition>
				<xsl:text disable-output-escaping="yes"><![CDATA[<![CDATA[]]></xsl:text>
				<xsl:apply-templates mode="formInfo"/>
				<xsl:apply-templates select="dict:senseGrp"/>
				<xsl:text disable-output-escaping="yes">]]&gt;</xsl:text>
			</definition>
		</article>
	</xsl:template>

	<xsl:template match="dict:formGrp" mode="formInfo">
		<xsl:apply-templates mode="formInfo"/>
	</xsl:template>

	<xsl:template match="dict:form" mode="formInfo">
		<xsl:choose>
			<xsl:when test="@primary='yes'">
				<xsl:value-of select="dict:pos"/>
				<xsl:text> </xsl:text>
			</xsl:when>
			<xsl:otherwise>
				<xsl:text disable-output-escaping="yes">&lt;b&gt;</xsl:text>
				<xsl:value-of select="dict:orth"/>
				<xsl:text disable-output-escaping="yes">&lt;/b&gt; </xsl:text>
			</xsl:otherwise>
		</xsl:choose>
		<xsl:apply-templates mode="formInfo"/>
	</xsl:template>

	<xsl:template match="dict:inflCode[@type='suff']" mode="formInfo">
		<xsl:text disable-output-escaping="yes">&lt;i&gt;</xsl:text>
		<xsl:apply-templates/>
		<xsl:text disable-output-escaping="yes">&lt;/i&gt; </xsl:text>
	</xsl:template>

	<xsl:template match="dict:inflPar" mode="formInfo">
		<xsl:if test="not(preceding-sibling::dict:inflCode)">
			<xsl:choose>
				<xsl:when test="preceding-sibling::dict:inflPar">
					<xsl:text>; </xsl:text>
				</xsl:when>
				<xsl:otherwise>
					<xsl:text disable-output-escaping="yes">&lt;i&gt;(</xsl:text>
				</xsl:otherwise>
			</xsl:choose>
			<xsl:apply-templates mode="formInfo"/>
			<xsl:choose>
				<xsl:when test="not(following-sibling::dict:inflPar)">
					<xsl:text disable-output-escaping="yes">)&lt;/i&gt; </xsl:text>
				</xsl:when>
			</xsl:choose>
		</xsl:if>
	</xsl:template>

	<xsl:template match="dict:inflSeq" mode="formInfo">
		<xsl:if test="preceding-sibling::dict:inflSeq">
			<xsl:text>, </xsl:text>
		</xsl:if>
		<xsl:apply-templates/>
	</xsl:template>

	<xsl:template match="*" mode="formInfo"/>

	<xsl:template match="dict:formGrp">
		<xsl:variable name="headWord" select="dict:form[@primary='yes']/dict:orth"/>
		<key>
			<xsl:value-of select="dict:form[@primary='yes']/dict:orth"/>
		</key>
		<xsl:for-each select="distinct-values(dict:form[@primary='no']/dict:orth|dict:form/dict:inflPar/dict:inflSeq)">
			<xsl:if test="not(.=$headWord)">
				<synonym>
					<xsl:value-of select="."/>
				</synonym>
			</xsl:if>
		</xsl:for-each>
	</xsl:template>

	<xsl:template match="dict:senseGrp">
		<xsl:if test="position() > 1">
			<xsl:text> </xsl:text>
		</xsl:if>
		<xsl:if test="count(../dict:senseGrp) > 1">
			<xsl:text disable-output-escaping="yes">&lt;b&gt;</xsl:text>
			<xsl:number value="position()" format="I"/>
			<xsl:text disable-output-escaping="yes">&lt;/b&gt; </xsl:text>
		</xsl:if>
		<xsl:apply-templates/>
	</xsl:template>

	<xsl:template match="dict:sense">
		<xsl:if test="position() > 1">
			<xsl:text> </xsl:text>
		</xsl:if>
		<xsl:if test="count(../dict:sense) > 1">
			<xsl:text disable-output-escaping="yes">&lt;b&gt;</xsl:text>
			<xsl:number value="position()"/>
			<xsl:text disable-output-escaping="yes">&lt;/b&gt; </xsl:text>
		</xsl:if>
		<xsl:apply-templates/>
	</xsl:template>

	<xsl:template match="dict:lbl"/>

	<xsl:template match="dict:trans">
		<xsl:choose>
			<xsl:when test="preceding-sibling::dict:lbl">
				<xsl:text> </xsl:text>
			</xsl:when>
			<xsl:when test="preceding-sibling::dict:trans">
				<xsl:text>, </xsl:text>
			</xsl:when>
			<xsl:when test="preceding-sibling::dict:q">
				<xsl:text> </xsl:text>
			</xsl:when>
		</xsl:choose>
		<xsl:apply-templates/>
	</xsl:template>

	<xsl:template match="dict:eg">
		<xsl:if test="position() > 1">
			<xsl:text>;</xsl:text>
		</xsl:if>
		<xsl:text> </xsl:text>
		<xsl:apply-templates/>
	</xsl:template>

	<xsl:template match="dict:q">
		<xsl:text disable-output-escaping="yes">&lt;i&gt;</xsl:text>
			<xsl:apply-templates/>
		<xsl:text disable-output-escaping="yes">&lt;/i&gt;</xsl:text>
	</xsl:template>

	<xsl:template match="*"/>

</xsl:stylesheet>
