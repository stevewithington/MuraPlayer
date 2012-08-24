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
	.muraPlayerBodyWrap h4{padding-top:1em;}
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

			<h3>Need help?</h3>
			<p>Catch me on the <a href="http://www.getmura.com/forum/" target="_blank">Mura CMS forums</a>, contact me through my site at <a href="http://www.stephenwithington.com" target="_blank">www.stephenwithington.com</a>, or via email at steve [at] stephenwithington [dot] com.</p>
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