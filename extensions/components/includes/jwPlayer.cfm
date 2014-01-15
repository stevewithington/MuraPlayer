<cfsilent><cfscript>
/**
* 
* This file is part of MuraPlayer TM
*
* Copyright 2010-2014 Stephen J. Withington, Jr.
* Licensed under the Apache License, Version v2.0
* http://www.apache.org/licenses/LICENSE-2.0
*
*/

	// http://www.longtailvideo.com/support/jw-player/jw-player-for-flash-v5/12536/configuration-options
	local.playerid = 'player_' & ReReplace(LCase(arguments.mediaid),'-','','ALL');
		
	variables.pluginConfig.addToHTMLHeadQueue('extensions/scripts/scriptsHead.cfm');

	local.isPlaylist = Len(Trim(arguments.playlist)) || ListLast(arguments.file, '.') == 'xml' ? true : false;

	// flashplayer
	if ( !Len(Trim(arguments.flashplayer)) ) {
		local.player = toBoolean(local.$.siteConfig('muraPlayerIncludeViral')) ? 'player-viral.swf' : 'player.swf';
		local.flashplayer = getPluginPath() & 'assets/players/jwplayer/' & local.player;
	} else {
		local.flashplayer = arguments.flashplayer;
	}

	// sharing link
	if ( toBoolean(arguments.allowsharing) && !Len(Trim(arguments.sharinglink)) ) {
		arguments.sharinglink = getPageContext().getRequest().getRequestURL();
		if ( len(trim(getPageContext().getRequest().getQueryString())) ) {
			arguments.sharinglink = arguments.sharinglink & '?' & getPageContext().getRequest().getQueryString();
		}
	}

	// sound file
	if ( !len(trim(arguments.image)) && isSoundFile(arguments.file) ) {
		// have to adjust the skin height if no image is used and file is 'sound'
		arguments.height = getSkinHeight(arguments.skin);	
		arguments.controlbarposition = 'bottom';
		arguments.dock = false;
		arguments.icons = false;
	}

	// Playlist
	if ( local.isPlaylist ) {
		// add support for iOS to enable one-finger scrolling!
		variables.pluginConfig.addToHTMLFootQueue('extensions/scripts/scriptsiOS.cfm');

		if ( !ListFindNoCase('bottom,top,right,left,over,none', arguments.playlistposition) || toBoolean(arguments.useflow) ) { 
			arguments.playlistposition='none';
		}

		if ( ListFindNoCase('left,right', arguments.playlistposition) ) {
			arguments.width = arguments.width + arguments.playlistsize;
		} else if ( ListFindNoCase('top,bottom', arguments.playlistposition) ) {
			arguments.height = arguments.height + arguments.playlistsize;
		}
	}

	// Repeat
	if ( !ListFindNoCase('none,list,always,single', arguments.repeat) ) {
		arguments.repeat = 'none';
	}

	// Stretching
	if ( !ListFindNoCase('none,exactfit,uniform,fill', arguments.stretching) ) {
		arguments.stretching = 'fill';
	}

	// If media file is an image...eventually will have UI to accomodate this
	if ( ListFindNoCase('jpg,jpeg,png,gif', ListLast(arguments.file, '.')) ) {
		arguments.duration = 5;
	}

	// Plugin: FLOW
	if ( toBoolean(arguments.useflow) ) {
		if ( !ListFindNoCase('top,bottom,left,right', arguments.flowposition) ) {
			arguments.flowposition = '';
		};
		if ( Len(trim(arguments.flowposition)) ) {
			if ( ListFindNoCase('left,right', arguments.flowposition) && !IsNumeric(arguments.flowsize) ) {
				arguments.flowsize=Val(arguments.width)/2;
			} else if ( ListFindNoCase('top,bottom', arguments.flowposition) ) {
				if ( !isNumeric(arguments.flowsize) ) {
					arguments.flowsize=Val(arguments.height)/2;
				}
				// clicking media thumbnails is buggy with showtext on when positioned top/bottom
				arguments.flowshowtext=false;
			}
		}
	}
