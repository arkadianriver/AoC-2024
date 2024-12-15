<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:xs="http://www.w3.org/2001/XMLSchema"
	xmlns:gar="urn:arkadianriver.com"
	exclude-result-prefixes="xs gar"
	version="3.0">

	<xsl:param name="srcdir"/>
	<xsl:param name="day" select="'00'"/>

	<xsl:output
		method="xml" indent="yes"
		doctype-public="-//OASIS//DTD DITA Topic//EN"	doctype-system="topic"
		cdata-section-elements="gar:cdata"
		/>

	<xsl:template name="master-map">
		<xsl:message>Creating master-map..</xsl:message>
		<xsl:result-document method="xml" 
			doctype-system="map" doctype-public="-//OASIS//DTD DITA Map//EN"
			href="file:///{$srcdir}/topics/map.ditamap">
			<map id="days-of-advent">
				<title>Days of Advent</title>
				<xsl:for-each select="sort(uri-collection('file:///'||$srcdir||'/topics/?select=day-*.dita'))">
					<topicref href="{replace(., 'file:', '')}"/>
				</xsl:for-each>
				<xsl:variable name="day-file" select="$srcdir||'/topics/day-'||$day||'.dita'"/>
				<topicref href="{$day-file}"/>
			</map>
		</xsl:result-document>
	</xsl:template>

	<!-- Utilities -->

	<xsl:function name="gar:init-caps" as="xs:string">
		<xsl:param name="s"/>
		<xsl:value-of select="upper-case(substring($s,1,1))||substring($s,2,string-length($s))"/>
	</xsl:function>

	<xsl:template name="print-solution-code">
		<xsl:param name="part"/>
		<xsl:variable name="xsl-doc" select="doc('file:///'||$srcdir||'/xsl/day-'||$day||'.xsl')"/>
		<codeblock outputclass="example">
		<xsl:text disable-output-escaping="yes">&lt;![CDATA[</xsl:text>
		<xsl:copy-of select="$xsl-doc/xsl:stylesheet/xsl:template[@name='solution-part-'||$part]" copy-namespaces="no"/>
		<xsl:text disable-output-escaping="yes">]]&gt;</xsl:text>
		</codeblock>
	</xsl:template>

</xsl:stylesheet>