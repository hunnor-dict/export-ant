<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:d="http://dict.hunnor.net">

	<xsl:param name="contentFile"/>
	<xsl:param name="logoFile"/>
	<xsl:param name="inLanguage"/>
	<xsl:param name="outLanguage"/>

	<xsl:template match="d:hnDict">
		<package unique-identifier="uid">
			<metadata>
				<dc-metadata xmlns:dc="http://purl.org/metadata/dublin_core" xmlns:oebpackage="http://openebook.org/namespaces/oeb-package/1.0/">
					<dc:Title>HunNor norvég-magyar szótár</dc:Title>
					<dc:Language>
						<xsl:value-of select="$inLanguage"/>
					</dc:Language>
					<dc:Creator>Barnabás Dávoti</dc:Creator>
					<dc:Description>HunNor norvég-magyar szótár</dc:Description>
					<dc:Date>
						<xsl:value-of select="@updated"/>
					</dc:Date>
				</dc-metadata>
				<x-metadata>
					<output encoding="utf-8" content-type="text/x-oeb1-document"/>
					<EmbeddedCover>
						<xsl:value-of select="$logoFile"/>
					</EmbeddedCover>
					<DictionaryInLanguage>
						<xsl:value-of select="$inLanguage"/>
					</DictionaryInLanguage>
					<DictionaryOutLanguage>
						<xsl:value-of select="$outLanguage"/>
					</DictionaryOutLanguage>
				</x-metadata>
			</metadata>
			<manifest>
				<item id="item1" media-type="text/x-oeb1-document">
					<xsl:attribute name="href" select="$contentFile"/>
				</item>
			</manifest>
			<spine toc="toc">
				<itemref idref="item1"/>
			</spine>
		</package>
	</xsl:template>

</xsl:stylesheet>
