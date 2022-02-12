<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>New Booking</title>
<link href="http://code.jquery.com/ui/1.10.2/themes/smoothness/jquery-ui.css" rel="stylesheet">
<link rel="shortcut icon" href="static/images/logo.png" type="image/x-icon">
<link href="static/css/bootstrap.css" type="text/css" rel="stylesheet">
<link href="static/css/style.css" type="text/css" rel="stylesheet">
<link href="static/css/font-awesome.min.css" type="text/css" rel="stylesheet">
<link rel="stylesheet" href="static/css/intlTelInput.css">
<link rel="stylesheet" href="static/css/jquery.passwordRequirements.css">
<script src="static/vendor/jquery/jquery.min.js"></script> 
<script src="static/vendor/jquery/jquery-migrate-3.0.0.min.js"></script> 
<script src="static/vendor/jquery/jquery.serializejson.min.js"></script> 
<script src="static/vendor/jquery/jquery.serializejson.js"></script> 
<script src="https://momentjs.com/downloads/moment.min.js"></script> 
<script  src="static/js/bootstrap.min.js"></script> 
<script src="static/js/_helpers/msgBlock.js"></script> 
<script src="static/js/_helpers/api-url.js"></script> 
<script src="static/js/_service/passwordValidation.js"></script> 
<script src="static/js/_service/AuthService.js"></script> 
<script src="static/js/_helpers/auth-header.js"></script> 
<script src="static/js/_service/ajaxCall.js"></script> 
<script src="static/js/_service/NumbersOnly.js"></script> 
<script src="static/js/_service/HomeService.js"></script> 
<script src="static/js/_helpers/backtolistpage.js"></script> 
<script src="static/js/intlTelInput.js"></script> 
<script src="static/js/jquery.passwordRequirements.js"></script> 
<script type="text/javascript">
   
  $(function() {
	    localStorage.removeItem("user");
		var contextPath='<%=request.getContextPath()%>';
		getUploadOfferData();
		const urlParams = new URLSearchParams(window.location.search);
		const resettoken = urlParams.get('token');
		
		if(resettoken){			
			$('#reset_password_modal').modal('show');
		}
		
		
		/* login code start*/
         /*  Submit form using Ajax */
        $('#user-log-form').submit(function(event) {
	    //  $('.spinner-border').show()
        //Prevent default submission of form
         event.preventDefault();
      
         //Remove all errors
         //$('input').next().remove();
         var form_data = $(this).serializeJSON({useIntKeysAsArrayIndex: true});
      
         console.log(form_data);
      
         $.post({
         url : server_url+'auth/signin',
         contentType: "application/json",
         data : JSON.stringify(form_data),
         success : function(response) {
        	console.log(response)
        	 
        	if(response.respCode == 1){
	            localStorage.setItem("user", JSON.stringify(response.respData));
	         
	        	 if(response.respData.roles =="AA"){
	        		 window.location.href = contextPath+"/upload_rate";
	        	 }
	        	 if(response.respData.roles =="CS"){
	        		 window.location.href = contextPath+"/user_home";
	        	 }
	        	 if(response.respData.roles =="FF"){
	        		 window.location.href = contextPath+"/forwarder_mydashboard";
	        	 }
	        	 if(response.respData.roles =="TR"){
	        		 window.location.href = contextPath+"/user_home";
	        	 }
	        	 if(response.respData.roles =="CR"){
	        		 window.location.href = contextPath+"/user_home";
	        	 }
	        	 if(response.respData.roles =="CH"){
	        		 window.location.href = contextPath+"/user_home";
	        	 }
	        	 if(response.respData.roles =="NV"){
	        		 window.location.href = contextPath+"/user_home";
	        	 }
	        	 if(response.respData.roles =="SU"){
	        		 errorBlock("#error_block","Unauthorized User")
	        	 }
       		  }else{
				errorBlock("#error_block",response.respData)
               }
            },
         error: function (error) {
        	 console.log(error)
        	 
        	 console.log(error.responseJSON )
             
             if( error.responseJSON != undefined){
            	 errorBlock("#error_block",error.responseJSON.respData);
              }else{
            	  errorBlock("#error_block","Server Error! Please contact administrator");
              } 
            // $('.spinner-border').hide()
     	}
      })
   });
		
		/* login code end */
		
		/* Regsitration Code Start */
		  
		  //Sigup form submit
	  /*  Submit form using Ajax */
	   $('#user-signup-form').submit(function(event) {
		    //  $('.spinner-border').show()
		    //Prevent default submission of form
		    event.preventDefault();
		    
		    var inputPassword =  $('#passwordId').val();
		     //var form_data = $(this).serializeJSON({useIntKeysAsArrayIndex: true});
		      var e = document.getElementById("roleDropdownId");
              var strUser = e.options[e.selectedIndex].value;
   
              if(strUser !=0)
              {
                                   
                 if($('input[name="termCondCheckBox"]').is(':checked')) {
                	 if(inputPassword.match(decimalPassword)) 
                	  {
                		 var formData = new FormData();
                         formData.append("email", $("#emailId").val());
                         formData.append("password", $("#passwordId").val());
                         formData.append("mobilenumber", $("#mobilenumberId").val());
                         formData.append("gstinnumber", $("#gstinnumberid").val())
                         formData.append("role", $("#roleDropdownId").val());
        
     	               $.post({
     	                   url : server_url+'auth/signup',	         
     	                   enctype: 'multipart/form-data',
     	                   processData: false,
     		               contentType: false,
     	                   data : formData,
      
     	         
     	                   success : function(response) {
     	        	          console.log(response)
     	        	 	        	
     	        	          if(response.respCode == 1){
     	        	        	 successBlock("#success_block",response.respData.msg);
     	        	        	 $('#reg_modal').modal('hide');
     	        	        	 $('#otp_modal').modal('show');
     	        		        
     	       		          }else{
     					        errorBlock("#error_block",response.respData)
     	                      }
     	                   },
     	                   error: function (error) {
     	        	          console.log(error)
     	        	 
     	        	          console.log(error.responseJSON )
     	              
     	                      if( error.responseJSON != undefined){
     	            	       errorBlock("#error_block",error.responseJSON.respData);
     	                      }else{
     	            	       errorBlock("#error_block","Server Error! Please contact administrator");
     	                      }
     	            
     	                     // $('.spinner-border').hide()
     	     	            }
     	               })
                      }else{
                    	  
                    	  errorBlock("#error_block","The minimum password length is 8 characters and must contain at least 1 lowercase letter, 1 capital letter, 1 number, and 1 special character.");
                      }  
		       }else{
		         errorBlock("#error_block","Please check the checkbox to agree terms and conditions");
	           }
  	           
            }else{
            	errorBlock("#error_block","Please select a user role");
            }
        
	 });
		
		/* Registration code end */
		
		/* User Registration Otp Form   */
		
		$('#user-signup-otp-form').submit(function(event) {
		    //  $('.spinner-border').show()
		    //Prevent default submission of form
		    event.preventDefault();
		    
		    var formData = new FormData();
            formData.append("emailverifyotp", $("#emailOtpId").val());
		    $.post({
                 url : server_url+'auth/signup_verify_otp',	         
                 enctype: 'multipart/form-data',
                 processData: false,
	             contentType: false,
                 data : formData,
                       
                 success : function(response) {
      	          console.log(response)
      	 	        	
      	          if(response.respCode == 1){
      	        	 successBlock("#success_block",response.respData.msg);
      	             $('otp_modal').modal('hide');		        
     		          }else{
				        errorBlock("#error_block",response.respData)
                    }
                 },
                 error: function (error) {
      	          console.log(error)
      	 
      	          console.log(error.responseJSON )
            
                    if( error.responseJSON != undefined){
          	       errorBlock("#error_block",error.responseJSON.respData);
                    }else{
          	       errorBlock("#error_block","Server Error! Please contact administrator");
                    }
          
                   // $('.spinner-border').hide()
   	            }
             })
		    
		});
		
		/* User Registration Otp form */
		
		/* forgot password code */
		
		   $('#user-forgot-form').submit(function(event) {
		       //  $('.spinner-border').show()
		       //Prevent default submission of form
		       event.preventDefault();
		    
               var formData = new FormData();
               formData.append("email", $("#forgotEmailId").val());
           
     	       $.post({
     	             url : server_url+'auth/forgotPassword',	         
     	             enctype: 'multipart/form-data',
     	             processData: false,
     		         contentType: false,
     	             data : formData,
     	             	         
     	             success : function(response) {
         	             	        	
     	        	     if(response.respCode == 1){
     	        	    	$('#forgot_modal').modal('hide');
     	        	        successBlock("#success_block",response.respData.msg);
     	        		        
     	       		     }else{
     					    errorBlock("#error_block",response.respData)
     	                 }
     	             },
     	             error: function (error) {
     	                  if( error.responseJSON != undefined){
     	            	       errorBlock("#error_block",error.responseJSON.respData);
     	                  }else{
     	            	       errorBlock("#error_block","Server Error! Please contact administrator");
     	                  }
     	                     // $('.spinner-border').hide()
     	     	     }
     	        })
	 });
		
		/* end forgot password code */
	/*start reset password */
	
	    $('#user-reset-form').submit(function(event) {
		       //  $('.spinner-border').show()
		       //Prevent default submission of form
		       event.preventDefault();
				
               var formData = new FormData();
               
               formData.append("password", $("#resetNewPassId").val());
               
               formData.append("resettoken",resettoken);
               
     	       $.post({
     	             url : server_url+'auth/resetPassword',	         
     	             enctype: 'multipart/form-data',
     	             processData: false,
     		         contentType: false,
     	             data : formData,
     	             	         
     	             success : function(response) {
         	             	        	
     	        	     if(response.respCode == 1){    	        	    	
     	        	    	$('#reset_password_modal').modal('hide');
     	        	        successBlock("#success_block",response.respData.msg);
     	        		        
     	       		     }else{
     					    errorBlock("#error_block",response.respData)
     	                 }
     	             },
     	             error: function (error) {
     	                  if( error.responseJSON != undefined){
     	            	       errorBlock("#error_block",error.responseJSON.respData);
     	                  }else{
     	            	       errorBlock("#error_block","Server Error! Please contact administrator");
     	                  }
     	                     // $('.spinner-border').hide()
     	     	     }
     	        })
	 });
		
		
		/*end reset password */
		
	    //var tagsOrigin = getSuggetionOriginList("");
	    //var tagsDestination = getSuggetionDestinationList("");
	    var tagsOriginDest = getSuggetionOriginList("");
	    
        /* var tagsOrigin = [];
	    $('#originInputId').on('input',function(){
		    var origin = $('#originInputId').val(); 
		    tagsOrigin = getSuggetionOriginList(origin);
		   
	    }); */
	    
		 	 
        $("#originInputId" ).autocomplete({     	
            source: function(request, response) {
	    	    var filteredArray = $.map(tagsOriginDest, function(item) {
	    	        if( item.toUpperCase().startsWith(request.term.toUpperCase())){
	    	            return item;
	    	        }
	    	        else{
	    	            return null;
	    	        }
	    	    });
	    	    response(filteredArray);
	    	},	   	  
        }); 
	   
	 	
	    $("#destinationInputId" ).autocomplete({ 
	      source: function(request, response) {
	    	    var filteredArray = $.map(tagsOriginDest, function(item) {
	    	        if( item.toUpperCase().startsWith(request.term.toUpperCase())){
	    	            return item;
	    	        }
	    	        else{
	    	            return null;
	    	        }
	    	    });
	    	    response(filteredArray);
	    	},	  	  
	    });
	    showRecentSearchData();
	    
	    
	   /*  Submit form using Ajax */
	   $("#booking-trans-details").submit(function(event) {
		    
	      //Prevent default submission of form
	      event.preventDefault();
	      
	      errorBlock("#error_block","You need to login to retrieve details");
	      
	   });
	   $('#btnFormReset').click(function(){
	        $('#booking-trans-details')[0].reset();
	        $("#lclData").hide();
	        $("#fclData").show();
	    });
	    
	});
  
	/* Start Load User role on popup */
	function loadUserRoleDropdown(){
	$.ajax({
		
		   type: 'GET',  		     	
		   contentType: "application/json",
		   url : server_url+'auth/getAllRole',
		   data: null
		})
		.done(function(response) {
			try{
				
				var ddl = document.getElementById("roleDropdownId");
                var option = document.createElement("OPTION");
                
				if(response != null && response.respData.length !=0){
			        $('#roleDropdownId').empty();	             
                    option.innerHTML = 'Choose your Role';
				    option.value = '0';
				    ddl.options.add(option);	
										
					for( i=0 ; i< response.respData.length ; i++){
								  
					       var option = document.createElement("OPTION");
					       option.innerHTML = response.respData[i].name;
					       option.value = response.respData[i].id;
					       ddl.options.add(option);			
					} 
										  		   
				}else{
					$('#roleDropdownId').empty();
					option.innerHTML = 'No role available';
				    option.value = '0';
				    ddl.options.add(option);
				}
				 
			}catch(err){				
				errorBlock("#error_block",response.respData);
			}
		})
		.fail(function(err) {			
			    errorBlock("#error_block",response.respData);
	    });
    }
    
    /* end Load User role on popup */
    
	
  </script>
