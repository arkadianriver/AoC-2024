<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:xs="http://www.w3.org/2001/XMLSchema"
	xmlns:gar="urn:arkadianriver.com"
	xmlns:xf="http://www.w3.org/2005/xpath-functions"
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
				<body></body>
				<topic id="aoc-day-{$day}-1">
					<title>Day <xsl:value-of select="$day"/>, part 1</title>
					<body>
						<section>
							<title>Discussion</title>
							<p>Looks like a regular expression task. Doing this in perl, it's a snap:</p>
							<codeblock>perl -0ne '$ttl = 0; while (/mul\((\d{1,3}),(\d{1,3})\)/g) { $ttl += $1 * $2 }; print qq(Total: $ttl\n);' src/data/03/actual.txt
Total: 178538786
							</codeblock>
							<p>I know xslt and xpath have great support for regular expressions, so lemme quickly look up the syntax for this.</p>
						</section>
						<section>
							<title>Solution</title>
							<p>I had this all in one template until I ended up using this same match function
								for part 2. Here's the guts of the match function:
							</p>
							<xsl:call-template name="print-solution-code">
								<xsl:with-param name="solution-name" select="'gar:accum-matches'"/>
								<xsl:with-param name="linenum" select="'91'"/>
							</xsl:call-template>
							<p>And here's the calling template:</p>
							<xsl:call-template name="print-solution-code">
								<xsl:with-param name="solution-name" select="'solution-part-1'"/>
								<xsl:with-param name="linenum" select="'106'"/>
							</xsl:call-template>
							<p>I added a bit more to the test data, particularly to test part 2.</p>
							<xsl:call-template name="solution-part-1"/>
							<xsl:call-template name="solution-part-1">
								<xsl:with-param name="dataset-name" select="'actual'"/>
							</xsl:call-template>
					        <p>TIL a convenient use for the <codeph>for-each-pair</codeph> function.</p>
						</section>
					</body>
				</topic>
				<topic id="aoc-day-{$day}-2">
					<title>Day <xsl:value-of select="$day"/>, part 2</title>
					<body>
						<section>
							<title>Discussion</title>
							<p></p>
						</section>
						<section>
							<title>Solution</title>
							<p>For each <codeph>do()</codeph> line, it uses the same match function as part 1.</p>
							<xsl:call-template name="print-solution-code">
								<xsl:with-param name="solution-name" select="'gar:accum-matches'"/>
								<xsl:with-param name="linenum" select="'91'"/>
							</xsl:call-template>
							<p>The solution first tests if there's a line before a <codeph>do</codeph>
								or <codeph>don't</codeph> function, then runs the <codeph>gar:accum-matches</codeph>
								function on each non-matching line whose preceding match is <codeph>do()</codeph>,
								summing it all up in the end.</p>
							<xsl:call-template name="print-solution-code">
								<xsl:with-param name="solution-name" select="'solution-part-2'"/>
								<xsl:with-param name="linenum" select="'119'"/>
							</xsl:call-template>
							<xsl:call-template name="solution-part-2"/>
							<xsl:call-template name="solution-part-2">
								<xsl:with-param name="dataset-name" select="'actual'"/>
							</xsl:call-template>
						</section>
					</body>
				</topic>
			</topic>
		</xsl:result-document>
	</xsl:template>

	<!-- PART 1 -->

	<xsl:function name="gar:accum-matches" as="xs:double">
		<xsl:param name="the-string"/>
		<xsl:variable name="matches" select="analyze-string($the-string, 'mul\((\d{1,3}),(\d{1,3})\)', 's')"/>
		<xsl:value-of select="
			sum(
				for-each-pair(
					$matches/xf:match/xf:group[@nr='1'],
					$matches/xf:match/xf:group[@nr='2'],
					function($arg1, $arg2) {
						$arg1 * $arg2
					})
			)
		"/>
	</xsl:function>

	<xsl:template name="solution-part-1"><!-- /mul\((\d{1,3}),(\d{1,3})\)/gs -->
		<xsl:param name="dataset-name" select="'test'"/>
		<xsl:variable name="data-doc" select="unparsed-text('file:///'||$srcdir||'/data/'||$day||'/'||$dataset-name||'.txt')"/>
		<xsl:variable name="products-sum" select="gar:accum-matches($data-doc)"/>
		<p><b>Solution to the <xsl:value-of select="$dataset-name"/> data set</b></p>
		<codeblock>
			<xsl:value-of select="format-number($products-sum, '#') (: the format prevents scientific notation :)"/>
		</codeblock>
	</xsl:template>


	<!-- PART 2 -->

	<xsl:template name="solution-part-2">
		<xsl:param name="dataset-name" select="'test'"/>
		<xsl:variable name="data-doc" select="unparsed-text('file:///'||$srcdir||'/data/'||$day||'/'||$dataset-name||'.txt')"/>
		<xsl:variable name="ddt-matches" select="analyze-string($data-doc, '(do\(\)|don''t\(\))', 's')"/>
		 <xsl:variable name="solution" select="
		 	if ($ddt-matches[child::*[1][self::xf:non-match]]) then
				sum((
					gar:accum-matches($ddt-matches/xf:non-match[1]),
					for-each($ddt-matches/xf:non-match[preceding-sibling::xf:match[1]/xf:group[@nr='1'] = 'do()'], function($arg) { gar:accum-matches($arg) })
				))
			else
				sum((
					for-each($ddt-matches/xf:non-match[preceding-sibling::xf:match[1]/xf:group[@nr='1'] = 'do()'], function($arg) { gar:accum-matches($arg) })
				))

		 "/>
		<p><b>Solution to the <xsl:value-of select="$dataset-name"/> data set</b></p>
		<codeblock>
			<xsl:copy-of select="format-number($solution, '#') (: the format prevents scientific notation :)"/>
		</codeblock>
	</xsl:template>

</xsl:stylesheet>