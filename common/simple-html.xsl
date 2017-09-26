<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:dict="http://dict.hunnor.net" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" exclude-result-prefixes="dict">

	<xsl:template match="dict:hnDict">
		<dictionary>
			<xsl:apply-templates/>
		</dictionary>
	</xsl:template>

	<xsl:template match="dict:entryGrp">
		<xsl:apply-templates/>
	</xsl:template>

	<xsl:template match="dict:entry">
		<entry>
			<xsl:if test="dict:formGrp">
				<forms-html><![CDATA[<![CDATA[]]><xsl:apply-templates select="dict:formGrp"/><![CDATA[]]]]><![CDATA[>]]></forms-html>
			</xsl:if>
			<xsl:if test="dict:senseGrp">
				<translations-html><![CDATA[<![CDATA[]]><xsl:apply-templates select="dict:senseGrp"/><![CDATA[]]]]><![CDATA[>]]></translations-html>
			</xsl:if>
		</entry>
	</xsl:template>

	<xsl:template match="dict:senseGrp">
		<xsl:if test="count(../dict:senseGrp) > 1">
			<xsl:if test="position() > 1">
				<xsl:text> </xsl:text>
			</xsl:if>
			<b>
				<xsl:number value="position()" format="I"/>
			</b>
			<xsl:text> </xsl:text>
		</xsl:if>
		<xsl:apply-templates/>
	</xsl:template>

	<xsl:template match="dict:sense">
		<xsl:if test="count(../dict:sense) > 1">
			<xsl:if test="position() > 1">
				<xsl:text> </xsl:text>
			</xsl:if>
			<b>
				<xsl:number value="position()"/>
			</b>
			<xsl:text> </xsl:text>
		</xsl:if>
		<xsl:apply-templates/>
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

</xsl:stylesheet>
