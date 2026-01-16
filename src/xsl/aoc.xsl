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

	<xsl:function name="gar:tstamp">
		<!-- <xsl:param name="now"/>
		<xsl:value-of select="format-dateTime($now, '[Y0001]-[M01]-[D01] [h01]:[m01]:[s01].[f001]')"/> -->
		<xsl:value-of select="seconds-from-dateTime(current-dateTime())"/>
	</xsl:function>

	<xsl:function name="gar:init-caps" as="xs:string">
		<xsl:param name="s"/>
		<xsl:value-of select="upper-case(substring($s,1,1))||substring($s,2,string-length($s))"/>
	</xsl:function>

	<xsl:template name="print-solution-code">
		<xsl:param name="solution-name"/>
		<xsl:param name="linenum"/>
		<xsl:variable name="xsl-doc" select="doc('file:///'||$srcdir||'/xsl/day-'||$day||'.xsl')"/>
		<p>See formatted solution code on GitHub:
		<xref scope="external" href="https://github.com/arkadianriver/AoC-2024/blob/main/src/xsl/day-{$day}.xsl#L{$linenum}">
			<xsl:value-of select="$solution-name||', line '||$linenum"/>
		</xref>.</p>
		<!-- <codeblock outputclass="example">
		<xsl:text disable-output-escaping="yes">&lt;![CDATA[</xsl:text>
		<xsl:choose>
			<xsl:when test="starts-with($solution-name, 'gar:')">
				<xsl:copy-of select="$xsl-doc/xsl:stylesheet/xsl:function[@name=$solution-name]" copy-namespaces="no"/>	
			</xsl:when>
			<xsl:otherwise>
				<xsl:copy-of select="$xsl-doc/xsl:stylesheet/xsl:template[@name=$solution-name]" copy-namespaces="no"/>
			</xsl:otherwise>		
		</xsl:choose>
		<xsl:text disable-output-escaping="yes">]]&gt;</xsl:text>
		</codeblock> -->
	</xsl:template>

</xsl:stylesheet>