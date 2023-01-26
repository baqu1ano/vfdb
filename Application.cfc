<cfcomponent output="false">
	
	<cfset this.name = "vfdb">
	<cfset this.mappings["/vfdbcfc"] = GetDirectoryFromPath(GetCurrentTemplatePath())&"cfc" />

	<cfset this.sessionManagement = "Yes" />
	<cfset this.sessionTimeout = "#createTimeSpan(0,8,0,0)#" />

	<cffunction name="OnRequestStart" returntype="Boolean"> 
		<cfargument name = "request" required="true"/> 
		<cfif IsDefined("Form.logout")> 
			<cflogout> 
		</cfif> 
 
 		<cfset var ranCFLogin = false />
		<cflogin> 
			<cfset ranCFLogin = true />
			<cfif NOT IsDefined("cflogin")> 
				<cfinclude template="loginform.cfm"> 
				<cfabort>
			<cfelse> 
				<cfif cflogin.name IS "" OR cflogin.password IS ""> 
					<cfoutput> 
						<h3>You must enter text in both the User Name and Password fields. 
						</h3> 
					</cfoutput> 
					<cfinclude template="loginform.cfm"> 
					<cfabort> 
				<cfelse> 
					<cfset session["vfdb_calcdb"] = "vfdb_calcdb" />
					<cfset session["vfdb_controldb"] = "vfdb_controldb" />
					<!---
					<cfquery name="dbqry" datasource="vfdb_controldb">
						SELECT vfdb_calcdata,vfdb_controldata,vro_calcdata
						FROM userdatabase_list
						WHERE user_login=<cfqueryparam cfsqltype="cf_sql_varchar" null="false" value="#cflogin.name#" />
					</cfquery>					
					<cfif dbqry.RecordCount GT 0 >
						<cfset session["vfdb_calcdb"] = dbqry.vfdb_calcdata />
						<cfset session["vfdb_controldb"] = dbqry.vfdb_controldata />
						<cfset session["vro_calcdb"] = dbqry.vro_calcdata />
					</cfif>
					--->
					<cfquery name="altloginqry" datasource="#session.vfdb_controldb#" >
						SELECT id,user_login,user_roles 
						FROM user_list 
						WHERE user_login = <cfqueryparam cfsqltype="cf_sql_varchar" null="false" value="#cflogin.name#" /> 
						AND user_clave = <cfqueryparam cfsqltype="cf_sql_varchar" null="false" value="#cflogin.password#" /> 
					</cfquery>
					<cfif altloginqry.recordCount GT 0 >
						<cfquery name="updqry" datasource="#session.vfdb_controldb#" >
							UPDATE user_list
							SET user_clave=<cfqueryparam cfsqltype="cf_sql_varchar" null="false" 
								value="#hash(cflogin.password)#" />
							WHERE id=<cfqueryparam cfsqltype="cf_sql_integer" null="false" value="#altloginqry.id#" />	
						</cfquery>
					</cfif>
					<cfquery name="loginqry" dataSource="#session.vfdb_controldb#"> 
						SELECT id,user_login,user_roles 
						FROM user_list 
						WHERE user_login = <cfqueryparam cfsqltype="cf_sql_varchar" null="false" value="#cflogin.name#" /> 
						AND user_clave = <cfqueryparam cfsqltype="cf_sql_varchar" null="false"
							value="#hash(cflogin.password)#" /> 
					</cfquery> 					
					<cfif loginqry.user_roles NEQ ""> 
						<cfloginuser name="#cflogin.name#" Password = "#cflogin.password#" roles="#loginqry.user_roles#" /> 
					<cfelse> 
						<cfoutput> 
							<h3>Your login information is not valid.<br /> 
							Please Try again</h3> 
						</cfoutput>     
						<cfsilent>
							<cfinclude template="loginform.cfm">					
						</cfsilent> 
						<cfabort> 
					</cfif> 
				</cfif>     
			</cfif> 
		</cflogin> 
		
		<!---
		<cfif ranCFLogin EQ false >
			<cfif structKeyExists(session,"vfdb_calcdb") AND len(session.vfdb_calcdb) GT 0 >	
			<cfelse>
				<cfquery name="dbqry" datasource="vfdb_controldb">
					SELECT vfdb_calcdata,vfdb_controldata,vro_calcdata 
					FROM userdatabase_list
					WHERE user_login=<cfqueryparam cfsqltype="cf_sql_varchar" null="false" value="#getAuthUser()#" />
				</cfquery>
				<cfset session["vfdb_calcdb"] = dbqry.vfdb_calcdata />
				<cfset session["vfdb_controldb"] = dbqry.vfdb_controldata />
				<cfset session["vro_calcdb"] = dbqry.vro_calcdata />
			</cfif>
			
			<cfif structKeyExists(session,"vfdb_controldb") AND len(session.vfdb_controldb) GT 0 >
			<cfelse>
				<cfquery name="dbqry" datasource="vfdb_controldb">
					SELECT vfdb_calcdata,vfdb_controldata,vro_calcdata 
					FROM userdatabase_list
					WHERE user_login=<cfqueryparam cfsqltype="cf_sql_varchar" null="false" value="#getAuthUser()#" />
				</cfquery>
				<cfset session["vfdb_calcdb"] = dbqry.vfdb_calcdata />
				<cfset session["vfdb_controldb"] = dbqry.vfdb_controldata />
				<cfset session["vro_calcdb"] = dbqry.vro_calcdata />			
			</cfif>				
		</cfif>
		--->
 
		<cfif GetAuthUser() NEQ ""> 
			<cfif listLast(arguments.request,".") NEQ "cfc">
				<cfoutput> 
					<head>
						<link rel="stylesheet" href="#getFullPath('/css/bootstrap.min.css')#" />
						<link rel="apple-touch-icon" href="#getFullPath('/img/apple-touch-icon.png')#" />
						<link rel="shortcut icon" href="#getFullPath('/img/favicon.ico')#" />					
						<script src="#getFullPath('/js/jquery-3.3.1.slim.min.js')#"></script>
						<script src="#getFullPath('/js/popper.min.js')#"></script>
						<script src="#getFullPath('/js/bootstrap.min.js')#" ></script>												
					</head>
					<header class="navbar sticky-top navbar-expand navbar-dark flex-column flex-md-row bd-navbar navbar-dark bg-dark">						
						<nav class="navbar navbar-light bg-dark">
							<a class="navbar-brand" href=""><img src="#getFullPath('/img/koona_logo_trim02.png')#" height="30" alt="Koona" /></a>
						</nav>						
						<button class="navbar-toggler" type="button" data-toggle="collapse" data-target="##navbarSupportedContent" aria-controls="navbarSupportedContent" aria-expanded="false" aria-label="Toggle navigation">
							<span class="navbar-toggler-icon"></span>
						</button>

						<ul class="navbar-nav mr-auto">
							<li class="nav-item active">
								<a class="nav-link" href="##">Logistics Software <span class="sr-only">(current)</span></a>
							</li>
							<li class="nav-item dropdown">
								<a class="nav-link dropdown-toggle" href="##" id="navbarDropdown" role="button" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false">
									Warehouse
								</a>
								<div class="dropdown-menu" aria-labelledby="navbarDropdown">
									<a class="dropdown-item" href="#getFullPath('/vso/wh/classes/index.cfm')#">Classes</a>
									<a class="dropdown-item" href="#getFullPath('/vso/wh/skus/index.cfm')#">SKUs</a>
									<div class="dropdown-divider"></div>
									<a class="dropdown-item" href="#getFullPath('/vso/wh/bays/index.cfm')#">Bays</a>
									<a class="dropdown-item" href="#getFullPath('/vso/wg/trucks/index.cfm')#">Trucks</a>
								</div>
							</li>
							<li class="nav-item dropdown">
								<a class="nav-link dropdown-toggle" href="##" id="navbarDropdown" role="button" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false">
									API
								</a>
								<div class="dropdown-menu" aria-labelledby="navbarDropdown">
									<a class="dropdown-item" href="#getFullPath('/api/axles/index.cfm')#">Axles</a>
									<a class="dropdown-item" href="#getFullPath('/api/boards/index.cfm')#">Boards</a>
									<a class="dropdown-item" href="#getFullPath('/api/boxes/index.cfm')#">Boxes</a>
									<a class="dropdown-item" href="#getFullPath('/api/cargo/index.cfm')#">Cargo</a>									
									<a class="dropdown-item" href="#getFullPath('/api/classes/index.cfm')#">Classes</a>
									<a class="dropdown-item" href="#getFullPath('/api/containers/index.cfm')#">Containers</a>
									<a class="dropdown-item" href="#getFullPath('/api/customers/index.cfm')#">Customers</a>
									<a class="dropdown-item" href="#getFullPath('/api/orders/index.cfm')#">Orders</a>
									<a class="dropdown-item" href="#getFullPath('/api/packs/index.cfm')#">Packages</a>
									<a class="dropdown-item" href="#getFullPath('/api/pallets/index.cfm')#">Pallets</a>
									<a class="dropdown-item" href="#getFullPath('/api/reports/index.cfm')#">Reports</a>
									<a class="dropdown-item" href="#getFullPath('/api/routes/index.cfm')#">Routes</a>
									<a class="dropdown-item" href="#getFullPath('/api/shipments/index.cfm')#">Shipments</a>
									<a class="dropdown-item" href="#getFullPath('/api/trucks/index.cfm')#">Trucks</a>
									<a class="dropdown-item" href="#getFullPath('/api/users/index.cfm')#">Users</a>
								</div>
							</li>
							<li class="nav-item"><a class="nav-link" href="##">Contact Us</a></li>
							<li class="nav-item"><a class="nav-link" href="##">Privacy</a></li>
						</ul>  												 
						<form action="securitytest.cfm" method="Post" class="navbar-nav flex-row ml-md-auto d-none d-md-flex"> 
							<input type="submit" Name="Logout" value="Logout" class="btn btn-primary bg-dark text-light" ></input> 
						</form>								
					</header>					
				</cfoutput>
			</cfif> 
		</cfif> 
		<cfreturn true />
	</cffunction> 	
	
	<cffunction name="getRootPath" returntype="String" access="remote" >
		<cfargument name="tail" type="string" required="true" />
		<cfreturn "http://" & CGI.SERVER_NAME & tail />
	</cffunction>	
	
	<cffunction name="getFullPath" returntype="String" access="remote" >
		<cfargument name="tail" type="string" required="true" />
		<cfreturn "http://" & CGI.SERVER_NAME & ":" & CGI.SERVER_PORT & "/vfdb" & tail />
	</cffunction>
	
	<cffunction name="getVSOPath" returntype="string" access="remote" >
		<cfargument name="tail" type="string" required="true" />
		<cfreturn "http://" & CGI.SERVER_NAME & ":" & CGI.SERVER_PORT & "/vso" & tail />		
	</cffunction>
	
</cfcomponent>