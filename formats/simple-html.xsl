<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="3.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:dict="http://dict.hunnor.net" exclude-result-prefixes="dict">

	<xsl:output indent="yes" suppress-indentation="forms-html translations-html"/>

	<xsl:strip-space elements="*"/>

	<xsl:template match="dict:hnDict">
		<dictionary>
			<xsl:copy-of select="@updated"/>
			<xsl:apply-templates/>
		</dictionary>
	</xsl:template>

	<xsl:template match="dict:entryGrp">
		<letter>
			<xsl:attribute name="label">
				<xsl:value-of select="@head"/>
			</xsl:attribute>
			<xsl:apply-templates/>
		</letter>
	</xsl:template>

	<xsl:template match="dict:entry">
		<entry>
			<xsl:copy-of select="@id"/>
			<xsl:if test="dict:formGrp">
				<xsl:if test="dict:formGrp/dict:form/dict:orth">
					<forms>
						<xsl:for-each select="dict:formGrp/dict:form/dict:orth">
							<xsl:sort select="."/>
							<form>
								<xsl:if test="@n > 1">
									<xsl:copy select="@n"/>
								</xsl:if>
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
		<span class="form">
			<xsl:apply-templates/>
		</span>
	</xsl:template>

	<xsl:template match="dict:orth">
		<xsl:if test="preceding-sibling::dict:orth">
			<span class="orth">, </span>
		</xsl:if>
		<span class="orth">
			<xsl:if test="@n > 0">
				<xsl:attribute name="data-n">
					<xsl:value-of select="@n"/>
				</xsl:attribute>
			</xsl:if>
			<xsl:apply-templates/>
		</span>
	</xsl:template>

	<xsl:template match="dict:pos">
		<xsl:if test="ancestor::dict:form[@primary = 'yes']">
			<xsl:text> </xsl:text>
			<span class="pos">
				<xsl:apply-templates/>
			</span>
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
		<span class="infl">
			<xsl:text>(</xsl:text>
			<xsl:apply-templates select="../dict:inflPar" mode="inflPar"/>
			<xsl:text>)</xsl:text>
		</span>
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
				<span class="senseGrp-nr">
					<xsl:number value="position()" format="I"/>
				</span>
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
					<span class="senseGlue">
						<xsl:text> </xsl:text>
					</span>
				</xsl:if>
				<span class="sense-nr">
					<xsl:number value="count(preceding-sibling::dict:sense) + 1"/>
				</span>
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
					<span class="lbl">, </span>
				</xsl:when>
				<xsl:when test="$previousTag = 'trans'">
					<xsl:text> </xsl:text>
				</xsl:when>
				<xsl:when test="$previousTag = 'q'">
					<xsl:text> </xsl:text>
				</xsl:when>
			</xsl:choose>
		</xsl:if>
		<span class="lbl">
			<xsl:apply-templates/>
		</span>
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
					<span class="q">, </span>
				</xsl:when>
			</xsl:choose>
		</xsl:if>
		<span class="q">
			<xsl:apply-templates/>
		</span>
	</xsl:template>

	<xsl:template match="*"/>

</xsl:stylesheet>
