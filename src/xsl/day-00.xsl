<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:xs="http://www.w3.org/2001/XMLSchema"
	xmlns:gar="urn:arkadianriver.com"
	exclude-result-prefixes="xs gar"
	version="3.0">

	<xsl:import href="aoc.xsl"/>

	<xsl:template name="xsl:initial-template">
		<xsl:call-template name="master-map"/>
		<xsl:message>Running day-<xsl:value-of select="$day"/>..</xsl:message>
		<xsl:result-document method="xml" indent="yes" href="file:///{$srcdir}/topics/day-{$day}.dita"
			cdata-section-elements="gar:cdata"
			doctype-public="-//OASIS//DTD DITA Topic//EN" doctype-system="topic">
			<topic id="aoc-day-{$day}">
				<title>Day <xsl:value-of select="$day"/></title>
				<shortdesc><xref scope="external" href="https://adventofcode.com/2024/day/{string(number($day))}">Problem statement on the web</xref>.</shortdesc>
				<body>
					<p>Discussion. blah, blah...</p>
				</body>
				<topic id="aoc-day-{$day}-1">
					<title>Day <xsl:value-of select="$day"/>, part 1</title>
					<body>
						<section>
							<title>Discussion</title>
							<p></p>
						</section>
						<section>
							<title>Solution</title>
							<xsl:call-template name="print-solution-code">
								<xsl:with-param name="part" select="'1'"/>
							</xsl:call-template>
							<xsl:call-template name="solution-part-1"/>
							<xsl:call-template name="solution-part-1">
								<xsl:with-param name="dataset-name" select="'actual'"/>
							</xsl:call-template>
						</section>
					</body>
				</topic>
				<!-- <topic id="aoc-day-{$day}-2">
					<title>Day <xsl:value-of select="$day"/>, part 2</title>
					<body>
						<section>
							<title>Discussion</title>
							<p></p>
						</section>
						<section>
							<title>Solution</title>
							<xsl:call-template name="print-solution-code">
								<xsl:with-param name="part" select="'1'"/>
							</xsl:call-template>
							<xsl:call-template name="solution-part-1"/>
							<xsl:call-template name="solution-part-1">
								<xsl:with-param name="dataset-name" select="'actual'"/>
							</xsl:call-template>
						</section>
					</body>
				</topic>
			</topic> -->
		</xsl:result-document>
	</xsl:template>

	<!-- PART 1 -->

	<xsl:template name="solution-part-1">
		<xsl:param name="dataset-name" select="'test'"/>
		<xsl:variable name="data-doc" select="unparsed-text('file:///'||$srcdir||'/data/'||$day||'/'||$dataset-name||'.txt')"/>
		<xsl:variable name="answer" select=""/>
		<p><b>Solution to the <xsl:value-of select="$dataset-name"/> data set</b></p>
		<codeblock>
			<xsl:value-of select="$answer"/>
		</codeblock>
	</xsl:template>


	<!-- PART 2 -->

	<!-- <xsl:template name="solution-part-2">
		<xsl:param name="dataset-name" select="'test'"/>
		<xsl:variable name="data-doc" select="unparsed-text('file:///'||$srcdir||'/data/'||$day||'/'||$dataset-name||'.txt')"/>
		<xsl:variable name="answer" select=""/>
		<p><b>Solution to the <xsl:value-of select="$dataset-name"/> data set</b></p>
		<codeblock>
	    	<xsl:value-of select="$answer"/>
		</codeblock>
	</xsl:template> -->

</xsl:stylesheet>