</cfscript></cfsilent>
<cfoutput>
	<div class="muraPlayerOuterWrapper">
		<div id="#local.playerid#"></div>
	</div>
	<script type="text/javascript">
		jQuery(document).ready(function($){
			jwplayer("#local.playerid#").setup({

				// PROPERTIES
				flashplayer: encodeURI("#local.flashplayer#"),
				<cfif len(trim(arguments.file))>
				file: encodeURI("#arguments.file#"),
				</cfif>
				<cfif len(trim(arguments.playlist))>
				playlist: #arguments.playlist#,
				</cfif>
				<cfif local.isPlaylist>
				'playlist.position': '#arguments.playlistposition#',
				'playlist.size': '#arguments.playlistsize#',
				shuffle: #arguments.shuffle#,
				</cfif>
				<cfif len(trim(arguments.title))>
				title: "#HTMLEditFormat(arguments.title)#",
				</cfif>
				<cfif len(trim(arguments.description))>
				description: "#HTMLEditFormat(arguments.description)#",
				</cfif>
				<cfif len(trim(arguments.streamer)) and arguments.streamer neq 'rtmp:///cfx/st'>
				provider: "rtmp",
				streamer: encodeURI("#arguments.streamer#"),
				</cfif>
				mediaid: "#arguments.mediaid#",
				<cfif arguments.duration neq 0>
				duration: #Val(arguments.duration)#,
				</cfif>
				<cfif len(arguments.image)>
				image: encodeURI("#arguments.image#"),
				</cfif>
				width: "#arguments.width#",
				height: "#arguments.height#",

				// LAYOUT
				controlbar: {
					position: "#arguments.controlbarposition#",
					idlehide: #toBoolean(arguments.controlbaridlehide)#,
				},
				display: {showmute: #toBoolean(arguments.displayshowmute)#},
				dock: #toBoolean(arguments.dock)#,
				icons: #toBoolean(arguments.icons)#,
				<cfif arguments.skin neq 'default'>
				skin: "#getPluginPath()#assets/players/jwplayer/skins/#arguments.skin#.zip",
				</cfif>

				// BEHAVIOR
				autostart: #toBoolean(arguments.autostart)#,
				id: "player_#arguments.mediaid#",
				mute: #toBoolean(arguments.mute)#,
				repeat: "#arguments.repeat#",
				shuffle: #toBoolean(arguments.shuffle)#,
				smoothing: #toBoolean(arguments.smoothing)#,
				stretching: "#arguments.stretching#",
				volume: "#Val(arguments.volume)#",
				<cfif Val(arguments.bufferlength) neq 1>
				bufferlength: "#Val(arguments.bufferlength)#",
				</cfif>
				<cfif Val(arguments.item) neq 0>
				item: "#Val(arguments.item)#",
				</cfif>

				// PLUGINS
				plugins: {
					<cfif toBoolean(arguments.allowfacebooklike)>
					"like-1": {},
					</cfif>
					<cfif toBoolean(arguments.allowsharing) and IsValid('url', arguments.sharinglink)>
					"sharing-3": {
						"link": encodeURI("#arguments.sharinglink#"),
						"heading": "Share this!",
					},
					</cfif>
					<cfif toBoolean(arguments.usegapro)>
					"gapro-2": {
						"trackstarts": #toBoolean(arguments.gaprotrackstarts)#,
						"trackpercentage": #toBoolean(arguments.gaprotrackpercentage)#,
						"tracktime": #toBoolean(arguments.gaprotracktime)#,
						"idstring": "#arguments.gaproidstring#",
					},
					</cfif>
					<cfif toBoolean(arguments.uselightsout)>
					"lightsout-1": {
						"backgroundcolor": "#Right(arguments.lightsoutbgcolor, 6)#",
						"dockicon": #toBoolean(arguments.lightsoutdockicon)#,
						"opacity": "#arguments.lightsoutopacity#",
						"time": "#arguments.lightsouttime#",
						"onidle": "#arguments.lightsoutonidle#",
						"onplay": "#arguments.lightsoutonplay#",
						"onpause": "#arguments.lightsoutonpause#",
						"oncomplete": "#arguments.lightsoutoncomplete#",
					},
					</cfif>
					<cfif local.isPlaylist and toBoolean(arguments.useflow)>
					"flow-2": {
						<cfif IsNumeric(arguments.flowcoverheight)>
						"coverheight": "#arguments.flowcoverheight#",
						</cfif>
						<cfif IsNumeric(arguments.flowcoverwidth)>
						"coverwidth": "#arguments.flowcoverwidth#",
						</cfif>
						"showtext": #toBoolean(arguments.flowshowtext)#,
						"position": "#arguments.flowposition#",
						"size": "#arguments.flowsize#",
					},
					</cfif>

				}, //@END plugins
			}); // @END jwplayer
		}); // @END jQuery
	</script>
</cfoutput>