<cfcomponent output="false">

	<cffunction name="addEditSite" access="remote" returntype="string" returnformat="JSON" >
		<cfargument name="siteinfo" required="true" type="string" />
		<cfset var obj = deserializeJSON(ARGUMENTS.siteinfo) />
		<cfset var dsname = session.vfdb_calcdb />
		<cfif structKeyExists(obj,"datasource") >
			<cfset dsname = obj.datasource />
		</cfif>
	
		<cfset var sitereply = {} />
		<cfquery name="siteqry" datasource="#dsname#" >
			SELECT id FROM site_list
			WHERE site_name=<cfqueryparam cfsqltype="cf_sql_varchar" null="false" value="#obj.site_name#" />
		</cfquery>
		<cfif siteqry.recordCount GT 0 >
			<cfquery name="updqry" datasource="#dsname#" >
				UPDATE site_list SET
					site_address1=<cfqueryparam cfsqltype="cf_sql_varchar" null="false" value="#obj.site_address1#" />,
					site_address2=<cfqueryparam cfsqltype="cf_sql_varchar" null="false" value="#obj.site_address2#" />,
					site_area=<cfqueryparam cfsqltype="cf_sql_real" null="false" value="#obj.site_area#" />,
					site_city=<cfqueryparam cfsqltype="cf_sql_varchar" null="false" value="#obj.site_city#" />,
					site_state=<cfqueryparam cfsqltype="cf_sql_varchar" null="false" value="#obj.site_state#" />,
					site_country=<cfqueryparam cfsqltype="cf_sql_varchar" null="false" value="#obj.site_country#" />,
					site_description=<cfqueryparam cfsqltype="cf_sql_varchar" null="false" value="#obj.site_description#" />,
					site_latitude=<cfqueryparam cfsqltype="cf_sql_real" null="false" value="#obj.site_latitude#" />,
					site_longitude=<cfqueryparam cfsqltype="cf_sql_real" null="false" value="#obj.site_longitude#" />,
					site_mapurl=<cfqueryparam cfsqltype="cf_sql_longvarchar" null="false" value="#obj.site_mapurl#" />,
					site_zipcode=<cfqueryparam cfsqltype="cf_sql_varchar" null="false" value="#obj.site_zipcode#" />
				WHERE id=<cfqueryparam cfsqltype="cf_sql_integer" null="false" value="#siteqry.id#" />
			</cfquery>
			<cfset sitereply["id"] = siteqry.id />
		<cfelse >
			<cfquery name="insqry" datasource="#dsname#" result="insqryresult" >
				INSERT INTO site_list (
					site_name,site_address1,site_address2,site_area,site_city,site_state,site_country,site_description,
					site_latitude,site_longitude,site_mapurl,site_zipcode
				) VALUES (
					<cfqueryparam cfsqltype="cf_sql_varchar" null="false" value="#obj.site_name#" />,
					<cfqueryparam cfsqltype="cf_sql_varchar" null="false" value="#obj.site_address1#" />,
					<cfqueryparam cfsqltype="cf_sql_varchar" null="false" value="#obj.site_address2#" />,
					<cfqueryparam cfsqltype="cf_sql_real" null="false" value="#obj.site_area#" />,
					<cfqueryparam cfsqltype="cf_sql_varchar" null="false" value="#obj.site_city#" />,
					<cfqueryparam cfsqltype="cf_sql_varchar" null="false" value="#obj.site_state#" />,
					<cfqueryparam cfsqltype="cf_sql_varchar" null="false" value="#obj.site_country#" />,
					<cfqueryparam cfsqltype="cf_sql_varchar" null="false" value="#obj.site_description#" />,
					<cfqueryparam cfsqltype="cf_sql_real" null="false" value="#obj.site_latitude#" />,
					<cfqueryparam cfsqltype="cf_sql_real" null="false" value="#obj.site_longitude#" />,
					<cfqueryparam cfsqltype="cf_sql_longvarchar" null="false" value="#obj.site_mapurl#" />,
					<cfqueryparam cfsqltype="cf_sql_varchar" null="false" value="#obj.site_zipcode#" />				
				)
			</cfquery>
			<cfset sitereply["id"] = insqryresult.GENERATEDKEY />
		</cfif>
		
		<cfset sitereply["error"] = 0 />
		<cfset sitereply["errormessage"] = 'No errors' />
		<cfreturn serializeJSON(sitereply) />
	</cffunction>

</cfcomponent>