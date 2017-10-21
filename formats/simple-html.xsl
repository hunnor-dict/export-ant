<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:dict="http://dict.hunnor.net" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:saxon="http://saxon.sf.net/" exclude-result-prefixes="saxon dict">

	<xsl:output indent="yes" saxon:suppress-indentation="forms-html translations-html"/>

	<xsl:strip-space elements="*"/>

	<xsl:template match="dict:hnDict">
		<dictionary>
			<xsl:if test="@updated">
				<xsl:attribute name="updated" select="@updated"/>
			</xsl:if>
			<xsl:apply-templates/>
		</dictionary>
	</xsl:template>

	<xsl:template match="dict:entryGrp">
		<xsl:apply-templates/>
	</xsl:template>

	<xsl:template match="dict:entry">
		<entry>
			<xsl:copy-of select="@id"/>
			<xsl:if test="dict:formGrp">
				<xsl:if test="dict:formGrp/dict:form/dict:orth">
					<forms>
						<xsl:for-each select="distinct-values(dict:formGrp/dict:form/dict:orth)">
							<xsl:sort select="."/>
							<form>
								<xsl:value-of select="."/>
							</form>
						</xsl:for-each>
					</forms>
				</xsl:if>
				<xsl:if test="dict:formGrp/dict:form/dict:inflPar/dict:inflSeq">
					<inflections>
						<xsl:for-each select="distinct-values(dict:formGrp/dict:form/dict:inflPar/dict:inflSeq)">
							<xsl:sort select="."/>
							<inflection>
								<xsl:value-of select="."/>
							</inflection>
						</xsl:for-each>
					</inflections>
				</xsl:if>
				<forms-html>
					<xsl:apply-templates select="dict:formGrp"/>
				</forms-html>
			</xsl:if>
			<xsl:if test="dict:senseGrp">
				<translations-html>
					<xsl:apply-templates select="dict:senseGrp"/>
				</translations-html>
			</xsl:if>
		</entry>
	</xsl:template>

	<xsl:template match="dict:formGrp">
		<xsl:apply-templates/>
	</xsl:template>

	<xsl:template match="dict:form">
		<xsl:if test="preceding-sibling::dict:form">
			<xsl:text> </xsl:text>
		</xsl:if>
		<xsl:apply-templates/>
	</xsl:template>

	<xsl:template match="dict:orth">
		<xsl:if test="preceding-sibling::dict:orth">
			<b>, </b>
		</xsl:if>
		<b>
			<xsl:apply-templates/>
		</b>
	</xsl:template>

	<xsl:template match="dict:pos">
		<xsl:if test="ancestor::dict:form[@primary = 'yes']">
			<xsl:text> </xsl:text>
			<i class="pos">
				<xsl:apply-templates/>
			</i>
		</xsl:if>
	</xsl:template>

	<xsl:template match="dict:inflCode">
		<xsl:if test="@type = 'suff'">
			<xsl:text> </xsl:text>
			<xsl:apply-templates/>
		</xsl:if>
	</xsl:template>

	<xsl:template match="dict:inflPar[1]">
		<xsl:text> </xsl:text>
		<i>
			<xsl:text>(</xsl:text>
			<xsl:apply-templates select="../dict:inflPar" mode="inflPar"/>
			<xsl:text>)</xsl:text>
		</i>
	</xsl:template>

	<xsl:template match="dict:inflPar">
	</xsl:template>

	<xsl:template match="dict:inflPar" mode="inflPar">
		<xsl:if test="preceding-sibling::dict:inflPar">
			<xsl:text>; </xsl:text>
		</xsl:if>
		<xsl:apply-templates/>
	</xsl:template>

	<xsl:template match="dict:inflSeq">
		<xsl:if test="preceding-sibling::dict:inflSeq">
			<xsl:text>, </xsl:text>
		</xsl:if>
		<xsl:apply-templates/>
	</xsl:template>

	<xsl:template match="dict:senseGrp">
		<span class="senseGrp">
			<xsl:if test="count(../dict:senseGrp) > 1">
				<xsl:attribute name="class" select="'senseGrp numbered'"/>
				<xsl:if test="position() > 1">
					<xsl:text> </xsl:text>
				</xsl:if>
				<b>
					<xsl:number value="position()" format="I"/>
				</b>
				<xsl:text> </xsl:text>
			</xsl:if>
			<xsl:apply-templates/>
		</span>
	</xsl:template>

	<xsl:template match="dict:sense">
		<span class="sense">
			<xsl:if test="count(../dict:sense) > 1">
				<xsl:attribute name="class" select="'sense numbered'"/>
				<xsl:if test="preceding-sibling::dict:sense">
					<xsl:text> </xsl:text>
				</xsl:if>
				<b>
					<xsl:number value="count(preceding-sibling::dict:sense) + 1"/>
				</b>
				<xsl:text> </xsl:text>
			</xsl:if>
			<xsl:apply-templates/>
		</span>
	</xsl:template>

	<xsl:template match="dict:lbl">
		<xsl:if test="preceding-sibling::dict:*">
			<xsl:variable name="previousTag" select="local-name(preceding-sibling::dict:*[1])"/>
			<xsl:choose>
				<xsl:when test="$previousTag = 'lbl'">
					<xsl:text>, </xsl:text>
				</xsl:when>
				<xsl:when test="$previousTag = 'trans'">
					<xsl:text> </xsl:text>
				</xsl:when>
				<xsl:when test="$previousTag = 'q'">
					<xsl:text> </xsl:text>
				</xsl:when>
			</xsl:choose>
		</xsl:if>
		<i>
			<xsl:apply-templates/>
		</i>
		<xsl:if test="parent::dict:senseGrp">
			<xsl:text> </xsl:text>
		</xsl:if>
	</xsl:template>

	<xsl:template match="dict:trans">
		<xsl:if test="preceding-sibling::dict:*">
			<xsl:variable name="previousTag" select="local-name(preceding-sibling::dict:*[1])"/>
			<xsl:choose>
				<xsl:when test="$previousTag = 'lbl'">
					<xsl:text> </xsl:text>
				</xsl:when>
				<xsl:when test="$previousTag = 'trans'">
					<xsl:text>, </xsl:text>
				</xsl:when>
				<xsl:when test="$previousTag = 'q'">
					<xsl:text> </xsl:text>
				</xsl:when>
			</xsl:choose>
		</xsl:if>
		<xsl:apply-templates/>
	</xsl:template>

	<xsl:template match="dict:eg">
		<xsl:if test="preceding-sibling::dict:*">
			<xsl:variable name="previousTag" select="local-name(preceding-sibling::dict:*[1])"/>
			<xsl:choose>
				<xsl:when test="$previousTag = 'lbl'">
					<xsl:text> </xsl:text>
				</xsl:when>
				<xsl:when test="$previousTag = 'trans'">
					<xsl:text>; </xsl:text>
				</xsl:when>
				<xsl:when test="$previousTag = 'eg'">
					<xsl:text>; </xsl:text>
				</xsl:when>
			</xsl:choose>
		</xsl:if>
		<xsl:apply-templates/>
	</xsl:template>

	<xsl:template match="dict:q">
		<xsl:if test="preceding-sibling::dict:*">
			<xsl:variable name="previousTag" select="local-name(preceding-sibling::dict:*[1])"/>
			<xsl:choose>
				<xsl:when test="$previousTag = 'lbl'">
					<xsl:text> </xsl:text>
				</xsl:when>
				<xsl:when test="$previousTag = 'q'">
					<b>, </b>
				</xsl:when>
			</xsl:choose>
		</xsl:if>
		<b>
			<xsl:apply-templates/>
		</b>
	</xsl:template>

	<xsl:template match="*"/>

</xsl:stylesheet>
