<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="3.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:dict="http://dict.hunnor.net" exclude-result-prefixes="dict">

	<xsl:output indent="yes" suppress-indentation="value"/>

	<xsl:strip-space elements="*"/>

	<xsl:param name="language"/>

	<!-- Table definitions -->

	<xsl:template match="dict:hnDict">
		<dataset>
			<table name="content">
				<column>id</column>
				<column>language</column>
				<column>pos</column>
				<column>dictForms</column>
				<column>homonyms</column>
				<column>inflectionLabels</column>
				<column>inflectedForms</column>
				<column>translation</column>
				<xsl:apply-templates mode="content"/>
			</table>
			<table name="forms">
				<column>id</column>
				<column>language</column>
				<column>inflected</column>
				<column>form</column>
				<column>form_normalized</column>
				<column>label</column>
				<column>n</column>
				<column>homonym</column>
				<column>sort</column>
				<xsl:apply-templates mode="forms"/>
			</table>
		</dataset>
	</xsl:template>

	<!-- Content table -->

	<xsl:template match="dict:entryGrp" mode="content">
		<xsl:apply-templates mode="content"/>
	</xsl:template>

	<xsl:template match="dict:entry" mode="content">
		<row>
			<!-- id -->
			<value>
				<xsl:value-of select="@id"/>
			</value>
			<!-- language -->
			<value>
				<xsl:value-of select="$language"/>
			</value>
			<!-- pos (only primary form has pos) -->
			<xsl:choose>
				<xsl:when test="dict:formGrp/dict:form/dict:pos[text() != '']">
					<value>
						<xsl:value-of select="dict:formGrp/dict:form/dict:pos"/>
					</value>
				</xsl:when>
				<xsl:otherwise>
					<null/>
				</xsl:otherwise>
			</xsl:choose>
			<!-- dictForms -->
			<value>
				<xsl:text>[</xsl:text>
				<xsl:for-each select="dict:formGrp/dict:form">
					<xsl:if test="position() > 1">
						<xsl:text>, </xsl:text>
					</xsl:if>
					<xsl:text>"</xsl:text>
					<xsl:value-of select="dict:orth"/>
					<xsl:text>"</xsl:text>
				</xsl:for-each>
				<xsl:text>]</xsl:text>
			</value>
			<!-- homonyms -->
			<xsl:choose>
				<xsl:when test="dict:formGrp/dict:form/dict:orth[@n != '0']">
					<value>
						<xsl:text>[</xsl:text>
						<xsl:for-each select="dict:formGrp/dict:form">
							<xsl:if test="position() > 1">
								<xsl:text>, </xsl:text>
							</xsl:if>
							<xsl:text>"</xsl:text>
							<xsl:if test="dict:orth[@n != '0']">
								<xsl:value-of select="dict:orth/@n"/>
							</xsl:if>
							<xsl:text>"</xsl:text>
						</xsl:for-each>
						<xsl:text>]</xsl:text>
					</value>
				</xsl:when>
				<xsl:otherwise>
					<null/>
				</xsl:otherwise>
			</xsl:choose>
			<!-- inflectionLabels -->
			<xsl:choose>
				<xsl:when test="dict:formGrp/dict:form/dict:inflCode[@type = 'suff']">
					<value>
						<xsl:text>[</xsl:text>
						<xsl:for-each select="dict:formGrp/dict:form">
							<xsl:if test="position() > 1">
								<xsl:text>, </xsl:text>
							</xsl:if>
							<xsl:text>"</xsl:text>
							<xsl:value-of select="dict:inflCode[@type = 'suff']"/>
							<xsl:text>"</xsl:text>
						</xsl:for-each>
						<xsl:text>]</xsl:text>
					</value>
				</xsl:when>
				<xsl:otherwise>
					<null/>
				</xsl:otherwise>
			</xsl:choose>
			<!-- inflectedForms -->
			<xsl:choose>
				<xsl:when test="dict:formGrp/dict:form/dict:inflPar/dict:inflSeq">
					<value>
						<xsl:text>[</xsl:text>
						<xsl:for-each select="dict:formGrp/dict:form">
							<xsl:if test="position() > 1">
								<xsl:text>, </xsl:text>
							</xsl:if>
							<xsl:text>[</xsl:text>
							<xsl:for-each select="dict:inflPar">
								<xsl:if test="position() > 1">
									<xsl:text>, </xsl:text>
								</xsl:if>
								<xsl:text>[</xsl:text>
								<xsl:for-each select="dict:inflSeq">
									<xsl:if test="position() > 1">
										<xsl:text>, </xsl:text>
									</xsl:if>
									<xsl:text>"</xsl:text>
									<xsl:value-of select="."/>
									<xsl:text>"</xsl:text>
								</xsl:for-each>
								<xsl:text>]</xsl:text>
							</xsl:for-each>
							<xsl:text>]</xsl:text>
						</xsl:for-each>
						<xsl:text>]</xsl:text>
					</value>
				</xsl:when>
				<xsl:otherwise>
					<null/>
				</xsl:otherwise>
			</xsl:choose>
			<!-- translation -->
			<value>
				<xsl:text disable-output-escaping="yes"><![CDATA[<![CDATA[]]></xsl:text>
				<xsl:apply-templates select="dict:senseGrp"/>
				<xsl:text disable-output-escaping="yes"><![CDATA[]]]]><![CDATA[>]]></xsl:text>
			</value>
		</row>
	</xsl:template>

	<!-- Forms table -->

	<xsl:template match="dict:entryGrp" mode="forms">
		<xsl:apply-templates mode="forms"/>
	</xsl:template>

	<xsl:template match="dict:entry" mode="forms">
		<!-- value of orth is expected to be unique within the entry -->
		<xsl:apply-templates select="dict:formGrp/dict:form/dict:orth"/>
		<!-- inflected forms are not unique -->
		<xsl:variable name="id" select="@id"/>
		<xsl:for-each select="distinct-values(dict:formGrp/dict:form/dict:inflPar/dict:inflSeq)">
			<xsl:call-template name="formsRow">
				<xsl:with-param name="id" select="$id"/>
				<xsl:with-param name="language" select="$language"/>
				<xsl:with-param name="form" select="."/>
				<xsl:with-param name="label" select="''"/>
				<xsl:with-param name="inflected" select="'1'"/>
			</xsl:call-template>
		</xsl:for-each>
	</xsl:template>

	<xsl:template match="dict:orth">
		<xsl:call-template name="formsRow">
			<xsl:with-param name="id" select="../../../@id"/>
			<xsl:with-param name="language" select="$language"/>
			<xsl:with-param name="form" select="."/>
			<xsl:with-param name="n" select="position()"/>
			<xsl:with-param name="homonym" select="@n"/>
			<xsl:with-param name="label" select="../../dict:form[1]/dict:pos"/>
			<xsl:with-param name="inflected" select="'0'"/>
		</xsl:call-template>
	</xsl:template>

	<xsl:template name="formsRow">
		<xsl:param name="id"/>
		<xsl:param name="language"/>
		<xsl:param name="inflected"/>
		<xsl:param name="form"/>
		<xsl:param name="n"/>
		<xsl:param name="homonym"/>
		<xsl:param name="label"/>
		<row>
			<!-- id -->
			<value>
				<xsl:value-of select="$id"/>
			</value>
			<!-- language -->
			<value>
				<xsl:value-of select="$language"/>
			</value>
			<!-- inflected -->
			<value>
				<xsl:value-of select="$inflected"/>
			</value>
			<!-- form -->
			<value>
				<xsl:value-of select="."/>
			</value>
			<!-- form_normalized -->
			<value>
				<xsl:call-template name="form_normalized">
					<xsl:with-param name="value" select="."/>
				</xsl:call-template>
			</value>
			<!-- label -->
			<xsl:choose>
				<xsl:when test="$label != ''">
					<value>
						<xsl:value-of select="$label"/>
					</value>
				</xsl:when>
				<xsl:otherwise>
					<null/>
				</xsl:otherwise>
			</xsl:choose>
			<!-- n -->
			<xsl:choose>
				<xsl:when test="$n">
					<value>
						<xsl:value-of select="$n"/>
					</value>
				</xsl:when>
				<xsl:otherwise>
					<null/>
				</xsl:otherwise>
			</xsl:choose>
			<!-- homonym -->
			<xsl:choose>
				<xsl:when test="$homonym != '' and $homonym != '0'">
					<value>
						<xsl:value-of select="$homonym"/>
					</value>
				</xsl:when>
				<xsl:otherwise>
					<null/>
				</xsl:otherwise>
			</xsl:choose>
			<!-- sort -->
			<value>
				<xsl:call-template name="sort">
					<xsl:with-param name="value" select="."/>
				</xsl:call-template>
			</value>
		</row>
	</xsl:template>

	<!-- Translation HTML -->

	<xsl:template match="dict:senseGrp">
		<div>
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
		</div>
	</xsl:template>

	<xsl:template match="dict:sense">
		<div>
			<xsl:if test="count(../dict:sense) > 1">
				<xsl:attribute name="class" select="'numbered'"/>
				<b>
					<xsl:number value="count(preceding-sibling::dict:sense) + 1"/>
				</b>
				<xsl:text> </xsl:text>
			</xsl:if>
			<xsl:apply-templates/>
		</div>
	</xsl:template>

	<xsl:template match="dict:lbl">
		<xsl:if test="preceding-sibling::dict:*">
			<xsl:variable name="previousTag" select="local-name(preceding-sibling::dict:*[1])"/>
			<xsl:choose>
				<xsl:when test="$previousTag = 'lbl'">
					<i>, </i>
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

	<xsl:template name="form_normalized">
		<xsl:param name="value"/>
		<xsl:variable name="phase1" select="lower-case($value)"/>
		<xsl:variable name="phase2" select="dict:to_ascii($phase1)"/>
		<xsl:value-of select="$phase2"/>
	</xsl:template>

	<xsl:template name="sort">
		<xsl:param name="value"/>
		<xsl:variable name="phase1" select="lower-case($value)"/>
		<xsl:variable name="phase2" select="dict:remove_punctuation($phase1)"/>
		<xsl:value-of select="$phase2"/>
	</xsl:template>

	<xsl:function name="dict:to_ascii">
		<xsl:param name="value"/>
		<xsl:variable name="phase1" select="replace($value, 'æ', 'ae')"/>
		<xsl:variable name="phase2" select="replace($phase1, 'ø', 'o')"/>
		<xsl:variable name="phase3" select="replace(normalize-unicode($phase2, 'NFKD'), '\p{IsCombiningDiacriticalMarks}', '')"/>
		<xsl:value-of select="$phase3"/>
	</xsl:function>

	<xsl:function name="dict:remove_punctuation">
		<xsl:param name="value"/>
		<xsl:variable name="phase1" select="replace($value, ' ', '')"/>
		<xsl:value-of select="$phase1"/>
	</xsl:function>

	<xsl:template match="*"/>

</xsl:stylesheet>
