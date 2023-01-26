<cfcomponent output="false" >

    <cffunction name="searchOrganizers" returntype="string" returnformat="JSON" >
        <cfargument name="snippet" type="string" required="true" />
        <cfset var obj = deserializeJSON(snippet) />
        <cfif structKeyExists(obj,'calcdb') EQ true >
            <cfset session["vfdb_calcdb"] = obj.calcdb />
        </cfif>

        <cfset var ret = {} />
        <cfset var organizers = [] />
        <cfset var o = {} />
        <cfquery name="qry" datasource="#session.vfdb_calcdb#" >
            SELECT id,org_name,org_phone1,org_phone2,org_phone3,org_email,org_ig,org_twitter,org_tiktok,
                org_page
            FROM organizer_list
            <cfif len(obj.snippet) GT 0 >
            WHERE org_name LIKE <cfqueryparam cfsqltype="cf_sql_varchar" null="false" value="%#obj.snippet#%" />
            OR org_ig LIKE <cfqueryparam cfsqltype="cf_sql_varchar" null="false" value="%#obj.snippet#%" />
            </cfif>
        </cfquery>
        <cfloop query="qry" >
            <cfset o = {} />
            <cfset o["id"] = qry.id />
            <cfset o["org_name"] = qry.org_name />
            <cfset o["org_phone1"] = qry.org_phone1 />
            <cfset o["org_phone2"] = qry.org_phone2 />
            <cfset o["org_phone3"] = qry.org_phone3 />
            <cfset o["org_email"] = qry.org_email />
            <cfset o["org_ig"] = qry.org_ig />
            <cfset o["org_twitter"] = qry.org_twitter />
            <cfset o["org_tiktok"] = qry.org_tiktok />
            <cfset o["org_page"] = qry.org_page />
            <cfset arrayAppend(organizers, o) />
        </cfloop>
        <cfset ret["organizers"] = organizers />
        <cfset ret["error"] = 'No error' />
        <cfset ret["errornumber"] = 0 />

        <cfreturn serializeJSON(ret) />
    </cffunction>

</cfcomponent>