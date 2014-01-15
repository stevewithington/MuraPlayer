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