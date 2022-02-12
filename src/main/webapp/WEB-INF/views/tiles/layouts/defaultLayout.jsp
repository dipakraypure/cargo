<%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1"%>
<%@ page isELIgnored="false"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib uri="http://tiles.apache.org/tags-tiles" prefix="tiles"%>
<html>
<head>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>
<tiles:getAsString name="title" />
</title>
<link rel="shortcut icon" href="static/images/logo.png" type="image/x-icon">
<link href="static/css/bootstrap.css" type="text/css" rel="stylesheet">
<link href="static/css/style.css" type="text/css" rel="stylesheet">
<link href="static/css/font-awesome.min.css" type="text/css" rel="stylesheet">
<link rel="stylesheet" href="static/css/intlTelInput.css">
<link rel="stylesheet" href="static/css/jquery.passwordRequirements.css">
<link rel="stylesheet" href="static/css/sweet-alert.css">
<link rel="stylesheet" href="static/css/loader.css"> 
<link href="static/css/jquery.dataTables.min.css" type="text/css" rel="stylesheet">
<link rel="stylesheet" href="static/css/bootstrap-datetimepicker.min.css">
<link rel="stylesheet" href="https://use.fontawesome.com/releases/v5.6.3/css/all.css">
<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/font-awesome/4.7.0/css/font-awesome.min.css">
<link href="static/css/select2.css" rel="stylesheet" />
<script src="static/vendor/jquery/jquery.min.js"></script> 

<script src="static/vendor/jquery/jquery-migrate-3.0.0.min.js"></script> 
<script src="static/vendor/jquery/jquery.serializejson.min.js"></script> 
<script src="https://momentjs.com/downloads/moment.min.js"></script> 
<script src="static/vendor/jquery/jquery.serializejson.js"></script> 
<script src="https://cdnjs.cloudflare.com/ajax/libs/popper.js/1.12.9/umd/popper.min.js" integrity="sha384-ApNbgh9B+Y1QKtv3Rn7W3mgPxhU9K/ScQsAP7hUibX39j7fakFPskvXusvfa0b4Q" crossorigin="anonymous"></script> 
<script  src="static/js/bootstrap.bundle.js"></script> 
<script  src="static/js/bootstrap.min.js"></script> 
<script  src="static/js/jquery.confirmModal.js"></script> 
<script  src="static/js/jquery.confirmModal.min.js"></script> 
<script src="static/js/intlTelInput.js"></script> 
<script src="static/js/jquery.passwordRequirements.js"></script> 
<script src="static/js/_helpers/active-nav.js"></script> 
<script src="static/js/_helpers/msgBlock.js"></script> 
<script src="static/js/_helpers/api-url.js"></script> 
<script src="static/js/_service/AuthService.js"></script> 
<script src="static/js/_service/deactivate.js"></script> 
<script src="static/js/_service/NumbersOnly.js"></script> 
<script src="static/js/_service/HomeService.js"></script> 
<script src="static/js/_helpers/auth-header.js"></script> 
<script src="static/js/_service/ajaxCall.js"></script> 
<script src="static/js/sweet-alert.js"></script>
<script src="static/js/jquery.dataTables.min.js"></script> 
<script src="static/js/dataTables.responsive.min.js"></script> 
<script src="static/js/bootstrap-datetimepicker.min.js"></script> 
<script src="static/js/select2.min.js"></script>
<script type="text/javascript">
$(document).ready(function(){
	  $('.green_sub').tooltip({title: "Hooray!", delay: 1000}); 
	});
/* $(document).ready(function() {
    $("body").tooltip({ 
         selector: '[data-toggle=tooltip]', 
        trigger : 'hover', 
    	delay: { "show": 500, "hide": 100 }
	 });
}); */


		var userInfo = getCurrentUser();
		var authHeader = authHeader();
		 var contextPath='<%=request.getContextPath()%>';
		console.log(userInfo);
		$(function() {
			//loaderShow();
			//loaderHide();
			$("#navbarHeaderId").show();
			if(userInfo.roles == "AA" || userInfo.roles == "AU"){
				$("#masters_userHome").remove(); // remove home 
				$("#masters_userDashboard").remove(); // remove user dashboard
				$("#masters_userProfile").remove(); // remove user myprofile(user profile) 
				$("#masters_userCompany").remove(); // remove user mycompany(company profile)				

				$("#masters_forwarderHome").remove();// remove forwarder Home
				$("#masters_forwarderProfile").remove();// remove forwarder myprofile
				$("#masters_forwarderCompany").remove();//remove forwarder mycompany
				$("#masters_forwarderAlerts").remove();// remove forwarder alerts				
				$("#masters_forwarderDashboard").remove();// remove forwarder dashboard
				
			}
			if(userInfo.roles == "CS"){
				$("#masters_uploadRate").remove();	// remove admin upload rate 		
				$("#masters_adminDashboard").remove(); // remove admin dashboard
				$("#masters_adminProfile").remove();	 // remove admin profile
				$("#masters_uploadOffer").remove();	// remove admin upload offer(campaign)
				$("#masters_adminSetup").remove();  // remove admin setup nav
				$("#masters_loginLog").remove();	// remove admin User Login log	
				$("#masters_adminFeedback").remove();	 // remove admin feedback
								
				$("#masters_forwarderHome").remove();// remove forwarder Home
				$("#masters_forwarderProfile").remove();// remove forwarder myprofile				
				$("#masters_forwarderCompany").remove();//remove forwarder mycompany
				$("#masters_forwarderAlerts").remove();// remove forwarder alerts
				$("#masters_forwarderDashboard").remove();// remove forwarder dashboard
				
			}
			if(userInfo.roles == "FF"){				
				$("#masters_userHome").remove(); // remove home 
				$("#masters_userDashboard").remove(); // remove user dashboard
				$("#masters_userProfile").remove(); // remove user myprofile(company profile) 
				$("#masters_userCompany").remove(); // remove user mycompany(company profile) 				

				$("#masters_uploadRate").remove();	// remove admin upload rate 	
				$("#masters_adminDashboard").remove(); // remove admin dashboard	
				$("#masters_adminProfile").remove();	 // remove admin profile
				$("#masters_uploadOffer").remove();	// remove admin upload offer(campaign)
				$("#masters_adminSetup").remove();  // remove admin setup nav
				$("#masters_loginLog").remove();	// remove admin User Login log	
				$("#masters_adminFeedback").remove();	 // remove admin feedback
				
				
			}
		});
</script>
</head>
<body>
<!-- loader -->
<div class="loader" id="loader" style="display:none;">
  <span class="loader__element"></span>
  <span class="loader__element"></span>
  <span class="loader__element"></span>
</div>
<!-- loader -->
<!--  <div id="loader" class="loader-wrapper">
		<span class="spinner-border spinner-border-sm" ></span>
	</div> 
	-->
<tiles:insertAttribute name="header" />
<%--    <tiles:insertAttribute name="menu" /> --%>

<!-- Page Content  -->
<div id="content" >
	<span id="error_block"></span>
	<span id="success_block"></span>
  	<tiles:insertAttribute name="body" />
</div>
<tiles:insertAttribute name="footer" />
</body>
</html>
<script src="static/js/_helpers/backtolistpage.js"></script>