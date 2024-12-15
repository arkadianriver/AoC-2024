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
							<p>To pair the smallest number in the left list with the smallest number in the right,
							sort the two lists, keeping duplicates.</p>
							<p>Then, to find the total distances between pairs, simply subtract one from another and get absolute value
							(in case negative), then sum.</p>
							<p>How in XSLT. Oh, geez.</p>
							<p>Given the lists are in the same file, side-by-side, let's do this:</p>
							<ol>
								<li>Create two node variables, each by:
									<ol>
										<li>Reading in the file, line-by-line, grabbing whichever side this variable represents.</li>
										<li>Perhaps do it in an XPATH 3 way, sorting and assigning to a single sequence as we go. We'll see.</li>
									</ol>
								</li>
								<li>Now that we have two sorted lists of nodes of the same length, to keep a running total, we need to do that
									recursive business. Call a recursive template that takes sum as param, and the base case is
									to print the sum. Each recursive calls itself on the following-sibling::*[1] with the $sum + $calculated-distance.</li>
							</ol>
							<p>I think that'll do it, let's go!</p>
						</section>
						<section>
							<title>Solution</title>
							<p>Let's see how far I need to deviate from my initial plan to get this thing working.</p>
							<xsl:call-template name="print-solution-code">
								<xsl:with-param name="part" select="'1'"/>
							</xsl:call-template>
							<xsl:call-template name="solution-part-1"/>
							<xsl:call-template name="solution-part-1">
								<xsl:with-param name="dataset-name" select="'actual'"/>
							</xsl:call-template>
							<p>Wow, that was pretty easy with sequences and XPATH 3.1.
							No recursing through nodes and carrying the running total necessary.
							Not at all what I expected.</p>
						</section>
					</body>
				</topic>
				<topic id="aoc-day-{$day}-2">
					<title>Day <xsl:value-of select="$day"/>, part 2</title>
					<body>
						<section>
							<title>Discussion</title>
							<p>Okay, this part is weird. I don't know what it actually solves, but I'm to take every number in the left list,
							count how often it appears in the right list, and multiply the number by how often it's in the right list, Then move
							onto the next left list number, adding all the products together.</p>
							<p>I know what it's testing, how to make the right list a hash lookup table rather than running through it every time.
							Hmm. I think this time, I'll build a node-tree of the right-list and use that as the lookup.
							Not sure how under the covers XSLT optimizes the lookup of matching nodes, but ....</p>
						</section>
						<section>
							<title>Solution</title>
							<xsl:call-template name="print-solution-code">
								<xsl:with-param name="part" select="'2'"/>
							</xsl:call-template>
							<xsl:call-template name="solution-part-2"/>
							<xsl:call-template name="solution-part-2">
								<xsl:with-param name="dataset-name" select="'actual'"/>
							</xsl:call-template>
							<p>Still no real hoops to jump through, but I'm curious if using a node-tree as a lookup is most efficient.</p>
						</section>
					</body>
				</topic>
			</topic>
		</xsl:result-document>
	</xsl:template>


<!-- PART 1 -->

<xsl:template name="solution-part-1">
  <xsl:param name="dataset-name" select="'test'"/>
  <xsl:variable name="data-doc" select="unparsed-text('file:///'||$srcdir||'/data/'||$day||'/'||$dataset-name||'.txt')"/>
  <xsl:variable name="answer" select="
    let $left-list := sort(for $x in tokenize($data-doc, '\n') return tokenize($x, '   ')[1]),
        $right-list := sort(for $x in tokenize($data-doc, '\n') return tokenize($x, '   ')[2])
    return
        sum(for $pos in 1 to count($left-list) return abs(number($left-list[$pos]) - number($right-list[$pos])))
    "/>
  <p><b>Solution to the <xsl:value-of select="$dataset-name"/> data set</b></p>
  <codeblock>
    <xsl:value-of select="format-number($answer, '#')"/>
  </codeblock>
</xsl:template>


<!-- PART 2 -->

<xsl:template name="solution-part-2">
	<xsl:param name="dataset-name" select="'test'"/>
	<xsl:variable name="data-doc" select="unparsed-text('file:///'||$srcdir||'/data/'||$day||'/'||$dataset-name||'.txt')"/>
	<xsl:variable name="right-list">
		<xsl:for-each select="tokenize($data-doc, '\n')">
			<location><xsl:value-of select="tokenize(., '   ')[2]"/></location>
		</xsl:for-each>
	</xsl:variable>
	<xsl:variable name="answer" select="
    let $left-list := for $x in tokenize($data-doc, '\n') return tokenize($x, '   ')[1],
	    $products := sum(for $location in $left-list return number($location) * count($right-list/location[text() = $location]))
    return
        format-number($products, '#')
    "/>
  <p><b>Solution to the <xsl:value-of select="$dataset-name"/> data set</b></p>
  <codeblock>
    <xsl:value-of select="$answer"/>
  </codeblock>
</xsl:template>

</xsl:stylesheet>