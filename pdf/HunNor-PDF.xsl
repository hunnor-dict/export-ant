<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:dict="http://dict.hunnor.net" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:fo="http://www.w3.org/1999/XSL/Format">

	<xsl:output method="xml" indent="yes"/>

	<xsl:strip-space elements="*"/>

	<xsl:template match="dict:hnDict">
		<fo:root>
			<fo:layout-master-set>
				<fo:simple-page-master master-name="hn-page-head" page-height="9in" page-width="6in" margin="0.5in">
					<fo:region-body/>
				</fo:simple-page-master>
				<fo:simple-page-master master-name="hn-page-body" page-height="9in" page-width="6in" margin="0.5in">
					<fo:region-body column-count="2" margin-top="0.25in"/>
					<fo:region-before extent="1cm"/>
				</fo:simple-page-master>
			</fo:layout-master-set>
			<fo:declarations>
				<x:xmpmeta xmlns:x="adobe:ns:meta/">
					<rdf:RDF xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#">
						<rdf:Description rdf:about="" xmlns:dc="http://purl.org/dc/elements/1.1/">
							<!-- Dublin Core Properties -->
							<dc:title>HunNor közösségi szótár</dc:title>
							<dc:creator>HunNor szerk.</dc:creator>
							<dc:description>norvég-magyar/magyar-norvég közösségi szótár</dc:description>
						</rdf:Description>
						<rdf:Description rdf:about="" xmlns:xmp="http://ns.adobe.com/xap/1.0/">
							<!-- XMP Properties -->
							<xmp:CreatorTool>Apache FOP</xmp:CreatorTool>
						</rdf:Description>
					</rdf:RDF>
				</x:xmpmeta>
			</fo:declarations>
			<fo:page-sequence master-reference="hn-page-head">
				<fo:flow flow-name="xsl-region-body">
					<fo:block text-align="center" font-family="LiberationSerif" font-weight="bold">
						<fo:block margin-top="0.75in">
							<fo:block font-size="28pt">
								<fo:inline>NORVÉG-MAGYAR</fo:inline>
							</fo:block>
							<fo:block font-size="24pt">
								<fo:inline>KÖZÖSSÉGI SZÓTÁR</fo:inline>
							</fo:block>
						</fo:block>
						<fo:block margin-top="0.75in">
							<fo:block font-size="28pt">
								<fo:inline>NORSK-UNGARSK</fo:inline>
							</fo:block>
							<fo:block font-size="24pt">
								<fo:inline>NETTORDBOK</fo:inline>
							</fo:block>
						</fo:block>
					</fo:block>
				</fo:flow>
			</fo:page-sequence>
			<fo:page-sequence master-reference="hn-page-head">
				<fo:flow flow-name="xsl-region-body">
					<fo:block text-align="center" font-family="LiberationSerif" font-size="12pt" margin-top="5in">
						<fo:block margin-top="0.25in">
							<fo:block>Frissítve: <xsl:value-of select="/dict:hnDict/@updated"/></fo:block>
							<fo:block>Szócikkek száma: <xsl:value-of select="count(//dict:entry)"/></fo:block>
							<fo:block>Forrás: http://dict.hunnor.net/</fo:block>
							<fo:block>A szótárra a GNU Általános Nyilvános Licenc vonatkozik.</fo:block>
						</fo:block>
						<fo:block margin-top="0.25in">
							<fo:block>Oppdatert: <xsl:value-of select="/dict:hnDict/@updated"/></fo:block>
							<fo:block>Antall artikler: <xsl:value-of select="count(//dict:entry)"/></fo:block>
							<fo:block>Kilde: http://dict.hunnor.net/</fo:block>
							<fo:block>Ordboka er lisensiert under GNU General Public License.</fo:block>
						</fo:block>
						<fo:block margin-top="0.25in">
							<fo:external-graphic src="url('../pdf/HunNor-Logo.png')"/>
						</fo:block>
					</fo:block>
				</fo:flow>
			</fo:page-sequence>
			<xsl:apply-templates/>
		</fo:root>
	</xsl:template>

	<xsl:template match="dict:entryGrp">
		<xsl:if test="@head='A'">
		<fo:page-sequence master-reference="hn-page-body" initial-page-number="1">
			<fo:static-content flow-name="xsl-region-before">
				<fo:block text-align="center" font-family="LiberationSerif" font-size="8pt" border-after-width="0.1mm" border-after-style="solid" border-after-color="black">
					<fo:page-number/>
				</fo:block>
			</fo:static-content>
			<fo:flow flow-name="xsl-region-body">
				<fo:block text-align="center" font-family="LiberationSerif" font-size="48pt" font-weight="bold">
					<xsl:value-of select="@head"/>
				</fo:block>
				<xsl:apply-templates/>
			</fo:flow>
		</fo:page-sequence>
		</xsl:if>
		<xsl:if test="@head!='A'">
		<fo:page-sequence master-reference="hn-page-body">
			<fo:static-content flow-name="xsl-region-before">
				<fo:block text-align="center" font-family="LiberationSerif" font-size="8pt" border-after-width="0.1mm" border-after-style="solid" border-after-color="black">
					<fo:page-number/>
				</fo:block>
			</fo:static-content>
			<fo:flow flow-name="xsl-region-body">
				<fo:block text-align="center" font-family="LiberationSerif" font-size="48pt" font-weight="bold">
					<xsl:value-of select="@head"/>
				</fo:block>
				<xsl:apply-templates/>
			</fo:flow>
		</fo:page-sequence>
		</xsl:if>
	</xsl:template>

	<xsl:template match="dict:entry">
		<fo:block font-family="LiberationSerif" font-size="8pt">
			<xsl:apply-templates/>
		</fo:block>
	</xsl:template>

	<xsl:template match="dict:orth">
		<xsl:if test="count(parent::dict:form/preceding-sibling::dict:form) > 0">
			<xsl:text> </xsl:text>
		</xsl:if>
		<fo:inline font-weight="bold">
			<xsl:apply-templates/>
		</fo:inline>
		<xsl:if test="@n > 0">
			<fo:inline baseline-shift="sub" font-size="6pt">
				<xsl:value-of select="@n"/>
			</fo:inline>
		</xsl:if>
	</xsl:template>

	<xsl:template match="dict:pos">
		<fo:inline font-style="italic">
			<xsl:text> </xsl:text>
			<xsl:choose>
				<xsl:when test="self::node()[text()='adj']"><xsl:text>mn</xsl:text></xsl:when>
				<xsl:when test="self::node()[text()='adv']"><xsl:text>htsz</xsl:text></xsl:when>
				<xsl:when test="self::node()[text()='art']"><xsl:text>nvel</xsl:text></xsl:when>
				<xsl:when test="self::node()[text()='fork']"><xsl:text>rv</xsl:text></xsl:when>
				<xsl:when test="self::node()[text()='inf']"><xsl:text></xsl:text></xsl:when>
				<xsl:when test="self::node()[text()='interj']"><xsl:text>ind</xsl:text></xsl:when>
				<xsl:when test="self::node()[text()='konj']"><xsl:text>ktsz</xsl:text></xsl:when>
				<xsl:when test="self::node()[text()='prep']"><xsl:text>elj</xsl:text></xsl:when>
				<xsl:when test="self::node()[text()='pron']"><xsl:text>nvms</xsl:text></xsl:when>
				<xsl:when test="self::node()[text()='subst']"><xsl:text>fn</xsl:text></xsl:when>
				<xsl:when test="self::node()[text()='tall']"><xsl:text>szmn</xsl:text></xsl:when>
				<xsl:when test="self::node()[text()='verb']"><xsl:text>ige</xsl:text></xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="self"/>
				</xsl:otherwise>
			</xsl:choose>
		</fo:inline>
	</xsl:template>

	<xsl:template match="dict:inflCode">
		<xsl:if test="@type = 'suff'">
			<xsl:text> </xsl:text>
			<xsl:apply-templates/>
		</xsl:if>
	</xsl:template>

	<xsl:template match="dict:inflPar">
		<xsl:if test="not(preceding-sibling::dict:inflCode)">
			<fo:inline font-style="italic">
				<xsl:if test="not(preceding-sibling::dict:inflPar)">
					<xsl:text> (</xsl:text>
				</xsl:if>
				<xsl:if test="preceding-sibling::dict:inflPar">
					<xsl:text>; </xsl:text>
				</xsl:if>
				<xsl:apply-templates/>
				<xsl:if test="not(following-sibling::dict:inflPar)">
					<xsl:text>)</xsl:text>
				</xsl:if>
			</fo:inline>
		</xsl:if>
	</xsl:template>

	<xsl:template match="dict:inflSeq">
		<xsl:if test="position() > 1">
			<xsl:text>, </xsl:text>
		</xsl:if>
		<xsl:apply-templates/>
	</xsl:template>

	<xsl:template match="dict:senseGrp">
		<xsl:if test="count(../dict:senseGrp) > 1">
			<fo:inline font-weight="bold">
				<xsl:text> </xsl:text>
				<xsl:number value="position()-1" format="I"/>
			</fo:inline>
		</xsl:if>
		<xsl:apply-templates/>
	</xsl:template>

	<xsl:template match="dict:sense">
		<xsl:if test="count(../dict:sense) > 1">
			<fo:inline font-weight="bold">
				<xsl:text> </xsl:text>
				<xsl:number value="position()"/>
			</fo:inline>
		</xsl:if>
		<xsl:apply-templates/>
	</xsl:template>

	<xsl:template match="dict:lbl"/>

	<xsl:template match="dict:trans">
		<xsl:if test="preceding-sibling::dict:trans">
			<xsl:text>,</xsl:text>
		</xsl:if>
		<xsl:text> </xsl:text>
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
		<fo:inline font-style="italic">
			<xsl:apply-templates/>
		</fo:inline>
	</xsl:template>

</xsl:stylesheet>
