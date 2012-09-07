<cfscript>
/**
* 
* This file is part of MuraPlayer TM
* (c) Stephen J. Withington, Jr. | StephenWithington.com
*
* This program is free software; you can redistribute it and/or modify
* it under the terms of the GNU General Public License as published by
* the Free Software Foundation; either version 2 of the License, or
* (at your option) any later version.
*
* This program is distributed in the hope that it will be useful,
* but WITHOUT ANY WARRANTY; without even the implied warranty of
* MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
* GNU General Public License for more details.
*
* You should have received a copy of the GNU General Public License along
* with this program; if not, write to the Free Software Foundation, Inc.,
* 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA.
*
*/
	include 'plugin/config.cfm';
</cfscript>
<style type="text/css">
	div.muraPlayerBodyWrap {width:650px;}
	.muraPlayerBodyWrap h3{padding-top:1.5em;}
	.muraPlayerBodyWrap h4, .muraPlayerBodyWrap h5{padding-top:1em;}
	.muraPlayerBodyWrap ul{padding:0 0.75em;margin:0 0.75em;}
</style>
<cfsavecontent variable="body">
	<cfoutput>
		<div class="muraPlayerBodyWrap">
			<h2>#HTMLEditFormat(pluginConfig.getName())#</h2>
			<p><em>Version: #pluginConfig.getVersion()#<br />
			Author: Stephen J. Withington, Jr. &mdash; <a href="http://blueriver.com" target="_blank">Blue River Interactive</a></em></p>

			<h3>End User License Agreement (EULA)</h3>
			<p><em><a href="license.txt" target="_blank">View Printer-Friendly Version &gt;</a></em></p>
			<div class="notice">
				<p><textarea readonly="readonly" name="EULA" id="EULA" label="End User License Agreement (EULA)" cols="77" rows="10"><cfinclude template="license.txt" /></textarea></p>
			</div>

			<h3>Supported File Formats</h3>
			<h4>Flash Playback</h4>
			<ul>
				<li><strong>Video Formats:</strong> H.264 (.mp4, .mov, .f4v), FLV (.flv), 3GPP (.3gp, .3g2), YouTube</li>
				<li><strong>Sound Formats:</strong> AAC (.aac, .m4a), MP3 (.mp3)</li>
				<li><strong>Image Formats:</strong> JPEG (.jpg), PNG (.png), GIF (.gif)</li>
			</ul>

			<h4>HTML5 Playback</h4>
			<ul>
				<li><strong>Video Formats*:</strong> H.264 / MP4 (.mp4), VP8 / WebM (.webm), Ogg Theora (.ogv)</li>
				<li><strong>Sound Formats*:</strong> AAC (.aac, .m4a), MP3 (.mp3), Ogg Vorbis (.ogg)<br>
				<em>* Browser dependent</em></li>
			</ul>

			<h4>XML Playlists</h4>
			<ul>
				<li><strong>Flash Only:</strong> ASX, ATOM with Media extensions, iRSS (RSS feeds with iTunes extensions), XSPF, SMIL</li>
				<li><strong>HTML5 &amp; Flash:</strong> mRSS (RSS feeds with Media extensions)</li>
			</ul>

			<h3>How Do I Use This?</h3>
			<p>Coming soon.</p>

			<h3>Requirements</h3>
			<div class="notice">
				<ul>
					<li>ColdFusion 9.0.1+ or Railo 3.3.1+ <em>(this has NOT been tested on Open BlueDragon)</em></li>
					<li>Mura 5.6.5+</li>
				</ul>
			</div>

			<h3>Troubleshooting</h3>
		
			<h4>Upload Issues</h4>
			<p>Please note, Mura CMS does NOT impose any kind of limit on your filesize uploads.  This means that if you're running into issues, there are probably limits being imposed by either your your CFML engine (e.g., Adobe ColdFusion, Railo, etc.), your webserver (IIS, apache, etc.), your web hosting company (e.g., software that they use to monitor their servers such as SeeFusion, etc.), your internet service provider (ISP), or possibly even your organization's network policies.  The point is, there's any nummber of places you may have to check.</p>
			<p class="error"><strong>WARNING!!!</strong> Changing filesize post data is a security risk. For example, if someone wants to perform a Denial of Service (DOS) attack, you're just giving them an easy way to do it. So please keep this in mind before attempting to make any adjustments to default settings.</p>
			<p>The information below is meant to help troubleshoot common problems with uploading large files.</p>

			
			<h5>ColdFusion Administrator</h5>
			<p>Login to your ColdFusion Administrator, go to Server Settings > Settings. Scroll to the bottom of the page and check the <strong>Request Size Limits</strong> section. The very first item listed shoudl be <strong>Maximum size of post data</strong>. The default is 100MB.</p>
			<p>If that doesn't work, you could attempt to increase your Timeout Requests setting (defaults to 60 seconds).</p>
			<p>Finally, check your JVM memory settings. Here's some links that are somewhat related:</p>
			<ul>
				<li><a href="http://www.talkingtree.com/blog/index.cfm/2010/9/9/JVM-Memory-Management-and-ColdFusion-Log-Analysis">http://www.talkingtree.com/blog/index.cfm/2010/9/9/JVM-Memory-Management-and-ColdFusion-Log-Analysis</a></li>
				<li><a href="http://www.petefreitag.com/articles/gctuning/">http://www.petefreitag.com/articles/gctuning/</a></li>
			</ul>
		
			<h5>HTTP 404.13</h5>
			<p>If you're getting a <strong>404.13 - Not Found</strong> error, then you're probably using Windows/IIS.  By default, IIS limits the maximum length of content in a request to 30000000 bytes (approximately 28.6MB). The links below may help resolve this issue:</p>
			<ul>
				<li><a href="http://www.iis.net/configreference/system.webserver/security/requestfiltering/requestlimits">Windows/IIS Request Limits</a></li>
				<li><a href="http://support.microsoft.com/kb/942074">IIS 7 - HTTP Error 404.13</a></li>
			</ul>
		

			<h3>Need help?</h3>
			<p>If you're running into an issue, please let me know at <a href="https://github.com/stevewithington/MuraPlayer/issues">https://github.com/stevewithington/MuraPlayer/issues</a> and I'll try to address it as soon as I can.</p>
			<p>Cheers!</p>
		</div>
	</cfoutput>
</cfsavecontent>
<cfoutput>
	#$.getBean('pluginManager').renderAdminTemplate(
		body = body
		, pageTitle = pluginConfig.getName()
	)#
</cfoutput>