<xsl:stylesheet xmlns:x="http://www.w3.org/2001/XMLSchema"
               version="1.0" exclude-result-prefixes="xsl ddwrt msxsl rssaggwrt" 
               xmlns:ddwrt="http://schemas.microsoft.com/WebParts/v2/DataView/runtime"
               xmlns:rssaggwrt="http://schemas.microsoft.com/WebParts/v3/rssagg/runtime"
               xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:msxsl="urn:schemas-microsoft-com:xslt"
               xmlns:rssFeed="urn:schemas-microsoft-com:sharepoint:RSSAggregatorWebPart"
               xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#" xmlns:dc="http://purl.org/dc/elements/1.1/"
               xmlns:rss1="http://purl.org/rss/1.0/" xmlns:atom="http://www.w3.org/2005/Atom"
               xmlns:itunes="http://www.itunes.com/dtds/podcast-1.0.dtd"
               xmlns:atom2="http://purl.org/atom/ns#" xmlns:ddwrt2="urn:frontpage:internal">

    <xsl:param name="rss_FeedLimit">5</xsl:param>
    <xsl:param name="rss_ExpandFeed">false</xsl:param>
    <xsl:param name="rss_LCID">1033</xsl:param>
    <xsl:param name="rss_WebPartID">RSS_Viewer_WebPart</xsl:param>
    <xsl:param name="rss_alignValue">left</xsl:param>
    <xsl:param name="rss_IsDesignMode">True</xsl:param>

    
                <xsl:template match="rss" xmlns:x="http://www.w3.org/2001/XMLSchema" xmlns:rssFeed="urn:schemas-microsoft-com:sharepoint:RSSAggregatorWebPart" xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#" xmlns:dc="http://purl.org/dc/elements/1.1/" xmlns:rss1="http://purl.org/rss/1.0/" xmlns:atom="http://www.w3.org/2005/Atom" xmlns:itunes="http://www.itunes.com/dtds/podcast-1.0.dtd" xmlns:atom2="http://purl.org/atom/ns#">
                    <html>
                        <head>                      						
                        </head>
                        <body>
                        <div id="xslRss" class="webpart">
                                <xsl:call-template name="RSSMainTemplate"/>
                            </div>
                        </body>                    
                        </html>
                </xsl:template>
        
                
        
                <xsl:template match="rdf:RDF">
                    <xsl:call-template name="RDFMainTemplate"/>
                </xsl:template>
        
                <xsl:template match="atom:feed">
                    <xsl:call-template name="ATOMMainTemplate"/>
                </xsl:template>
        
                <xsl:template match="atom2:feed">
                    <xsl:call-template name="ATOM2MainTemplate"/>
                </xsl:template>
        
                <xsl:template name="RSSMainTemplate">
                    <xsl:variable name="Rows" select="channel/item"/>
                    <xsl:variable name="RowCount" select="count($Rows)"/>
                    <div class="slm-layout-main" >         
	                    <!--Title Div -->	                    
		                <div class="groupheader item medium">
						<!--Header Items-->
		                    <h2 class="groupheader_child title">News</h2>
		                    <div class="groupheader_child button_wrapper">
							<!--Buttons-->
				                <img class="nav_button" src="http://mentintranet/SiteAssets/Webparts/RssFeed/rss_nav_button_left.png" alt="Previous Button" onclick="SwitchCard('previous', 'xslRss')"></img>
				                <img class="nav_button" src="http://mentintranet/SiteAssets/Webparts/RssFeed/rss_nav_button_right.png" alt="Previous Button" onclick="SwitchCard('next', 'xslRss')"></img>						
			                </div>
	                    </div>	
					<!--Card Frame-->		                    
	                    <div class="card_display display">   
						<!--MELogo as background -->
	              	        <img class="card_background" src="http://mentintranet/SiteAssets/Webparts/RssFeed/me_logo.png" alt="Card Background"></img>          
	                    	<xsl:call-template name="RSSMainTemplate.body">
	                        	<xsl:with-param name="Rows" select="$Rows"/>
	                        	<xsl:with-param name="RowCount" select="count($Rows)"/>
	                    	</xsl:call-template>
	                    </div>
                    </div>
                </xsl:template>
              
                <xsl:template name="RSSMainTemplate.body">                      		
                    	<xsl:param name="Rows"/>
                    	<xsl:param name="RowCount"/>
                    		<xsl:for-each select="$Rows">                   	
                        		<xsl:variable name="CurPosition" select="position()" />
                        		<xsl:variable name="RssFeedLink" select="$rss_WebPartID" />
                        		<xsl:variable name="CurrentElement" select="concat($RssFeedLink,$CurPosition)" />
                        		<xsl:if test="($CurPosition &lt;= $rss_FeedLimit)">           
                            <div class="link-item card_layout" style="opacity:0; left:471px">
							<!--Card Title-->
                            	<div class="card_title">                       		                                                     
	                                 <h2><xsl:value-of select="title"/></h2>       
                                </div>             
                                <xsl:call-template name="RSSMainTemplate.description">
                                    <xsl:with-param name="DescriptionStyle" select="string('display:block;')"/>
                                    <xsl:with-param name="CurrentElement" select="$CurrentElement"/>
                                </xsl:call-template>                                 
                            </div>                          
                        </xsl:if>                        	                       
                    </xsl:for-each>
                </xsl:template>
        

        
                <xsl:template name="RSSMainTemplate.description">
                    <xsl:param name="DescriptionStyle"/>
                    <xsl:param name="CurrentElement"/>
					<!--Card description-->
                    <div class="description_wrapper">
		                <div id="{$CurrentElement}" class="description" align="{$rss_alignValue}" style="{$DescriptionStyle} text-align:{$rss_alignValue};">
		                        <xsl:choose>
		                            <!-- some RSS2.0 contain pubDate tag, some others dc:date -->
		                            <xsl:when test="string-length(pubDate) &gt; 0">
		                                <xsl:variable name="pubDateLength" select="string-length(pubDate) - 3" />
		                        <xsl:value-of select="ddwrt:FormatDate(substring(pubDate,0,$pubDateLength),number($rss_LCID),3)"/>
		                            </xsl:when>
		                            <xsl:otherwise>
		                                <xsl:value-of select="ddwrt:FormatDate(string(dc:date),number($rss_LCID),3)"/>
		                            </xsl:otherwise>
		                        </xsl:choose>
		        
		                        <xsl:if test="string-length(description) &gt; 0">
		                            <xsl:variable name="SafeHtml">
		                                <xsl:call-template name="GetSafeHtml">
		                                    <xsl:with-param name="Html" select="description"/>
		                                </xsl:call-template>
		                            </xsl:variable>
		                             - <xsl:value-of select="$SafeHtml" disable-output-escaping="yes"/>
		                        </xsl:if>
		                </div>
						<!--Times of malta redirect-->
		                <div class="redirect">
                        	<a href="{ddwrt:EnsureAllowedProtocol(string(link))}" target="_blank">Full Story</a>
                    	</div>
		             </div>
		             <br style="clear:both"></br>
                </xsl:template>
        
        
                
        
        
                <xsl:template name="RDFMainTemplate" xmlns:ddwrt="http://schemas.microsoft.com/WebParts/v2/DataView/runtime" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:msxsl="urn:schemas-microsoft-com:xslt">
                    <xsl:variable name="Rows" select="rss1:item"/>
                    <xsl:variable name="RowCount" select="count($Rows)"/>
                    <div class="slm-layout-main" >
                    <div class="groupheader item medium">
                        <a href="{ddwrt:EnsureAllowedProtocol(string(rss1:channel/rss1:link))}">
                            <xsl:value-of select="rss1:channel/rss1:title"/>
                        </a>
                    </div>            
                        <xsl:call-template name="RDFMainTemplate.body">
                            <xsl:with-param name="Rows" select="$Rows"/>
                            <xsl:with-param name="RowCount" select="count($Rows)"/>
                        </xsl:call-template>
                    </div>
                </xsl:template>
        
                <xsl:template name="RDFMainTemplate.body" xmlns:ddwrt="http://schemas.microsoft.com/WebParts/v2/DataView/runtime" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:msxsl="urn:schemas-microsoft-com:xslt">
                    <xsl:param name="Rows"/>
                    <xsl:param name="RowCount"/>
                    <xsl:for-each select="$Rows">
                        <xsl:variable name="CurPosition" select="position()" />
                        <xsl:variable name="RssFeedLink" select="$rss_WebPartID" />
                        <xsl:variable name="CurrentElement" select="concat($RssFeedLink,$CurPosition)" />
                        <xsl:if test="($CurPosition &lt;= $rss_FeedLimit)">
                            <div class="item link-item" >
                                <a href="{concat(&quot;javascript:ToggleItemDescription('&quot;,$CurrentElement,&quot;')&quot;)}" >
                                    <xsl:value-of select="rss1:title"/>
                                </a>
                                <xsl:if test="$rss_ExpandFeed = true()">
                                        <xsl:call-template name="RDFMainTemplate.description">
                                            <xsl:with-param name="DescriptionStyle" select="string('display:block;')"/>
                                            <xsl:with-param name="CurrentElement" select="$CurrentElement"/>
                                        </xsl:call-template>
                                </xsl:if>
                                <xsl:if test="$rss_ExpandFeed = false()">
                                        <xsl:call-template name="RDFMainTemplate.description">
                                            <xsl:with-param name="DescriptionStyle" select="string('display:none;')"/>
                                            <xsl:with-param name="CurrentElement" select="$CurrentElement"/>
                                        </xsl:call-template>
                                </xsl:if>
                            </div>
                </xsl:if>
                    </xsl:for-each>
                </xsl:template>
        
                <xsl:template name="RDFMainTemplate.description" xmlns:ddwrt="http://schemas.microsoft.com/WebParts/v2/DataView/runtime" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:msxsl="urn:schemas-microsoft-com:xslt">
                    <xsl:param name="DescriptionStyle"/>
                    <xsl:param name="CurrentElement"/>
                <div id="{$CurrentElement}" class="description" align="{$rss_alignValue}" style="{$DescriptionStyle} text-align:{$rss_alignValue};">
                    <xsl:value-of select="ddwrt:FormatDate(string(dc:date),number($rss_LCID),3)"/>
                        <xsl:if test="string-length(rss1:description) &gt; 0">
                            <xsl:variable name="SafeHtml">
                                <xsl:call-template name="GetSafeHtml">
                                    <xsl:with-param name="Html" select="rss1:description"/>
                                </xsl:call-template>
                            </xsl:variable>
                             - <xsl:value-of select="$SafeHtml" disable-output-escaping="yes"/>
                        </xsl:if>
                    <div class="description">
                        <a href="{ddwrt:EnsureAllowedProtocol(string(rss1:link))}">More...</a>
                    </div>
                </div>
                </xsl:template>
        
        
                <xsl:template name="ATOMMainTemplate" xmlns:ddwrt="http://schemas.microsoft.com/WebParts/v2/DataView/runtime" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:msxsl="urn:schemas-microsoft-com:xslt">
                    <xsl:variable name="Rows" select="atom:entry"/>
                    <xsl:variable name="RowCount" select="count($Rows)"/>
                    <div class="slm-layout-main" >
                    <div class="groupheader item medium">
                        <a href="{ddwrt:EnsureAllowedProtocol(string(atom:link/@href))}">
                            <xsl:value-of select="atom:title"/>
                        </a>
                    </div>            
                        <xsl:call-template name="ATOMMainTemplate.body">
                            <xsl:with-param name="Rows" select="$Rows"/>
                            <xsl:with-param name="RowCount" select="count($Rows)"/>
                        </xsl:call-template>
                    </div>
                </xsl:template>
        
                <xsl:template name="ATOMMainTemplate.body" xmlns:ddwrt="http://schemas.microsoft.com/WebParts/v2/DataView/runtime" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:msxsl="urn:schemas-microsoft-com:xslt">
                    <xsl:param name="Rows"/>
                    <xsl:param name="RowCount"/>
                    <xsl:for-each select="$Rows">
                        <xsl:variable name="CurPosition" select="position()" />
                        <xsl:variable name="RssFeedLink" select="$rss_WebPartID" />
                        <xsl:variable name="CurrentElement" select="concat($RssFeedLink,$CurPosition)" />
                        <xsl:if test="($CurPosition &lt;= $rss_FeedLimit)">
                                    <div class="item link-item" >
                                        <a href="{concat(&quot;javascript:ToggleItemDescription('&quot;,$CurrentElement,&quot;')&quot;)}" >
                                            <xsl:value-of select="atom:title"/>
                                        </a>
                                        <xsl:if test="$rss_ExpandFeed = true()">
                                            <xsl:call-template name="ATOMMainTemplate.description">
                                                <xsl:with-param name="DescriptionStyle" select="string('display:block;')"/>
                                                <xsl:with-param name="CurrentElement" select="$CurrentElement"/>
                                            </xsl:call-template>
                                    </xsl:if>
                                        <xsl:if test="$rss_ExpandFeed = false()">
                                            <xsl:call-template name="ATOMMainTemplate.description">
                                                <xsl:with-param name="DescriptionStyle" select="string('display:none;')"/>
                                                <xsl:with-param name="CurrentElement" select="$CurrentElement"/>
                                            </xsl:call-template>
                                    </xsl:if>
                                    </div>
                </xsl:if>
                    </xsl:for-each>
                </xsl:template>
        
                <xsl:template name="ATOMMainTemplate.description" xmlns:ddwrt="http://schemas.microsoft.com/WebParts/v2/DataView/runtime" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:msxsl="urn:schemas-microsoft-com:xslt">
                    <xsl:param name="DescriptionStyle"/>
                    <xsl:param name="CurrentElement"/>
                <div id="{$CurrentElement}" class="description" align="{$rss_alignValue}" style="{$DescriptionStyle} text-align:{$rss_alignValue};">
                <xsl:value-of select="ddwrt:FormatDate(string(atom:updated),number($rss_LCID),3)"/>
                        <xsl:choose>
                            <xsl:when test="string-length(atom:summary) &gt; 0">
                                <xsl:variable name="SafeHtml">
                                    <xsl:call-template name="GetSafeHtml">
                                        <xsl:with-param name="Html" select="atom:summary"/>
                                    </xsl:call-template>
                                </xsl:variable>
                                 - <xsl:value-of select="$SafeHtml" disable-output-escaping="yes"/>
                            </xsl:when>
                            <xsl:when test="string-length(atom:content) &gt; 0">
                                <xsl:variable name="SafeHtml">
                                    <xsl:call-template name="GetSafeHtml">
                                        <xsl:with-param name="Html" select="atom:content"/>
                                    </xsl:call-template>
                                </xsl:variable>
                                 - <xsl:value-of select="$SafeHtml" disable-output-escaping="yes"/>
                            </xsl:when>
                        </xsl:choose>
                    <div class="description">
                        <a href="{ddwrt:EnsureAllowedProtocol(string(atom:link/@href))}">More...</a>
                    </div>
                </div>
                </xsl:template>
        
                <xsl:template name="ATOM2MainTemplate" xmlns:ddwrt="http://schemas.microsoft.com/WebParts/v2/DataView/runtime" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:msxsl="urn:schemas-microsoft-com:xslt">
                    <xsl:variable name="Rows" select="atom2:entry"/>
                    <xsl:variable name="RowCount" select="count($Rows)"/>
                    <div class="slm-layout-main" >
                    <div class="groupheader item medium">                
                        <a href="{ddwrt:EnsureAllowedProtocol(string(atom2:link/@href))}">
                            <xsl:value-of select="atom2:title"/>
                        </a>
                    </div>
                        <xsl:call-template name="ATOM2MainTemplate.body">
                            <xsl:with-param name="Rows" select="$Rows"/>
                            <xsl:with-param name="RowCount" select="count($Rows)"/>
                        </xsl:call-template>
                    </div>
                </xsl:template>
        
                <xsl:template name="ATOM2MainTemplate.body" xmlns:ddwrt="http://schemas.microsoft.com/WebParts/v2/DataView/runtime" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:msxsl="urn:schemas-microsoft-com:xslt">
                    <xsl:param name="Rows"/>
                    <xsl:param name="RowCount"/>
                    <xsl:for-each select="$Rows">
                        <xsl:variable name="CurPosition" select="position()" />
                        <xsl:variable name="RssFeedLink" select="$rss_WebPartID" />
                        <xsl:variable name="CurrentElement" select="concat($RssFeedLink,$CurPosition)" />
                        <xsl:if test="($CurPosition &lt;= $rss_FeedLimit)">
                             <div class="item link-item" >
                                        <a href="{concat(&quot;javascript:ToggleItemDescription('&quot;,$CurrentElement,&quot;')&quot;)}" >
                                            <xsl:value-of select="atom2:title"/>
                                        </a>
                                    <xsl:if test="$rss_ExpandFeed = true()">
                                        <xsl:call-template name="ATOM2MainTemplate.description">
                                            <xsl:with-param name="DescriptionStyle" select="string('display:block;')"/>
                                            <xsl:with-param name="CurrentElement" select="$CurrentElement"/>
                                        </xsl:call-template>
                                    </xsl:if>
                                    <xsl:if test="$rss_ExpandFeed = false()">
                                        <xsl:call-template name="ATOM2MainTemplate.description">
                                            <xsl:with-param name="DescriptionStyle" select="string('display:none;')"/>
                                            <xsl:with-param name="CurrentElement" select="$CurrentElement"/>
                                        </xsl:call-template>
                                    </xsl:if>
                            </div>
                </xsl:if>
                    </xsl:for-each>
                </xsl:template>
        
                <xsl:template name="ATOM2MainTemplate.description" xmlns:ddwrt="http://schemas.microsoft.com/WebParts/v2/DataView/runtime" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:msxsl="urn:schemas-microsoft-com:xslt">
                    <xsl:param name="DescriptionStyle"/>
                    <xsl:param name="CurrentElement"/>
                <div id="{$CurrentElement}" class="description" align="{$rss_alignValue}" style="{$DescriptionStyle} text-align:{$rss_alignValue};">
                    <xsl:value-of select="ddwrt:FormatDate(string(atom2:updated),number($rss_LCID),3)"/>
                        <xsl:choose>
                            <xsl:when test="string-length(atom2:summary) &gt; 0">
                                <xsl:variable name="SafeHtml">
                                    <xsl:call-template name="GetSafeHtml">
                                        <xsl:with-param name="Html" select="atom2:summary"/>
                                    </xsl:call-template>
                                </xsl:variable>
                                 - <xsl:value-of select="$SafeHtml" disable-output-escaping="yes"/>
                            </xsl:when>
                            <xsl:when test="string-length(atom2:content) &gt; 0">
                                <xsl:variable name="SafeHtml">
                                    <xsl:call-template name="GetSafeHtml">
                                        <xsl:with-param name="Html" select="atom2:content"/>
                                    </xsl:call-template>
                                </xsl:variable>
                                 - <xsl:value-of select="$SafeHtml" disable-output-escaping="yes"/>
                            </xsl:when>
                        </xsl:choose>
                    <div class="description">
                        <a href="{ddwrt:EnsureAllowedProtocol(string(atom2:link/@href))}">More...</a>
                    </div>
                </div>
                </xsl:template>
        
                <xsl:template name="GetSafeHtml">
                    <xsl:param name="Html"/>
                    <xsl:choose>
                        <xsl:when test="$rss_IsDesignMode = 'True'">
                             <xsl:value-of select="$Html"/>
                        </xsl:when>
                        <xsl:otherwise>
                             <xsl:value-of select="rssaggwrt:MakeSafe($Html)"/>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:template>
</xsl:stylesheet>
