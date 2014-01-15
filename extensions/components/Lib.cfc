<!---
	This file is part of MuraPlayer TM

	Copyright 2010-2014 Stephen J. Withington, Jr.
	Licensed under the Apache License, Version v2.0
	http://www.apache.org/licenses/LICENSE-2.0
--->
<cfcomponent output="false">

	<cffunction name="wddx" access="public" returntype="any" output="false">
		<cfset var result = "">
		<cfwddx attributeCollection="#arguments#" output="result" />
		<cfreturn result />
	</cffunction>

	<cffunction name="zipDBBackup" access="public" returntype="any" output="false">
		<cfargument name="zfile" default="#ExpandPath('./dbBackup-#DateFormat(now(), 'yyyymmdd')#-#TimeFormat(now(), 'HHmmsstt')#.zip')#" />
		<cfargument name="wddx" default="" />
		<cfargument name="entrypath" default="data.wddx.xml" />
		<cftry>
			<cfzip action="zip" file="#arguments.zfile#" overwrite="true">
				<cfzipparam content="#arguments.wddx#" entrypath="#arguments.entrypath#" />
			</cfzip>
			<cfcatch>
				<cfreturn false />
			</cfcatch>
		</cftry>
		<cfreturn true />
	</cffunction>

</cfcomponent>