</head>
<body>
<span id="success_block"></span> <span id="error_block"></span>
<nav class="navbar navbar-expand-lg padd0">
  <div class="container-fluid"> <a class="navbar-brand" href="#"> <img src="static/images/logo.png" class="clogo" alt="Book My Cargo"> </a>
    <button class="navbar-toggler" type="button" data-toggle="collapse" data-target="#navbarSupportedContent" aria-controls="navbarSupportedContent" aria-expanded="false" aria-label="Toggle navigation"> <span class="navbar-toggler-icon"></span> </button>
    <div class="collapse navbar-collapse d-flex flex-column mtm5" id="navbarSupportedContent">
      <div class="ml-auto mb-2"> <a class="nav_reg_btn" href="#" id="loginId" role="button">Login</a> <a class="nav_reg_btn2" href="#" id="registerId" role="button">Register</a> </div>
      <ul class="navbar-nav main_nav_bg">
        <!--  <li class="nav-item active" id="masters_home">
		        <a  id="menu1" class="nav-link" href="#">Home <span class="sr-only">(current)</span></a>
		      </li> -->
        
      </ul>
    </div>
  </div>
</nav>
<form method="post" id="booking-trans-details">
  <div class="container-fluid">
    <div class="bg_white_main">
      <div class="row minht400 spl_padd">
        <div class="col-md-12 padd0">
          <h2 class="book_cargo_hd">Terms & Conditions</h2>
        </div>
        <div class="col-md-12">
          <h3 class="viewMoreHd2">Terms of Usage</h3>
  <p class="viewMoreSub2">These Terms of Usage describe the applicable terms and conditions for your access and use of the website / portal owned, operated, branded and made available by BookMyCargo.online from time to time and unless expressly agreed in writing, BookMyCargo.online does not recognize any conflicting terms or conditions.</p>
  <p class="viewMoreSub2">These Terms of Usage describe the applicable terms and conditions for your access and use of the website / portal owned, operated, branded and made available by BookMyCargo.online from time to time and unless expressly agreed in writing, BookMyCargo.online does not recognize any conflicting terms or conditions. </p>
  <p class="viewMoreSub2">By accessing this website and / or any of its subsites ("Website"), you accept that you may only use the Website for the purposes for which it was created (i.e. to transact your logistics business digitally by using information available on the Website) and you confirm reading, understanding and agreeing to all the prevailing Terms & Conditions at the time of your access. If you do not agree with any of the stipulated terms & conditions, then you will be prohibited from accessing the website.</p>
  <p class="viewMoreSub2">At any point in time, we reserve the right, in our sole discretion, to make changes or modifications to these Terms &amp; Conditions for any reason and the last revision date will be explicitly shown. There will be no separate intimation or notification for changes or amendments done to the Terms &amp; Conditions. It will be completely your responsibility to periodically check and appraise yourself of the prevailing Terms &amp; Conditions to stay informed of all updates. Also, by your continued usage of the website after the terms &amp; conditions are revised, your acceptance will be deemed to the changes made.</p>
  <br><h3 class="viewMoreHd2">Website Usage &amp; Access</h3>
  <p class="viewMoreSub2">You are prohibited from accessing the website for any purpose other than the purposes for which it was created and "Prohibited Use" include but not limited to the following:</p>
  <ol class="viewMoreSub2">
    <li>Use the Website in a way that violates the applicable laws and / or the rights (including, without limitation, intellectual property rights) of BookMyCargo.online or others</li>
    <li>Use of screen scraping and/or data scraping technologies to retrieve information by circumventing technical safeguards</li>
    <li>Use of search engines, software, tools, agents or other automated processes (robots), including, without limitation, browsers, spiders, crawlers, searchbots and intelligent agents, in a way that circumvents technical safeguards so as to search and use the website (a) in a manner other than that prescribed by BookMyCargo.online or by means other than commonly available browsers (e.g. Internet Explorer, Firefox, Chrome);</li>
    <li>Attempting to decipher, decrypt, disassemble, decompile or reverse engineer software that constitutes the Website or parts of the Website;
    <li>Engage in displaying content from the Website in the form of frames on other websites</li>
    <li>Collecting or systematically retrieving and storing personal data pertaining to other users of this Website</li>
    <li>Reproducing, copying or commercially exploiting content from the website or parts of it without first obtaining express written permission or by trying to circumvent technical safeguards</li>
    <li>Attempt to impersonate another user or person or gaining access to data that is not intended for you personally</li>
    <li>Interfere with, disrupt or create an undue burden on the application or the network infrastructure that results in disproportionately higher loads </li>
    <li>Use the website in connection with any commercial endeavour that is not explicitly approved by us</li>
    <li>Disparage, tarnish, or otherwise harm, in our opinion, us and/or the website </li>
    <li>Intimidate or threaten any of our agents engaged in providing services to you</li>
  </ol>
  <p class="viewMoreSub2">Any use of the website in violation of the foregoing may result in, among other things, termination or suspension of your rights to use the website. The information shown on the website is not intended for distribution and users are solely responsible for compliance with local laws in the country they are based. In addition, BookMyCargo.online at its sole discretion, (a) remove from the Website any material relating to the Prohibited Use, (b) take legal action against you in order to recover any and all damages (including reputational damages and legal and administrative costs) incurred as a result of Prohibited Use engaged by you, (c) forward to public authorities any information it deems relevant for the due enforcement of applicable laws, and/or (d) take any other action it deems appropriate to mitigate its losses and to safeguard the Website against Prohibited Use both now and in the future.</p>
  <br><h3 class="viewMoreHd2">User Representation</h3>
  <p class="viewMoreSub2">By accessing the website, you represent and warrant that (1) all registration information that you submit is true, accurate, current and complete; (2) you will maintain the accuracy of such information and promptly update such registration information as necessary; (3) you have the legal capacity and you agree to comply with these Terms of use; (4) you will not access the website through automated or non-human means (using a BOT, script or otherwise); (5) you will not use the website for any illegal or unauthorized purpose; and (6) your use of the website will not violate any applicable law or regulation. If any information that you provided is untrue, inaccurate, not current or incomplete, we have the right to suspend or terminate your account and refuse any and all current or future use of the application (or any portion thereof).</p>
  <p class="viewMoreSub2">You are solely responsible for all data that relates to any activity you have undertaken on the website. You agree that we shall have no liability to you for any loss or corruption of any such data, and you hereby waive any right of action against us arising from any such loss or corruption of such data. </p>
  <br><h3 class="viewMoreHd2">Information Accuracy</h3>
  <p class="viewMoreSub2">Any information on the website that contains typographical errors, inaccuracies, or omissions, including descriptions, tariffs and other related information, we reserve the right to correct such errors, inaccuracies, or omissions on the website at any time, without prior notice. We also reserve the right to change, modify or remove the contents of the website at any time or for any reason at our sole discretion without notice. We have no obligation to update any information on our website and we reserve the right to modify or discontinue all or part of the website without notice at any time. We will not be liable to anyone for any modification, rates revision, suspension or discontinuance of the website. </p>
  <br><h3 class="viewMoreHd2">Service Availability </h3>
  <p class="viewMoreSub2">We cannot guarantee the application will be available at all times. We may experience hardware, software, or other problems or need to perform maintenance related to the application resulting in interruptions, delays, or errors. We reserve the right to change, revise, update, suspend, discontinue, or otherwise modify the application at any time or for any reason without notice to you. You agree that we have no liability whatsoever for any loss, damage, or inconvenience caused by your inability to access or use the website during any downtime or discontinuance of the website. Nothing in these Terms of Use will be construed to obligate us to maintain and support the website or to supply any corrections, updates or releases in connection thereof.</p>
  <br><h3 class="viewMoreHd2">Intellectual Property Rights</h3>
  <p class="viewMoreSub2">The website functionality, content (design, images, audio, video, text and graphics), source code (including databases), the logo &amp; trademarks contained therein are owned or controlled by us and are protected by copyright and trademark laws. No part of the website or its content may be reproduced, aggregated, copied, distributed, transmitted, republished, encoded, translated, sold, licensed or otherwise exploited for any commercial purpose whatsoever, without prior written permission from us. Based on Terms of Usage, you are granted a limited license to access the website and to download or print a copy of any portion of the content to which you have properly gained access solely for your personal and non-commercial use. All copyright and other intellectual property rights are reserved unless expressly granted to you. </p>
  <p class="viewMoreSub2">All suggestions, ideas, feedback, or any other information regarding the website that will be shared by you with us will be non-confidential in nature and it shall become our sole property. We shall own exclusive rights, including all intellectual property rights and we will be entitled to the unrestricted use and dissemination of these inputs for any lawful purpose, commercial or otherwise, without acknowledgement or compensation to you. You hereby waive all moral rights to any such submissions and you hereby warrant that any such submissions are original with you or that you have the right to submit such submissions. You agree there shall be no recourse against us for any alleged or actual infringement or misappropriation of any proprietary right in your submissions.</p>
  <br><h3 class="viewMoreHd2">Warranties</h3>
  <p class="viewMoreSub2">While all care has been exercised in the development of the website, the software is provided "AS IS". Therefore, except in the case of intentional or fraudulent conduct, BookMyCargo.online accepts no liability or responsibility for any technical or legal defects in the software; in particular, it makes no representations and gives no warranty, express or implied, that the software is free of errors and faults, unencumbered by copyrights or other intellectual property rights owned by others, is complete, or fit for use. For all other eventualities, BookMyCargo.online hereby excludes all liability except where liability cannot be excluded by contract, loss caused by intentional conduct, gross negligence or fraudulent concealment of defects.</p>
  <br><h3 class="viewMoreHd2">Liability</h3>
  <p class="viewMoreSub2">The information provided via the website is accurate and correct to the best of BookMyCargo.online's  knowledge, it may nevertheless contain errors and inaccuracies. The information is provided "AS IS," and BookMyCargo.online makes no representations and gives no warranties, express or implied, as to its correctness or completeness. BookMyCargo.online therefore accepts no liability for any errors or omissions in the information provided via the website or for any consequences arising from the use of the information provided via the website. </p>
  <br><h3 class="viewMoreHd2">Indemnification </h3>
  <p class="viewMoreSub2">You agree to defend, indemnify, and hold us harmless, including our subsidiaries, affiliates, and all of our agents, partners, and employees, from and against any loss, damage, liability, claim or demand, including reasonable attorney fees and expenses, made by any third party due to or arising out of the use of the site, breach of Terms of Use, your violation of the rights of a third party, including but not limited to intellectual property rights; or any overt harmful act toward any other user of the site with whom you connected via the site. Notwithstanding the foregoing, we reserve the right, at your expense, to assume the exclusive defense and control of any matter for which you are required to indemnify us, and you agree to co-operate, at your expense, with our defence of such claims. We will use reasonable efforts to notify you of any such claim, action, or proceeding which is subject to this indemnification upon becoming aware of it.</p>
  <br><h3 class="viewMoreHd2">Term &amp; Termination</h3>
  <p class="viewMoreSub2">These Terms of Use shall remain in full force and effect while you use the website and we reserve the right to in our sole discretion and without notice or liability, deny access to and use of the website to any person for any reason or for no reason including without limitation. For breach of any representation or warranty contained in these Terms of Use or any applicable law or regulation, we may terminate your use or delete your account without any warning. If we terminate or suspend your account for any reason, you are prohibited from registering and creating a new account under your name or a fake or borrowed name. In addition to terminating or suspending your account, we reserve the right to take appropriate legal action, including without limitation pursuing civil, criminal, and injunctive redress.</p>
  <br><h3 class="viewMoreHd2">Disclaimer</h3>
  <p class="viewMoreSub2">The website is provided on an AS-IS and AS-AVAILABLE basis and you agree that your access of the website will be solely at your own risk </p>
  <ol class="viewMoreSub2">
    <li>We disclaim all warranties, express or implied in connection with the website and your use thereof including without limitation the fitness for a particular purpose</li>
    <li>We make no warranties or representations about the accuracy or completeness of the website's content</li>
    <li>We will not assume any liability or responsibility for any errors, mistakes or inaccuracies or any unauthorized access</li>
    <li>We will not be responsible for any interruption or cessation of service due to a virus attack</li>
    <li>We do not guarantee or assume responsibility for any product or service advertised on the website or hyperlinked website or for contents shown in any banner or advertising  medium</li>
    <li>We will not be a party to or in any way be responsible for monitoring any transaction between you and third-party providers of products or services</li>
  </ol>
        </div>
        
        <!-- Codes by HTMLcodes.ws -->
        <div class="col-md-12">
          <marquee class="scroll_text" behavior="scroll" direction="left">
          We provide you the ability to digitally manage all your logistics requirements.
          </marquee>
          <div class="highlight_text_wrap">
            <div class="row">
              <div class="col-md-3"> <img src="static/images/icon1.png" alt="img" class="icon_img">
                <h3 class="highlight_hd">Quotation</h3>
              </div>
              <div class="col-md-3"> <img src="static/images/icon2.png" alt="img" class="icon_img">
                <h3 class="highlight_hd">Booking</h3>
              </div>
              <div class="col-md-3"> <img src="static/images/icon3.png" alt="img" class="icon_img">
                <h3 class="highlight_hd">Customs Clearance</h3>
              </div>
              <div class="col-md-3"> <img src="static/images/icon4.png" alt="img" class="icon_img">
                <h3 class="highlight_hd">Tracking</h3>
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>
  </div>
