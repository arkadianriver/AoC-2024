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
				<body></body>
				<topic id="aoc-day-{$day}-1">
					<title>Day <xsl:value-of select="$day"/>, part 1</title>
					<body>
						<section>
							<title>Discussion</title>
							<p>Another line-by-line set of data. I think this time I'll try recursion.
							I'll call a template on a line, call an isSafe function on that line's sequence, adding 1 or not to the safe-levels
							variable, which I'll carry as a parameter to the recursive iteration on line+next until there's no +next values left.
							The isSafe function checks first if starts off ascending or descending then evaluates that each subsequent interval meets the criteria.</p>
						</section>
						<section>
							<title>Solution</title>
							<xsl:call-template name="print-solution-code">
								<xsl:with-param name="solution-name" select="'solution-p1'"/>
								<xsl:with-param name="linenum" select="'98'"/>
							</xsl:call-template>
							<xsl:call-template name="print-solution-code">
								<xsl:with-param name="solution-name" select="'check-levels-p1'"/>
								<xsl:with-param name="linenum" select="'119'"/>
							</xsl:call-template>
							<xsl:call-template name="print-solution-code">
								<xsl:with-param name="solution-name" select="'gar:level-increment-p1'"/>
								<xsl:with-param name="linenum" select="'143'"/>
							</xsl:call-template>
							<xsl:message>START Part 1 test: <xsl:value-of select="gar:tstamp()"/></xsl:message>
							<xsl:call-template name="solution-p1"/>
							<xsl:message>END Part 1 test: <xsl:value-of select="gar:tstamp()"/></xsl:message>
							<xsl:message>START Part 1 actual: <xsl:value-of select="gar:tstamp()"/></xsl:message>
							<xsl:call-template name="solution-p1">
								<xsl:with-param name="dataset-name" select="'actual'"/>
							</xsl:call-template>
							<xsl:message>END Part 1 actual: <xsl:value-of select="gar:tstamp()"/></xsl:message>
						</section>
					</body>
				</topic>
				<topic id="aoc-day-{$day}-2">
					<title>Day <xsl:value-of select="$day"/>, part 2</title>
					<body>
						<section>
							<title>Discussion</title>
							<p>Looks like I just need to copy the <codeph>solution</codeph> template, the recursive <codeph>check-levels</codeph>
							template, and change the <codeph>gar:safe-increment()</codeph> function. I'm thinking I could
							save the previous index as I progress down the sequence, and when a condition against the next index fails, try again
							using the previous index, and if that succeeds, drop the _current_ index and move on. But if it fails,
							drop the _next_ index to see if it succeeds. If it does, move on, or else fail altogether.
							one fails. I think.
							Let's have at it.</p>
							<p>Well, after struggling through it, I ended up checking how Daniel Persson solved it and it looks like he had
							a time with it, too. Like he did, I decided to remove each index in sequence and test the sub-sequence (after making
							sure the full sequence didn't already work by indexing at 0), using the <codeph>some in .. satisfies</codeph> to
							exit upon success.
							</p>
						</section>
						<section>
							<title>Solution</title>
							<xsl:call-template name="print-solution-code">
								<xsl:with-param name="solution-name" select="'gar:level-increment-p2'"/>
								<xsl:with-param name="linenum" select="'207'"/>
							</xsl:call-template>
							<xsl:message>START Part 2 test: <xsl:value-of select="gar:tstamp()"/></xsl:message>
							<xsl:call-template name="solution-p2"/>
							<xsl:message>END Part 2 test: <xsl:value-of select="gar:tstamp()"/></xsl:message>
							<xsl:message>START Part 2 actual: <xsl:value-of select="gar:tstamp()"/></xsl:message>
							<xsl:call-template name="solution-p2">
								<xsl:with-param name="dataset-name" select="'actual'"/>
							</xsl:call-template>
							<xsl:message>END Part 2 actual: <xsl:value-of select="gar:tstamp()"/></xsl:message>
						</section>
					</body>
				</topic>
			</topic>
		</xsl:result-document>
	</xsl:template>


	<!-- PART 1 -->

	<xsl:template name="solution-p1">
		<xsl:param name="dataset-name" select="'test'"/>
		<xsl:variable name="data-doc" select="unparsed-text('file:///'||$srcdir||'/data/'||$day||'/'||$dataset-name||'.txt')"/>
		<xsl:variable name="data">
			<xsl:for-each select="tokenize($data-doc, '\n')">
				<levels><xsl:value-of select="."/></levels>
			</xsl:for-each>
		</xsl:variable>
		<xsl:variable name="answer">
			<xsl:call-template name="check-levels-p1">
				<xsl:with-param name="data" select="$data"/>
				<xsl:with-param name="pos" select="1"/>
				<xsl:with-param name="safe-levels" select="0"/>
			</xsl:call-template>
		</xsl:variable>
		<p><b>Solution to the <xsl:value-of select="$dataset-name"/> data set</b></p>
		<codeblock>
			<xsl:value-of select="$answer"/>
		</codeblock>
	</xsl:template>

	<xsl:template name="check-levels-p1">
		<xsl:param name="data"/>
		<xsl:param name="pos"/><!-- linenum -->
		<xsl:param name="safe-levels"/>
		<xsl:variable name="report" select="$data/levels[$pos]/text()"/><!-- line text -->
		<!--
		<xsl:message><xsl:value-of select="'safe-levels: '||$safe-levels||'&#x0a;'"/></xsl:message>
		<xsl:message><xsl:value-of select="'pos: '||$pos||'&#x0a;'"/></xsl:message>
		<xsl:message><xsl:value-of select="'report: '||$report||'&#x0a;'"/></xsl:message>
		-->
		<xsl:choose>
			<xsl:when test="$report != ''">
				<xsl:call-template name="check-levels-p1">
					<xsl:with-param name="data" select="$data"/>
					<xsl:with-param name="pos" select="$pos + 1"/><!-- next linenum -->
					<xsl:with-param name="safe-levels" select="$safe-levels + gar:level-increment-p1($report)"/><!-- test current line and add to previous sum -->
				</xsl:call-template>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="$safe-levels"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:function name="gar:level-increment-p1" as="xs:double">
		<xsl:param name="report" as="xs:string"/><!-- line of text -->
		<xsl:variable name="is-safe" as="xs:boolean">
			<xsl:value-of select="
			let $seq := for $num in tokenize($report, ' ') return number($num),
				$safe-interval := function ($v as xs:double) as xs:boolean { $v &gt; 0 and $v &lt;= 3 }
			return
				if ($seq[1] &lt; $seq[2]) then
					every $x in (1 to count($seq) - 1) satisfies $safe-interval($seq[$x+1] - $seq[$x])
				else
					every $x in (1 to count($seq) - 1) satisfies $safe-interval($seq[$x] - $seq[$x+1])
			"/>
		</xsl:variable>
		<xsl:value-of select="if ($is-safe) then 1 else 0"/><!-- line is safe -->
	</xsl:function>


	<!-- PART 2 -->

	<xsl:template name="solution-p2">
		<xsl:param name="dataset-name" select="'test'"/>
		<xsl:variable name="data-doc" select="unparsed-text('file:///'||$srcdir||'/data/'||$day||'/'||$dataset-name||'.txt')"/>
		<xsl:variable name="data">
			<xsl:for-each select="tokenize($data-doc, '\n')">
				<levels><xsl:value-of select="."/></levels>
			</xsl:for-each>
		</xsl:variable>
		<xsl:variable name="answer">
			<xsl:call-template name="check-levels-p2">
				<xsl:with-param name="data" select="$data"/>
				<xsl:with-param name="pos" select="1"/>
				<xsl:with-param name="safe-levels" select="0"/>
			</xsl:call-template>
		</xsl:variable>
		<p><b>Solution to the <xsl:value-of select="$dataset-name"/> data set</b></p>
		<codeblock>
			<xsl:value-of select="$answer"/>
		</codeblock>
	</xsl:template>

	<xsl:template name="check-levels-p2">
		<xsl:param name="data"/>
		<xsl:param name="pos"/><!-- linenum -->
		<xsl:param name="safe-levels"/>
		<xsl:variable name="report" select="$data/levels[$pos]/text()"/><!-- line text -->
		<!--
		<xsl:message><xsl:value-of select="'safe-levels: '||$safe-levels||'&#x0a;'"/></xsl:message>
		<xsl:message><xsl:value-of select="'pos: '||$pos||'&#x0a;'"/></xsl:message>
		<xsl:message><xsl:value-of select="'report: '||$report||'&#x0a;'"/></xsl:message>
		-->
		<xsl:choose>
			<xsl:when test="$report != ''">
				<xsl:call-template name="check-levels-p2">
					<xsl:with-param name="data" select="$data"/>
					<xsl:with-param name="pos" select="$pos + 1"/><!-- next linenum -->
					<xsl:with-param name="safe-levels" select="$safe-levels + gar:level-increment-p2($report)"/><!-- test current line and add to previous sum -->
				</xsl:call-template>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="$safe-levels"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:function name="gar:level-increment-p2" as="xs:double">
		<xsl:param name="report" as="xs:string"/><!-- line of text -->
		<xsl:variable name="is-safe" as="xs:boolean">
			<xsl:value-of select="
			let $seq := for $num in tokenize($report, ' ') return number($num),
				$safe-interval := function ($v as xs:double) as xs:boolean { $v &gt; 0 and $v &lt;= 3 }
			return
				some $i in (0 to count($seq)) satisfies
					let $sq := remove($seq, $i)
					return
						if ($sq[1] &lt; $sq[2]) then
							every $x in (1 to count($sq) - 1) satisfies $safe-interval($sq[$x+1] - $sq[$x])
						else
							every $x in (1 to count($sq) - 1) satisfies $safe-interval($sq[$x] - $sq[$x+1])
			"/>
		</xsl:variable>
		<xsl:value-of select="if ($is-safe) then 1 else 0"/><!-- line is safe -->
	</xsl:function>

</xsl:stylesheet>