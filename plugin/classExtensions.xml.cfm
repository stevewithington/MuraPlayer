<cfsilent><cfscript>
/**
* 
* This file is part of MuraPlayer TM
*
* Copyright 2010-2014 Stephen J. Withington, Jr.
* Licensed under the Apache License, Version v2.0
* http://www.apache.org/licenses/LICENSE-2.0
*
* NOTES:
* 
* Valid Types: Text, TextBox, TextArea, HTMLEditor, SelectBox, MultiSelectBox, RadioGroup, File, Hidden
* Valid Containers: Default (Extended Attributes Tab), Basic, Custom
* 
* http://www.longtailvideo.com/support/jw-player/jw-player-for-flash-v5/12536/configuration-options
* 
*/
</cfscript></cfsilent>
<cfsavecontent variable="commonPlayerAttributes">
	<attribute 
		name="muraPlayerDimensions"
		label="Player Dimensions (width by height)"
		hint="Height and width of the player. If the media is a sound file and no primary associated image is uploaded, then the height will be auto-adjusted."
		type="SelectBox"
		defaultValue="[mura]$.siteConfig('muraPlayerDimensionsDefault')[/mura]"
		required="false"
		validation="None"
		regex=""
		message=""
		optionList="[mura]application.muraPlayer.getPlayerDimensionsOptionList()[/mura]"
		optionLabelList="[mura]application.muraPlayer.getPlayerDimensionsOptionLabelList()[/mura]" />

	<attribute
		name="muraPlayerSkin"
		label="Player Skin"
		hint=""
		type="SelectBox"
		defaultValue="[mura]$.siteConfig('muraPlayerSkinDefault')[/mura]"
		required="false"
		validation="None"
		regex=""
		message=""
		optionList="[mura]application.muraPlayer.getPlayerSkinsOptionList()[/mura]"
		optionLabelList="[mura]application.muraPlayer.getPlayerSkinsOptionLabelList()[/mura]" />

	<attribute 
		name="muraPlayerAutoStart"
		label="Auto Start"
		hint="Set this to Yes to automatically start the player when it loads."
		type="RadioGroup"
		defaultValue="false"
		required="false"
		validation="None"
		regex=""
		message=""
		optionList="false^true"
		optionLabelList="No^Yes" />

	<attribute
		name="muraPlayerControlbarPosition"
		label="Control Bar Position"
		hint="Position of the control bar."
		type="SelectBox"
		defaultValue="over"
		required="false"
		validation="None"
		regex=""
		message=""
		optionList="bottom^over^none"
		optionLabelList="Bottom^Over^None" />

	<attribute 
		name="muraPlayerControlbarIdleHide"
		label="Hide Control Bar (if set to 'over')"
		hint="If control bar's position is set to 'over,' this option determines whether the controlbar stays hidden when the player is paused or stopped."
		type="RadioGroup"
		defaultValue="false"
		required="false"
		validation="None"
		regex=""
		message=""
		optionList="false^true"
		optionLabelList="No^Yes" />

	<attribute 
		name="muraPlayerMute"
		label="Mute"
		hint="Must the sounds on startup. Is saved in a cookie."
		type="RadioGroup"
		defaultValue="false"
		required="false"
		validation="None"
		regex=""
		message=""
		optionList="false^true"
		optionLabelList="No^Yes" />

	<attribute 
		name="muraPlayerShowMute"
		label="Show Mute Icon"
		hint="IF the video is muted, setting this to 'Yes' will show a mute icon in the player's display window while the player is playing."
		type="RadioGroup"
		defaultValue="false"
		required="false"
		validation="None"
		regex=""
		message=""
		optionList="false^true"
		optionLabelList="No^Yes" />

	<attribute
		name="muraPlayerRepeat"
		label="Repeat"
		hint="What to do when the mediafile has ended. Has several options - None: do nothing (stop playback) whever a file is completed. List: play each file in the playlist once, stop at the end. Always: continously play the file (or all files in the playlist). Single: continously repeat the current file in the playlist."
		type="SelectBox"
		defaultValue="none"
		required="false"
		validation="None"
		regex=""
		message=""
		optionList="none^list^always^single"
		optionLabelList="None^List^Always^Single" />

	<attribute
		name="muraPlayerStretching"
		label="Stretching"
		hint="Defines how to resize the poster image and video to fit the display. Options are - None: keep the original dimensions. Exact Fit: disproportionally stretch the video/image to exactly fit the display. Uniform: stretch the image/video while maintaining its aspect ratio. There’ll be black borders. Fill: stretch the image/video while maintaining its aspect ratio, completely filling the display."
		type="SelectBox"
		defaultValue="uniform"
		required="false"
		validation="None"
		regex=""
		message=""
		optionList="none^exactfit^uniform^fill"
		optionLabelList="None^Exact Fit^Uniform^Fill" />

	<attribute 
		name="muraPlayerVolume"
		label="Player Startup Volume"
		hint="Select the startup audio volume of the player. The higher the number, the louder the volume."
		type="SelectBox"
		defaultValue="90"
		required="false"
		validation="None"
		regex=""
		message=""
		optionList="[mura]application.muraPlayer.getPlayerVolumeOptionList()[/mura]"
		optionLabelList="[mura]application.muraPlayer.getPlayerVolumeOptionLabelList()[/mura]" />
