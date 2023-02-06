<cfcomponent output="false" extends="vfdb.Application" hint="put here to avoid WSDL problems">

    <cffunction name="OnRequestStart" access="public" returntype="boolean" output="false" hint="Handles pre-page processing for each request.">

		<!--- Define arguments. --->
		<cfargument
			name="page"
			required="true"
			hint="The template requested by the user."
			/>

		<cfset var username = getAuthUser() />
		<cfif structKeyExists(session,"vfdb_calcdb") AND len(session.vfdb_calcdb) GT 0 >	
		<cfelse>
            <cfset session["vfdb_calcdb"] = "vfdb_calcdb" />		
		</cfif>
		
		<cfif structKeyExists(session,"vfdb_controldb") AND len(session.vfdb_controldb) GT 0 >
		<cfelse>
            <cfset session["vfdb_controldb"] = "vfdb_controldb" />				
		</cfif>	

		<cfreturn true />		
 
		<cfif len(getAuthUser()) GT 0 >
			<cfreturn true />
		</cfif>

		<cfif SUPER.OnRequestStart( page )>

			<!--- Store the sub root directory folder. --->
			<cfset REQUEST.SubDirectory = GetDirectoryFromPath(
				GetCurrentTemplatePath()
				) />

			<!--- Return out. --->
			<cfreturn true />

		<cfelse>

			<!---
				The root application returned false for this
				page request. Therefore, we want to return
				false to honor that logic.
			--->
			<cfreturn false />

		</cfif>
	</cffunction>

</cfcomponent>