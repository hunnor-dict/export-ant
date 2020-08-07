<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="3.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:dict="http://dict.hunnor.net" xmlns:json="http://www.w3.org/2005/xpath-functions" exclude-result-prefixes="dict json">

	<xsl:output method="text" omit-xml-declaration="yes"/>

	<xsl:strip-space elements="*"/>

	<xsl:template match="dict:hnDict">
		<xsl:variable name="result">
			<json:array>
				<xsl:apply-templates/>
			</json:array>
		</xsl:variable>
		<xsl:value-of disable-output-escaping="yes" select="xml-to-json($result, map {'indent': true()})"/>
	</xsl:template>

	<xsl:template match="dict:entryGrp">
		<xsl:apply-templates/>
	</xsl:template>

	<xsl:template match="dict:entry">
		<json:map>
			<json:number key="id">
				<xsl:value-of select="@id"/>
			</json:number>
			<xsl:if test="dict:formGrp">
				<xsl:if test="dict:formGrp/dict:form/dict:orth">
					<json:array key="roots">
						<xsl:for-each select="dict:formGrp/dict:form/dict:orth">
							<xsl:sort select="."/>
							<json:string>
								<xsl:value-of select="."/>
							</json:string>
						</xsl:for-each>
					</json:array>
				</xsl:if>
				<xsl:if test="dict:formGrp/dict:form/dict:inflPar/dict:inflSeq">
					<json:array key="inflections">
						<xsl:for-each select="distinct-values(dict:formGrp/dict:form/dict:inflPar/dict:inflSeq)">
							<xsl:sort select="."/>
							<json:string>
								<xsl:value-of select="."/>
							</json:string>
						</xsl:for-each>
					</json:array>
				</xsl:if>
			</xsl:if>
			<xsl:if test="dict:formGrp or dict:senseGrp">
				<json:string key="content">
					<xsl:apply-templates select="dict:formGrp"/>
					<xsl:apply-templates select="dict:senseGrp"/>
				</json:string>
			</xsl:if>
		</json:map>
	</xsl:template>

	<xsl:template match="dict:formGrp">
		<xsl:apply-templates/>
	</xsl:template>

	<xsl:template match="dict:form">
		<xsl:text disable-output-escaping="yes">&lt;div></xsl:text>
			<xsl:apply-templates/>
		<xsl:text disable-output-escaping="yes">&lt;/div></xsl:text>
	</xsl:template>

	<xsl:template match="dict:orth">
		<xsl:if test="preceding-sibling::dict:orth">
			<xsl:text>, </xsl:text>
		</xsl:if>
		<xsl:text disable-output-escaping="yes">&lt;b></xsl:text>
		<xsl:apply-templates/>
		<xsl:text disable-output-escaping="yes">&lt;/b></xsl:text>
	</xsl:template>

	<xsl:template match="dict:pos">
		<xsl:if test="ancestor::dict:form[@primary = 'yes']">
			<xsl:text> </xsl:text>
			<xsl:apply-templates/>
		</xsl:if>
	</xsl:template>

	<xsl:template match="dict:inflCode">
		<xsl:if test="@type = 'suff'">
			<xsl:text> </xsl:text>
			<xsl:apply-templates/>
		</xsl:if>
	</xsl:template>

	<xsl:template match="dict:inflPar">
		<xsl:text disable-output-escaping="yes">&lt;div class="infl"></xsl:text>
		<xsl:apply-templates/>
		<xsl:text disable-output-escaping="yes">&lt;/div></xsl:text>
	</xsl:template>

	<xsl:template match="dict:inflSeq">
		<xsl:if test="preceding-sibling::dict:inflSeq">
			<xsl:text>, </xsl:text>
		</xsl:if>
		<xsl:apply-templates/>
	</xsl:template>

	<xsl:template match="dict:senseGrp">
		<xsl:text disable-output-escaping="yes">&lt;div></xsl:text>
		<xsl:if test="count(../dict:senseGrp) > 1">
			<xsl:text disable-output-escaping="yes">&lt;b></xsl:text>
			<xsl:number value="position()" format="I"/>
			<xsl:text disable-output-escaping="yes">&lt;/b></xsl:text>
			<xsl:text> </xsl:text>
		</xsl:if>
		<xsl:apply-templates/>
		<xsl:text disable-output-escaping="yes">&lt;/div></xsl:text>
	</xsl:template>

	<xsl:template match="dict:sense">
		<xsl:text disable-output-escaping="yes">&lt;div></xsl:text>
		<xsl:if test="count(../dict:sense) > 1">
			<xsl:text disable-output-escaping="yes">&lt;b></xsl:text>
			<xsl:number value="count(preceding-sibling::dict:sense) + 1"/>
			<xsl:text disable-output-escaping="yes">&lt;/b></xsl:text>
			<xsl:text> </xsl:text>
		</xsl:if>
		<xsl:apply-templates/>
		<xsl:text disable-output-escaping="yes">&lt;/div></xsl:text>
	</xsl:template>

	<xsl:template match="dict:lbl">
		<xsl:if test="preceding-sibling::dict:*">
			<xsl:variable name="previousTag" select="local-name(preceding-sibling::dict:*[1])"/>
			<xsl:choose>
				<xsl:when test="$previousTag = 'lbl'">
					<xsl:text disable-output-escaping="yes">&lt;i></xsl:text>
					<xsl:text>, </xsl:text>
					<xsl:text disable-output-escaping="yes">&lt;/i></xsl:text>
				</xsl:when>
				<xsl:when test="$previousTag = 'trans'">
					<xsl:text> </xsl:text>
				</xsl:when>
				<xsl:when test="$previousTag = 'q'">
					<xsl:text> </xsl:text>
				</xsl:when>
			</xsl:choose>
		</xsl:if>
		<xsl:text disable-output-escaping="yes">&lt;i></xsl:text>
		<xsl:apply-templates/>
		<xsl:text disable-output-escaping="yes">&lt;/i></xsl:text>
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
					<xsl:text disable-output-escaping="yes">&lt;b></xsl:text>
					<xsl:text>, </xsl:text>
					<xsl:text disable-output-escaping="yes">&lt;/b></xsl:text>
				</xsl:when>
			</xsl:choose>
		</xsl:if>
		<xsl:text disable-output-escaping="yes">&lt;b></xsl:text>
		<xsl:apply-templates/>
		<xsl:text disable-output-escaping="yes">&lt;/b></xsl:text>
	</xsl:template>

	<xsl:template match="*"/>

</xsl:stylesheet>
