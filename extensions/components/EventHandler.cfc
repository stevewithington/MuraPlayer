/**
* 
* This file is part of MuraPlayer TM
*
* Copyright 2010-2014 Stephen J. Withington, Jr.
* Licensed under the Apache License, Version v2.0
* http://www.apache.org/licenses/LICENSE-2.0
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
		arguments.$.loadJSLib();
		set$(arguments.$);
	}

	public any function onPageMuraPlayerBodyRender(required struct $) output=false {
		var local = {};
		set$(arguments.$);
		local.$ = arguments.$;

		// Content Body
		local.body = local.$.setDynamicContent(local.$.content('body'));

		// Skin
		local.skin = local.$.content('muraPlayerSkin');
		if ( local.skin == 'siteDefault' ) {
			local.skin = local.$.siteConfig('muraPlayerSkinDefault');
		};

		// Width x Height
		if ( local.$.content('muraPlayerDimensions') == 'default' ) {
			local.width = ListFirst(local.$.siteConfig('muraPlayerDimensionsDefault'), 'x');
			local.height = ListLast(local.$.siteConfig('muraPlayerDimensionsDefault'), 'x');
		} else {
			local.width = ListFirst(local.$.content('muraPlayerDimensions'), 'x');
			local.height = ListLast(local.$.content('muraPlayerDimensions'), 'x');
		};

		if ( !ListFindNoCase('over,none', local.$.content('muraPlayerControlbarPosition')) ) {
			local.height = local.height + getSkinHeight(local.skin);
		};

		// File
		local.file = IsValid('url', local.$.content('muraPlayerYouTubeURL')) ? local.$.content('muraPlayerYouTubeURL') : getFileURL(local.$.content('muraPlayerFile'));

		if ( !Len(Trim(local.file)) ) {
			local.file = local.$.getURLForImage(
				fileid = local.$.content('muraPlayerFile')
				,width = local.width
				,height = local.height
			);
		};

		// Image
		local.image = local.$.getURLForImage(
			fileid = local.$.content('fileid')
			,width = local.width
			,height = local.height
		);

		// If media file is an image and no associated image exists, use media file
		if ( !Len(Trim(local.image)) && ListFindNoCase('jpg,jpeg,png,gif', ListLast(local.file, '.')) ) {
			local.image = local.file;
		};

		// Amazon CloudFront + Streaming
		local.streamer = '';
		if ( len(trim(local.$.siteConfig('muraPlayerStreamURL'))) ) {
			// we need to append '/cfx/st' to it for Amazon CloudFront streaming
			local.streamer = local.$.siteConfig('muraPlayerStreamURL') & '/cfx/st';
			if ( left(local.streamer, 4) != 'rtmp' ) {
				local.streamer = 'rtmp://' & local.streamer;
			};
		};

		// Player
		local.player = dspJWPlayer(
			file = local.file
			,streamer = local.streamer
			,mediaid = local.$.content('contentid')
			,image = local.image
			,width = local.width
			,height = local.height
			,skin = local.skin
			,title = local.$.content('title')
			,description = local.$.content('muraPlayerDescription')
			,controlbarposition = local.$.content('muraPlayerControlbarPosition')
			,controlbaridlehide = local.$.content('muraPlayerControlbarIdleHide')
			,autostart = local.$.content('muraPlayerAutoStart')
			,mute = local.$.content('muraPlayerMute')
			,displayshowmute = local.$.content('muraPlayerShowMute')
			,repeat = local.$.content('muraPlayerRepeat')
			,stretching = local.$.content('muraPlayerStretching')
			,volume = Val(local.$.content('muraPlayerVolume'))
			,allowsharing = local.$.content('muraPlayerAllowSharing')
			,sharingurl = local.$.content('url')
			,allowgoogleplus = local.$.content('muraPlayerAllowGooglePlus')
			,allowfacebooklike = local.$.content('muraPlayerAllowFacebookLike')
			,usegapro = local.$.siteConfig('muraPlayerUseGAPro')
			,gaprotrackstarts = local.$.siteConfig('muraPlayerGAProTrackStarts')
			,gaprotrackpercentage = local.$.siteConfig('muraPlayerGAProTrackPercentage')
			,gaprotracktime = local.$.siteConfig('muraPlayerGAProTrackTime')
			,gaprohidden = local.$.content('muraPlayerGAProHidden')
			,uselightsout = local.$.siteConfig('muraPlayerUseLightsOut')
			,lightsoutdockicon = local.$.siteConfig('muraPlayerLightsOutDockIcon')
			,lightsoutopacity = local.$.siteConfig('muraPlayerLightsOutOpacity')
			,lightsoutbgcolor = local.$.siteconfig('muraPlayerLightsOutBGColor')
			,lightsouttime = local.$.siteconfig('muraPlayerLightsOutTime')
			,lightsoutonidle = local.$.siteconfig('muraPlayerLightsOutOnIdle')
			,lightsoutonplay = local.$.siteconfig('muraPlayerLightsOutOnPlay')
			,lightsoutonpause = local.$.siteconfig('muraPlayerLightsOutOnPause')
			,lightsoutoncomplete = local.$.siteconfig('muraPlayerLightsOutOnComplete')
		);

		return local.player & local.body;
	}


	/**
	* Folder / MuraPlaylist
	*/
	public any function onFolderMuraPlaylistBodyRender(required struct $) output=false {
		var local = {};
		set$(arguments.$);
		local.$ = arguments.$;

		// Content Body
		local.body = local.$.setDynamicContent(local.$.content('body'));

		// MuraPlayersBean 
		local.muraPlayersBean = getMuraPlayersBean(
			sortBy = local.$.content('sortBy')
			,sortDirection = local.$.content('sortDirection')
			,maxItems = local.$.globalConfig('maxPortalItems')
			,showNavOnly = true
			,showChildrenOnly = local.$.content('muraPlaylistShowChildrenOnly')
			,parentContentID = local.$.content('contentid')
		);

		// Skin
		local.skin = local.$.content('muraPlayerSkin');
		if ( local.skin == 'siteDefault' ) {
			local.skin = local.$.siteConfig('muraPlayerSkinDefault');
		};

		// Width x Height
		if ( local.$.content('muraPlayerDimensions') == 'default' ) {
			local.width = ListFirst(local.$.siteConfig('muraPlayerDimensionsDefault'), 'x');
			local.height = ListLast(local.$.siteConfig('muraPlayerDimensionsDefault'), 'x');
		} else {
			local.width = ListFirst(local.$.content('muraPlayerDimensions'), 'x');
			local.height = ListLast(local.$.content('muraPlayerDimensions'), 'x');
		};

		if ( !ListFindNoCase('over,none', local.$.content('muraPlayerControlbarPosition')) ) {
			local.height = local.height + getSkinHeight(local.skin);
		};

		// Playlist
		local.playlist = getJWPlaylist(
			width = local.width
			,height = local.height
			,muraPlayersBean = local.muraPlayersBean
		);

		// Image
		local.image = local.$.getURLForImage(
			fileid = local.$.content('fileid')
			,width = local.width
			,height = local.height
		);

		// JW Player
		local.player = dspJWPlayer(
			playlist = local.playlist
			,streamer = ''
			,mediaid = local.$.content('contentid')
			,image = local.image
			,width = local.width
			,height = local.height
			,skin = local.skin
			,controlbarposition = local.$.content('muraPlayerControlbarPosition')
			,controlbaridlehide = local.$.content('muraPlayerControlbarIdleHide')
			,autostart = local.$.content('muraPlayerAutoStart')
			,mute = local.$.content('muraPlayerMute')
			,displayshowmute = local.$.content('muraPlayerShowMute')
			,repeat = local.$.content('muraPlayerRepeat')
			,stretching = local.$.content('muraPlayerStretching')
			,volume = Val(local.$.content('muraPlayerVolume'))
			,useflow = local.$.content('muraPlaylistUseFlow')
			,flowposition = local.$.content('muraPlaylistFlowPosition')
			,allowsharing = local.$.content('muraPlayerAllowSharing')
			,allowgoogleplus = local.$.content('muraPlayerAllowGooglePlus')
			,allowfacebooklike = local.$.content('muraPlayerAllowFacebookLike')
			,usegapro = local.$.siteConfig('muraPlayerUseGAPro')
			,gaprotrackstarts = local.$.siteConfig('muraPlayerGAProTrackStarts')
			,gaprotrackpercentage = local.$.siteConfig('muraPlayerGAProTrackPercentage')
			,gaprotracktime = local.$.siteConfig('muraPlayerGAProTrackTime')
			,uselightsout = local.$.siteConfig('muraPlayerUseLightsOut')
			,lightsoutdockicon = local.$.siteConfig('muraPlayerLightsOutDockIcon')
			,lightsoutopacity = local.$.siteConfig('muraPlayerLightsOutOpacity')
			,lightsoutbgcolor = local.$.siteconfig('muraPlayerLightsOutBGColor')
			,lightsouttime = local.$.siteconfig('muraPlayerLightsOutTime')
			,lightsoutonidle = local.$.siteconfig('muraPlayerLightsOutOnIdle')
			,lightsoutonplay = local.$.siteconfig('muraPlayerLightsOutOnPlay')
			,lightsoutonpause = local.$.siteconfig('muraPlayerLightsOutOnPause')
			,lightsoutoncomplete = local.$.siteconfig('muraPlayerLightsOutOnComplete')
		);

		return local.player & local.body;
	}

	// Possibly create a Custom UI in future version
	// public any function onContentEdit(required struct $) output=false {
	// 	var local = {};
	//	local.$ = arguments.$;
	//	set$(arguments.$);
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
		,streamer='rtmp://#get$().siteConfig('muraPlayerStreamURL')#/cfx/st'
	) output=false {
		var local = {};
		local.$ = get$();
		if ( !Len(Trim(arguments.file)) && ( arguments.playlist == '[]' || arguments.playlist == '' ) ) {
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
		local.$ = get$();
		// allow for configured display object in future version
		local.params = IsJSON(local.$.event('objectParams')) ? DeSerializeJSON(local.$.event('objectParams')) : {};
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
		,width='#ListFirst(get$().siteConfig('muraPlayerDimensionsDefault'), 'x')#'
		,height='#ListLast(get$().siteConfig('muraPlayerDimensionsDefault'), 'x')#'
		,muraPlayersBean='#getMuraPlayersBean()#'
	) output=false {
		var local = {};
		local.$ = get$();
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

					// Streaming
					local.streamer = !local.isYouTube && len(trim(local.$.siteConfig('muraPlayerStreamURL'))) ? 'rtmp://#local.$.siteConfig('muraPlayerStreamURL')#/cfx/st' : '';

					// Image
					local.image = local.$.getURLForImage(
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
							,'streamer' = local.streamer
							,'mediaid' = local.item.getValue('contentid')
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
		,parentContentID='#get$().content('contentid')#'
	) output=false {
		var local = {};
		local.$ = get$();
		
		// create a dynamic feed of Page/MuraPlayer subtypes
		local.fBean = local.$.getBean('feed');
		local.fBean.setName('MuraPlayers');
		local.fBean.setSortBy(arguments.sortBy);
		local.fBean.setSortDirection(arguments.sortDirection);
		local.fBean.setMaxItems(arguments.maxItems); // 0 = unlimited
		local.fBean.setShowNavOnly(toBoolean(arguments.showNavOnly));

		// Show Children Only?
		if ( ( ListFindNoCase('Portal,Folder', local.$.content('type')) && local.$.content('subtype') == 'MuraPlaylist' && toBoolean(local.$.content('muraPlaylistShowChildrenOnly')) ) || toBoolean(arguments.showChildrenOnly) && IsValid('uuid', arguments.parentContentID) ) {
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
		return arguments.includeDefault ? variables.playerDimensionsOptionList : ListDeleteAt(variables.playerDimensionsOptionList, 1, '^');
	}

	private void function setPlayerDimensionsOptionLabelList() output=false {
		variables.playerDimensionsOptionLabelList = 'Use Default Dimensions From Site Settings^320x240 (4:3)^480x360 (4:3)^640x480 (4:3)^400x225 (16:9)^480x272 (16:9)^640x360 (16:9)^720x405 (16:9)^960x540 (16:9)^1280x720 (16:9)^1920x1080 (16:9)';
	}

	public string function getPlayerDimensionsOptionLabelList(boolean includeDefault=true) output=false {
		return arguments.includeDefault ? variables.playerDimensionsOptionLabelList : ListDeleteAt(variables.playerDimensionsOptionLabelList, 1, '^');
	}

	// Player Skins
	private void function setPlayerSkinsOptionList() output=false {
		var local = {};
		var delim = get$().globalConfig('fileDelim');
		local.path = pluginConfig.getFullPath() & delim & 'assets' & delim & 'players' & delim & 'jwplayer' & delim & 'skins';
		variables.playerSkinsOptionList = REReplaceNoCase(
			ArrayToList(DirectoryList(local.path,false,'name','*.zip','directory ASC'),'^')
			, '.zip'
			, ''
			, 'ALL'
		);
	}

	public string function getPlayerSkinsOptionList(boolean includeSiteDefault=true) output=false {
		return arguments.includeSiteDefault ? 'siteDefault^default^' & variables.playerSkinsOptionList : 'default^' & variables.playerSkinsOptionList;
	}

	private void function setPlayerSkinsOptionLabelList() output=false {
		variables.playerSkinsOptionLabelList = capitalizeAll(getPlayerSkinsOptionList(false));
	}

	public string function getPlayerSkinsOptionLabelList(boolean includeSiteDefault=true) output=false {
		return arguments.includeSiteDefault ? 'Use Skin From Site Settings^' & variables.playerSkinsOptionLabelList : variables.playerSkinsOptionLabelList;
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

	public any function get$() output=false {
		return StructKeyExists(variables, '$') ? variables.$ : application.serviceFactory.getBean('$').init(session.siteid);
	}

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
		local.db = new dbinfo(datasource=get$().globalConfig('datasource'));
		local.rsDBTables = local.db.tables();
		for ( local.i=1; local.i <= local.rsDBTables.recordcount; local.i++ ) {
			local.table = local.rsDBTables["TABLE_NAME"][i];
			if ( ListFindNoCase(arguments.tables, local.table) || !Len(Trim(arguments.tables)) ) {
				local.tableCount++;
				local.data[local.table] = {};
				// schema
				local.rsTableFields = new dbinfo(datasource=get$().globalConfig('datasource'),table=local.table).columns();
				local.data[local.table].schema = local.rsTableFields;
				// data
				local.rsData = new Query(datasource=get$().globalConfig('datasource'),sql='SELECT * FROM #local.table#').execute().getResult();
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
				return getPluginPath() & 'assets/images/sound_noimage.png';
				break;
			default :
				return getPluginPath() & 'assets/images/video_noimage.png';
		};
	}

	public string function getPluginPath() output=false {
		return get$().globalConfig('context') & '/plugins/' & pluginConfig.getDirectory() & '/';
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

			switch( get$().globalConfig('filestore') ) {

				case 'database' : 
					Throw(type='InvalidData',message='Filestore setting of "database" not supported.');
					break;

				case 'filedir' :
					local.fileURL = '#get$().globalConfig('context')#/#local.rsFileData.siteid#/cache/file/#local.rsFileData.fileid#.#local.rsFileData.fileExt#';
					break;
	
				// S3 = files are stored on Amazon S3
				// If they also use CloudFront AND have set up a streaming distribution url, then we could use it to optimize delivery of the media through the player
				// Amazon CloudFront Streaming - http://docs.amazonwebservices.com/AmazonCloudFront/latest/DeveloperGuide/
				case 'S3' :
					local.file = local.rsFileData.siteid & '/' & local.rsFileData.fileid & '.' & local.rsFileData.fileext;

					local.baseurl	= getPageContext().getRequest().getScheme() & '://s3.amazonaws.com/' & ListLast(get$().globalConfig('fileStoreAccessInfo'),'^') & '/';

					// if a cloudurl exists, let's use it
					// example Amazon CloudFront Domain Name: d3uo0mcmxgzzlk.cloudfront.net
					local.cloudurl = get$().siteConfig('muraPlayerCloudURL');
					if ( len(trim(local.cloudurl)) ) {
						// just in case the cloud url doesn't contain http or https, we'll use whatever scheme the user is using
						if ( left(local.cloudurl, 4) != 'http' ) {
							local.cloudurl = getPageContext().getRequest().getScheme() & '://' & local.cloudurl;
						};
						if ( right(local.cloudurl, 1) != '/' ) {
							local.cloudurl = local.cloudurl & '/';
						};
						local.baseurl = local.cloudurl;
					};

					if ( len(trim(get$().siteConfig('muraPlayerStreamURL'))) ) {
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