<cfscript>
/**
* 
* This file is part of MuraPlayer TM
* (c) Stephen J. Withington, Jr. | www.blueriver.com
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
	$ = application.serviceFactory.getBean('MuraScope').init(session.siteid);
	params = IsJSON($.event('params')) ? DeSerializeJSON($.event('params')) : {};
	defaultParams = {};
	StructAppend(params, defaultParams, false);
</cfscript>
<style type="text/css">
	#availableObjectParams dt { padding-top:1em; }
	#availableObjectParams dt.first { padding-top:0; }
</style>
<script>
	// jQuery magic
</script>
<cfoutput>
	<div id="availableObjectParams"	
		data-object="plugin" 
		data-name="MuraPlayer" 
		data-objectid="#$.event('objectID')#">
		<dl class="singleColumn">
			<!--- FUTURE TODO --->
		</dl>
	</div>
</cfoutput>