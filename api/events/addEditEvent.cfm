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
				
					<h1>Add/Edit Event</h1><br />

					<h4>Updated</h4>
					<p>February 06, 2023</p>
					
			    	<h4>Method Name</h4>
					<p><code>addEditEvent()</code></p>
		
					<h4>WSDL</h4>
					<p><code>http[s]://[SERVERNAME]/vfdb/cfc/VFDBEventService.cfc?wsdl</code></p>
					
					<h4>URL</h4>
					<p><code>http[s]://[SERVERNAME]/vfdb/cfc/VFDBEventService.cfc?method=addEditEvent&eventinfo=</code></p>					
		
					<h4>Description</h4>
					<p>The <code>addEditEvent()</code> method creates a new event if none exists or edits an existing event.</p>
					
					<h4>Input</h4>
					<p>Variable name: <code>eventinfo</code></p>
					<pre><code>
{
    "event_date": [DATESTRING],
    "event_name": [VARCHAR],
    "event_type": [VARCHAR],
    "event_edition": [INTEGER],
    "event_description": [VARCHAR],
    "event_page": [TEXT],
    "organizer": [INTEGER],
    "site": [INTEGER],
    "modes": [
        {
            "mode_date": [DATESTRING],
            "distance": [FLOAT],
            "capacity": [INTEGER],
            "cost": [FLOAT],
            "real_distance": [FLOAT],
            "min_elevation": [FLOAT],
            "max_elevation": [FLOAT],
            "ascent": [FLOAT],
            "descent": [FLOAT],
            "route_link": [TEXT],
            "gpx_link": [TEXT]
        }
    ]
}		
					</code></pre>
					
					<ul>
						<li>event_date: the first day of the event in YYYY:MM:DD hh:mm:ss format</li>
                        <li>event_name: the official name of the event</li>

					</ul>
					
					<h4>Output</h4>
					<pre><code>
		{
			"id":[INTEGER]			
		}
					</code></pre>
					
					<ul>
						<li>id: the unique database identifier of the organizer</li>
					</ul>
					
					<h4>Error Types:</h4>
					<ol start="0">
						<li>no errors</li>
						<li>User not authorized: the user is not the SiteManager</li>
					</ol>						
				
					<br />
					<hr />	
				    <h2>Test API Method</h2>
					<p>A form is available for inputting data manually through the following <a href="../../vso/routes/dumpFullRoutes.cfm">link</a>.</p>
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
					  <cfset eventinfo = serializeJSON(predata) />
					  <cfset outputtext = createObject('component','vfdbcfc.VFDBEventService').addEditEvent(eventinfo) />
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