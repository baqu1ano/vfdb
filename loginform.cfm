<cffunction name="getPath" returntype="String" >
	<cfargument name="tail" type="string" required="true" />
	<cfreturn "http://" & CGI.SERVER_NAME & ":" & CGI.SERVER_PORT & "/QPMCalcServer" & tail />
</cffunction> 

<!DOCTYPE html>
<html class="no-js" lang="en">
<head>
  <meta name="generator" content="HTML Tidy for Mac OS X (vers 31 October 2006 - Apple Inc. build 15.12), see www.w3.org">
  <meta http-equiv="content-type" content="text/html; charset=utf-8">
  <meta http-equiv="x-ua-compatible" content="ie=edge">

  <title>VFDB - API Documentation</title>
  <meta name="description" content="">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <!-- appropriate links for third-level web pages. Replace 127.0.0.1:8500 with local URL -->
		<cfset apath = getPath('/img/qpm_icon_test_small.png') />
  <link rel="apple-touch-icon" href="/img/apple-touch-icon.png" />
  <link rel="shortcut icon" href="/img/favicon.ico" />
  <link rel="stylesheet" href="/css/default5.css" type="text/css" />
  <link rel="stylesheet" href="/css/normalize.css" type="text/css" />
  <link rel="stylesheet" href="/css/main.css" type="text/css" />
  <script src="/js/plugins.js" type="text/javascript" ></script>
  <script src="/js/main.js" type="text/javascript" ></script>
  <script src="/js/vendor/modernizr-2.8.3.min.js" type="text/javascript" ></script>
</head>

<body>
  <!--[if lt IE 8]>
            <p class="browserupgrade">You are using an <strong>outdated</strong> browser. Please <a href="http://browsehappy.com/">upgrade your browser</a> to improve your experience.</p>
        <![endif]-->

  <div class="container">
    <div class="site-header clearfix" role="banner">
      <div class="site-logo">
        VFDB API
      </div>

      <ul class="site-nav inline-block-list">
        <li><a href="https://www.sabercorrer.com" data-ga-category="Outbound links" data-ga-action="Nav click" data-ga-label="Download">Saber Correr</a></li>
        <li><a href="https://feveatletismo.org/" data-ga-category="Outbound links" data-ga-action="Nav click" data-ga-label="Features">Feveatletismo</a></li>
        <li><a href="https://www.koona.com/qpm/support/index.html" data-ga-category="Outbound links" data-ga-action="Nav click" data-ga-label="Support">Support</a></li>
        <li><a href="https://www.koona.com/qpm/buy/index.html" data-ga-category="Outbound links" data-ga-action="Nav click" data-ga-label="Buy">Buy QPM</a></li>
      </ul>
    </div>   
  </div>

  <div class="site-section"> 
    <div class="container">
      <img src="/img/qpm_icon_test_small.png" alt="Quick Pallet Maker" />
      

		<h2>Please login</h2>
 
		<cfoutput> 
			<form action="#CGI.script_name#?#CGI.query_string#" method="Post"> 
			<div>User Name</div>
			<div><input type="text" name="j_username"></div>
			<div style="height:15px;"></div>
			<div>Password</div>
			<input type="password" name="j_password">
			<div style="height:25px;"></div>
			<div><input type="submit" class="button" value="Log In"></div>
			</form> 
		</cfoutput>

    </div>    
  </div> 

  <div class="site-section site-section-video">
    <h2>Subscribe to our Newsletter</h2>
	<p>Click the button below to fill out a simple form and be informed of updates and tutorials.</p>
    <div class="cta-option">
      <a class="btn btn-alt" href="http://eepurl.com/KuHtT" data-ga-category="Outbound links" data-ga-action="Watch video" data-ga-label="Newsletter">Subscribe</a>
    </div>
  </div>

  <div class="site-section">
    <h2>Need Product Support?</h2>
    <p class="in-the-wild">Please remember that the Quick Pallet Maker software allows you to test ALL the features prior to purchasing. If all is not fine, <a href="https://www.koona.com/qpm/support/index.html">contact us</a>.</p>
  </div>

  <div class="site-footer" role="contentinfo">
    <p style="color:#FFF;">This page was created using <a href="https://github.com/h5bp">HTML5 Boilerplate</a></p>
    <p style="color:#FFF;">Quick Pallet Maker &copy;2000-2023 SCA Mecanica, S.A. <br />Rights reserved.</p>
  </div>

</body>
</html>