</form>
<div id="viewMoreModal" class="modal fade" tabindex="-1" role="dialog" aria-labelledby="myLargeModalLabel" aria-hidden="true">
  <div class="modal-dialog modal-md modal-dialog-centered">
    <div class="modal-content"> <img src="static/images/place.jpg" id="modalImgId" alt="place" class="place_img2">
      <h3 class="viewMoreHd">Antwerp & Rotterdam Export</h3>
      <h4 class="viewMoreSub">Special Promotional Rates from
        <label id="modalOfValidDateFromId"></label>
        to
        <label id="modalOfValidDateToId"></label>
      </h4>
      <p class="viewMoreLine">(For General Cargo only)</p>
      <table class="table viewMoreTable">
        <tr>
          <td>20'</td>
          <td>40'</td>
          <td>40' HC</td>
        </tr>
        <tr>
          <td>USD
            <label id="modalOfTwentyRate"></label></td>
          <td>USD
            <label id="modalOfFourtyRate"></label></td>
          <td>USD
            <label id="modalOfFourtyHcRate"></label></td>
        </tr>
      </table>
      <img alt="img" src="static/images/viewMoreModalImg.png" class="viewModalImg">
      <h4 class="viewMoreSub">Avail this limited time offer!</h4>
      <h4 class="viewMoreSub mb-3">Book Now using campaign code <span class="color_theme" id="campaigncode"></span></h4>
    </div>
  </div>
</div>
<div id="location_detail_modal" class="modal fade" tabindex="-1" role="dialog" aria-labelledby="myLargeModalLabel" aria-hidden="true">
  <div class="modal-dialog modal-lg modal-dialog-centered">
    <div class="modal-content">
      <div class="modal-header modal-header-spl">
        <h5 class="modal-title">Location specific requirements</h5>
        <button type="button" class="close btn_close" data-dismiss="modal" aria-label="Close"> <span aria-hidden="true">&times;</span> </button>
      </div>
      <div class="modal-body">
        <h3 class="viewMoreHd2">Below are the location specific requirements</h3>
        <p class="viewMoreSub2" id="locSpecReqId"></p>
      </div>
    </div>
  </div>
</div>
<div id="login_modal" class="modal fade" tabindex="-1" role="dialog" aria-labelledby="myLargeModalLabel" aria-hidden="true">
  <div class="modal-dialog modal-dialog-centered">
    <div class="modal-content">
      <div class="modal-header modal-header-spl">
        <h5 class="modal-title">Login</h5>
        <button type="button" class="close btn_close" data-dismiss="modal" aria-label="Close"> <span aria-hidden="true">&times;</span> </button>
      </div>
      <div class="modal-body">
        <form method="post" id="user-log-form" name="user-log-form" >
          <h3 class="viewMoreHd2 mb-3">Enter your login details</h3>
          <input type="text" class="form-control mb-3" placeholder="Enter your email id" name="username" id="email" required>
          <input type="password" class="form-control mb-3" placeholder="Enter your password" name="password" id="password" required>
          <a href="#" id="forgotPassMdlLinkId" class="forgot_link2">Forgot Password? </a>
          <input type="submit" class="btn btn-theme" value="Submit">
        </form>
      </div>
    </div>
  </div>
</div>
<div id="forgot_modal" class="modal fade" tabindex="-1" role="dialog" aria-labelledby="myLargeModalLabel" aria-hidden="true">
  <div class="modal-dialog modal-dialog-centered">
    <div class="modal-content">
      <div class="modal-header modal-header-spl">
        <h5 class="modal-title">Forgot your Password?</h5>
        <button type="button" class="close btn_close" data-dismiss="modal" aria-label="Close"> <span aria-hidden="true">&times;</span> </button>
      </div>
      <div class="modal-body">
        <form method="post" id="user-forgot-form" name="user-forgot-form" >
          <h3 class="viewMoreHd2 mb-3">Enter your Email</h3>
          <input type="text" class="form-control mb-3" placeholder="Enter your email id" name="username" id='forgotEmailId' required>
          <input type="submit" class="btn btn-theme" value="Send">
        </form>
      </div>
    </div>
  </div>
</div>
<div id="reset_password_modal" class="modal fade" tabindex="-1" role="dialog" aria-labelledby="myLargeModalLabel" aria-hidden="true">
  <div class="modal-dialog modal-dialog-centered">
    <div class="modal-content">
      <div class="modal-header modal-header-spl">
        <h5 class="modal-title">Reset Password</h5>
        <button type="button" class="close btn_close" data-dismiss="modal" aria-label="Close"> <span aria-hidden="true">&times;</span> </button>
      </div>
      <div class="modal-body">
        <form method="post" id="user-reset-form" name="user-reset-form" >
          <h3 class="viewMoreHd2 mb-3">Enter your details to Reset Password</h3>
          <input type="password" class="form-control mb-3 pr-password" placeholder="Enter your New password" name="newPassword" id='resetNewPassId' required>
          <input type="password" class="form-control mb-3" placeholder="Confirm your new password" name="newRePassword" id='resetNewConfirmPassId' oninput="checkRePass(this)" required>
          <script language='javascript' type='text/javascript'>
                 function checkRePass(input) {
                   if (input.value != document.getElementById('resetNewPassId').value) {
                     input.setCustomValidity('Password Must be Matching.');
                   } else {
                     // input is valid -- reset the error message
                     input.setCustomValidity('');
                   }
                  }
               </script>
          <input type="submit" class="btn btn-theme" value="Change Password">
        </form>
      </div>
    </div>
  </div>
</div>
<div id="terms_modal" class="modal fade" tabindex="-1" role="dialog" aria-labelledby="myLargeModalLabel" aria-hidden="true">
  <div class="modal-dialog modal-dialog-scrollable modal-dialog-centered modal-lg">
    <div class="modal-content">
      <div class="modal-header modal-header-spl">
        <h5 class="modal-title">Terms & Condition</h5>
        <button type="button" class="close btn_close" data-dismiss="modal" aria-label="Close"> <span aria-hidden="true">&times;</span> </button>
      </div>
