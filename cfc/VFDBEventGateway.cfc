<cfcomponent>
    
    <cffunction  name="searchEvents" returntype="string" returnformat="JSON" >
        <cfargument  name="searchterms" type="string" required="true" />
        <cfset var obj = deserializeJSON(searchterms) />
        <cfif structKeyExists(obj,'calcdb') EQ true >
            <cfset session["vfdb_calcdb"] = obj.calcdb />
        </cfif>

        <!---
            ['event_date','event_name','event_type','org_name','modes','site_city','site_state','org_page','org_ig'];
        --->
        <cfset var ret = {} />
        <cfset var events = [] />
        <cfset var e = {} />
        <cfquery name="qry" datasource="#session.vfdb_calcdb#">
            SELECT e.id,e.event_date,e.event_name,e.event_type,o.org_name,m.id AS mode_id,m.distance,s.site_city,
                s.site_state,o.org_page,o.org_ig
            FROM event_list e 
            JOIN organizer_list o ON e.organizer = o.id
            JOIN mode_list m ON e.id = m.event_id
            JOIN site_list s ON e.site = s.id 
            <cfif structKeyExists(obj, "min_elevation") EQ true OR structKeyExists(obj, "max_elevation") EQ true >
            JOIN geography g ON m.id = g.mode_id
            </cfif>
            WHERE e.event_name != ''
            <cfif len(obj.snippet) GT 0 >
            AND (e.event_name LIKE <cfqueryparam cfsqltype="cf_sql_varchar" null="false" value="%#obj.snippet#%" />
            OR e.event_description LIKE <cfqueryparam cfsqltype="cf_sql_varchar" null="false" value="%#obj.snippet#%" />)
            </cfif>
            <cfif structKeyExists(obj, "year") EQ true >
            AND YEAR(e.event_date) = <cfqueryparam cfsqltype="cf_sql_integer" null="false" value="#obj.year#" />
            </cfif>
            
            <cfif structKeyExists(obj, "min_elevation") EQ true >
            AND g.min_elevation >= <cfqueryparam cfsqltype="cf_sql_float" null="false" value="#obj.min_elevation#" />
            </cfif>
            <cfif structKeyExists(obj, "max_elevation") EQ true >
            AND g.max_elevation <= <cfqueryparam cfsqltype="cf_sql_float" null="false" value="#obj.max_elevation#" />
            </cfif>            
            ORDER BY e.event_date,m.distance       
        </cfquery>
        <cfloop query="qry" >
            <cfquery name="geoqry" datasource="#session.vfdb_calcdb#" >
                SELECT id,grade,temperature,humidity,distance,min_elevation,max_elevation,ascent,descent,km_effort,
                    route_link
                FROM geography
                WHERE mode_id = <cfqueryparam cfsqltype="cf_sql_integer" null="false" value="#qry.mode_id#" />
            </cfquery>
            <cfset found = false />
            <cfloop array="#events#" index="i">
                <cfif qry.id EQ events[i].id >
                    <cfset found = true />
                    <cfif geoqry.recordcount GT 0 >
                        <cfset events[i].modes = events[i].modes & "," & qry.distance & "km" & " (+" & geoqry.ascent & "m)" />                    
                    <cfelse>
                        <cfset events[i].modes = events[i].modes & "," & qry.distance />                    
                    </cfif>
                </cfif>
            </cfloop>
            <cfif found EQ false >
                <cfset e = {} />
                <cfset e["id"] = qry.id />
                <cfset e["event_date"] = dateTimeFormat(qry.event_date,"yyyy-mm-dd HH:nn:ss") />
                <cfset e["event_name"] = qry.event_name />
                <cfset e["event_type"] = qry.event_type />
                <cfset e["org_name"] = qry.org_name />
                <cfset e["distance"] = qry.distance />
                <cfif geoqry.recordcount GT 0 >
                    <cfset e["modes"] = qry.distance & "km" & " (+" & geoqry.ascent & "m)" />                    
                <cfelse>
                    <cfset e["modes"] = qry.distance />                    
                </cfif>
                <cfset e["site_city"] = qry.site_city />
                <cfset e["site_state"] = qry.site_state />
                <cfset e["org_page"] = qry.org_page />
                <cfset e["org_ig"] = qry.org_ig />
                <cfset arrayAppend(events, e) />
            </cfif>
        </cfloop>
        <cfset ret["events"] = events />

        <cfreturn serializeJSON(ret) />
    </cffunction>

</cfcomponent>