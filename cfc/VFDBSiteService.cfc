<cfcomponent output="false">

	<cffunction name="addEditSite" access="remote" returntype="string" returnformat="JSON" >
		<cfargument name="siteinfo" required="true" type="string" />
		<cfreturn createObject('component','VFDBSiteDAO').addEditSite(siteinfo) />
	</cffunction>

	<cffunction name="getSiteInfo" returntype="string" returnformat="JSON" access="remote" >
		<cfargument name="siteid" required="true" type="string" />
		<cfreturn createObject('component','VFDBSiteDAO').getSiteInfo(siteid) />
	</cffunction>

	<cffunction name="getSites" returntype="string" returnformat="JSON" access="remote">
		<cfargument name="snippet" required="true" type="string" />
		<cfreturn createObject('component','VFDBSiteGateway').getSites(snippet) />
	</cffunction>

	<cffunction  name="searchSites" access="remote" returntype="string" returnformat="JSON">
		<cfargument name="snippet" required="true" type="string" />
		<cfreturn createObject('component','VFDBSiteGateway').searchSites(snippet) />
	</cffunction>

</cfcomponent>