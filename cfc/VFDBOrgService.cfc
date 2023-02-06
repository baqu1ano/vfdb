<cfcomponent output="false">

    <cffunction  name="addEditOrganizer" returntype="string" returnformat="JSON" access="remote" >
        <cfargument name="orginfo" required="true" type="string" />
        <cfreturn createObject('component','VFDBOrgDAO').addEditOrganizer(orginfo) />
    </cffunction>

    <cffunction name="getOrganizers" returntype="string" returnformat="JSON" access="remote" >
        <cfargument name="snippet" type="string" required="true" />
        <cfreturn createObject('component','VFDBOrgGateway').getOrganizers(snippet) />
    </cffunction>

    <cffunction name="searchOrganizers" returntype="string" returnformat="JSON" access="remote" >
        <cfargument name="snippet" type="string" required="true" />
        <cfreturn createObject('component','VFDBOrgGateway').searchOrganizers(snippet) />
    </cffunction>

</cfcomponent>