<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="3.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:fo="http://www.w3.org/1999/XSL/Format">

	<xsl:output method="xml" indent="yes" suppress-indentation="fo:block"/>

	<xsl:strip-space elements="entry"/>

	<xsl:template match="dictionary">
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
							<fo:block>Frissítve: <xsl:value-of select="@updated"/></fo:block>
							<fo:block>Szócikkek száma: <xsl:value-of select="count(/dictionary/letter/entry)"/></fo:block>
							<fo:block>Forrás: http://dict.hunnor.net/</fo:block>
							<fo:block>A szótárra a GNU Általános Nyilvános Licenc vonatkozik.</fo:block>
						</fo:block>
						<fo:block margin-top="0.25in">
							<fo:block>Oppdatert: <xsl:value-of select="@updated"/></fo:block>
							<fo:block>Antall artikler: <xsl:value-of select="count(/dictionary/letter/entry)"/></fo:block>
							<fo:block>Kilde: http://dict.hunnor.net/</fo:block>
							<fo:block>Ordboka er lisensiert under GNU General Public License.</fo:block>
						</fo:block>
						<fo:block margin-top="0.25in">
							<fo:external-graphic src="url('images/logo-gold.png')"/>
						</fo:block>
					</fo:block>
				</fo:flow>
			</fo:page-sequence>
			<xsl:apply-templates/>
		</fo:root>
	</xsl:template>

	<xsl:template match="letter">
		<fo:page-sequence master-reference="hn-page-body">
			<xsl:if test="@label = 'A'">
				<xsl:attribute name="initial-page-number">1</xsl:attribute>
			</xsl:if>
			<fo:static-content flow-name="xsl-region-before">
				<fo:block text-align="center" font-family="LiberationSerif" font-size="8pt" border-after-width="0.1mm" border-after-style="solid" border-after-color="black">
					<fo:page-number/>
				</fo:block>
			</fo:static-content>
			<fo:flow flow-name="xsl-region-body">
				<fo:block text-align="center" font-family="LiberationSerif" font-size="48pt" font-weight="bold">
					<xsl:value-of select="@label"/>
				</fo:block>
				<xsl:apply-templates/>
			</fo:flow>
		</fo:page-sequence>
	</xsl:template>

	<xsl:template match="entry">
		<fo:block font-family="LiberationSerif" font-size="8pt">
			<xsl:apply-templates/>
		</fo:block>
	</xsl:template>

	<xsl:template match="forms | inflections"/>

	<xsl:template match="forms-html">
		<xsl:apply-templates/>
	</xsl:template>

	<xsl:template match="translations-html">
		<xsl:if test="preceding-sibling::forms-html">
			<xsl:text> </xsl:text>
		</xsl:if>
		<xsl:apply-templates/>
	</xsl:template>

	<xsl:template match="span">
		<xsl:choose>
			<xsl:when test="@class = 'orth' or @class = 'senseGrp-nr' or @class = 'sense-nr'">
				<fo:inline font-weight="bold">
					<xsl:apply-templates/>
				</fo:inline>
			</xsl:when>
			<xsl:when test="@class = 'infl' or @class = 'lbl' or @class = 'q'">
				<fo:inline font-style="italic">
					<xsl:apply-templates/>
				</fo:inline>
			</xsl:when>
			<xsl:when test="@class = 'pos'">
				<fo:inline font-style="italic">
					<xsl:call-template name="pos">
						<xsl:with-param name="original" select="."/>
					</xsl:call-template>
				</fo:inline>
			</xsl:when>
			<xsl:otherwise>
				<xsl:apply-templates/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template name="pos">
		<xsl:param name="original"/>
		<xsl:choose>
			<xsl:when test="$original = 'adj'"><xsl:text>mn</xsl:text></xsl:when>
			<xsl:when test="$original = 'adv'"><xsl:text>htsz</xsl:text></xsl:when>
			<xsl:when test="$original = 'art'"><xsl:text>nvel</xsl:text></xsl:when>
			<xsl:when test="$original = 'fork'"><xsl:text>rv</xsl:text></xsl:when>
			<xsl:when test="$original = 'inf'"><xsl:text></xsl:text></xsl:when>
			<xsl:when test="$original = 'interj'"><xsl:text>ind</xsl:text></xsl:when>
			<xsl:when test="$original = 'konj'"><xsl:text>ktsz</xsl:text></xsl:when>
			<xsl:when test="$original = 'prep'"><xsl:text>elj</xsl:text></xsl:when>
			<xsl:when test="$original = 'pron'"><xsl:text>nvms</xsl:text></xsl:when>
			<xsl:when test="$original = 'subst'"><xsl:text>fn</xsl:text></xsl:when>
			<xsl:when test="$original = 'tall'"><xsl:text>szmn</xsl:text></xsl:when>
			<xsl:when test="$original = 'verb'"><xsl:text>ige</xsl:text></xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="$original"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

</xsl:stylesheet>
