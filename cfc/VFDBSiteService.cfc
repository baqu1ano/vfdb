<cfcomponent output="false">

	<cffunction name="addEditSite" access="remote" returntype="string" returnformat="JSON" >
		<cfargument name="siteinfo" required="true" type="string" />
		<cfreturn createObject('component','VFDBSiteDAO').addEditSite(siteinfo) />
	</cffunction>

</cfcomponent>