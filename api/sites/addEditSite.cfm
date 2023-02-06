<!DOCTYPE html>
<html class="no-js" lang="en">
	<head>
		<meta charset="utf-8" /> 
		<meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no" /> 
		<link rel="stylesheet" href="#getFullPath('/css/bootstrap.min.css')#" /> 
		<script type="text/javascript" >
			function updateTable() {
				refreshTable();
			}
		</script>
		<script src="../../js/jquery_3_3_1.js"></script> 
		<script type="text/javascript" >
			$(document).ready(function(){
				$('#apiAccordion').load('../shared/apiAccordion.html');
				$('#apiFooter').load('../shared/apiFooter.html');
			});			
		</script>			
		<title>Venezuelan Footrace Database - API Documentation</title>
	</head>
	<body>
  <!--[if lt IE 8]>
            <p class="browserupgrade">You are using an <strong>outdated</strong> browser. Please <a href="http://browsehappy.com/">upgrade your browser</a> to improve your experience.</p>
        <![endif]-->
		<a class="skippy sr-only sr-only-focusable" href="#content"><span class="skippy-text">Skip to main content</span></a>
		<div class="container-fluid ml-3 mr-3 mt-3 mb-3">
			<div class="row flex-xl-nowrap">
				<div class="col-12 col-md-3 col-xl-2 bd-sidebar">
					<div class="card bg-light text-dark pt-2 pb-1 mb-2 text-center"><h5>API Documentation</h5></div>					
					<div class="accordion" id="apiAccordion">			
					</div>									
				</div>
				<main class="col-12 col-md-9 col-xl-8 py-md-3 pl-md-5 bd-content" role="main">  	 	   				    
				
					<h1>Search Events</h1><br />

					<h4>Updated</h4>
					<p>January 28, 2023</p>
					
			    	<h4>Method Name</h4>
					<p><code>addEditSite()</code></p>
		
					<h4>WSDL</h4>
					<p><code>http[s]://[SERVERNAME]/vfdb/cfc/VFDBSiteService.cfc?wsdl</code></p>
					
					<h4>URL</h4>
					<p><code>http[s]://[SERVERNAME]/vfdb/cfc/VFDBSiteService.cfc?method=addEditSite&siteinfo=</code></p>					
		
					<h4>Description</h4>
					<p>The <code>addEditSite()</code> method adds a new site to the database. If it already exists, then this method edits the site information. A site is basically the starting point of a race.</p>
					
					<h4>Input</h4>
					<p>Variable name: <code>siteinfo</code></p>
					<pre><code>
{
	"siteinfo":{
		"site_name":[VARCHAR(50)],
		"site_address1":[VARCHAR(50)],
		"site_address2":[VARCHAR(50)],
		"site_city":[VARCHAR(50)],
		"site_state":[VARCHAR(50)],
		"site_zipcode":[VARCHAR(20)],
		"site_country":[VARCHAR(20)],
		"site_description":[VARCHAR(100)],
		"site_latitude":[FLOAT],
		"site_longitude":[FLOAT],
		"site_mapurl":[TEXT],
		"site_area":[FLOAT]
	}
}		
					</code></pre>
					
					<ul>
						<li>site_name: the name of the site</li>
						<li>site_address1: the first line of the address for the site</li>
						<li>site_address2: the second line in the site address</li>
						<li>site_area: the measured area of the site</li>
						<li>site_city: the city where the site is located</li>
						<li>site_state: the state or province of the site</li>
						<li>site_country: the site country</li>
						<li>site_description: a text explaining the site</li>
						<li>site_latitude: the latitude of the site</li>
						<li>site_longitude: the longitude of the site</li>
						<li>site_mapurl: text that contains a URL that points to the site location on a map</li>
						<li>site_zipcode: the zip code of the place where the site is located</li>
					</ul>
					
					<h4>Output</h4>
					<pre><code>
		{
			"id":[INTEGER]
			"error": [INTEGER],
			"errormessage": [STRING]			
		}
					</code></pre>
					
					<ul>
						<li>id: the database index of the site</li>						
					</ul>
					
					<h4>Error Types:</h4>
					<ol start="0">
						<li>no errors</li>
						<li>User not authorized: the user is not the SiteManager</li>
					</ol>						
				
					<br />
					<hr />	
				    <h2>Test API Method</h2>
					<div class="cta-option" style="width:80%;">
					  Enter the JSON input data in the box below, click on "Calculate" and the resulting JSON string should appear in the bottom box.
					<cfform name="testinput" >	  
					  <div style="padding-top:25px;">
						<textarea name="inputjson" style="color:##111111;width:100%;height:200px;font-size:12px;" ></textarea>
					  </div>
					  <div style="padding-top:25px;padding-bottom:25px;">
						<cfinput name="goAhead" type="submit" value="Calculate" class="btn btn-alt"/>
					  </div>	     	
					</cfform>
					<cfif IsDefined("Form.goAhead")>
					  <cfset predata = deserializeJSON(Form.inputjson) />
					  <cfset siteinfo = serializeJSON(predata) />
					  <cfset outputtext = createObject('component','vfdbcfc.VFDBSiteService').addEditSite(siteinfo) />
					  <div>
					  	<cfoutput >
					  	  <textarea name="outputjson" style="color:##111111;width:100%;height:200px;" >#outputtext#</textarea>	
					  	</cfoutput>
					  </div>   	
					</cfif>
				    </div>					
				
				</main>
				<div class="d-none d-xl-block col-xl-2 bd-toc">
					
				</div>				
			</div>			
		</div>        
		<footer id="apiFooter" class="page-footer font-small bg-dark text-light mt-3 pt-4 pl-3" >

		</footer>		
		<script src="#getFullPath('/js/jquery-3.3.1.slim.min.js')#"></script>
		<script src="#getFullPath('/js/popper.min.js')#"></script>
		<script src="#getFullPath('/js/bootstrap.min.js')#" ></script>			
	</body>	
</html>