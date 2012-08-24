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