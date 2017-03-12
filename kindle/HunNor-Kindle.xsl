<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE xsl:stylesheet [
<!ENTITY nbsp "&#x00A0;">
]>
<!--
	TODO:
	- inflections are redunant
-->
<xsl:stylesheet version="2.0"
	            xmlns:d="http://dict.hunnor.net"
	            xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	            xmlns:mbp="http://www.mobipocket.com/mbp"
	            xmlns:idx="http://www.mobipocket.com/idx"
	            exclude-result-prefixes="d">
	
	<xsl:output method="xml" indent="yes"/>
	<xsl:strip-space elements="*"/>
	
	<!-- document root -->
	<xsl:template match="d:hnDict">
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
		<xsl:text>&#xA;</xsl:text>
	</xsl:template>

	<!-- grouping by 1st letter -->
	<xsl:template match="d:entryGrp">
		<xsl:apply-templates/>
	</xsl:template>

	<!-- entry -->
	<xsl:template match="d:entry[d:formGrp/d:form[@primary='yes']/d:orth/@n='0' or d:formGrp/d:form[@primary='yes']/d:orth/@n='1']">
		<xsl:variable name="headWord" select="d:formGrp/d:form[@primary='yes']/d:orth"/>
		<idx:entry name="word" scriptable="yes">
			<idx:orth value="{$headWord}">
				<idx:infl>
					<!-- inflections on the 1st orth -->
					<xsl:apply-templates select="d:formGrp/d:form[@primary='no']/d:orth"/>
					<xsl:apply-templates select="d:formGrp/d:form/d:inflPar/d:inflSeq"/>

					<!-- inflections on the other numbered orths if exist -->
					<xsl:if test="d:formGrp/d:form/d:orth/@n='1'">
						<xsl:for-each select="following-sibling::d:entry[d:formGrp/d:form[@primary='yes']/d:orth=$headWord]">
							<xsl:apply-templates select="d:formGrp/d:form[@primary='no']/d:orth"/>
							<xsl:apply-templates select="d:formGrp/d:form/d:inflPar/d:inflSeq"/>
						</xsl:for-each>
					</xsl:if>
				</idx:infl>				
			</idx:orth>
			
			<!-- 1st orth -->
			<xsl:apply-templates select="d:formGrp/d:form[@primary='yes']/d:orth" mode="html"/>
			<xsl:apply-templates select="d:senseGrp"/>
			
			<!-- the other numbered orths if exist -->
			<xsl:if test="d:formGrp/d:form/d:orth/@n='1'">
				<xsl:for-each select="following-sibling::d:entry[d:formGrp/d:form[@primary='yes']/d:orth=$headWord]">
					<xsl:apply-templates select="d:formGrp/d:form[@primary='yes']/d:orth" mode="html"/>
					<xsl:apply-templates select="d:senseGrp"/>
				</xsl:for-each>
			</xsl:if>
		</idx:entry>
	</xsl:template>

	<!-- orth - display the name optionally with n attribute  -->
	<xsl:template match="d:orth" mode="html">
		<br/><br/>
		<b><xsl:value-of select="."/></b>
		<xsl:if test="@n!='0'">
			<sub>(<xsl:value-of select="@n"/>)</sub>
		</xsl:if>
		<xsl:apply-templates select="following-sibling::d:pos" mode="html"/>:
	</xsl:template>

	<!-- pos   -->
	<xsl:template match="d:pos" mode="html">
		<i><xsl:value-of select="."/></i>
	</xsl:template>

	<!-- inflections + secondary forms registered as inflections -->
	<xsl:template match="d:inflSeq | d:formGrp/d:form[@primary='no']/d:orth">
		<idx:iform>
			<xsl:attribute name="value">
				<xsl:value-of select="."/>
			</xsl:attribute>
		</idx:iform>
	</xsl:template>

	<!-- sense group -->
	<xsl:template match="d:senseGrp">
		<xsl:if test="position() > 1">
			<xsl:text> </xsl:text>
		</xsl:if>
		<xsl:if test="count(../d:senseGrp) > 1">
			<br/><xsl:text>&nbsp;&nbsp;</xsl:text>
			<xsl:number value="position()" format="I"/>.
		</xsl:if>
		<xsl:apply-templates/>
	</xsl:template>
	
	<!-- sense -->
	<xsl:template match="d:sense">
		<xsl:text>&nbsp;</xsl:text>
		<xsl:if test="count(../d:sense) > 1">
			<br/><xsl:text>&nbsp;&nbsp;&nbsp;&nbsp;</xsl:text>
			<b><xsl:number value="position()"/>.</b>
			<xsl:text>&nbsp;</xsl:text>
		</xsl:if>
		<xsl:apply-templates/>
	</xsl:template>

	<!-- trans -->
	<xsl:template match="d:sense/d:trans">
		<xsl:choose>
			<xsl:when test="preceding-sibling::d:lbl">
				<xsl:text> </xsl:text>
			</xsl:when>
			<xsl:when test="preceding-sibling::d:trans">
				<xsl:text>, </xsl:text>
			</xsl:when>
			<xsl:when test="preceding-sibling::d:q">
				<xsl:text> </xsl:text>
			</xsl:when>
		</xsl:choose>
		<xsl:apply-templates/>
	</xsl:template>

	<!-- eg - examples -->
	<xsl:template match="d:eg">
		<br/>
		<xsl:apply-templates/>
	</xsl:template>

	<xsl:template match="d:eg/d:q">
		<xsl:text>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;|&nbsp;</xsl:text><i><xsl:value-of select="."/> - </i> 
	</xsl:template>

	<xsl:template match="d:eg/d:trans">
		<xsl:value-of select="."/>
	</xsl:template>

	<!-- ignore these for now -->
	<xsl:template match="d:lbl | d:entry"/>
	
</xsl:stylesheet>

