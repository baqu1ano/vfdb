<cfcomponent output="false">

    <cffunction  name="addEditOrganizer" returntype="string" returnformat="JSON" >
        <cfargument name="orginfo" required="true" type="string" />
        <cfset var obj = deserializeJSON(orginfo) />
        <cfset var ret = {} />

        <cfquery name="chkqry" datasource="#session.vfdb_calcdb#" >
            SELECT id FROM organizer_list
            WHERE org_name = <cfqueryparam cfsqltype="cf_sql_varchar" null="false" value="#obj.org_name#" />
        </cfquery>
        <cfif chkqry.recordcount GT 0 >
            <cfset ret["id"] = chkqry.id />
            <cfquery name="updqry" datasource="#session.vfdb_calcdb#" >
                UPDATE organizer_list SET
                    org_phone1 = <cfqueryparam cfsqltype="cf_sql_varchar" null="false" value="#obj.org_phone1#" />,
                    org_phone2 = <cfqueryparam cfsqltype="cf_sql_varchar" null="false" value="#obj.org_phone2#" />,
                    org_phone3 = <cfqueryparam cfsqltype="cf_sql_varchar" null="false" value="#obj.org_phone3#" />,
                    org_email = <cfqueryparam cfsqltype="cf_sql_varchar" null="false" value="#obj.org_email#" />,
                    org_ig = <cfqueryparam cfsqltype="cf_sql_varchar" null="false" value="#obj.org_ig#" />,
                    org_page = <cfqueryparam cfsqltype="cf_sql_longvarchar" null="false" value="#obj.org_page#" />,
                    org_twitter = <cfqueryparam cfsqltype="cf_sql_varchar" null="false" value="#obj.org_twitter#" />,
                    org_tiktok = <cfqueryparam cfsqltype="cf_sql_varchar" null="false" value="#obj.org_tiktok#" />
                WHERE id = <cfqueryparam cfsqltype="cf_sql_integer" null="false" value="#ret.id#" />
            </cfquery>            
        <cfelse>
            <cfquery name="insqry" datasource="#session.vfdb_calcdb#" result="insqryresult" >
                INSERT INTO organizer_list (
                    org_name,org_phone1,org_phone2,org_phone3,org_email,org_ig,org_page,org_twitter,org_tiktok
                ) VALUES (
                    <cfqueryparam cfsqltype="cf_sql_varchar" null="false" value="#obj.org_name#" />,
                    <cfqueryparam cfsqltype="cf_sql_varchar" null="false" value="#obj.org_phone1#" />,
                    <cfqueryparam cfsqltype="cf_sql_varchar" null="false" value="#obj.org_phone2#" />,
                    <cfqueryparam cfsqltype="cf_sql_varchar" null="false" value="#obj.org_phone3#" />,
                    <cfqueryparam cfsqltype="cf_sql_varchar" null="false" value="#obj.org_email#" />,
                    <cfqueryparam cfsqltype="cf_sql_varchar" null="false" value="#obj.org_ig#" />,
                    <cfqueryparam cfsqltype="cf_sql_longvarchar" null="false" value="#obj.org_page#" />,
                    <cfqueryparam cfsqltype="cf_sql_varchar" null="false" value="#obj.org_twitter#" />,
                    <cfqueryparam cfsqltype="cf_sql_varchar" null="false" value="#obj.org_tiktok#" />
                )
            </cfquery>
            <cfset ret["id"] = insqryresult.GENERATEDKEY />
        </cfif>

        <cfset ret["error"] = 0 />
        <cfset ret["errormessage"] = 'No errors' />
        <cfreturn serializeJSON(ret) />
    </cffunction>

</cfcomponent>