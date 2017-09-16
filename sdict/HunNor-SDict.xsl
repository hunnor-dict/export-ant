<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:dict="http://dict.hunnor.net" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

	<xsl:include href="../common/flat-html.xsl"/>

	<xsl:output method="text" omit-xml-declaration="yes"/>

	<xsl:strip-space elements="*"/>

	<xsl:param name="sourceLanguage"/>

	<xsl:template match="dict:hnDict">
		<xsl:text># HunNor közösségi szótár&#xA;</xsl:text>
		<xsl:text># SDictionary formátum&#xA;</xsl:text>
		<xsl:text>&lt;header&gt;&#xA;</xsl:text>
		<xsl:text>title = HunNor közösségi szótár </xsl:text>
		<xsl:value-of select="upper-case($sourceLanguage)"/>
		<xsl:text>&#xA;</xsl:text>
		<xsl:text>copyright = GNU Általános Nyilvános Licenc&#xA;</xsl:text>
		<xsl:text>version = </xsl:text><xsl:value-of select="@updated"/><xsl:text>&#xA;</xsl:text>
		<xsl:text>w_lang = </xsl:text>
		<xsl:choose>
			<xsl:when test="$sourceLanguage = 'nh'">
				<xsl:text>no</xsl:text>
			</xsl:when>
			<xsl:otherwise>
				<xsl:text>hu</xsl:text>
			</xsl:otherwise>
		</xsl:choose>
		<xsl:text>&#xA;</xsl:text>
		<xsl:text>a_lang = </xsl:text>
		<xsl:choose>
			<xsl:when test="$sourceLanguage = 'nh'">
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

	<xsl:template match="dict:entryGrp">
		<xsl:apply-templates/>
	</xsl:template>

	<xsl:template match="dict:entry">
		<xsl:apply-templates/>
		<xsl:text>&#xA;</xsl:text>
		<xsl:call-template name="refInflectionsEntry">
			<xsl:with-param name="baseForm" select="dict:formGrp/dict:form[@primary='yes']/dict:orth"/>
		</xsl:call-template>
		<xsl:apply-templates select="dict:formGrp" mode="references"/>
	</xsl:template>

	<xsl:template match="dict:formGrp">
		<xsl:apply-templates/>
	</xsl:template>

	<xsl:template match="dict:form[@primary='yes']">
		<xsl:apply-templates/>
	</xsl:template>

	<xsl:template match="dict:orth">
		<xsl:apply-templates/>
		<xsl:text>___</xsl:text>
	</xsl:template>

	<xsl:template match="dict:pos">
		<xsl:apply-templates/>
	</xsl:template>

	<xsl:template match="dict:inflCode[@type='suff']">
		<xsl:text> &lt;i&gt;</xsl:text>
		<xsl:apply-templates/>
		<xsl:text>&lt;/i&gt;</xsl:text>
	</xsl:template>

	<xsl:template match="dict:inflPar">
		<xsl:if test="not(preceding-sibling::dict:inflCode)">
			<xsl:choose>
				<xsl:when test="preceding-sibling::dict:inflPar">
					<xsl:text>; </xsl:text>
				</xsl:when>
				<xsl:otherwise>
					<xsl:text> &lt;i&gt;(</xsl:text>
				</xsl:otherwise>
			</xsl:choose>
			<xsl:apply-templates/>
			<xsl:choose>
				<xsl:when test="not(following-sibling::dict:inflPar)">
					<xsl:text>)&lt;/i&gt;</xsl:text>
				</xsl:when>
			</xsl:choose>
		</xsl:if>
	</xsl:template>

	<xsl:template match="dict:inflSeq">
		<xsl:if test="preceding-sibling::dict:inflSeq">
			<xsl:text>, </xsl:text>
		</xsl:if>
		<xsl:text>&lt;f&gt;</xsl:text>
		<xsl:apply-templates/>
		<xsl:text>&lt;/f&gt;</xsl:text>
	</xsl:template>

	<xsl:template match="dict:formGrp" mode="references">
		<xsl:apply-templates mode="references"/>
	</xsl:template>

	<xsl:template match="dict:form[@primary='no']" mode="references">
		<xsl:apply-templates mode="references"/>
		<xsl:call-template name="headwordOrth"/>
		<xsl:text>&#xA;</xsl:text>
		<xsl:call-template name="refInflections">
			<xsl:with-param name="baseForm" select="dict:orth"/>
		</xsl:call-template>
	</xsl:template>

	<xsl:template match="dict:orth" mode="references">
		<xsl:apply-templates mode="references"/>
		<xsl:text>___</xsl:text>
		<xsl:call-template name="headwordPoS"/>
	</xsl:template>

	<xsl:template name="headwordOrth">
		<xsl:text>ld. &lt;r&gt;</xsl:text>
		<xsl:value-of select="../dict:form[@primary='yes']/dict:orth"/>
		<xsl:text>&lt;/r&gt;</xsl:text>
	</xsl:template>

	<xsl:template name="headwordPoS">
		<xsl:value-of select="../../dict:form[@primary='yes']/dict:pos"/>
	</xsl:template>

	<xsl:template match="dict:pos" mode="references">
		<xsl:apply-templates mode="references"/>
	</xsl:template>

	<xsl:template match="dict:inflCode[@type='suff']" mode="references">
		<xsl:text> &lt;i&gt;</xsl:text>
		<xsl:apply-templates mode="references"/>
		<xsl:text>&lt;/i&gt;</xsl:text>
	</xsl:template>

	<xsl:template match="dict:inflPar" mode="references">
		<xsl:if test="not(preceding-sibling::dict:inflCode)">
			<xsl:choose>
				<xsl:when test="preceding-sibling::dict:inflPar">
					<xsl:text>; </xsl:text>
				</xsl:when>
				<xsl:otherwise>
					<xsl:text> &lt;i&gt;(</xsl:text>
				</xsl:otherwise>
			</xsl:choose>
			<xsl:apply-templates/>
			<xsl:choose>
				<xsl:when test="not(following-sibling::dict:inflPar)">
					<xsl:text>)&lt;/i&gt;</xsl:text>
				</xsl:when>
			</xsl:choose>
		</xsl:if>
	</xsl:template>

	<xsl:template match="dict:inflSeq" mode="references">
		<xsl:if test="preceding-sibling::dict:inflSeq">
			<xsl:text>, </xsl:text>
		</xsl:if>
		<xsl:apply-templates mode="references"/>
	</xsl:template>

	<xsl:template name="refInflections">
		<xsl:param name="baseForm"/>
		<xsl:for-each select="distinct-values(dict:inflPar/dict:inflSeq)">
			<xsl:if test="not(.=$baseForm)">
				<xsl:value-of select="."/>
				<xsl:text>___ld. &lt;r&gt;</xsl:text>
				<xsl:value-of select="$baseForm"/>
				<xsl:text>&lt;/r&gt;&#xA;</xsl:text>
			</xsl:if>
		</xsl:for-each>
	</xsl:template>

	<xsl:template name="refInflectionsEntry">
		<xsl:param name="baseForm"/>
		<xsl:for-each select="distinct-values(dict:formGrp/dict:form[@primary='yes']/dict:inflPar/dict:inflSeq)">
			<xsl:if test="not(.=$baseForm)">
				<xsl:value-of select="."/>
				<xsl:text>___ld. &lt;r&gt;</xsl:text>
				<xsl:value-of select="$baseForm"/>
				<xsl:text>&lt;/r&gt;&#xA;</xsl:text>
			</xsl:if>
		</xsl:for-each>
	</xsl:template>

	<xsl:template match="dict:senseGrp">
		<xsl:if test="preceding-sibling::dict:senseGrp">
			<xsl:text>&lt;br&gt;</xsl:text>
		</xsl:if>
		<xsl:text>&lt;br&gt;</xsl:text>
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
		<xsl:text>&lt;b&gt;</xsl:text>
			<xsl:apply-templates/>
		<xsl:text>&lt;/b&gt;</xsl:text>
	</xsl:template>

	<xsl:template match="*"/>

	<xsl:template match="*" mode="references"/>

</xsl:stylesheet>