</cfsavecontent>

<cfsavecontent variable="commonSharingAttributes">

	<attribute 
		name="muraPlayerAllowSharing"
		label="Allow Sharing?"
		hint="Sharing is most often used in viral sharing of a video. Set to 'Yes' to display a share link for the video, e.g. the URL for the page where the video is hosted."
		type="RadioGroup"
		defaultValue="false"
		required="false"
		validation="None"
		regex=""
		message=""
		optionList="false^true"
		optionLabelList="No^Yes" />

	<attribute 
		name="muraPlayerAllowFacebookLike"
		label="Allow Facebook Like?"
		hint="Allows you to create a like dock icon / controlbar icon, to like the page / video on Facebook. Like is a great way to share your video urls with your Facebook friends."
		type="RadioGroup"
		defaultValue="false"
		required="false"
		validation="None"
		regex=""
		message=""
		optionList="false^true"
		optionLabelList="No^Yes" />

</cfsavecontent>

<cfoutput>
	<extensions>

		<!--- ///////////////////////////////////////////////////////////////////////////

				SITE SETTINGS

		--->
		<extension type="Site" subType="Default">
			<attributeset name="MuraPlayer Default Settings">

				<attribute 
					name="muraPlayerDimensionsDefault"
					label="Default Player Dimensions (width by height)"
					hint="Height and width of the player. If the media is a sound file and no primary associated image is uploaded, then the height will be auto-adjusted."
					type="SelectBox"
					defaultValue="640x360"
					required="false"
					validation="None"
					regex=""
					message=""
					optionList="[mura]application.muraPlayer.getPlayerDimensionsOptionList(false)[/mura]"
					optionLabelList="[mura]application.muraPlayer.getPlayerDimensionsOptionLabelList(false)[/mura]" />

				<attribute
					name="muraPlayerSkinDefault"
					label="Default Skin"
					hint="The media's container"
					type="SelectBox"
					defaultValue="[mura]ListFirst(application.muraPlayer.getPlayerSkinsOptionList(false), '^')[/mura]"
					required="false"
					validation="None"
					regex=""
					message=""
					optionList="[mura]application.muraPlayer.getPlayerSkinsOptionList(false)[/mura]"
					optionLabelList="[mura]application.muraPlayer.getPlayerSkinsOptionLabelList(false)[/mura]" />

				<attribute 
					name="muraPlayerIncludeViral"
					label="Include Viral, a video sharing plugin"
					hint="If yes, then when player is paused or stopped, viewers can share a link to the file and/or grab embed code to use on their own site."
					type="RadioGroup"
					defaultValue="true"
					required="false"
					validation="None"
					regex=""
					message=""
					optionList="false^true"
					optionLabelList="No^Yes" />

			</attributeset>

			<cfif application.configBean.getValue('filestore') eq 'S3'>

				<attributeset name="MuraPlayer Amazon CloudFront/Streaming Settings">

					<attribute 
						name="muraPlayerCloudURL"
						label="Amazon CloudFront Domain Name"
						hint="If you have enabled Amazon CloudFront for your Amazon S3 account, then we can use it to optimize delivery of your media assets. (e.g., d3uo0mcmxgzzlk.cloudfront.net) For more information about Amazon CloudFront, please visit http://docs.amazonwebservices.com/AmazonCloudFront/latest/DeveloperGuide/"
						type="Text"
						defaultValue=""
						required="false"
						validation="None"
						regex=""
						message=""
						optionList=""
						optionLabelList="" />

					<attribute 
						name="muraPlayerStreamURL"
						label="Amazon Streaming Domain Name"
						hint="Requires Amazon CloudFront along with your Amazon S3 account. (e.g., s3td5ck0c1yomt.cloudfront.net)  For more information about creating streaming distributions via Amazon CloudFront, please visit http://docs.amazonwebservices.com/AmazonCloudFront/latest/DeveloperGuide/CreatingStreamingDistributions.html"
						type="Text"
						defaultValue=""
						required="false"
						validation="None"
						regex=""
						message=""
						optionList=""
						optionLabelList="" />

				</attributeset>

			</cfif>

			<attributeset name="MuraPlayer Google Analytics Options">
				
				<attribute 
					name="muraPlayerUseGAPro"
					label="Use Google Analytics PRO?"
					hint="You will need to have the Google Analytics tracking code present on the page with the player for tracking to function. There are a number of ways to do this including the use of a Mura CMS plugin. See http://www.longtailvideo.com/jw/upload/LTV-GAPro-2-UserGuide.pdf for detailed information about this JWPlayer plugin."
					type="RadioGroup"
					defaultValue="false"
					required="false"
					validation="None"
					regex=""
					message=""
					optionList="false^true"
					optionLabelList="No^Yes" />

				<attribute 
					name="muraPlayerGAProTrackStarts"
					label="Track Starts?"
					hint="Controls whether data about video starts are sent to Google Analytics. One start event is sent each time a viewer begins playback from the first frame of teh video. NOTE: This includes starts that occur after the viewer pressed stop, or completed the video and pressed play again."
					type="RadioGroup"
					defaultValue="true"
					required="false"
					validation="None"
					regex=""
					message=""
					optionList="false^true"
					optionLabelList="No^Yes" />

				<attribute 
					name="muraPlayerGAProTrackPercentage"
					label="Track Percentage"
					hint="Controls whether data about the percentage of the total video content played by the viewer is sent to Google Analytics."
					type="RadioGroup"
					defaultValue="true"
					required="false"
					validation="None"
					regex=""
					message=""
					optionList="false^true"
					optionLabelList="No^Yes" />

				<attribute 
					name="muraPlayerGAProTrackTime"
					label="Track Time"
					hint="Controls whether data about the total time the viewer spent watching the video is sent to Google Analytics."
					type="RadioGroup"
					defaultValue="true"
					required="false"
					validation="None"
					regex=""
					message=""
					optionList="false^true"
					optionLabelList="No^Yes" />

			</attributeset>

			<attributeset name="MuraPlayer Lights Out Options" container="Default">
				
				<attribute 
					name="muraPlayerUseLightsOut"
					label="Use Lights Out?"
					hint="Lights Out is a plugin for the JW Player that 'turns off the lights' in the background and lets the users focus on the media playing in the JW Player. The lights out functionality causes the entire browser window (all but the JW Player, of course) to be overlayed with a background shade. The background shade is customizable for both color and opacity settings."
					type="RadioGroup"
					defaultValue="false"
					required="false"
					validation="None"
					regex=""
					message=""
					optionList="false^true"
					optionLabelList="No^Yes" />

				<attribute 
					name="muraPlayerLightsOutDockIcon"
					label="Show Lights Out Button on top of video?"
					hint="If 'No', then background will automatically dim with the user having to click an icon when the video begins to play (based on the rest of the settings for this JW Player plugin)"
					type="RadioGroup"
					defaultValue="false"
					required="false"
					validation="None"
					regex=""
					message=""
					optionList="false^true"
					optionLabelList="No^Yes" />

				<attribute 
					name="muraPlayerLightsOutBGColor"
					label="Background Color Shade"
					hint=""
					type="TextBox"
					defaultValue="##000000"
					required="false"
					validation="color"
					regex=""
					message=""
					optionList=""
					optionLabelList="" />

				<attribute 
					name="muraPlayerLightsOutOpacity"
					label="Opacity of background shade (min:0, max:1)"
					hint=""
					type="SelectBox"
					defaultValue="0.8"
					required="false"
					validation="None"
					regex=""
					message=""
					optionList="0.0^0.1^0.2^0.3^0.4^0.5^0.6^0.7^0.8^0.9^1.0"
					optionLabelList="0.0^0.1^0.2^0.3^0.4^0.5^0.6^0.7^0.8^0.9^1.0" />

				<attribute 
					name="muraPlayerLightsOutTime"
					label="The time (in seconds) to fade in/out the lights"
					hint=""
					type="SelectBox"
					defaultValue="800"
					required="false"
					validation="None"
					regex=""
					message=""
					optionList="200^400^600^800^1000^1200^1400^1600^1800^2000"
					optionLabelList="0.2^0.4^0.6^0.8^1.0^1.2^1.4^1.6^1.8^2.0" />

				<attribute 
					name="muraPlayerLightsOutOnIdle"
					label="Lights on/off if player is idle"
					hint=""
					type="RadioGroup"
					defaultValue="on"
					required="false"
					validation="None"
					regex=""
					message=""
					optionList="on^off"
					optionLabelList="On^Off" />

				<attribute 
					name="muraPlayerLightsOutOnPlay"
					label="Lights on/off if player is playing"
					hint=""
					type="RadioGroup"
					defaultValue="off"
					required="false"
					validation="None"
					regex=""
					message=""
					optionList="on^off"
					optionLabelList="On^Off" />

				<attribute 
					name="muraPlayerLightsOutOnPause"
					label="Lights on/off if player is paused"
					hint=""
					type="RadioGroup"
					defaultValue="on"
					required="false"
					validation="None"
					regex=""
					message=""
					optionList="on^off"
					optionLabelList="On^Off" />

				<attribute 
					name="muraPlayerLightsOutOnComplete"
					label="Lights on/off if player is completed"
					hint=""
					type="RadioGroup"
					defaultValue="on"
					required="false"
					validation="None"
					regex=""
					message=""
					optionList="on^off"
					optionLabelList="On^Off" />

			</attributeset>
		</extension>


		<!--- ///////////////////////////////////////////////////////////////////////////

				PAGE / MuraPlayer

		--->
		<extension type="Page" subType="MuraPlayer" iconClass="icon-film" hasBody="1">

			<attributeset name="MuraPlayer Options" container="Basic">

				<attribute 
					name="muraPlayerYouTubeURL"
					label="YouTube URL (Don't use if uploading a Media File)"
					hint="The full, complete URL of the YouTube video. (e.g., http://www.youtube.com/watch?v=eENsm6cOH4A)"
					type="Text"
					defaultValue=""
					required="false"
					validation="None"
					regex=""
					message=""
					optionList=""
					optionLabelList="" />

				<attribute 
					name="muraPlayerFile"
					label="Movie / Media File"
					hint="The recommended video format is .mp4 which plays for both Flash and HTML5. The recommended sound format is either .aac, .m4a or .mp3, all of which are typically supported for both Flash and HTML5. [Flash Video Formats: H.264(.mp4,.mov, .f4v), FLV (.flv), 3GPP(.3gp,.3g2), Flash Sound Formats: AAC (.aac, .m4a), MP3 (.mp3), HTML5 Video Formats (browser dependent!): H.264 / MP4 (.mp4), VP8 / WebM (.webm), Ogg Theora (.ogv), HTML5 Sound Formats (browser dependent!):  AAC (.aac, .m4a), MP3 (.mp3), Ogg Vorbis (.ogg)]"
					type="File"
					defaultValue=""
					required="false"
					validation="None"
					regex=""
					message=""
					optionList=""
					optionLableList="" />

				<attribute 
					name="muraPlayerDescription"
					label="Movie / Media Description"
					hint="A brief description of the video. This will appear on playlists, much like summaries do on Portals."
					type="TextBox"
					defaultValue=""
					required="false"
					validation="None"
					regex=""
					message=""
					optionList=""
					optionLableList="" />

				#commonPlayerAttributes#

			</attributeset>

			<attributeset name="MuraPlayer Sharing Options" container="Default">
				#commonSharingAttributes#
			</attributeset>

			<attributeset name="MuraPlayer Google Analytics Options" container="Default">

				<!--- THIS IS USED ONLY WHEN DISPLAYED IN A PLAYLIST --->
				<attribute 
					name="muraPlayerGAProHidden"
					label="Hide From Google Analytics When Playlist Item"
					hint="If Google Analytics has been enabled for your media (via Site Settings > Extended Attributes), this setting controls whether any data tracking data is sent for a particular playlist item. Only applies when displayed as a playlist item. Set to 'Yes' if you don't want to track data on this item."
					type="RadioGroup"
					defaultValue="false"
					required="false"
					validation="None"
					regex=""
					message=""
					optionList="false^true"
					optionLabelList="No^Yes" />

			</attributeset>

		</extension>


		<!--- ///////////////////////////////////////////////////////////////////////////

				FOLDER / MuraPlaylist

		--->
		<extension type="Folder" subType="MuraPlaylist" iconClass="icon-th-list" availableSubTypes="Page/MuraPlayer">
			<attributeset name="MuraPlaylist Options" container="Basic">

				<attribute 
					name="muraPlaylistShowChildrenOnly"
					label="Show only children of this Folder?"
					hint="Should this playlist ONLY inlcude MuraPlayers that are direct children of this Folder?"
					type="RadioGroup"
					defaultValue="true"
					required="false"
					validation="None"
					regex=""
					message=""
					optionList="false^true"
					optionLabelList="No^Yes" />

				<attribute 
					name="muraPlaylistUseFlow"
					label="Use Flow Playlist Format?"
					hint="Flow provides slick, 3D animation of playlist effects for users to flip through their playlist items. It automatically grabs thumbnail images and renders them three-dimensionally in a row. Users can navigate through the playlist by clicking on a thumbnail image or using the left/right arrows keys and space bar to select items."
					type="RadioGroup"
					defaultValue="true"
					required="false"
					validation="None"
					regex=""
					message=""
					optionList="false^true"
					optionLabelList="No^Yes" />

				<attribute
					name="muraPlaylistFlowPosition"
					label="Flow Playlist Position"
					hint="Position of the control bar."
					type="SelectBox"
					defaultValue="over"
					required="false"
					validation="None"
					regex=""
					message=""
					optionList="over^top^bottom^left^right"
					optionLabelList="Over^Top^Bottom^Left^Right" />

				#commonPlayerAttributes#

			</attributeset>

			<attributeset name="MuraPlaylist Sharing Options" container="Default">

				#commonSharingAttributes#

			</attributeset>

		</extension>

	</extensions>
</cfoutput>