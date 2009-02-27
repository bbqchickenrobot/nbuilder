<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:msxsl="urn:schemas-microsoft-com:xslt">
	<!-- Created for NCoverExplorer by Grant Drake (see http://www.kiwidude.com/blog/)	-->
	<xsl:output method="html" doctype-system="http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd" doctype-public="-//W3C//DTD XHTML 1.0 Transitional//EN"/>
	
	<xsl:template match="/">
		<html>
			<head>
				<xsl:comment>Generated by NCoverExplorer (see http://www.kiwidude.com/blog/)</xsl:comment>
				<title>NCoverExplorer - Merged Report</title>
				<style>
					body 						{ font: small verdana, arial, helvetica; color:#000000;	}
					.coverageReportTable		{ font-size: 9px; }
					.reportHeader 				{ padding: 5px 8px 5px 8px; font-size: 12px; border: 1px solid; margin: 0px;	}
					.titleText					{ font-weight: bold; font-size: 12px; white-space: nowrap; padding: 0px; margin: 1px; }
					.subtitleText 				{ font-size: 9px; font-weight: normal; padding: 0px; margin: 1px; white-space: nowrap; }
					.projectStatistics			{ font-size: 10px; border-left: #649cc0 1px solid; white-space: nowrap;	width: 40%;	}
					.heading					{ font-weight: bold; }
					.mainTableHeaderLeft 		{ border: #dcdcdc 1px solid; font-weight: bold;	padding-left: 5px; }
					.mainTableHeader 			{ border-bottom: 1px solid; border-top: 1px solid; border-right: 1px solid;	text-align: center;	}
					.mainTableGraphHeader 		{ border-bottom: 1px solid; border-top: 1px solid; border-right: 1px solid;	text-align: left; font-weight: bold; }
					.mainTableCellItem 			{ background: #ffffff; border-left: #dcdcdc 1px solid; border-right: #dcdcdc 1px solid; padding-left: 10px; padding-right: 10px; font-weight: bold; font-size: 10px; }
					.mainTableCellData 			{ background: #ffffff; border-right: #dcdcdc 1px solid;	text-align: center;	white-space: nowrap; }
					.mainTableCellPercent 		{ background: #ffffff; font-weight: bold; white-space: nowrap; text-align: right; padding-left: 10px; }
					.mainTableCellGraph 		{ background: #ffffff; border-right: #dcdcdc 1px solid; padding-right: 5px; }
					.mainTableCellBottom		{ border-bottom: #dcdcdc 1px solid;	}
					.childTableHeader 			{ border-top: 1px solid; border-bottom: 1px solid; border-left: 1px solid; border-right: 1px solid;	font-weight: bold; padding-left: 10px; }
					.childTableCellIndentedItem { background: #ffffff; border-left: #dcdcdc 1px solid; border-right: #dcdcdc 1px solid; padding-right: 10px; font-size: 10px; }		
					.exclusionTableCellItem 	{ background: #ffffff; border-left: #dcdcdc 1px solid; border-right: #dcdcdc 1px solid; padding-left: 10px; padding-right: 10px; }
					.projectTable				{ background: #a9d9f7; border-color: #649cc0; }
					.primaryTable				{ background: #d7eefd; border-color: #a4dafc; }
					.secondaryTable 			{ background: #f9e9b7; border-color: #f6d376; }
					.secondaryChildTable 		{ background: #fff6df; border-color: #f5e1b1; }
					.exclusionTable				{ background: #fadada; border-color: #f37f7f; }
					.graphBarNotVisited			{ font-size: 2px; border:#9c9c9c 1px solid; background:#df0000; }
					.graphBarSatisfactory		{ font-size: 2px; border:#9c9c9c 1px solid;	background:#f4f24e; }
					.graphBarVisited			{ background: #00df00; font-size: 2px; border-left:#9c9c9c 1px solid; border-top:#9c9c9c 1px solid; border-bottom:#9c9c9c 1px solid; }
					.graphBarVisitedFully		{ background: #00df00; font-size: 2px; border:#9c9c9c 1px solid; }
				</style>
			</head>
			<body>
				<table class="coverageReportTable" cellpadding="2" cellspacing="0">
					<tbody>
					<xsl:apply-templates select="//coverageReport" />
					</tbody>
				</table>
			</body>
		</html>
	</xsl:template>
	
	<!-- Main Project Section -->
	<xsl:template match="//coverageReport">
		<xsl:variable name="reportType" select="./@reportTitle" />
		<xsl:variable name="threshold">
			<xsl:choose>
				<xsl:when test="$reportType = 'Module Class Function Summary'"><xsl:value-of select="./project/@acceptableFunction" /></xsl:when>
				<xsl:otherwise><xsl:value-of select="./project/@acceptable" /></xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:variable name="unvisitedTitle">
			<xsl:choose>
				<xsl:when test="$reportType = 'Module Class Function Summary'">Unvisited Functions</xsl:when>
				<xsl:otherwise>Unvisited SeqPts</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
 		<xsl:variable name="coverageTitle">
			<xsl:choose>
				<xsl:when test="$reportType = 'Module Class Function Summary'">Function Coverage</xsl:when>
				<xsl:otherwise>Coverage</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
   
		<xsl:call-template name="header" />
    
		<xsl:call-template name="projectSummary">
			<xsl:with-param name="threshold" select="$threshold" />
			<xsl:with-param name="unvisitedTitle" select="$unvisitedTitle" />
			<xsl:with-param name="coverageTitle" select="$coverageTitle" />
			<xsl:with-param name="reportType" select="$reportType" />
		</xsl:call-template>
        
		<xsl:if test="$reportType != 'Namespace Summary'">
			<xsl:call-template name="moduleSummary">
				<xsl:with-param name="threshold" select="$threshold" />
				<xsl:with-param name="unvisitedTitle" select="$unvisitedTitle" />
				<xsl:with-param name="coverageTitle" select="$coverageTitle" />
			</xsl:call-template>
		</xsl:if>
    
		<xsl:if test="$reportType = 'Module Namespace Summary'">
			<xsl:call-template name="moduleNamespaceSummary">
				<xsl:with-param name="threshold" select="$threshold" />
			</xsl:call-template>
		</xsl:if>
    
		<xsl:if test="($reportType = 'Module Class Summary') or ($reportType = 'Module Class Function Summary')">
			<xsl:call-template name="classModuleSummary">
				<xsl:with-param name="threshold" select="$threshold" />
				<xsl:with-param name="unvisitedTitle" select="$unvisitedTitle" />
				<xsl:with-param name="coverageTitle" select="$coverageTitle" />
			</xsl:call-template>
		</xsl:if>
   
		<xsl:if test="$reportType = 'Namespace Summary'">
			<xsl:call-template name="namespaceSummary">
				<xsl:with-param name="threshold" select="$threshold" />
			</xsl:call-template>
		</xsl:if>
    
		<xsl:if test="count(./exclusions/exclusion) != 0">
			<xsl:call-template name="exclusionsSummary" />
		</xsl:if>
    
		<xsl:call-template name="footer" />  
  </xsl:template>

	
	<!-- Report Header -->
	<xsl:template name="header">
				<tr>
					<td class="projectTable reportHeader" colspan="5">
						<table width="100%">
							<tbody>
								<tr>
									<td valign="top">
										<h1 class="titleText">NCoverExplorer Coverage Report - <xsl:value-of select="./project/@name" />&#160;&#160;</h1>
										<table cellpadding="1" class="subtitleText">
											<tbody>
												<tr>
													<td class="heading">Report generated on:</td>
													<td><xsl:value-of select="./@date" />&#160;at&#160;<xsl:value-of select="./@time" /></td>
												</tr>
												<tr>
													<td class="heading">NCoverExplorer version:</td>
													<td><xsl:value-of select="./@version" /></td>
												</tr>
												<tr>
													<td class="heading">Filtering / Sorting:</td>
													<td><xsl:value-of select="./project/@filteredBy" />&#160;/&#160;<xsl:value-of select="./project/@sortedBy" /></td>
												</tr>
											</tbody>
										</table>
									</td>
									<td class="projectStatistics" align="right" valign="top">
										<table cellpadding="1">
											<tbody>
												<tr>
													<td rowspan="4" valign="top" nowrap="true" class="heading">Project Statistics:</td>
													<td align="right" class="heading">Files:</td>
													<td align="right"><xsl:value-of select="./project/@files" /></td>
													<td rowspan="4">&#160;</td>
													<td align="right" class="heading">NCLOC:</td>
													<td align="right"><xsl:value-of select="./project/@nonCommentLines" /></td>
												</tr>
												<tr>
													<td align="right" class="heading">Classes:</td>
													<td align="right"><xsl:value-of select="./project/@classes" /></td>
													<td align="right" class="heading">&#160;</td>
													<td align="right">&#160;</td>
												</tr>
												<tr>
													<td align="right" class="heading">Functions:</td>
													<td align="right"><xsl:value-of select="./project/@members" /></td>
													<td align="right" class="heading">Unvisited:</td>
													<td align="right"><xsl:value-of select="./project/@unvisitedFunctions" /></td>
												</tr>
												<tr>
													<td align="right" class="heading">Seq Pts:</td>
													<td align="right"><xsl:value-of select="./project/@sequencePoints" /></td>
													<td align="right" class="heading">Unvisited:</td>
													<td align="right"><xsl:value-of select="./project/@unvisitedPoints" /></td>
												</tr>
											</tbody>
										</table>
									</td>
								</tr>
							</tbody>
						</table>
					</td>
				</tr>
	</xsl:template>
	
	<!-- Project Summary -->
	<xsl:template name="projectSummary">
		<xsl:param name="threshold" />
		<xsl:param name="unvisitedTitle" />
		<xsl:param name="coverageTitle" />
		<xsl:param name="reportType" />
				<tr>
					<td colspan="5">&#160;</td>
				</tr>
				<tr>
					<td class="projectTable mainTableHeaderLeft">Project</td>
					<td class="projectTable mainTableHeader">Acceptable</td>
					<td class="projectTable mainTableHeader"><xsl:value-of select="$unvisitedTitle" /></td>
					<td class="projectTable mainTableGraphHeader" colspan="2"><xsl:value-of select="$coverageTitle" /></td>
				</tr>
			<xsl:call-template name="coverageDetail">
				<xsl:with-param name="name" select="./project/@name" />
				<xsl:with-param name="unvisitedPoints">
					<xsl:choose>
						<xsl:when test="$reportType = 'Module Class Function Summary'"><xsl:value-of select="./project/@unvisitedFunctions" /></xsl:when>
						<xsl:otherwise><xsl:value-of select="./project/@unvisitedPoints" /></xsl:otherwise>
					</xsl:choose>
				</xsl:with-param>
				<xsl:with-param name="sequencePoints">
					<xsl:choose>
						<xsl:when test="$reportType = 'Module Class Function Summary'"><xsl:value-of select="./project/@members" /></xsl:when>
						<xsl:otherwise><xsl:value-of select="./project/@sequencePoints" /></xsl:otherwise>
					</xsl:choose>
				</xsl:with-param>
				<xsl:with-param name="coverage">
					<xsl:choose>
						<xsl:when test="$reportType = 'Module Class Function Summary'"><xsl:value-of select="./project/@functionCoverage" /></xsl:when>
						<xsl:otherwise><xsl:value-of select="./project/@coverage" /></xsl:otherwise>
					</xsl:choose>
				</xsl:with-param>
				<xsl:with-param name="threshold" select="$threshold" />
				<xsl:with-param name="showThreshold">True</xsl:with-param>
			</xsl:call-template>
	</xsl:template>
		
	<!-- Modules Summary -->
	<xsl:template name="moduleSummary">
		<xsl:param name="threshold" />
		<xsl:param name="unvisitedTitle" />
		<xsl:param name="coverageTitle" />
				<tr>
					<td colspan="5">&#160;</td>
				</tr>
				<tr>
					<td class="primaryTable mainTableHeaderLeft">Modules</td>
					<td class="primaryTable mainTableHeader">Acceptable</td>
					<td class="primaryTable mainTableHeader"><xsl:value-of select="$unvisitedTitle" /></td>
					<td class="primaryTable mainTableGraphHeader" colspan="2"><xsl:value-of select="$coverageTitle" /></td>
				</tr>				
		<xsl:for-each select="./modules/module">
			<xsl:call-template name="coverageDetail">
				<xsl:with-param name="name" select="./@name" />
				<xsl:with-param name="unvisitedPoints" select="./@unvisitedPoints" />
				<xsl:with-param name="sequencePoints" select="./@sequencePoints" />
				<xsl:with-param name="coverage" select="./@coverage" />
				<xsl:with-param name="threshold" select="./@acceptable" />
				<xsl:with-param name="showThreshold">True</xsl:with-param>
			</xsl:call-template>
		</xsl:for-each>
	</xsl:template>
		
	<!-- Namespaces per Module Summary -->
	<xsl:template name="moduleNamespaceSummary">
		<xsl:param name="threshold" />
		<xsl:for-each select="./modules/module">
				<tr>
					<td colspan="5">&#160;</td>
				</tr>
				<tr>
					<td class="secondaryTable mainTableHeaderLeft">Module</td>
					<td class="secondaryTable mainTableHeader">Acceptable</td>
					<td class="secondaryTable mainTableHeader">Unvisited SeqPts</td>
					<td class="secondaryTable mainTableGraphHeader" colspan="2">Coverage</td>
				</tr>				
			<xsl:call-template name="coverageDetailSecondary">
				<xsl:with-param name="name" select="./@name" />
				<xsl:with-param name="unvisitedPoints" select="./@unvisitedPoints" />
				<xsl:with-param name="sequencePoints" select="./@sequencePoints" />
				<xsl:with-param name="coverage" select="./@coverage" />
				<xsl:with-param name="threshold" select="./@acceptable" />
			</xsl:call-template>
				<tr>
					<td class="secondaryChildTable childTableHeader" colspan="5">Namespaces</td>
				</tr>				
			<xsl:for-each select="./namespace">
				<xsl:call-template name="coverageIndentedDetail">
					<xsl:with-param name="name" select="./@name" />
					<xsl:with-param name="unvisitedPoints" select="./@unvisitedPoints" />
					<xsl:with-param name="sequencePoints" select="./@sequencePoints" />
					<xsl:with-param name="coverage" select="./@coverage" />
					<xsl:with-param name="threshold" select="./../@acceptable" />
				</xsl:call-template>
			</xsl:for-each>
		</xsl:for-each>
	</xsl:template>
		
	<!-- Classes per Namespace per Module Summary -->
	<xsl:template name="classModuleSummary">
		<xsl:param name="threshold" />
		<xsl:param name="unvisitedTitle" />
		<xsl:param name="coverageTitle" />
		<xsl:for-each select="./modules/module">
				<tr>
					<td colspan="5">&#160;</td>
				</tr>
				<tr>
					<td class="secondaryTable mainTableHeaderLeft">Module</td>
					<td class="secondaryTable mainTableHeader">Acceptable</td>
					<td class="secondaryTable mainTableHeader"><xsl:value-of select="$unvisitedTitle" /></td>
					<td class="secondaryTable mainTableGraphHeader" colspan="2"><xsl:value-of select="$coverageTitle" /></td>
				</tr>				
			<xsl:call-template name="coverageDetailSecondary">
				<xsl:with-param name="name" select="./@name" />
				<xsl:with-param name="unvisitedPoints" select="./@unvisitedPoints" />
				<xsl:with-param name="sequencePoints" select="./@sequencePoints" />
				<xsl:with-param name="coverage" select="./@coverage" />
				<xsl:with-param name="threshold" select="./@acceptable" />
			</xsl:call-template>
				<tr>
					<td class="secondaryChildTable childTableHeader" colspan="5">Namespace / Classes</td>
				</tr>				
			<xsl:for-each select="./namespace">
				<xsl:call-template name="coverageIndentedDetail">
					<xsl:with-param name="name" select="./@name" />
					<xsl:with-param name="unvisitedPoints" select="./@unvisitedPoints" />
					<xsl:with-param name="sequencePoints" select="./@sequencePoints" />
					<xsl:with-param name="coverage" select="./@coverage" />
					<xsl:with-param name="threshold" select="../@acceptable" />
					<xsl:with-param name="styleTweak">padding-left:20px;font-weight:bold</xsl:with-param>
				</xsl:call-template>
				<xsl:for-each select="./class">
					<xsl:call-template name="coverageIndentedDetail">
						<xsl:with-param name="name" select="./@name" />
						<xsl:with-param name="unvisitedPoints" select="./@unvisitedPoints" />
						<xsl:with-param name="sequencePoints" select="./@sequencePoints" />
						<xsl:with-param name="coverage" select="./@coverage" />
						<xsl:with-param name="threshold" select="../../@acceptable" />
						<xsl:with-param name="styleTweak">padding-left:30px</xsl:with-param>
						<xsl:with-param name="scale">160</xsl:with-param>
					</xsl:call-template>
				</xsl:for-each>
			</xsl:for-each>
		</xsl:for-each>
	</xsl:template>
		
	<!-- Namespaces Summary -->
	<xsl:template name="namespaceSummary">
		<xsl:param name="threshold" />
				<tr>
					<td colspan="5">&#160;</td>
				</tr>
				<tr>
					<td class="primaryTable mainTableHeaderLeft" colspan="2">Namespaces</td>
					<td class="primaryTable mainTableHeader">Unvisited SeqPts</td>
					<td class="primaryTable mainTableGraphHeader" colspan="2">Coverage</td>
				</tr>				
		<xsl:for-each select="./namespaces/namespace">
			<xsl:call-template name="coverageDetail">
				<xsl:with-param name="name" select="./@name" />
				<xsl:with-param name="unvisitedPoints" select="./@unvisitedPoints" />
				<xsl:with-param name="sequencePoints" select="./@sequencePoints" />
				<xsl:with-param name="coverage" select="./@coverage" />
				<xsl:with-param name="threshold" select="$threshold" />
				<xsl:with-param name="showThreshold">False</xsl:with-param>
			</xsl:call-template>
		</xsl:for-each>
	</xsl:template>
	
	<!-- Coverage detail row in main grid displaying a name, statistics and graph bar -->
	<xsl:template name="coverageDetail">
		<xsl:param name="name" />
		<xsl:param name="unvisitedPoints" />
		<xsl:param name="sequencePoints" />
		<xsl:param name="coverage" />
		<xsl:param name="threshold" />
		<xsl:param name="showThreshold" />
				<tr>
			<xsl:choose>
				<xsl:when test="$showThreshold='True'">
					<td class="mainTableCellBottom mainTableCellItem"><xsl:value-of select="$name" /></td>
					<td class="mainTableCellBottom mainTableCellData"><xsl:value-of select="concat(format-number($threshold,'#0.0'), ' %')" /></td>
				</xsl:when>
				<xsl:otherwise>
					<td class="mainTableCellBottom mainTableCellItem" colspan="2"><xsl:value-of select="$name" /></td>
				</xsl:otherwise>
			</xsl:choose>
					<td class="mainTableCellBottom mainTableCellData"><xsl:value-of select="$unvisitedPoints" /></td>
					<td class="mainTableCellBottom mainTableCellPercent"><xsl:value-of select="concat(format-number($coverage,'#0.0'), ' %')" /></td>
					<td class="mainTableCellBottom mainTableCellGraph">
						<xsl:call-template name="detailPercent">
							<xsl:with-param name="notVisited" select="$unvisitedPoints" />
							<xsl:with-param name="total" select="$sequencePoints" />
							<xsl:with-param name="threshold" select="$threshold" />
							<xsl:with-param name="scale" select="200" />
						</xsl:call-template>
					</td>
				</tr>
	</xsl:template>
	
	<!-- Coverage detail row in secondary grid header displaying a name, statistics and graph bar -->
	<xsl:template name="coverageDetailSecondary">
		<xsl:param name="name" />
		<xsl:param name="unvisitedPoints" />
		<xsl:param name="sequencePoints" />
		<xsl:param name="coverage" />
		<xsl:param name="threshold" />
				<tr>
					<td class="mainTableCellItem"><xsl:value-of select="$name" /></td>
					<td class="mainTableCellData"><xsl:value-of select="concat(format-number($threshold,'#0.0'), ' %')" /></td>
					<td class="mainTableCellData"><xsl:value-of select="$unvisitedPoints" /></td>
					<td class="mainTableCellPercent"><xsl:value-of select="concat(format-number($coverage,'#0.0'), ' %')" /></td>
					<td class="mainTableCellGraph">
						<xsl:call-template name="detailPercent">
							<xsl:with-param name="notVisited" select="$unvisitedPoints" />
							<xsl:with-param name="total" select="$sequencePoints" />
							<xsl:with-param name="threshold" select="$threshold" />
							<xsl:with-param name="scale" select="200" />
						</xsl:call-template>
					</td>
				</tr>
	</xsl:template>
	
	<!-- Coverage detail row with indented item name and shrunk graph bar -->
	<xsl:template name="coverageIndentedDetail">
		<xsl:param name="name" />
		<xsl:param name="unvisitedPoints" />
		<xsl:param name="sequencePoints" />
		<xsl:param name="coverage" />
		<xsl:param name="threshold" />
		<xsl:param name="styleTweak">padding-left:20px</xsl:param>
		<xsl:param name="scale">180</xsl:param>
				<tr>
					<td class="mainTableCellBottom childTableCellIndentedItem" colspan="2"><xsl:attribute name="style"><xsl:value-of select="$styleTweak"/></xsl:attribute><xsl:value-of select="$name" /></td>
					<td class="mainTableCellBottom mainTableCellData"><xsl:value-of select="$unvisitedPoints" /></td>
					<td class="mainTableCellBottom mainTableCellPercent"><xsl:value-of select="concat(format-number($coverage,'#0.0'), ' %')" /></td>
					<td class="mainTableCellBottom mainTableCellGraph">
						<xsl:call-template name="detailPercent">
							<xsl:with-param name="notVisited" select="$unvisitedPoints" />
							<xsl:with-param name="total" select="$sequencePoints" />
							<xsl:with-param name="threshold" select="$threshold" />
							<xsl:with-param name="scale" select="$scale" />
						</xsl:call-template>
					</td>
				</tr>
	</xsl:template>
		
	<!-- Exclusions Summary -->
	<xsl:template name="exclusionsSummary">
			<tr>
					<td colspan="5">&#160;</td>
				</tr>
				<tr>
					<td class="exclusionTable mainTableHeaderLeft" colspan="3">Excluded From Coverage Results</td>
					<td class="exclusionTable mainTableGraphHeader" colspan="2">All Code Within</td>
				</tr>
		<xsl:for-each select="./exclusions/exclusion">
				<tr>
					<td class="mainTableCellBottom exclusionTableCellItem" colspan="3"><xsl:value-of select="@name" /></td>
					<td class="mainTableCellBottom mainTableCellGraph" colspan="2"><xsl:value-of select="@category" /></td>
				</tr>
		</xsl:for-each>
	</xsl:template>
	
	<!-- Footer -->
	<xsl:template name="footer">
				<tr>
					<td colspan="5">&#160;</td>
				</tr>
	</xsl:template>
	
	<!-- Draw % Green/Red/Yellow Bar -->
	<xsl:template name="detailPercent">
		<xsl:param name="notVisited" />
		<xsl:param name="total" />
		<xsl:param name="threshold" />
		<xsl:param name="scale" />
		<xsl:variable name="visited" select="$total - $notVisited" />
		<xsl:variable name="coverage" select="$visited div $total * 100"/>
		<table cellpadding="0" cellspacing="0">
			<tbody>
				<tr>
					<xsl:if test="$notVisited = 0">
						<td class="graphBarVisitedFully" height="14">
							<xsl:attribute name="width">
								<xsl:value-of select="$scale" />
							</xsl:attribute>.</td>
					</xsl:if>
					<xsl:if test="($visited != 0) and ($notVisited != 0)">
						<td class="graphBarVisited" height="14">
							<xsl:attribute name="width">
								<xsl:value-of select="format-number($coverage div 100 * $scale, '0') - 1" />
							</xsl:attribute>.</td>
					</xsl:if>
					<xsl:if test="$notVisited != 0">
						<td height="14">
							<xsl:attribute name="class">
								<xsl:if test="$coverage &gt;= $threshold">graphBarSatisfactory</xsl:if>
								<xsl:if test="$coverage &lt; $threshold">graphBarNotVisited</xsl:if>
							</xsl:attribute>
							<xsl:attribute name="width">
								<xsl:value-of select="format-number($notVisited div $total * $scale, '0')" />
							</xsl:attribute>.</td>
					</xsl:if>
				</tr>
			</tbody>
		</table>
	</xsl:template>
</xsl:stylesheet>