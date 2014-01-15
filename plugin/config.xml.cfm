<cfscript>
/**
* 
* This file is part of MuraPlayer TM
*
* Copyright 2010-2014 Stephen J. Withington, Jr.
* Licensed under the Apache License, Version v2.0
* http://www.apache.org/licenses/LICENSE-2.0
*
*/
</cfscript>
<cfoutput>
	<plugin>

		<name>MuraPlayer</name>
		<package>MuraPlayer</package>
		<directoryFormat>packageOnly</directoryFormat>
		<loadPriority>5</loadPriority>
		<version>1.0.9</version>
		<provider>Blue River Interactive</provider>
		<providerURL>http://blueriver.com</providerURL>
		<category>Application</category>
		<ormCFCLocation></ormCFCLocation>
		<customTagPaths></customTagPaths>
		<autoDeploy>false</autoDeploy>
		<settings></settings>

		<!-- Event Handlers -->
		<eventHandlers>
			<!-- only need to register the eventHandler.cfc via onApplicationLoad() -->
			<eventHandler 
				event="onApplicationLoad" 
				component="extensions.components.EventHandler" 
				persist="false" />

			<!--- FUTURE Maybe/TODO: create a Custom UI for this plugin --->
			<!--- <eventHandler
				event="onContentEdit"
				component="extensions.components.EventHandler"
				persist="false" /> --->

		</eventHandlers>

		<!-- Display Objects -->
		<displayobjects location="global">

			<!--- FUTURE TODO: create configurable display object(s) --->
			<!--- <displayobject 
				name="MuraPlayer Playlist" 
				component="extensions.components.EventHandler"
				displaymethod="dspConfiguredJWPlaylist" 
				configuratorJS="extensions/configurators/jwplaylist/configurator.js"
				configuratorInit="init"
				persist="false" /> --->

		</displayobjects>

		<!-- Custom Class Extensions -->
		<cfinclude template="classExtensions.xml.cfm" />

	</plugin>

</cfoutput>