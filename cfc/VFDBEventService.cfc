<cfcomponent output="false">

    <cffunction name="searchEvents" returntype="string" returnformat="JSON" access="remote" >
        <cfargument  name="searchterms" type="string" required="true" />
        <cfreturn createObject('component','VFDBEventGateway').searchEvents(searchterms) />
    </cffunction>

</cfcomponent>