<div class="modal-body">
  <h3 class="viewMoreHd2">Terms of Usage</h3>
  <p class="viewMoreSub2">These Terms of Usage describe the applicable terms and conditions for your access and use of the website / portal owned, operated, branded and made available by BookMyCargo.online from time to time and unless expressly agreed in writing, BookMyCargo.online does not recognize any conflicting terms or conditions.</p>
  <p class="viewMoreSub2">These Terms of Usage describe the applicable terms and conditions for your access and use of the website / portal owned, operated, branded and made available by BookMyCargo.online from time to time and unless expressly agreed in writing, BookMyCargo.online does not recognize any conflicting terms or conditions. </p>
  <p class="viewMoreSub2">By accessing this website and / or any of its subsites ("Website"), you accept that you may only use the Website for the purposes for which it was created (i.e. to transact your logistics business digitally by using information available on the Website) and you confirm reading, understanding and agreeing to all the prevailing Terms & Conditions at the time of your access. If you do not agree with any of the stipulated terms & conditions, then you will be prohibited from accessing the website.</p>
  <p class="viewMoreSub2">At any point in time, we reserve the right, in our sole discretion, to make changes or modifications to these Terms &amp; Conditions for any reason and the last revision date will be explicitly shown. There will be no separate intimation or notification for changes or amendments done to the Terms &amp; Conditions. It will be completely your responsibility to periodically check and appraise yourself of the prevailing Terms &amp; Conditions to stay informed of all updates. Also, by your continued usage of the website after the terms &amp; conditions are revised, your acceptance will be deemed to the changes made.</p>
  <br><h3 class="viewMoreHd2">Website Usage &amp; Access</h3>
  <p class="viewMoreSub2">You are prohibited from accessing the website for any purpose other than the purposes for which it was created and "Prohibited Use" include but not limited to the following:</p>
  <ol class="viewMoreSub2">
    <li>Use the Website in a way that violates the applicable laws and / or the rights (including, without limitation, intellectual property rights) of BookMyCargo.online or others</li>
    <li>Use of screen scraping and/or data scraping technologies to retrieve information by circumventing technical safeguards</li>
    <li>Use of search engines, software, tools, agents or other automated processes (robots), including, without limitation, browsers, spiders, crawlers, searchbots and intelligent agents, in a way that circumvents technical safeguards so as to search and use the website (a) in a manner other than that prescribed by BookMyCargo.online or by means other than commonly available browsers (e.g. Internet Explorer, Firefox, Chrome);</li>
    <li>Attempting to decipher, decrypt, disassemble, decompile or reverse engineer software that constitutes the Website or parts of the Website;
    <li>Engage in displaying content from the Website in the form of frames on other websites</li>
    <li>Collecting or systematically retrieving and storing personal data pertaining to other users of this Website</li>
    <li>Reproducing, copying or commercially exploiting content from the website or parts of it without first obtaining express written permission or by trying to circumvent technical safeguards</li>
    <li>Attempt to impersonate another user or person or gaining access to data that is not intended for you personally</li>
    <li>Interfere with, disrupt or create an undue burden on the application or the network infrastructure that results in disproportionately higher loads </li>
    <li>Use the website in connection with any commercial endeavour that is not explicitly approved by us</li>
    <li>Disparage, tarnish, or otherwise harm, in our opinion, us and/or the website </li>
    <li>Intimidate or threaten any of our agents engaged in providing services to you</li>
  </ol>
  <p class="viewMoreSub2">Any use of the website in violation of the foregoing may result in, among other things, termination or suspension of your rights to use the website. The information shown on the website is not intended for distribution and users are solely responsible for compliance with local laws in the country they are based. In addition, BookMyCargo.online at its sole discretion, (a) remove from the Website any material relating to the Prohibited Use, (b) take legal action against you in order to recover any and all damages (including reputational damages and legal and administrative costs) incurred as a result of Prohibited Use engaged by you, (c) forward to public authorities any information it deems relevant for the due enforcement of applicable laws, and/or (d) take any other action it deems appropriate to mitigate its losses and to safeguard the Website against Prohibited Use both now and in the future.</p>
  <br><h3 class="viewMoreHd2">User Representation</h3>
  <p class="viewMoreSub2">By accessing the website, you represent and warrant that (1) all registration information that you submit is true, accurate, current and complete; (2) you will maintain the accuracy of such information and promptly update such registration information as necessary; (3) you have the legal capacity and you agree to comply with these Terms of use; (4) you will not access the website through automated or non-human means (using a BOT, script or otherwise); (5) you will not use the website for any illegal or unauthorized purpose; and (6) your use of the website will not violate any applicable law or regulation. If any information that you provided is untrue, inaccurate, not current or incomplete, we have the right to suspend or terminate your account and refuse any and all current or future use of the application (or any portion thereof).</p>
  <p class="viewMoreSub2">You are solely responsible for all data that relates to any activity you have undertaken on the website. You agree that we shall have no liability to you for any loss or corruption of any such data, and you hereby waive any right of action against us arising from any such loss or corruption of such data. </p>
  <br><h3 class="viewMoreHd2">Information Accuracy</h3>
  <p class="viewMoreSub2">Any information on the website that contains typographical errors, inaccuracies, or omissions, including descriptions, tariffs and other related information, we reserve the right to correct such errors, inaccuracies, or omissions on the website at any time, without prior notice. We also reserve the right to change, modify or remove the contents of the website at any time or for any reason at our sole discretion without notice. We have no obligation to update any information on our website and we reserve the right to modify or discontinue all or part of the website without notice at any time. We will not be liable to anyone for any modification, rates revision, suspension or discontinuance of the website. </p>
  <br><h3 class="viewMoreHd2">Service Availability </h3>
  <p class="viewMoreSub2">We cannot guarantee the application will be available at all times. We may experience hardware, software, or other problems or need to perform maintenance related to the application resulting in interruptions, delays, or errors. We reserve the right to change, revise, update, suspend, discontinue, or otherwise modify the application at any time or for any reason without notice to you. You agree that we have no liability whatsoever for any loss, damage, or inconvenience caused by your inability to access or use the website during any downtime or discontinuance of the website. Nothing in these Terms of Use will be construed to obligate us to maintain and support the website or to supply any corrections, updates or releases in connection thereof.</p>
  <br><h3 class="viewMoreHd2">Intellectual Property Rights</h3>
  <p class="viewMoreSub2">The website functionality, content (design, images, audio, video, text and graphics), source code (including databases), the logo &amp; trademarks contained therein are owned or controlled by us and are protected by copyright and trademark laws. No part of the website or its content may be reproduced, aggregated, copied, distributed, transmitted, republished, encoded, translated, sold, licensed or otherwise exploited for any commercial purpose whatsoever, without prior written permission from us. Based on Terms of Usage, you are granted a limited license to access the website and to download or print a copy of any portion of the content to which you have properly gained access solely for your personal and non-commercial use. All copyright and other intellectual property rights are reserved unless expressly granted to you. </p>
  <p class="viewMoreSub2">All suggestions, ideas, feedback, or any other information regarding the website that will be shared by you with us will be non-confidential in nature and it shall become our sole property. We shall own exclusive rights, including all intellectual property rights and we will be entitled to the unrestricted use and dissemination of these inputs for any lawful purpose, commercial or otherwise, without acknowledgement or compensation to you. You hereby waive all moral rights to any such submissions and you hereby warrant that any such submissions are original with you or that you have the right to submit such submissions. You agree there shall be no recourse against us for any alleged or actual infringement or misappropriation of any proprietary right in your submissions.</p>
  <br><h3 class="viewMoreHd2">Warranties</h3>
  <p class="viewMoreSub2">While all care has been exercised in the development of the website, the software is provided "AS IS". Therefore, except in the case of intentional or fraudulent conduct, BookMyCargo.online accepts no liability or responsibility for any technical or legal defects in the software; in particular, it makes no representations and gives no warranty, express or implied, that the software is free of errors and faults, unencumbered by copyrights or other intellectual property rights owned by others, is complete, or fit for use. For all other eventualities, BookMyCargo.online hereby excludes all liability except where liability cannot be excluded by contract, loss caused by intentional conduct, gross negligence or fraudulent concealment of defects.</p>
  <br><h3 class="viewMoreHd2">Liability</h3>
  <p class="viewMoreSub2">The information provided via the website is accurate and correct to the best of BookMyCargo.online's  knowledge, it may nevertheless contain errors and inaccuracies. The information is provided "AS IS," and BookMyCargo.online makes no representations and gives no warranties, express or implied, as to its correctness or completeness. BookMyCargo.online therefore accepts no liability for any errors or omissions in the information provided via the website or for any consequences arising from the use of the information provided via the website. </p>
  <br><h3 class="viewMoreHd2">Indemnification </h3>
  <p class="viewMoreSub2">You agree to defend, indemnify, and hold us harmless, including our subsidiaries, affiliates, and all of our agents, partners, and employees, from and against any loss, damage, liability, claim or demand, including reasonable attorney fees and expenses, made by any third party due to or arising out of the use of the site, breach of Terms of Use, your violation of the rights of a third party, including but not limited to intellectual property rights; or any overt harmful act toward any other user of the site with whom you connected via the site. Notwithstanding the foregoing, we reserve the right, at your expense, to assume the exclusive defense and control of any matter for which you are required to indemnify us, and you agree to co-operate, at your expense, with our defence of such claims. We will use reasonable efforts to notify you of any such claim, action, or proceeding which is subject to this indemnification upon becoming aware of it.</p>
  <br><h3 class="viewMoreHd2">Term &amp; Termination</h3>
  <p class="viewMoreSub2">These Terms of Use shall remain in full force and effect while you use the website and we reserve the right to in our sole discretion and without notice or liability, deny access to and use of the website to any person for any reason or for no reason including without limitation. For breach of any representation or warranty contained in these Terms of Use or any applicable law or regulation, we may terminate your use or delete your account without any warning. If we terminate or suspend your account for any reason, you are prohibited from registering and creating a new account under your name or a fake or borrowed name. In addition to terminating or suspending your account, we reserve the right to take appropriate legal action, including without limitation pursuing civil, criminal, and injunctive redress.</p>
  <br><h3 class="viewMoreHd2">Disclaimer</h3>
  <p class="viewMoreSub2">The website is provided on an AS-IS and AS-AVAILABLE basis and you agree that your access of the website will be solely at your own risk </p>
  <ol class="viewMoreSub2">
    <li>We disclaim all warranties, express or implied in connection with the website and your use thereof including without limitation the fitness for a particular purpose</li>
    <li>We make no warranties or representations about the accuracy or completeness of the website's content</li>
    <li>We will not assume any liability or responsibility for any errors, mistakes or inaccuracies or any unauthorized access</li>
    <li>We will not be responsible for any interruption or cessation of service due to a virus attack</li>
    <li>We do not guarantee or assume responsibility for any product or service advertised on the website or hyperlinked website or for contents shown in any banner or advertising  medium</li>
    <li>We will not be a party to or in any way be responsible for monitoring any transaction between you and third-party providers of products or services</li>
  </ol>
