<cfcomponent output="false">

	<cffunction name="addEditSite" returntype="string" returnformat="JSON" >
		<cfargument name="siteinfo" required="true" type="string" />
		<cfset var obj = deserializeJSON(ARGUMENTS.siteinfo) />
		<cfset var dsname = session.vfdb_calcdb />
		<cfset var sitereply = {} />
		<cfif structKeyExists(obj,"datasource") EQ true >
			<cfset dsname = obj.datasource />
		</cfif>

		<cfif structKeyExists(obj, "username") EQ false >
			<cfset sitereply()
		</cfif>	

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

	<cffunction name="getSiteInfo" returntype="string" returnformat="JSON" >
		<cfargument name="siteid" required="true" type="string" />
		<cfset var obj = deserializeJSON(siteid) />

		<cfset var ret = {} />
		<cfquery name="qry" datasource="#session.vfdb_calcdb#" >
			SELECT id,site_name,site_address1,site_address2,site_area,site_city,site_state,
					site_country,site_description,site_latitude,site_longitude,site_mapurl,
					site_zipcode
			FROM site_list
			WHERE id = <cfqueryparam cfsqltype="cf_sql_integer" null="false" value="#obj.id#" />
 		</cfquery>
		<cfif qry.recordcount GT 0 >
			<cfset ret["id"] = qry.id />
			<cfset ret["site_name"] = qry.site_name />
			<cfset ret["site_address1"] = qry.site_address1 />
			<cfset ret["site_address2"] = qry.site_address2 />
			<cfset ret["site_area"] = qry.site_area />
			<cfset ret["site_city"] = qry.site_city />
			<cfset ret["site_state"] = qry.site_state />
			<cfset ret["site_country"] = qry.site_country />
			<cfset ret["site_description"] = qry.site_description />
			<cfset ret["site_latitude"] = qry.site_latitude />
			<cfset ret["site_longitude"] = qry.site_longitude />
			<cfset ret["site_mapurl"] = qry.site_mapurl />
			<cfset ret["site_zipcode"] = qry.site_zipcode />			
		</cfif>

		<cfreturn serializeJSON(ret) />
	</cffunction>

</cfcomponent>