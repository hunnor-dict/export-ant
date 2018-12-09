<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="3.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

	<xsl:output method="xml" indent="yes"/>

	<xsl:param name="direction"/>

	<xsl:template match="dictionary">
		<plist version="1.0">
			<dict>
				<key>CFBundleDevelopmentRegion</key>
				<string>Norway</string>
				<key>CFBundleIdentifier</key>
				<string>
					<xsl:text>net.hunnor.dict.apple.</xsl:text>
					<xsl:value-of select="$direction"/>
				</string>
				<key>CFBundleName</key>
				<string>
					<xsl:text>HunNor közösségi szótár </xsl:text>
					<xsl:value-of select="upper-case($direction)"/>
				</string>
				<key>CFBundleShortVersionString</key>
				<string>
					<xsl:value-of select="@updated"/>
				</string>
				<key>DCSDictionaryCopyright</key>
				<string>GNU Általános Nyilvános Licenc</string>
				<key>DCSDictionaryManufacturerName</key>
				<string>HunNor közösségi szótár</string>
			</dict>
		</plist>
	</xsl:template>

</xsl:stylesheet>