</div>
      <div class="modal-footer">
        <button type="button" class="btn btn-secondary" data-dismiss="modal">Close</button>
      </div>
    </div>
  </div>
</div>
<div id="reg_modal" class="modal fade" tabindex="-1" role="dialog" aria-labelledby="myLargeModalLabel" aria-hidden="true">
  <div class="modal-dialog modal-dialog-centered">
    <div class="modal-content">
      <div class="modal-header modal-header-spl">
        <h5 class="modal-title">Register</h5>
        <button type="button" class="close btn_close" data-dismiss="modal" aria-label="Close"> <span aria-hidden="true">&times;</span> </button>
      </div>
      <div class="modal-body">
        <form method="post" id="user-signup-form" >
          <h3 class="viewMoreHd2 mb-3">Enter your details to register</h3>
          <input type="text" class="form-control mb-3" placeholder="Enter your email id" name="email" id='emailId' required>
          <input type="password" class="form-control mb-3 pr-password" placeholder="Enter your password" name="password" id='passwordId' required>
          <input type="password" class="form-control mb-3" placeholder="Re Enter your password" name="repassword" id='repasswordId' oninput="check(this)" required>
          <script language='javascript' type='text/javascript'>
                 function check(input) {
                   if (input.value != document.getElementById('passwordId').value) {
                     input.setCustomValidity('Password Must be Matching.');
                   } else {
                     // input is valid -- reset the error message
                     input.setCustomValidity('');
                   }
                  }
               </script>
          <input type="text" class="form-control mb-3" placeholder="Enter your mobile number" name="mobilenumber" id='mobilenumberId' pattern="\+[0-9]{2,3}[0-9]+" required>
          <input type="text" class="form-control mb-3 mt-3" placeholder="Enter your GSTIN" name="gstinnumber" id='gstinnumberid' required>
          <select class="form-control mb-3 mt-3" id="roleDropdownId" name="role">
          </select>
          <div class="width100">
            <input type="checkbox" value="agree" class="reg_checkbox ml-0" name="termCondCheckBox" >
            <label>I agree to <a class="terms_link" href="#">Terms & Conditions</a></label>
          </div>
          <input type="submit" class="btn btn-theme" value="Submit">
        </form>
      </div>
    </div>
  </div>
</div>
<div id="otp_modal" class="modal fade" tabindex="-1" role="dialog" aria-labelledby="myLargeModalLabel" aria-hidden="true">
  <div class="modal-dialog modal-dialog-centered">
    <div class="modal-content">
      <div class="modal-header modal-header-spl">
        <h5 class="modal-title">OTP Verification</h5>
        <button type="button" class="close btn_close" data-dismiss="modal" aria-label="Close"> <span aria-hidden="true">&times;</span> </button>
      </div>
      <div class="modal-body">
        <form method="post" id="user-signup-otp-form" >
          <h3 class="viewMoreHd2 mb-3">Enter your OTP for verification send to your email</h3>
          <input type="text" class="form-control mb-3" placeholder="Enter your OTP" name="emailotp" id='emailOtpId' required>
          <input type="submit" class="btn btn-theme" value="Submit">
        </form>
      </div>
    </div>
  </div>
</div>

<!-- footer start-->
<footer class="footer mt-3">
  <div class="container-fluid">
    <div class="row">
      <div class="col-md-1">
        <h3 class="footer_hd">Sitemap</h3>
        <p><a href="#" class="footer_link">Home</a></p>
        <p><a class="footer_link">My Profile</a></p>
        <p><a href="#" class="footer_sublink">- My Company</a></p>
      </div>
      <div class="col-md-2">
        <h3 class="footer_hd">&nbsp;</h3>
        <p><a class="footer_link">My Preferences</a></p>
        <p><a href="#" class="footer_sublink">- My Booking</a></p>
        <p><a href="#" class="footer_sublink">- My Checklist</a></p>
        <p><a href="#" class="footer_sublink">- My Shipping Bills</a></p>
        <p><a href="#" class="footer_sublink">- My BLs</a></p>
        <p><a href="#" class="footer_sublink">- My Invoices</a></p>
      </div>
      <div class="col-md-2">
        <h3 class="footer_hd">Legal</h3>
        <p><a href="#" class="footer_link">Terms & Conditions</a></p>
        <p><a href="#" class="footer_link">Privacy Policy</a></p>
      </div>
      <div class="col-md-2">
        <h3 class="footer_hd">Social</h3>
        <p><a href="#" class="footer_link"><i class="fa fa-linkedin footer_icons" aria-hidden="true"></i> Linkedin</a></p>
        <p><a href="#" class="footer_link"><i class="fa fa-facebook footer_icons" aria-hidden="true"></i> Facebook</a></p>
      </div>
      <div class="col-md-2">
        <h3 class="footer_hd">Write to us</h3>
        <input type="text" class="form-control footer_input" placeholder="Enter your Name">
        <input type="text" class="form-control footer_input" placeholder="Enter your Email id">
        <input type="text" class="form-control footer_input" placeholder="Enter your Mobile no.">
      </div>
      <div class="col-md-3">
        <h3 class="footer_hd">&nbsp;</h3>
        <textarea class="form-control footer_input" rows="3" placeholder="Enter your Message"></textarea>
        <input type="submit" value="Submit" class="form_submit">
      </div>
      <div class="col-md-12">
        <p class="copy_line"> &copy; BookMyCargo 2021. All rights reserved. | <a href="#privacy_modal" data-toggle="modal" >Privacy Policy </a> </p>
      </div>
    </div>
  </div>
</footer>
<!-- footer end --> 

<div id="privacy_modal" class="modal fade" tabindex="-1" role="dialog" aria-labelledby="myLargeModalLabel" aria-hidden="true">
  <div class="modal-dialog modal-dialog-scrollable modal-dialog-centered modal-lg">
    <div class="modal-content">
      <div class="modal-header modal-header-spl">
        <h5 class="modal-title">Privacy Policy</h5>
        <button type="button" class="close btn_close" data-dismiss="modal" aria-label="Close"> <span aria-hidden="true">&times;</span> </button>
      </div>
      <div class="modal-body">
        <h3 class="viewMoreHd2">Privacy Policy</h3>
        <p class="viewMoreSub2">Your privacy is important to us and we are committed to protecting the privacy of our users and the information that you share on our website.</p>
        <p class="viewMoreSub2">This Privacy Policy identifies:</p>
        <ol class="viewMoreSub2">
          <li>What information we collect</li>
          <li>How we process and manage such information</li>
          <li>Your rights with respect to the use and disclosure of the same</li>
        </ol>
        <p class="viewMoreSub2">Please read the Privacy Policy carefully and if you do not agree with the terms of this policy, please do not access the website.</p>
        <p class="viewMoreSub2">We are committed to handling your personal information with high standards of information security. We take appropriate physical, electronic, and administrative steps to maintain the security and accuracy of personally identifiable information we collect, including limiting the number of people who have physical access to our database servers, as well as employing electronic security systems and password protections that guard against unauthorized access.</p>
        <p class="viewMoreSub2">We reserve the right to make changes to this Privacy Policy at any time and for any reason and you are encouraged to periodically review this Privacy Policy to stay informed of updates at all times. You will be deemed to be aware of and accepted all changes in the prevailing Privacy Policy by your continued use of the website. The last revised date will be shown at all times on the Privacy Policy.</p>
        <br>
        <h3 class="viewMoreHd2">Personal and Non-Personal Data</h3>
        <p class="viewMoreSub2">"Personal Data" means data that allows someone to identify or contact you, including, for example, your name, address, telephone number, email address, Internet Protocol ("P") address (a number that is automatically assigned to your computer when you use the Internet, which may vary from session to session), as well as any other non-public information about you that is associated with or linked to any of the foregoing data.</p>
        <p class="viewMoreSub2">"Non-Personal Data" means data that is not associated with or linked to your Personal Data; Non-Personal Data does not, by itself, permit the identification of individual persons. We collect Personal Data and Non-Personal Data, as described below.</p>
        <br>
        <h3 class="viewMoreHd2">Collection of information</h3>
        <p class="viewMoreSub2">We receive and store information about you such as:</p>
        <ol class="viewMoreSub2">
          <li>Information You Give Us: We receive and store any information you enter on the website. We collect Personal Data that you voluntarily provide us, for example, when you register to access the website, we may require your name, email, contact information that you may provide us. You can choose not to provide certain information, but then you may not be able to access all the features. </li>
          <li>Automatic Information: We receive and store certain types of information whenever you interact with us. For example, we use "cookies," and we obtain certain types of information when your web browser accesses the website.</li>
          <li>Email Communication: To help us make emails more useful and interesting, we often receive a confirmation when you open an email from newsletters if your computer supports such capabilities. We also compare our customer list to lists received from other companies, in an effort to avoid sending unnecessary messages to our customers. If you do not want to receive email or other mail from us, you may unsubscribe from these emails at any time by clicking on the "unsubscribe" link included in any email or by contacting us via email at support@bookmycargo.online with the word "UNSUBSCRIBE" in the subject line.</li>
          <li>Information from Other Sources: We also collect information about you from various sources (like public records), to enable us to update and correct the information contained in our database and to provide product recommendations and special offers that we think will interest you.</li>
        </ol>
        <br>
        <h3 class="viewMoreHd2">Use of Data</h3>
        <p class="viewMoreSub2">We use the information to analyze, administer, enhance and personalize our services and marketing efforts, to process your registration, and to communicate with you. For example, we use the information to make the website accessible to you, communicate with you (by email, text messaging, push notifications) so that we can send you updates about special offers, promotional announcements, and surveys</p>
        <br>
        <h3 class="viewMoreHd2">Disclosure of Personal & Company information</h3>
        <p class="viewMoreSub2">We may share information we have collected about you in certain situations and your information may be disclosed as follows:</p>
        <br>
        <h3 class="viewMoreHd2">Compliance with laws and for other legitimate business purposes</h3>
        <p class="viewMoreSub2">We will share your Personal Data when we believe disclosure is necessary or required by law, regulation, to protect users, the integrity of the website and to defend or exercise our legal rights. We may also disclose your Personal Data when it may be necessary for other legitimate and lawful purposes as reasonably determined by us</p>
        <br>
        <h3 class="viewMoreHd2">Third-Party Service Providers</h3>
        <p class="viewMoreSub2">We may share your information with vendors and service providers who perform services for us or on our behalf marketing, data analytics support and other services associated with the website such as customer service, hosting and email delivery.</p>
        <br>
        <h3 class="viewMoreHd2">Corporate restructuring</h3>
        <p class="viewMoreSub2">If another company acquires our company, business, or assets, that company will possess the Personal Data collected by us and will assume the rights and obligations regarding your Personal Data as described in this Privacy Policy</p>
        <br>
        <h3 class="viewMoreHd2">Affiliates and Business Partners</h3>
        <p class="viewMoreSub2">With your consent, we may share your information for marketing purposes with our affiliates and business partners, as maybe permitted by law</p>
        <p class="viewMoreSub2">Non-Personal Data we collect</p>
        <ol class="viewMoreSub2">
          <li>Information Collected by Our Servers: To make our website more useful to you, our servers (which may be hosted by a third-party service provider) collect information from you, including your browser type, operating system, domain name, and/or a date/time stamp for your visit.</li>
          <li>Log Files: We gather certain information automatically and store it in the log files. This information includes IP addresses, browser type, Internet service provider ("ISP"), referring / exit pages, operating system, date / time stamp, and clickstream data. We use this information to analyze trends, administer the website and to track user movements on the website and gather demographic information. For example, some of the information may be collected so that when you visit the website again, it will recognize you and the information coold then be used to serve advertisements and other information appropriate to your interests.</li>
          <li>Cookies: We use cookies to collect information. A "cookie" is a small data file stored by your web browser on your computer and it allows us to recognize your computer (but not specifically who is using it) upon entering our site by associating the identification numbers in the cookie with other customer information you have provided us which is stored in our secured database. Session Cookies are automatically deleted from your hard drive after the end of the browser session. </li>
          <li>Analytics: We use third-party vendors, such as Google Analytics to allow tracking technologies and remarketing services on the website to determine the popularity of certain content and to better understand online activity. By accessing the website, you consent to the collection and use of your information by such third-party vendors and you are urged to review their privacy policy from time to time. </li>
          <li>External Websites: If you use links to third-party websites, any information you provide is not covered by this Privacy Policy and we cannot guarantee the safety and privacy of your information as we are not responsible for their privacy policies.</li>
        </ol>
        <br>
        <h3 class="viewMoreHd2">Information Security & Confidentiality</h3>
        <p class="viewMoreSub2">We undertake appropriate organizational and technical measures to protect the security and confidentiality of any information we process. However, no organizational or technical measures are 100% secure so you should take care when disclosing information online and act reasonably to protect yourself online. We cannot guarantee complete security if you provide personal information to us.</p>
        <br>
        <h3 class="viewMoreHd2">Privacy Rights</h3>
        <ol class="viewMoreSub2">
          <li>a.	You may modify the information you have provided to us at any time through your Account</li>
          <li>b.	You can also opt-out of receiving marketing communications, deactivate, or delete your Account at any time</li>
          <li>c.	Based on your request to delete your account, we will deactivate the same from our database but a trace will be retained to comply with legal requirements or to assist with any investigations</li>
        </ol>
      </div>
      <div class="modal-footer">
        <button type="button" class="btn btn-secondary" data-dismiss="modal">Close</button>
      </div>
    </div>
  </div>
