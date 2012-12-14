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
</cfscript>
<cfoutput>
	<plugin>

		<name>MuraPlayer</name>
		<package>MuraPlayer</package>
		<directoryFormat>packageOnly</directoryFormat>
		<loadPriority>5</loadPriority>
		<version>1.0.3</version>
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