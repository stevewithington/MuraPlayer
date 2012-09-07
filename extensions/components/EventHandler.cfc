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
component extends="mura.plugin.pluginGenericEventHandler" accessors=true output=false {

	property name='$' hint='mura scope';
	property name='playerSkinsOptionList';
	property name='playerSkinsOptionLabelList';
	property name='playerDimensionsOptionList';
	property name='playerDimensionsOptionLabelList';
	property name='playerVolumeOptionList';
	property name='playerVolumeOptionLabelList';
	
	// ---------------------------------------------------------------------
	// MURA EVENTS
	// ---------------------------------------------------------------------
	public void function onApplicationLoad(required struct $) output=false {
		var local = {};
		set$(arguments.$);
		variables.pluginConfig.addEventHandler(this);

		// set option lists
		setPlayerSkinsOptionList();
		setPlayerSkinsOptionLabelList();
		setPlayerDimensionsOptionList();
		setPlayerDimensionsOptionLabelList();
		setPlayerVolumeOptionList();
		setPlayerVolumeOptionLabelList();

		// this will enable the ability to dynamically populate dropdowns, etc. for player options...e.g., application.muraPlayer.getPlayerSkinsOptionList()
		lock scope='application' type='exclusive' timeout=10 {
			application.muraPlayer = this;
		};
	}

	public void function onSiteRequestStart(required struct $) output=false {
		var local = {};
		arguments.$.setCustomMuraScopeKey('muraPlayer', this);
		set$(arguments.$);
	}
	
	public void function onRenderStart(required struct $) output=false {
		var local = {};
		set$(arguments.$);
		arguments.$.loadJSLib();
	}

	public any function onPageMuraPlayerBodyRender(required struct $) output=false {
		var local = {};

		// Content Body
		local.body = $.setDynamicContent($.content('body'));

		// Width x Height
		if ( $.content('muraPlayerDimensions') == 'default' ) {
			local.width = ListFirst($.siteConfig('muraPlayerDimensionsDefault'), 'x');
			local.height = ListLast($.siteConfig('muraPlayerDimensionsDefault'), 'x');
		} else {
			local.width = ListFirst($.content('muraPlayerDimensions'), 'x');
			local.height = ListLast($.content('muraPlayerDimensions'), 'x');
		};

		// File
		local.file = IsValid('url', $.content('muraPlayerYouTubeURL')) ? $.content('muraPlayerYouTubeURL') : getFileURL($.content('muraPlayerFile'));

		if ( !Len(Trim(local.file)) ) {
			local.file = $.getURLForImage(fileid=$.content('muraPlayerFile'),width=local.width,height=local.height);
		};

		// Image
		local.image = $.getURLForImage(fileid=$.content('fileid'),width=local.width,height=local.height);

		// If media file is an image and no associated image exists, use media file
		if ( !Len(Trim(local.image)) && ListFindNoCase('jpg,jpeg,png,gif', ListLast(local.file, '.')) ) {
			local.image = local.file;
		};

		// Skin
		local.skin = $.content('muraPlayerSkin');
		if ( local.skin == 'siteDefault' ) {
			local.skin = $.siteConfig('muraPlayerSkinDefault');
		};

		// Amazon CloudFront + Streaming
		// we need to append '/cfx/st' to it for Amazon CloudFront streaming
		local.streamer = $.siteConfig('muraPlayerStreamURL') & '/cfx/st';

		// Player
		local.player = dspJWPlayer(
			file = local.file
			,streamer = local.streamer
			,mediaid = $.content('contentid')
			,image = local.image
			,width = local.width
			,height = local.height
			,skin = local.skin
			,title = $.content('title')
			,description = $.content('muraPlayerDescription')
			,controlbarposition = $.content('muraPlayerControlbarPosition')
			,controlbaridlehide = $.content('muraPlayerControlbarIdleHide')
			,autostart = $.content('muraPlayerAutoStart')
			,mute = $.content('muraPlayerMute')
			,displayshowmute = $.content('muraPlayerShowMute')
			,repeat = $.content('muraPlayerRepeat')
			,stretching = $.content('muraPlayerStretching')
			,volume = Val($.content('muraPlayerVolume'))
			,allowsharing = $.content('muraPlayerAllowSharing')
			,sharingurl = $.content('url')
			,allowgoogleplus = $.content('muraPlayerAllowGooglePlus')
			,allowfacebooklike = $.content('muraPlayerAllowFacebookLike')
			,usegapro = $.siteConfig('muraPlayerUseGAPro')
			,gaprotrackstarts = $.siteConfig('muraPlayerGAProTrackStarts')
			,gaprotrackpercentage = $.siteConfig('muraPlayerGAProTrackPercentage')
			,gaprotracktime = $.siteConfig('muraPlayerGAProTrackTime')
			,gaprohidden = $.content('muraPlayerGAProHidden')
			,uselightsout = $.siteConfig('muraPlayerUseLightsOut')
			,lightsoutdockicon = $.siteConfig('muraPlayerLightsOutDockIcon')
			,lightsoutopacity = $.siteConfig('muraPlayerLightsOutOpacity')
			,lightsoutbgcolor = $.siteconfig('muraPlayerLightsOutBGColor')
			,lightsouttime = $.siteconfig('muraPlayerLightsOutTime')
			,lightsoutonidle = $.siteconfig('muraPlayerLightsOutOnIdle')
			,lightsoutonplay = $.siteconfig('muraPlayerLightsOutOnPlay')
			,lightsoutonpause = $.siteconfig('muraPlayerLightsOutOnPause')
			,lightsoutoncomplete = $.siteconfig('muraPlayerLightsOutOnComplete')
		);

		return local.player & local.body;
	}


	/**
	* Portal / MuraPlaylist
	* 
	*/
	public any function onPortalMuraPlaylistBodyRender(required struct $) output=false {
		var local = {};
		// Content Body
		local.body = $.setDynamicContent($.content('body'));

		// MuraPlayersBean 
		local.muraPlayersBean = getMuraPlayersBean(
			sortBy=$.content('sortBy')
			,sortDirection=$.content('sortDirection')
			,maxItems=$.globalConfig('maxPortalItems')
			,showNavOnly=true
			,showChildrenOnly=$.content('muraPlaylistShowChildrenOnly')
			,parentContentID=$.content('contentid')
		);

		// Skin
		local.skin = $.content('muraPlayerSkin');
		if ( local.skin == 'siteDefault' ) {
			local.skin = $.siteConfig('muraPlayerSkinDefault');
		};

		// Width x Height
		if ( $.content('muraPlayerDimensions') == 'default' ) {
			local.width = ListFirst($.siteConfig('muraPlayerDimensionsDefault'), 'x');
			local.height = ListLast($.siteConfig('muraPlayerDimensionsDefault'), 'x');
		} else {
			local.width = ListFirst($.content('muraPlayerDimensions'), 'x');
			local.height = ListLast($.content('muraPlayerDimensions'), 'x');
		};

		local.height = local.height + getSkinHeight(local.skin);

		// Playlist
		local.playlist = getJWPlaylist(
			width=local.width
			,height=local.height
			,muraPlayersBean = local.muraPlayersBean
		);

		// Image
		local.image = $.getURLForImage(fileid=$.content('fileid'),width=local.width,height=local.height);

		// Amazon CloudFront + Streaming
		// we need to append '/cfx/st' to it for Amazon CloudFront streaming
		local.streamer = $.siteConfig('muraPlayerStreamURL') & '/cfx/st';

		local.player = dspJWPlayer(
			playlist = local.playlist
			,streamer = local.streamer
			,mediaid = $.content('contentid')
			,image = local.image
			,width = local.width
			,height = local.height
			,skin = local.skin
			,controlbarposition = $.content('muraPlayerControlbarPosition')
			,controlbaridlehide = $.content('muraPlayerControlbarIdleHide')
			,autostart = $.content('muraPlayerAutoStart')
			,mute = $.content('muraPlayerMute')
			,displayshowmute = $.content('muraPlayerShowMute')
			,repeat = $.content('muraPlayerRepeat')
			,stretching = $.content('muraPlayerStretching')
			,volume = Val($.content('muraPlayerVolume'))
			,useflow = $.content('muraPlaylistUseFlow')
			,flowposition = $.content('muraPlaylistFlowPosition')
			,allowsharing = $.content('muraPlayerAllowSharing')
			,allowgoogleplus = $.content('muraPlayerAllowGooglePlus')
			,allowfacebooklike = $.content('muraPlayerAllowFacebookLike')
			,usegapro = $.siteConfig('muraPlayerUseGAPro')
			,gaprotrackstarts = $.siteConfig('muraPlayerGAProTrackStarts')
			,gaprotrackpercentage = $.siteConfig('muraPlayerGAProTrackPercentage')
			,gaprotracktime = $.siteConfig('muraPlayerGAProTrackTime')
			,uselightsout = $.siteConfig('muraPlayerUseLightsOut')
			,lightsoutdockicon = $.siteConfig('muraPlayerLightsOutDockIcon')
			,lightsoutopacity = $.siteConfig('muraPlayerLightsOutOpacity')
			,lightsoutbgcolor = $.siteconfig('muraPlayerLightsOutBGColor')
			,lightsouttime = $.siteconfig('muraPlayerLightsOutTime')
			,lightsoutonidle = $.siteconfig('muraPlayerLightsOutOnIdle')
			,lightsoutonplay = $.siteconfig('muraPlayerLightsOutOnPlay')
			,lightsoutonpause = $.siteconfig('muraPlayerLightsOutOnPause')
			,lightsoutoncomplete = $.siteconfig('muraPlayerLightsOutOnComplete')
		);
		return local.player & local.body;
	}

	// Possibly create a Custom UI in future version
	// public any function onContentEdit(required struct $) output=false {
	// 	var local = {};
	// 	savecontent variable='local.str' {
	// 		include 'includes/onContentEdit.cfm';
	// 	};
	// 	return local.str;
	// }


	// ---------------------------------------------------------------------
	// DISPLAY OBJECTS
	// ---------------------------------------------------------------------
	// JW PLAYER
	public any function dspJWPlayer(
		file=''
		,playlist=''
		,playlistposition='right'
		,playlistsize='180'
		,mediaid='#CreateUUID()#'
		,image=''
		,width='480'
		,height='272'
		,skin='default'
		,title=''
		,description=''
		,duration='0'
		,controlbarposition='bottom'
		,controlbaridlehide=false
		,displayshowmute=false
		,dock=true
		,icons=true
		,autostart=false
		,bufferlength='1'
		,item='0'
		,mute=false
		,repeat='none'
		,shuffle=false
		,smoothing=true
		,stretching='fill'
		,volume='90'
		,hdfile=''
		,hdstate=false
		,usegapro=false
		,gaprotrackstarts=true
		,gaprotrackpercentage=true
		,gaprotracktime=true
		,gaproidstring='||mediaid||-||title||-||file||'
		,gaprohidden=false
		,allowsharing=true
		,sharinglink=''
		,allowfacebooklike=false
		,allowgoogleplus=false
		,uselightsout=false
		,lightsoutdockicon=true
		,lightsoutopacity='0.8'
		,lightsoutbgcolor='000000'
		,lightsouttime='800'
		,lightsoutonidle='on'
		,lightsoutonplay='off'
		,lightsoutonpause='on'
		,lightsoutoncomplete='on'
		,usecaptions=false
		,captionsback=true
		,captionsfile=''
		,captionsfontsize='14'
		,captionsstate=false
		,useagegate=false
		,agegateminage='18'
		,agegatemaxage='100'
		,agegatemessage=''
		,agegatebgcolor='000000'
		,agegatetextcolor='FFFFFF'
		,agegatesubheadertextcolor='FFCC00'
		,agegatemessagetextcolor='FFFFFF'
		,agegatecookielife='60'
		,agegateheader=''
		,agegatesubheader=''
		,agegateautoredirect=false
		,agegateredirecturl=''
		,agegateredirecttarget='_blank'
		,useflow=false
		,flowcoverheight=''
		,flowcoverwidth='150'
		,flowshowtext=true
		,flowposition=''
		,flowsize=''
		,flashplayer=''
		,streamer='#$.siteConfig('muraPlayerStreamURL')#/cfx/st'
	) output=false {
		var local = {};
		if ( !Len(Trim(arguments.file)) && ( arguments.playlist == '[]' || arguments.playlist == '') ) {
			return '';
		};
		savecontent variable='local.str' {
			include 'includes/jwPlayer.cfm';
		};
		return local.str;
	}

	// JW PLAYER PLAYLIST
	// you can also pass in any of the arguments available for dspJWPlayer()
	public any function dspJWPlaylist() output=false {
		var local = {};
		// allow for configured display object in future version
		local.params = IsJSON($.event('objectParams')) ? DeSerializeJSON($.event('objectParams')) : {};
		local.defaultParams = {
			playlist = getJWPlaylist()
		};
		StructAppend(local.params, arguments, false);
		StructAppend(local.params, local.defaultParams, false);
		local.str = dspJWPlayer(argumentCollection=local.params);
		return local.str;
	}

	/**
	* Configured JW Playlist
	*/
	// public any function dspConfiguredJWPlaylist() output=false {
	// 	return dspJWPlaylist();
	// }


	// ---------------------------------------------------------------------
	// OTHER
	// ---------------------------------------------------------------------

	/**
	* getJWPlaylist()
	* @listContentIDs a comma-separated list of contentID's to play
	*/
	public any function getJWPlaylist(
		listContentIDs=''
		,listDelim=','
		,width='#ListFirst($.siteConfig('muraPlayerDimensionsDefault'), 'x')#'
		,height='#ListLast($.siteConfig('muraPlayerDimensionsDefault'), 'x')#'
		,muraPlayersBean='#getMuraPlayersBean()#'
	) output=false {
		var local = {};
		local.playlist = [];
		local.it = arguments.muraPlayersBean.getIterator();

		if ( local.it.hasNext() ) {
			while ( local.it.hasNext() ) {
				local.item = local.it.next();

				if ( !Len(Trim(arguments.listContentIDs)) || ( Len(Trim(arguments.listContentIDs)) && ListFindNoCase(arguments.listContentIDs, local.item.getValue('contentid')) ) ) {
			
					local.isYouTube = IsValid('url', local.item.getValue('muraPlayerYouTubeURL')) ? true : false;

					// File
					local.file = local.isYouTube
						? local.item.getValue('muraPlayerYouTubeURL') 
						: getFileURL(local.item.getValue('muraPlayerFile'));

					// Image
					local.image = $.getURLForImage(
						fileid=local.item.getValue('fileid')
						,width=arguments.width
						,height=arguments.height
					);

					if ( !local.isYouTube && !Len(Trim(local.image)) ) {
						if ( isSoundFile(local.file) ) {
							local.image = getMuraPlayerDefaultImage('sound');
						} else {
							local.image = getMuraPlayerDefaultImage('video');
						}
					}

					// Add the item to the playlist
					ArrayAppend(local.playlist,
						{
							'file' = local.file
							,'image' = local.image
							,'title' = local.item.getValue('title')
							,'description' = local.item.getValue('muraPlayerDescription')
							,'link' = local.item.getURL(complete=true)
							,'gapro.hidden' = local.item.getValue('muraPlayerGAProHidden')
						}
					);

				};
			};	
		};

		return SerializeJSON(local.playlist);
	}

	public any function getMuraPlayersBean(
		sortBy='title'
		,sortDirection='asc'
		,maxItems='0'
		,showNavOnly=true
		,showChildrenOnly=false
		,parentContentID='#$.content('contentid')#'
	) output=false {
		var local = {};
		
		// create a dynamic feed of Page/MuraPlayer subtypes
		local.fBean = $.getBean('feed');
		local.fBean.setName('MuraPlayers');
		local.fBean.setSortBy(arguments.sortBy);
		local.fBean.setSortDirection(arguments.sortDirection);
		local.fBean.setMaxItems(arguments.maxItems); // 0 = unlimited
		local.fBean.setShowNavOnly(toBoolean(arguments.showNavOnly));

		// Show Children Only?
		if ( ( $.content('type') == 'Portal' && $.content('subtype') == 'MuraPlaylist' && toBoolean($.content('muraPlaylistShowChildrenOnly')) ) || toBoolean(arguments.showChildrenOnly) && IsValid('uuid', arguments.parentContentID) ) {
			local.fBean.addAdvancedParam(
				relationship='AND'
				, field='tcontent.parentid'
				, condition='eq'
				, criteria=arguments.parentContentID
			);
		};

		local.fBean.addParam(
			relationship='AND'
			,field='tcontent.Type'
			,criteria='Page'
			,dataType='varchar'
		);
		local.fBean.addParam(
			relationship='AND'
			,field='tcontent.SubType'
			,criteria='MuraPlayer'
			,dataType='varchar'
		);

		return local.fBean;
	}


	// ---------------------------------------------------------------------
	// OPTION LISTS
	// ---------------------------------------------------------------------

	// Player Dimensions
	private void function setPlayerDimensionsOptionList() output=false {
		variables.playerDimensionsOptionList = 'default^320x240^480x360^640x480^400x225^480x272^640x360^720x405^960x540^1280x720^1920x1080';
	}

	public string function getPlayerDimensionsOptionList(boolean includeDefault=true) output=false {
		if ( arguments.includeDefault ) {
			return variables.playerDimensionsOptionList;
		} else {
			return ListDeleteAt(variables.playerDimensionsOptionList, 1, '^');
		};
	}

	private void function setPlayerDimensionsOptionLabelList() output=false {
		variables.playerDimensionsOptionLabelList = 'Use Default Dimensions From Site Settings^320x240 (4:3)^480x360 (4:3)^640x480 (4:3)^400x225 (16:9)^480x272 (16:9)^640x360 (16:9)^720x405 (16:9)^960x540 (16:9)^1280x720 (16:9)^1920x1080 (16:9)';
	}

	public string function getPlayerDimensionsOptionLabelList(boolean includeDefault=true) output=false {
		if ( arguments.includeDefault ) {
			return variables.playerDimensionsOptionLabelList;
		} else {
			return ListDeleteAt(variables.playerDimensionsOptionLabelList, 1, '^');
		};
	}

	// Player Skins
	private void function setPlayerSkinsOptionList() output=false {
		var local = {};
		var delim = $.globalConfig('fileDelim');
		local.path = pluginConfig.getFullPath() & delim & 'assets' & delim & 'players' & delim & 'jwplayer' & delim & 'skins';
		variables.playerSkinsOptionList = REReplaceNoCase(
			ArrayToList(DirectoryList(local.path,false,'name','*.zip','directory ASC'),'^')
			, '.zip'
			, ''
			, 'ALL'
		);
	}

	public string function getPlayerSkinsOptionList(boolean includeSiteDefault=true) output=false {
		if ( arguments.includeSiteDefault ) {
			return 'siteDefault^default^' & variables.playerSkinsOptionList;
		} else {
			return 'default^' & variables.playerSkinsOptionList;
		};
	}

	private void function setPlayerSkinsOptionLabelList() output=false {
		variables.playerSkinsOptionLabelList = capitalizeAll(getPlayerSkinsOptionList(false));
	}

	public string function getPlayerSkinsOptionLabelList(boolean includeSiteDefault=true) output=false {
		if ( arguments.includeSiteDefault ) {
			return 'Use Skin From Site Settings^' & variables.playerSkinsOptionLabelList;
		} else {
			return variables.playerSkinsOptionLabelList;
		};
	}

	private void function setPlayerVolumeOptionList() output=false {
		var local = {};
		local.str = '';
		for ( local.i = 0; local.i <= 100; local.i++ ) {
			local.str = local.str & local.i;
			if ( local.i != 100 ) {
				local.str = local.str & '^';
			};
		};
		variables.playerVolumeOptionList = local.str;
	}

	private void function setPlayerVolumeOptionLabelList() output=false {
		variables.playerVolumeOptionLabelList = getPlayerVolumeOptionList();
	}


	// ---------------------------------------------------------------------
	// HELPERS
	// ---------------------------------------------------------------------

	public any function getSkinHeight(string skin='') output=false {
		switch( arguments.skin ) {
			case 'beelden' :
				return 30;
				break;
			case 'bekle' :
				return 60;
				break;
			case 'classic' :
				return 20;
				break;
			case 'five' :
				return 24;
				break;
			case 'glow' :
				return 29;
				break;
			case 'lulu' :
				return 32;
				break;
			case 'minima' :
				return 24;
				break;
			case 'modieus' :
				return 30;
				break;
			case 'nacht' :
				return 24;
				break;
			case 'schoon' :
				return 34;
				break;
			case 'simple' :
				return 24;
				break;
			case 'slim' :
				return 19;
				break;
			case 'snel' :
				return 32;
				break;
			case 'stijl' :
				return 40;
				break;
			case 'stormtrooper' :
				return 25;
				break;
			default : 
				return 24;
		};
	}

	/**
	* To be used in a future version of the plugin
	* @tables a comma-separated list of tables to backup OR leave blank to backup entire db.
	*/
	public any function dbBackup(string tables='') output=false {
		var local = {};
		local.data  = {};
		local.tableCount = 0;
		local.db = new dbinfo(datasource=$.globalConfig('datasource'));
		local.rsDBTables = local.db.tables();
		for ( local.i=1; local.i <= local.rsDBTables.recordcount; local.i++ ) {
			local.table = local.rsDBTables["TABLE_NAME"][i];
			if ( ListFindNoCase(arguments.tables, local.table) || !Len(Trim(arguments.tables)) ) {
				local.tableCount++;
				local.data[local.table] = {};
				// schema
				local.rsTableFields = new dbinfo(datasource=$.globalConfig('datasource'),table=local.table).columns();
				local.data[local.table].schema = local.rsTableFields;
				// data
				local.rsData = new Query(datasource=$.globalConfig('datasource'),sql='SELECT * FROM #local.table#').execute().getResult();
				local.data[local.table].data = local.rsData;
			};
		};
		// serialize data
		local.wddx = new Lib().wddx(action="cfml2wddx",input=local.data);
		// create .zip file
		local.zipBackup = new Lib().zipDBBackup(wddx=local.wddx);
		return 'I backed up #local.tableCount# of #local.rsDBTables.recordcount# total tables available. You''re welcome!';
	}

	public boolean function toBoolean(any arg='') output=false {
		return IsBoolean(arg) && arg ? true : false;
	}

	public any function isSoundFile(string file='') output=false {
		return toBoolean(ListFindNoCase('aac,m4a,mp3,ogg', ListLast(arguments.file, '.')));
	}

	public any function getMuraPlayerDefaultImage(string type='') output=false {
		switch(arguments.type) {
			case 'sound' :
				return getPluginPath() & 'assets/images/sound_noimage.jpg';
				break;
			default :
				return getPluginPath() & 'assets/images/video_noimage.png';
		};
	}

	public string function getPluginPath() output=false {
		return $.globalConfig('context') & '/plugins/' & pluginConfig.getDirectory() & '/';
	}

	// capitalize all words in the string
	public string function capitalizeAll(string str='') output=false {
		return ReReplace(arguments.str, '\b(\w)', '\u\1', 'ALL');
	}

	public string function getFileURL(string fileid='', string method='inline') output=false {
		var local = {};
		local.fileURL = '';
		local.rsFileData = getBean('fileManager').read(arguments.fileid);

		if ( !local.rsFileData.recordcount || !ListFindNoCase('audio,video', local.rsFileData.contenttype) ) {
			return '';
		} else {

			switch( $.globalConfig('filestore') ) {

				case 'database' : 
					Throw(type='InvalidData',message='Filestore setting of "database" not supported.');
					break;

				case 'filedir' :
					local.fileURL = '#$.globalConfig('context')#/#local.rsFileData.siteid#/cache/file/#local.rsFileData.fileid#.#local.rsFileData.fileExt#';
					break;
	
				// S3 = files are stored on Amazon S3
				// If they also use CloudFront AND have set up a streaming distribution url, then we could use it to optimize delivery of the media through the player
				// Amazon CloudFront Streaming - http://docs.amazonwebservices.com/AmazonCloudFront/latest/DeveloperGuide/
				case 'S3' :
					local.file = local.rsFileData.siteid & '/' & local.rsFileData.fileid & '.' & local.rsFileData.fileext;

					local.baseurl	= getPageContext().getRequest().getScheme() & '://s3.amazonaws.com/' & ListLast($.globalConfig('fileStoreAccessInfo'),'^') & '/';

					// if a cloudurl exists, let's use it
					// example cloud url: http://cloud.domain.com
					local.cloudurl = $.siteConfig('muraPlayerCloudURL');
					if ( len(trim(local.cloudurl)) && IsValid('url', local.cloudurl) ) {
						if ( right(local.cloudurl, 1) != '/' ) {
							local.cloudurl = local.cloudurl & '/';
						};
						local.baseurl = local.cloudurl;
					};

					if ( len(trim($.siteConfig('muraPlayerStreamURL'))) ) {
						// we don't need to provide the full url if we're streaming since we're going to provide a streaming url instead
						local.baseurl = '';
					};

					// finish building the url to the media file
					local.fileURL = local.baseurl & local.file;
					break;
			};

			return local.fileURL;
		};
	}

}