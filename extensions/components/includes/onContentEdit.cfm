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
</cfscript></cfsilent>
<!--- Custom UI for MuraPlayer - NOT IMPLEMENTED YET!!! --->
<cfoutput>
	<div id="customUIWrapper">
		<dl>
			<dt><label for="muraPlayerYouTubeURL">YouTube URL</label></dt>
			<dd><input name="muraPlayerYouTubeURL" type="text" value="#local.$.content('muraPlayerYouTubeURL')#" class="textLong" /></dd>

			<cfif YesNoFormat($.siteConfig('muraPlayerSkinDefaultEnforce'))>
				<cfset skinDisplay = 'none'>
			<cfelse>
				<cfset skinDisplay = 'block'>
			</cfif>
			<dt style="display:#skinDisplay#"><label for="muraPlayerSkin">Player Skin:</label></dt>
			<dd style="display:#skinDisplay#">
				<select name="muraPlayerSkin">
					<cfscript>
						skinsOptionList = application.muraPlayer.getPlayerSkinsOptionList();
						skinsOptionLabelList = application.muraPlayer.getPlayerSkinsOptionLabelList();
						for ( i=1; i <= ListLen(skinsOptionList, '^'); i++ ) {
							option = ListGetAt(skinsOptionList, i, '^');
							label = ListGetAt(skinsOptionLabelList, i, '^');
							WriteOutput('<option value="#option#"');
							if ( $.content().getIsNew() ) {
								if ( $.siteConfig('muraPlayerSkinDefault') == option ) {
									WriteOutput(' selected="selected"');
								};
							} else if ( $.content('muraPlayerSkin') == option ) {
								WriteOutput(' selected="selected"');
							};
							WriteOutput('>#label#</option>');
						};
					</cfscript>
				</select>
			</dd>
		</dl>
	</div>
</cfoutput>
<script>
	jQuery(document).ready(function($){

		// disable the Custom tab IF we're not actually editing the special content subType
		var tabLabel = '<cfoutput>#variables.pluginConfig.getName()#</cfoutput>';
		var contentTabs = $('div.tabs');
		var typeSelector = $('select[name="typeSelector"]');
		var initialType = typeSelector.val().split('^')[0];
		var initialSubType = typeSelector.val().split('^')[1];
		var theTab = $('div.tabs ul li a span').filter(tabLabel).parent().parent();
		var theTabIndex = theTab.index();
		if ( initialSubType != tabLabel ) {
			contentTabs.tabs('disable', theTabIndex);
		};
		typeSelector.change(function(){
			var str = $(this).val();
			var newSubType = str.split('^')[1];
			if ( newSubType != tabLabel ) {
				contentTabs.tabs('select', 0).tabs('disable', theTabIndex);
			} else {
				contentTabs.tabs('enable', theTabIndex);
			};
		});

	});
</script>