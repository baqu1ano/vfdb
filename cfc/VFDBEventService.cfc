<cfcomponent output="false">

    <cffunction name="addEditEvent" returntype="string" returnformat="JSON" access="remote">
        <cfargument name="eventinfo" type="string" required="true" />
        <cfreturn createObject('component','VFDBEventDAO').addEditEvent(eventinfo) />
    </cffunction>

    <cffunction name="addModeToEvent" returntype="string" returnformat="JSON" access="remote" >
        <cfargument name="eventmode" type="string" required="true" />
        <cfreturn createObject('component','VFDBEventDAO').addModeToEvent(eventmode) />
    </cffunction>

    <cffunction name="getDescriptions" returntype="string" returnformat="JSON" access="remote" >
        <cfargument name="searchyear" type="string" required="true" />
        <cfreturn createObject('component','VFDBEventGateway').getDescriptions(searchyear) />
    </cffunction>

    <cffunction name="getDistances" returntype="string" returnformat="JSON" access="remote">
        <cfargument name="searchinfo" type="string" required="true" />
        <cfreturn createObject('component','VFDBEventGateway').getDistances(searchinfo) />
    </cffunction>

    <cffunction name="getEventData" returntype="string" returnformat="JSON" access="remote">
        <cfargument name="eventid" type="string" required="true" />
        <cfreturn createObject('component','VFDBEventDAO').getEventData(eventid) />
    </cffunction>

    <cffunction name="getEventNames" returntype="string" returnformat="JSON" access="remote">
        <cfargument name="eventyear" type="string" required="true" />
        <cfreturn createObject('component','VFDBEventGateway').getEventNames(eventyear) />
    </cffunction>

    <cffunction  name="getOrganizers" returntype="string" returnFormat="JSON" access="remote">
        <cfargument name="searchyear" type="string" required="true" />
        <cfreturn createObject('component','VFDBEventGateway').getOrganizers(searchyear) />
    </cffunction>

    <cffunction name="getStates" returntype="string" returnformat="JSON" access="remote">
        <cfargument name="searchyear" type="string" required="true" />
        <cfreturn createObject('component','VFDBEventGateway').getStates(searchyear) />
    </cffunction>

    <cffunction name="searchEvents" returntype="string" returnformat="JSON" access="remote" >
        <cfargument  name="searchterms" type="string" required="true" />
        <cfreturn createObject('component','VFDBEventGateway').searchEvents(searchterms) />
    </cffunction>

</cfcomponent>