</div>

<script src="http://code.jquery.com/ui/1.10.2/jquery-ui.js" ></script> 
<script>
	$(document).ready(function() {
		$("#place_img1").click(function(){
			$("#img_wrap1").hide(400);
			$("#img_wrap2").show(800);
		});
		$("#place_img2").click(function(){
			$("#img_wrap2").hide(400);
			$("#img_wrap1").show(800);
		});
		var input = document.querySelector("#mobilenumberId");
	    window.intlTelInput(input, {
	       nationalMode: false,     
	       utilsScript: "static/js/utils.js",
	    });
	    $(".pr-password").passwordRequirements({
        });
		
		$(".recent_hidden_link").hide();
		$(".recent_arrow").click(function(){
		    $(".recent_hidden_link").toggle(100);
		  });
		
		$( "#shipTypeFclId" ).prop( "checked", true );
		$("#lclData").hide();
        $("#fclData").show();
        $(".search_btn").show(); 
		$('.minus').click(function () {
			var $input = $(this).parent().find('input');
			var count = parseInt($input.val()) - 1;
			count = count < 1 ? 0 : count;
			$input.val(count);
			$input.change();
			return false;
		});
		$('.plus').click(function () {
			var $input = $(this).parent().find('input');
			$input.val(parseInt($input.val()) + 1);
			$input.change();
			return false;
		});
		$('input[type=radio][name=shipmentType]').change(function() {
		    if (this.value == 'fcl') {
		    	$("#lclData").hide();
		        $("#fclData").show();
		        $(".search_btn").show();
		    }
		    else if (this.value == 'lcl') {
		    	getAllPackageUnits();
		    	
		    	$("#fclData").hide();
		        $("#lclData").show();
		        $(".search_btn").show();
		        
		    }
		});
		$(".modal").on("shown.bs.modal", function () {
		    if ($(".modal-backdrop").length > 1) {
		        $(".modal-backdrop").not(':first').remove();
		    }
		})
		
		$('.terms_link').click(function(){
			$('#terms_modal').modal('show');
		});
		
		$('#view_more_btn').click(function(){
			$('#viewMoreModal').modal('show');
		});
		 $('#loginId').click(function(){
			$('#login_modal').modal('show');
		}); 
		$('#registerId').click(function(){
			loadUserRoleDropdown();
			$('#reg_modal').modal('show');
		});
		
		$('.country_list_link').click(function(){
			//onclick="doSomething(this.id)"
		
			var locSpecReqVal = $(this).attr('setvalue');
			$('#locSpecReqId').text(locSpecReqVal);
			$('#location_detail_modal').modal('show');
		});
		$('.country_linkA').click(function(){
			$('.country_listB, .country_listC, .country_listD, .country_listE, .country_listF, .country_listG, .country_listH, .country_listI, .country_listJ, .country_listK, .country_listL, .country_listM, .country_listN, .country_listO, .country_listP, .country_listQ, .country_listR, .country_listS, .country_listT, .country_listU, .country_listV, .country_listW, .country_listX, .country_listU, .country_listX, .country_listY, .country_listZ').hide();
			$('.country_listA').show();
			$('.country_linkB, .country_linkC, .country_linkD, .country_linkE, .country_linkF, .country_linkG, .country_linkH, .country_linkI, .country_linkJ, .country_linkK, .country_linkL, .country_linkM, .country_linkN, .country_linkO, .country_linkP, .country_linkQ, .country_linkR, .country_linkS, .country_linkT, .country_linkU, .country_linkV, .country_linkW, .country_linkX, .country_linkY, .country_linkZ').removeClass("country_link_active");
			$('.country_linkA').addClass("country_link_active");
		});
		$('.country_linkB').click(function(){
			$('.country_listA, .country_listC, .country_listD, .country_listE, .country_listF, .country_listG, .country_listH, .country_listI, .country_listJ, .country_listK, .country_listL, .country_listM, .country_listN, .country_listO, .country_listP, .country_listQ, .country_listR, .country_listS, .country_listT, .country_listU, .country_listV, .country_listW, .country_listX, .country_listU, .country_listX, .country_listY, .country_listZ').hide();
			$('.country_listB').show();
			$('.country_linkA, .country_linkC, .country_linkD, .country_linkE, .country_linkF, .country_linkG, .country_linkH, .country_linkI, .country_linkJ, .country_linkK, .country_linkL, .country_linkM, .country_linkN, .country_linkO, .country_linkP, .country_linkQ, .country_linkR, .country_linkS, .country_linkT, .country_linkU, .country_linkV, .country_linkW, .country_linkX, .country_linkY, .country_linkZ').removeClass("country_link_active");
			$('.country_linkB').addClass("country_link_active");
		});
		$('.country_linkC').click(function(){
			$('.country_listB, .country_listA, .country_listD, .country_listE, .country_listF, .country_listG, .country_listH, .country_listI, .country_listJ, .country_listK, .country_listL, .country_listM, .country_listN, .country_listO, .country_listP, .country_listQ, .country_listR, .country_listS, .country_listT, .country_listU, .country_listV, .country_listW, .country_listX, .country_listU, .country_listX, .country_listY, .country_listZ').hide();
			$('.country_listC').show();
			$('.country_linkB, .country_linkA, .country_linkD, .country_linkE, .country_linkF, .country_linkG, .country_linkH, .country_linkI, .country_linkJ, .country_linkK, .country_linkL, .country_linkM, .country_linkN, .country_linkO, .country_linkP, .country_linkQ, .country_linkR, .country_linkS, .country_linkT, .country_linkU, .country_linkV, .country_linkW, .country_linkX, .country_linkY, .country_linkZ').removeClass("country_link_active");
			$('.country_linkC').addClass("country_link_active");
		});
		$('.country_linkD').click(function(){
			$('.country_listB, .country_listA, .country_listC, .country_listE, .country_listF, .country_listG, .country_listH, .country_listI, .country_listJ, .country_listK, .country_listL, .country_listM, .country_listN, .country_listO, .country_listP, .country_listQ, .country_listR, .country_listS, .country_listT, .country_listU, .country_listV, .country_listW, .country_listX, .country_listU, .country_listX, .country_listY, .country_listZ').hide();
			$('.country_listD').show();
			$('.country_linkB, .country_linkA, .country_linkC, .country_linkE, .country_linkF, .country_linkG, .country_linkH, .country_linkI, .country_linkJ, .country_linkK, .country_linkL, .country_linkM, .country_linkN, .country_linkO, .country_linkP, .country_linkQ, .country_linkR, .country_linkS, .country_linkT, .country_linkU, .country_linkV, .country_linkW, .country_linkX, .country_linkY, .country_linkZ').removeClass("country_link_active");
			$('.country_linkD').addClass("country_link_active");
		});
		$('.country_linkE').click(function(){
			$('.country_listB, .country_listA, .country_listC, .country_listD, .country_listF, .country_listG, .country_listH, .country_listI, .country_listJ, .country_listK, .country_listL, .country_listM, .country_listN, .country_listO, .country_listP, .country_listQ, .country_listR, .country_listS, .country_listT, .country_listU, .country_listV, .country_listW, .country_listX, .country_listU, .country_listX, .country_listY, .country_listZ').hide();
			$('.country_listE').show();
			$('.country_linkB, .country_linkA, .country_linkC, .country_linkD, .country_linkF, .country_linkG, .country_linkH, .country_linkI, .country_linkJ, .country_linkK, .country_linkL, .country_linkM, .country_linkN, .country_linkO, .country_linkP, .country_linkQ, .country_linkR, .country_linkS, .country_linkT, .country_linkU, .country_linkV, .country_linkW, .country_linkX, .country_linkY, .country_linkZ').removeClass("country_link_active");
			$('.country_linkE').addClass("country_link_active");
		});
		$('.country_linkF').click(function(){
			$('.country_listB, .country_listA, .country_listC, .country_listD, .country_listE, .country_listG, .country_listH, .country_listI, .country_listJ, .country_listK, .country_listL, .country_listM, .country_listN, .country_listO, .country_listP, .country_listQ, .country_listR, .country_listS, .country_listT, .country_listU, .country_listV, .country_listW, .country_listX, .country_listU, .country_listX, .country_listY, .country_listZ').hide();
			$('.country_listF').show();
			$('.country_linkB, .country_linkA, .country_linkC, .country_linkD, .country_linkE, .country_linkG, .country_linkH, .country_linkI, .country_linkJ, .country_linkK, .country_linkL, .country_linkM, .country_linkN, .country_linkO, .country_linkP, .country_linkQ, .country_linkR, .country_linkS, .country_linkT, .country_linkU, .country_linkV, .country_linkW, .country_linkX, .country_linkY, .country_linkZ').removeClass("country_link_active");
			$('.country_linkF').addClass("country_link_active");
		});
		$('.country_linkG').click(function(){
			$('.country_listB, .country_listA, .country_listC, .country_listD, .country_listE, .country_listF, .country_listH, .country_listI, .country_listJ, .country_listK, .country_listL, .country_listM, .country_listN, .country_listO, .country_listP, .country_listQ, .country_listR, .country_listS, .country_listT, .country_listU, .country_listV, .country_listW, .country_listX, .country_listU, .country_listX, .country_listY, .country_listZ').hide();
			$('.country_listG').show();
			$('.country_linkB, .country_linkA, .country_linkC, .country_linkD, .country_linkE, .country_linkF, .country_linkH, .country_linkI, .country_linkJ, .country_linkK, .country_linkL, .country_linkM, .country_linkN, .country_linkO, .country_linkP, .country_linkQ, .country_linkR, .country_linkS, .country_linkT, .country_linkU, .country_linkV, .country_linkW, .country_linkX, .country_linkY, .country_linkZ').removeClass("country_link_active");
			$('.country_linkG').addClass("country_link_active");
		});
		$('.country_linkH').click(function(){
			$('.country_listB, .country_listA, .country_listC, .country_listD, .country_listE, .country_listF, .country_listG, .country_listI, .country_listJ, .country_listK, .country_listL, .country_listM, .country_listN, .country_listO, .country_listP, .country_listQ, .country_listR, .country_listS, .country_listT, .country_listU, .country_listV, .country_listW, .country_listX, .country_listU, .country_listX, .country_listY, .country_listZ').hide();
			$('.country_listH').show();
			$('.country_linkB, .country_linkA, .country_linkC, .country_linkD, .country_linkE, .country_linkF, .country_linkG, .country_linkI, .country_linkJ, .country_linkK, .country_linkL, .country_linkM, .country_linkN, .country_linkO, .country_linkP, .country_linkQ, .country_linkR, .country_linkS, .country_linkT, .country_linkU, .country_linkV, .country_linkW, .country_linkX, .country_linkY, .country_linkZ').removeClass("country_link_active");
			$('.country_linkH').addClass("country_link_active");
		});
		$('.country_linkI').click(function(){
			$('.country_listB, .country_listA, .country_listC, .country_listD, .country_listE, .country_listF, .country_listG, .country_listH, .country_listJ, .country_listK, .country_listL, .country_listM, .country_listN, .country_listO, .country_listP, .country_listQ, .country_listR, .country_listS, .country_listT, .country_listU, .country_listV, .country_listW, .country_listX, .country_listU, .country_listX, .country_listY, .country_listZ').hide();
			$('.country_listI').show();
			$('.country_linkB, .country_linkA, .country_linkC, .country_linkD, .country_linkE, .country_linkF, .country_linkG, .country_linkH, .country_linkJ, .country_linkK, .country_linkL, .country_linkM, .country_linkN, .country_linkO, .country_linkP, .country_linkQ, .country_linkR, .country_linkS, .country_linkT, .country_linkU, .country_linkV, .country_linkW, .country_linkX, .country_linkY, .country_linkZ').removeClass("country_link_active");
			$('.country_linkI').addClass("country_link_active");
		});
		$('.country_linkJ').click(function(){
			$('.country_listB, .country_listA, .country_listC, .country_listD, .country_listE, .country_listF, .country_listG, .country_listH, .country_listI, .country_listK, .country_listL, .country_listM, .country_listN, .country_listO, .country_listP, .country_listQ, .country_listR, .country_listS, .country_listT, .country_listU, .country_listV, .country_listW, .country_listX, .country_listU, .country_listX, .country_listY, .country_listZ').hide();
			$('.country_listJ').show();
			$('.country_linkB, .country_linkA, .country_linkC, .country_linkD, .country_linkE, .country_linkF, .country_linkG, .country_linkH, .country_linkI, .country_linkK, .country_linkL, .country_linkM, .country_linkN, .country_linkO, .country_linkP, .country_linkQ, .country_linkR, .country_linkS, .country_linkT, .country_linkU, .country_linkV, .country_linkW, .country_linkX, .country_linkY, .country_linkZ').removeClass("country_link_active");
			$('.country_linkJ').addClass("country_link_active");
		});
		$('.country_linkK').click(function(){
			$('.country_listB, .country_listA, .country_listC, .country_listD, .country_listE, .country_listF, .country_listG, .country_listH, .country_listI, .country_listJ, .country_listL, .country_listM, .country_listN, .country_listO, .country_listP, .country_listQ, .country_listR, .country_listS, .country_listT, .country_listU, .country_listV, .country_listW, .country_listX, .country_listU, .country_listX, .country_listY, .country_listZ').hide();
			$('.country_listK').show();
			$('.country_linkB, .country_linkA, .country_linkC, .country_linkD, .country_linkE, .country_linkF, .country_linkG, .country_linkH, .country_linkI, .country_linkJ, .country_linkL, .country_linkM, .country_linkN, .country_linkO, .country_linkP, .country_linkQ, .country_linkR, .country_linkS, .country_linkT, .country_linkU, .country_linkV, .country_linkW, .country_linkX, .country_linkY, .country_linkZ').removeClass("country_link_active");
			$('.country_linkK').addClass("country_link_active");
		});
		$('.country_linkL').click(function(){
			$('.country_listB, .country_listA, .country_listC, .country_listD, .country_listE, .country_listF, .country_listG, .country_listH, .country_listI, .country_listJ, .country_listK, .country_listM, .country_listN, .country_listO, .country_listP, .country_listQ, .country_listR, .country_listS, .country_listT, .country_listU, .country_listV, .country_listW, .country_listX, .country_listU, .country_listX, .country_listY, .country_listZ').hide();
			$('.country_listL').show();
			$('.country_linkB, .country_linkA, .country_linkC, .country_linkD, .country_linkE, .country_linkF, .country_linkG, .country_linkH, .country_linkI, .country_linkJ, .country_linkK, .country_linkM, .country_linkN, .country_linkO, .country_linkP, .country_linkQ, .country_linkR, .country_linkS, .country_linkT, .country_linkU, .country_linkV, .country_linkW, .country_linkX, .country_linkY, .country_linkZ').removeClass("country_link_active");
			$('.country_linkL').addClass("country_link_active");
		});
		$('.country_linkM').click(function(){
			$('.country_listB, .country_listA, .country_listC, .country_listD, .country_listE, .country_listF, .country_listG, .country_listH, .country_listI, .country_listJ, .country_listK, .country_listL, .country_listN, .country_listO, .country_listP, .country_listQ, .country_listR, .country_listS, .country_listT, .country_listU, .country_listV, .country_listW, .country_listX, .country_listU, .country_listX, .country_listY, .country_listZ').hide();
			$('.country_listM').show();
			$('.country_linkB, .country_linkA, .country_linkC, .country_linkD, .country_linkE, .country_linkF, .country_linkG, .country_linkH, .country_linkI, .country_linkJ, .country_linkK, .country_linkL, .country_linkN, .country_linkO, .country_linkP, .country_linkQ, .country_linkR, .country_linkS, .country_linkT, .country_linkU, .country_linkV, .country_linkW, .country_linkX, .country_linkY, .country_linkZ').removeClass("country_link_active");
			$('.country_linkM').addClass("country_link_active");
		});
		$('.country_linkN').click(function(){
			$('.country_listB, .country_listA, .country_listC, .country_listD, .country_listE, .country_listF, .country_listG, .country_listH, .country_listI, .country_listJ, .country_listK, .country_listL, .country_listM, .country_listO, .country_listP, .country_listQ, .country_listR, .country_listS, .country_listT, .country_listU, .country_listV, .country_listW, .country_listX, .country_listU, .country_listX, .country_listY, .country_listZ').hide();
			$('.country_listN').show();
			$('.country_linkB, .country_linkA, .country_linkC, .country_linkD, .country_linkE, .country_linkF, .country_linkG, .country_linkH, .country_linkI, .country_linkJ, .country_linkK, .country_linkL, .country_linkM, .country_linkO, .country_linkP, .country_linkQ, .country_linkR, .country_linkS, .country_linkT, .country_linkU, .country_linkV, .country_linkW, .country_linkX, .country_linkY, .country_linkZ').removeClass("country_link_active");
			$('.country_linkN').addClass("country_link_active");
		});
		$('.country_linkO').click(function(){
			$('.country_listB, .country_listA, .country_listC, .country_listD, .country_listE, .country_listF, .country_listG, .country_listH, .country_listI, .country_listJ, .country_listK, .country_listL, .country_listM, .country_listN, .country_listP, .country_listQ, .country_listR, .country_listS, .country_listT, .country_listU, .country_listV, .country_listW, .country_listX, .country_listU, .country_listX, .country_listY, .country_listZ').hide();
			$('.country_listO').show();
			$('.country_linkB, .country_linkA, .country_linkC, .country_linkD, .country_linkE, .country_linkF, .country_linkG, .country_linkH, .country_linkI, .country_linkJ, .country_linkK, .country_linkL, .country_linkM, .country_linkN, .country_linkP, .country_linkQ, .country_linkR, .country_linkS, .country_linkT, .country_linkU, .country_linkV, .country_linkW, .country_linkX, .country_linkY, .country_linkZ').removeClass("country_link_active");
			$('.country_linkO').addClass("country_link_active");
		});
		$('.country_linkP').click(function(){
			$('.country_listB, .country_listA, .country_listC, .country_listD, .country_listE, .country_listF, .country_listG, .country_listH, .country_listI, .country_listJ, .country_listK, .country_listL, .country_listM, .country_listN, .country_listO, .country_listQ, .country_listR, .country_listS, .country_listT, .country_listU, .country_listV, .country_listW, .country_listX, .country_listU, .country_listX, .country_listY, .country_listZ').hide();
			$('.country_listP').show();
			$('.country_linkB, .country_linkA, .country_linkC, .country_linkD, .country_linkE, .country_linkF, .country_linkG, .country_linkH, .country_linkI, .country_linkJ, .country_linkK, .country_linkL, .country_linkM, .country_linkN, .country_linkO, .country_linkQ, .country_linkR, .country_linkS, .country_linkT, .country_linkU, .country_linkV, .country_linkW, .country_linkX, .country_linkY, .country_linkZ').removeClass("country_link_active");
			$('.country_linkP').addClass("country_link_active");
		});
		$('.country_linkQ').click(function(){
			$('.country_listB, .country_listA, .country_listC, .country_listD, .country_listE, .country_listF, .country_listG, .country_listH, .country_listI, .country_listJ, .country_listK, .country_listL, .country_listM, .country_listN, .country_listO, .country_listP, .country_listR, .country_listS, .country_listT, .country_listU, .country_listV, .country_listW, .country_listX, .country_listU, .country_listX, .country_listY, .country_listZ').hide();
			$('.country_listQ').show();
			$('.country_linkB, .country_linkA, .country_linkC, .country_linkD, .country_linkE, .country_linkF, .country_linkG, .country_linkH, .country_linkI, .country_linkJ, .country_linkK, .country_linkL, .country_linkM, .country_linkN, .country_linkO, .country_linkP, .country_linkR, .country_linkS, .country_linkT, .country_linkU, .country_linkV, .country_linkW, .country_linkX, .country_linkY, .country_linkZ').removeClass("country_link_active");
			$('.country_linkQ').addClass("country_link_active");
		});
		$('.country_linkR').click(function(){
			$('.country_listB, .country_listA, .country_listC, .country_listD, .country_listE, .country_listF, .country_listG, .country_listH, .country_listI, .country_listJ, .country_listK, .country_listL, .country_listM, .country_listN, .country_listO, .country_listP, .country_listQ, .country_listS, .country_listT, .country_listU, .country_listV, .country_listW, .country_listX, .country_listU, .country_listX, .country_listY, .country_listZ').hide();
			$('.country_listR').show();
			$('.country_linkB, .country_linkA, .country_linkC, .country_linkD, .country_linkE, .country_linkF, .country_linkG, .country_linkH, .country_linkI, .country_linkJ, .country_linkK, .country_linkL, .country_linkM, .country_linkN, .country_linkO, .country_linkP, .country_linkQ, .country_linkS, .country_linkT, .country_linkU, .country_linkV, .country_linkW, .country_linkX, .country_linkY, .country_linkZ').removeClass("country_link_active");
			$('.country_linkR').addClass("country_link_active");
		});
		$('.country_linkS').click(function(){
			$('.country_listB, .country_listA, .country_listC, .country_listD, .country_listE, .country_listF, .country_listG, .country_listH, .country_listI, .country_listJ, .country_listK, .country_listL, .country_listM, .country_listN, .country_listO, .country_listP, .country_listQ, .country_listR, .country_listT, .country_listU, .country_listV, .country_listW, .country_listX, .country_listU, .country_listX, .country_listY, .country_listZ').hide();
			$('.country_listS').show();
			$('.country_linkB, .country_linkA, .country_linkC, .country_linkD, .country_linkE, .country_linkF, .country_linkG, .country_linkH, .country_linkI, .country_linkJ, .country_linkK, .country_linkL, .country_linkM, .country_linkN, .country_linkO, .country_linkP, .country_linkQ, .country_linkR, .country_linkT, .country_linkU, .country_linkV, .country_linkW, .country_linkX, .country_linkY, .country_linkZ').removeClass("country_link_active");
			$('.country_linkS').addClass("country_link_active");
		});
		$('.country_linkT').click(function(){
			$('.country_listB, .country_listA, .country_listC, .country_listD, .country_listE, .country_listF, .country_listG, .country_listH, .country_listI, .country_listJ, .country_listK, .country_listL, .country_listM, .country_listN, .country_listO, .country_listP, .country_listQ, .country_listR, .country_listS, .country_listU, .country_listV, .country_listW, .country_listX, .country_listU, .country_listX, .country_listY, .country_listZ').hide();
			$('.country_listT').show();
			$('.country_linkB, .country_linkA, .country_linkC, .country_linkD, .country_linkE, .country_linkF, .country_linkG, .country_linkH, .country_linkI, .country_linkJ, .country_linkK, .country_linkL, .country_linkM, .country_linkN, .country_linkO, .country_linkP, .country_linkQ, .country_linkR, .country_linkS, .country_linkU, .country_linkV, .country_linkW, .country_linkX, .country_linkY, .country_linkZ').removeClass("country_link_active");
			$('.country_linkT').addClass("country_link_active");
		});
		$('.country_linkU').click(function(){
			$('.country_listB, .country_listA, .country_listC, .country_listD, .country_listE, .country_listF, .country_listG, .country_listH, .country_listI, .country_listJ, .country_listK, .country_listL, .country_listM, .country_listN, .country_listO, .country_listP, .country_listQ, .country_listR, .country_listS, .country_listT, .country_listV, .country_listW, .country_listX, .country_listU, .country_listX, .country_listY, .country_listZ').hide();
			$('.country_listU').show();
			$('.country_linkB, .country_linkA, .country_linkC, .country_linkD, .country_linkE, .country_linkF, .country_linkG, .country_linkH, .country_linkI, .country_linkJ, .country_linkK, .country_linkL, .country_linkM, .country_linkN, .country_linkO, .country_linkP, .country_linkQ, .country_linkR, .country_linkS, .country_linkT, .country_linkV, .country_linkW, .country_linkX, .country_linkY, .country_linkZ').removeClass("country_link_active");
			$('.country_linkU').addClass("country_link_active");
		});
		$('.country_linkV').click(function(){
			$('.country_listB, .country_listA, .country_listC, .country_listD, .country_listE, .country_listF, .country_listG, .country_listH, .country_listI, .country_listJ, .country_listK, .country_listL, .country_listM, .country_listN, .country_listO, .country_listP, .country_listQ, .country_listR, .country_listS, .country_listT, .country_listU, .country_listW, .country_listX, .country_listU, .country_listX, .country_listY, .country_listZ').hide();
			$('.country_listV').show();
			$('.country_linkB, .country_linkA, .country_linkC, .country_linkD, .country_linkE, .country_linkF, .country_linkG, .country_linkH, .country_linkI, .country_linkJ, .country_linkK, .country_linkL, .country_linkM, .country_linkN, .country_linkO, .country_linkP, .country_linkQ, .country_linkR, .country_linkS, .country_linkT, .country_linkU, .country_linkW, .country_linkX, .country_linkY, .country_linkZ').removeClass("country_link_active");
			$('.country_linkV').addClass("country_link_active");
		});
		$('.country_linkW').click(function(){
			$('.country_listB, .country_listA, .country_listC, .country_listD, .country_listE, .country_listF, .country_listG, .country_listH, .country_listI, .country_listJ, .country_listK, .country_listL, .country_listM, .country_listN, .country_listO, .country_listP, .country_listQ, .country_listR, .country_listS, .country_listT, .country_listU, .country_listV, .country_listX, .country_listU, .country_listX, .country_listY, .country_listZ').hide();
			$('.country_listW').show();
			$('.country_linkB, .country_linkA, .country_linkC, .country_linkD, .country_linkE, .country_linkF, .country_linkG, .country_linkH, .country_linkI, .country_linkJ, .country_linkK, .country_linkL, .country_linkM, .country_linkN, .country_linkO, .country_linkP, .country_linkQ, .country_linkR, .country_linkS, .country_linkT, .country_linkU, .country_linkV, .country_linkX, .country_linkY, .country_linkZ').removeClass("country_link_active");
			$('.country_linkW').addClass("country_link_active");
		});
		$('.country_linkX').click(function(){
			$('.country_listB, .country_listA, .country_listC, .country_listD, .country_listE, .country_listF, .country_listG, .country_listH, .country_listI, .country_listJ, .country_listK, .country_listL, .country_listM, .country_listN, .country_listO, .country_listP, .country_listQ, .country_listR, .country_listS, .country_listT, .country_listU, .country_listV, .country_listW, .country_listU, .country_listX, .country_listY, .country_listZ').hide();
			$('.country_listX').show();
			$('.country_linkB, .country_linkA, .country_linkC, .country_linkD, .country_linkE, .country_linkF, .country_linkG, .country_linkH, .country_linkI, .country_linkJ, .country_linkK, .country_linkL, .country_linkM, .country_linkN, .country_linkO, .country_linkP, .country_linkQ, .country_linkR, .country_linkS, .country_linkT, .country_linkU, .country_linkV, .country_linkW, .country_linkY, .country_linkZ').removeClass("country_link_active");
			$('.country_linkX').addClass("country_link_active");
		});
		$('.country_linkY').click(function(){
			$('.country_listB, .country_listA, .country_listC, .country_listD, .country_listE, .country_listF, .country_listG, .country_listH, .country_listI, .country_listJ, .country_listK, .country_listL, .country_listM, .country_listN, .country_listO, .country_listP, .country_listQ, .country_listR, .country_listS, .country_listT, .country_listU, .country_listV, .country_listW, .country_listU, .country_listX, .country_listX, .country_listZ').hide();
			$('.country_listY').show();
			$('.country_linkB, .country_linkA, .country_linkC, .country_linkD, .country_linkE, .country_linkF, .country_linkG, .country_linkH, .country_linkI, .country_linkJ, .country_linkK, .country_linkL, .country_linkM, .country_linkN, .country_linkO, .country_linkP, .country_linkQ, .country_linkR, .country_linkS, .country_linkT, .country_linkU, .country_linkV, .country_linkW, .country_linkX, .country_linkZ').removeClass("country_link_active");
			$('.country_linkY').addClass("country_link_active");
		});
		$('.country_linkZ').click(function(){
			$('.country_listB, .country_listA, .country_listC, .country_listD, .country_listE, .country_listF, .country_listG, .country_listH, .country_listI, .country_listJ, .country_listK, .country_listL, .country_listM, .country_listN, .country_listO, .country_listP, .country_listQ, .country_listR, .country_listS, .country_listT, .country_listU, .country_listV, .country_listW, .country_listU, .country_listX, .country_listX, .country_listY').hide();
			$('.country_listZ').show();
			$('.country_linkB, .country_linkA, .country_linkC, .country_linkD, .country_linkE, .country_linkF, .country_linkG, .country_linkH, .country_linkI, .country_linkJ, .country_linkK, .country_linkL, .country_linkM, .country_linkN, .country_linkO, .country_linkP, .country_linkQ, .country_linkR, .country_linkS, .country_linkT, .country_linkU, .country_linkV, .country_linkW, .country_linkX, .country_linkY').removeClass("country_link_active");
			$('.country_linkZ').addClass("country_link_active");
		});
		
		$('#forgotPassMdlLinkId').click(function(){
			$('#login_modal').modal('hide');
			$('#reset_password_modal').modal('hide');
			$('#forgot_modal').modal('show');
		});
		/*
		$('#resetPassMdlLinkId').click(function(){
			$('#login_modal').modal('hide');
			$('#forgot_modal').modal('hide');
			
			$('#reset_password_modal').modal('show');
		});
		*/
		
		$(function() {
			$( "#cargoReadyDateId" ).datepicker({ 
				dateFormat: 'dd-M-yy',
				minDate: 0,
				beforeShow: function (textbox, instance) {
		            instance.dpDiv.css({
		                    marginTop: (-textbox.offsetHeight) + 'px',
		                    marginLeft: textbox.offsetWidth + 'px'
		            });
		          }
			});
			});
		
	});
	
  </script>
</body>
</html>