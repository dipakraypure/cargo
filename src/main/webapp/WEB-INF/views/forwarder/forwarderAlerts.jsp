<%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="ISO-8859-1">
<title>My Alerts</title>
<style>

 #accordionExample .accordionBtn:before, #accordionExample .accordionBtn.collapsed:before {
    /* content: "\f067";
    font-family: "Font Awesome 5 Free";
    font-weight: 900;
    width: 25px;
    height: 25px;
    line-height: 28px;
    font-size: 14px;
    color: #50bbaa;
    text-align: center; */
    position: absolute;
    top: 18px;
    right: 15px;
    transform: rotate(135deg);
    transition: all 0.3s ease 0s;
}
#accordionExample .accordionBtn.collapsed:before {
    color: #a0a0a0;
    transform: rotate(0);
}
.listbox {
    background-color: #fff;
    border: 1px solid #ccc;
    border-radius: 3px;
    height: 375px;
    overflow-x: auto;
}
@media (max-width: 1440px) {
.listbox {
  height:300px !important;
}}
.list_btn {
    padding: 3px;
    margin: 1px 3px;
    color: #ed8b5c;
    font-weight: 500;
    font-size: 14px;    text-align: left;
}
.list_btn:visited {
    border: none;
}
.list_btn:hover {
    border: none;
}
.list_btn:focus {
    outline: none;
}
.list_btnBl {
       padding: 3px;
    margin: 1px 3px;
    color: #161a47;
    font-weight: 500;
    font-size: 14px;
    background: none;
    border: 0px !important;
        text-align: left;
}
.list_btnBl:visited {
    border: none;
}
.list_btnBl:hover {
    border: none;
}
.list_btnBl:focus {
    outline: none;
}
.card {
    background-color: #fff;
    border: 0 solid #fff;
}
.card-header {
    padding: 0;
    margin-bottom: 0;
    background-color: fff;
    border-bottom: 0px solid rgba(0, 0, 0, 0.125);
}
.card-body {
    padding: 5px;
    font-size: 12px;
}
.card-body ul {
    padding: 0px;
    margin: 0 0 0 17px;
}
.card-body li {
    list-style: none;
    line-height: 20px;
}
.card-body li input {
    margin: 0px 4px;
}
.fa-plus, .fa-minus{
    margin: 0 5px;
}
.hidden {
	display: none;
}
.bt1 {
    position: absolute;
    top: 50%;left:15%;
    color: #ed8b5c;
}
.bt2{
    position: absolute;
    top: 60%;
    left:15%;
    color: #161a47;
}
</style>
</head>
<body>
<div class="container-fluid">
  <div class="bg_white_main mb-4 mt-4">
    <div class="spl_padd">
      <div class="col-md-12 padd0">
        <h2 class="book_cargo_hd">Configure My Enquiry Alerts</h2>
      </div>
      <div class="row">
        <div class="col-md-12 col-xs-12">
          <p class="upload_subline">Select specific location(s) for which you do not want to receive alerts.</p>
          <div class="row">
            <div class="col-md-6 col-xs-12">
              <div class="bg_white3">
                <h3 class="book_cargo_hd2">Origin (Choose Country & Location)</h3>
                <div class="row"> 
                  <!--Select-->
                  <div class="col-md-5 ">
                    <p class="upload_subline">Location(s) for which alerts should be <br>received.</p>
                    <input type="text" placeholder="Search" class="form-control mb-2" origin-add-data-search>
                    <div class="listbox ">
                      <div class="accordion" id="accordionOrgAdd"> </div>
                    </div>
                    <div class="clearfix"></div>
                    <!-- <div class="col-md-6">
                      <button type="button" class="login_btn2 mt-4 mb-1 pl-4 pr-4" onclick="getSelectedOriginLocationForAdd();"><i class="fa fa-arrow-right" aria-hidden="true"></i></button>
                    </div> -->
                  </div>
                  <!--Select--> 
                  <div class="col-md-1 ">
                  <div class="row align-items-center">
                   <button type="button" class="btn bt1" onclick="getSelectedOriginLocationForAdd();"><i class="fas fa-chevron-right" aria-hidden="true"></i></button>
                   <br><div class="clearfix"></div>
                   <button type="button" class="btn bt2" onclick="getSelectedOriginLocationForRemove();"><i class="fas fa-chevron-left" aria-hidden="true"></i></button>
                  </div></div>
                  <!--Selected-->
                  <div class="col-md-5 ">
                    <p class="upload_subline">Location(s) for which alerts should not be received.</p>
                      <input type="text" placeholder="Search" class="form-control mb-2" origin-remove-data-search>                     
                    <div class="listbox">                   
                      <div class="accordion" id="accordionOrgRemove"></div>
                     <!-- 
                      <div class="card" origin-remove-data-filter-item origin-remove-data-filter-name="Afghanistan">
                        <div class="card-header" id="headingOne">
                          <h2 class="mb-0">
                            <button type="button" class="list_btn" data-toggle="collapse" data-target="#collapseRemoveOrg1"><i class="fa fa-plus"></i>Afghanistan</button>
                          </h2>
                        </div>
                        <div id="collapseRemoveOrg1" class="collapse" aria-labelledby="headingOne" data-parent="#accordionOrgRemove">
                          <div class="card-body">
                            <ul>
                              <li><input type="checkbox"  name="removeOriginLocation" value="4315">Bagram (AFBAG)</li>
                              <li><input type="checkbox" name="removeOriginLocation" value="4721">Bamian (AFBIN)</li>
                            </ul>
                          </div>
                        </div>
                      </div>
                      
                      <div class="card" origin-remove-data-filter-item origin-remove-data-filter-name="Algeria">
                        <div class="card-header" id="headingOne">
                          <h2 class="mb-0">
                            <button type="button" class="list_btn" data-toggle="collapse" data-target="#collapseRemoveOrg2"><i class="fa fa-plus"></i>Algeria</button>
                          </h2>
                        </div>
                        <div id="collapseRemoveOrg2" class="collapse" aria-labelledby="headingOne" data-parent="#accordionOrgRemove">
                          <div class="card-body">
                            <ul>
                              <li><input type="checkbox"  name="removeOriginLocation" value="415">Adrar (DZAZR)</li>
                              <li><input type="checkbox" name="removeOriginLocation" value="1341">Arzew (DZAZW)</li>
                            </ul>
                          </div>
                        </div>
                      </div>
                       -->
                    </div>                    
                    <!-- <div class="col-md-6">
                      <button type="button" class="login_btn2 mt-4 mb-1" onclick="getSelectedOriginLocationForRemove();"><i class="fa fa-arrow-left" aria-hidden="true"></i></button>
                    </div> -->
                  </div>
                  <!--Selected--> 
                </div>
              </div>
            </div>
            <div class="col-md-6 col-xs-12">
              <div class="bg_white3">
                <h3 class="book_cargo_hd2">Destination (Choose Country & Location)</h3>
                <div class="row"> 
                  <!--Select-->
                  <div class="col-md-5">
                    <p class="upload_subline">Location(s) for which alerts should be <br>received.</p>
                      <input type="text" placeholder="Search" class="form-control mb-2" destination-add-data-search>
                    <div class="listbox">
                      <div class="accordion" id="accordionDestAdd"> </div>
                    </div>
                    <div class="clearfix"></div>
                    <!-- <div class="col-md-6">
                      <button type="button" class="login_btn2 mt-4 mb-1 pl-4 pr-4" onclick="getSelectedDestinationLocationForAdd();"><i class="fa fa-arrow-right" aria-hidden="true"></i></button>
                    </div> -->
                  </div>
                  <!--Select--> 
                  <div class="col-md-1 ">
                  <div class="row align-items-center">
                  <button type="button" class="btn bt1" onclick="getSelectedDestinationLocationForAdd();"><i class="fas fa-chevron-right" aria-hidden="true"></i></button>
                   <br><div class="clearfix"></div>
                   <button type="button" class="btn bt2" onclick="getSelectedDestinationLocationForRemove();"><i class="fas fa-chevron-left" aria-hidden="true"></i></button>
                  </div></div>
                  <!--Selected-->
                  <div class="col-md-5">
                    <p class="upload_subline">Location(s) for which alerts should not be received.</p>
                      <input type="text" placeholder="Search" class="form-control mb-2" destination-remove-data-search>
                    <div class="listbox">
                      <div class="accordion" id="accordionDestRemove"></div>
                      <!--
                      <div class="card" destination-remove-data-filter-item destination-remove-data-filter-name="Afghanistan">
                        <div class="card-header" id="headingOne">
                          <h2 class="mb-0">
                            <button type="button" class="list_btn" data-toggle="collapse" data-target="#collapseRemoveDest1"><i class="fa fa-plus"></i>Afghanistan</button>
                          </h2>
                        </div>
                        <div id="collapseRemoveDest1" class="collapse" aria-labelledby="headingOne" data-parent="#accordionDestRemove">
                          <div class="card-body">
                            <ul>
                              <li><input type="checkbox"  name="removeDestinationLocation" value="4315">Bagram (AFBAG)</li>
                              <li><input type="checkbox" name="removeDestinationLocation" value="4721">Bamian (AFBIN)</li>
                            </ul>
                          </div>
                        </div>
                      </div>
                      
                      <div class="card" destination-remove-data-filter-item destination-remove-data-filter-name="Algeria">
                        <div class="card-header" id="headingOne">
                          <h2 class="mb-0">
                            <button type="button" class="list_btn" data-toggle="collapse" data-target="#collapseRemoveDest2"><i class="fa fa-plus"></i>Algeria</button>
                          </h2>
                        </div>
                        <div id="collapseRemoveDest2" class="collapse" aria-labelledby="headingOne" data-parent="#accordionDestRemove">
                          <div class="card-body">
                            <ul>
                              <li><input type="checkbox"  name="removeDestinationLocation" value="415">Adrar (DZAZR)</li>
                              <li><input type="checkbox" name="removeDestinationLocation" value="1341">Arzew (DZAZW)</li>
                            </ul>
                          </div>
                        </div>
                      </div>
                     -->
                    </div>
                    <!-- <div class="col-md-6">
                      <button type="button" class="login_btn2 mt-4 mb-1" onclick="getSelectedDestinationLocationForRemove();"><i class="fa fa-arrow-left" aria-hidden="true"></i></button>
                    </div> -->
                  </div>
                  <!--Selected--> 
                </div>
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>
  </div>
</div>
<script>
  if ( window.history.replaceState ) {
     window.history.replaceState( null, null, window.location.href );
  }
 		  
    $(function() {   	
    	activeNavigationClass();
    	 getAllCountryList(); 
    	 getAllConfiguredLocation();

         // Search filter for origin add search
    	 $('[origin-add-data-search]').on('keyup', function() {
    			var searchVal = $(this).val();
    			var filterItems = $('[origin-add-data-filter-item]');

    			if ( searchVal != '' ) {
    				filterItems.addClass('hidden');
    				searchVal = searchVal.toLowerCase();
    				//$('[data-filter-item][data-filter-name*="' + searchVal.toLowerCase() + '"]').removeClass('hidden');
    				$('[origin-add-data-filter-item][origin-add-data-filter-name^="' + searchVal + '"]').removeClass('hidden');    				
    			} else {
    				filterItems.removeClass('hidden');
    			}
    		});

    	 //Serach filter for origin remove filter 
    	 $('[origin-remove-data-search]').on('keyup', function() {
 			var searchVal = $(this).val();
 			var filterItems = $('[origin-remove-data-filter-item]');

 			if ( searchVal != '' ) {
 				filterItems.addClass('hidden');
 				searchVal = searchVal.toLowerCase();
 				//$('[data-filter-item][data-filter-name*="' + searchVal.toLowerCase() + '"]').removeClass('hidden');
 				$('[origin-remove-data-filter-item][origin-remove-data-filter-name^="' + searchVal + '"]').removeClass('hidden');    				
 			} else {
 				filterItems.removeClass('hidden');
 			}
 		});
  		
         //Serach filter for destination add filter 
    	 $('[destination-add-data-search]').on('keyup', function() {
 			var searchVal = $(this).val();
 			var filterItems = $('[destination-add-data-filter-item]');

 			if ( searchVal != '' ) {
 				filterItems.addClass('hidden');
 				searchVal = searchVal.toLowerCase();
 				//$('[data-filter-item][data-filter-name*="' + searchVal.toLowerCase() + '"]').removeClass('hidden');
 				$('[destination-add-data-filter-item][destination-add-data-filter-name^="' + searchVal + '"]').removeClass('hidden');    				
 			} else {
 				filterItems.removeClass('hidden');
 			}
 		});

    	//Serach filter for destination remove filter 
    	 $('[destination-remove-data-search]').on('keyup', function() {
 			var searchVal = $(this).val();
 			var filterItems = $('[destination-remove-data-filter-item]');

 			if ( searchVal != '' ) {
 				filterItems.addClass('hidden');
 				searchVal = searchVal.toLowerCase();
 				//$('[data-filter-item][data-filter-name*="' + searchVal.toLowerCase() + '"]').removeClass('hidden');
 				$('[destination-remove-data-filter-item][destination-remove-data-filter-name^="' + searchVal + '"]').removeClass('hidden');    				
 			} else {
 				filterItems.removeClass('hidden');
 			}
 		});
           	   
    });

    function getSelectedOriginLocationForAdd(){
      
      var items = $('input:checkbox[name="addOriginLocation"]:checked').map(function() {
		  var val = this.value.trim();		 
		  return val    
	  }).get().join(',');
      
      if(items == ""){
   	   swal("Please select location");
      }else{
	    	 
    	  $('#loader').show();
        	      
    	  var userId = userInfo.id;
    	  var obj = {'userid':userId, 'ids':items};
    	  
    	  $.post({
    	    url: server_url + 'forwarder/addOriginLocationAlert',
    	    contentType: "application/json; charset=utf-8",
    	    headers: authHeader,
    	    processData: false,
    	    data: JSON.stringify(obj),
    	    success: function (response) {
    	      $('#loader').hide();
    	      console.log(response)

    	      if (response.respCode == 1) {   	     
    	        successBlock("#success_block", response.respData.msg);
    	        getAllConfiguredLocation();
    	      } else if (response.respCode == 0) {
    	        errorBlock("#error_block", response.respData.msg);
    	      } else {
    	        errorBlock("#error_block", response.respData);
    	      }
    	      $('#loader').hide();
    	    },
    	    error: function (error) {
    	      console.log(error)
    	      if (error.responseJSON != undefined) {
    	        errorBlock("#error_block", error.responseJSON.respData);
    	      } else {
    	        errorBlock("#error_block", "Server Error! Please contact administrator");
    	      }
    	      $('#loader').hide();
    	    }
    	  })
    	
      } 
    }
    
    function getSelectedOriginLocationForRemove(){

    	var items = $('input:checkbox[name="removeOriginLocation"]:checked').map(function() {
  		  var val = this.value.trim();  		  
  		  return val    
  	  }).get().join(',');    	  
    	 
    	 if(items == ""){
      	   swal("Please select location");
         }else{
        	 $('#loader').show();
   	      
       	  var userId = userInfo.id;
       	  var obj = {'userid':userId, 'ids':items};
       	  
       	 $.ajax({
    		type: 'PUT',
       	    url: server_url + 'forwarder/removeOriginLocationAlert',
       	    contentType: "application/json; charset=utf-8",
       	    headers: authHeader,
       	    processData: false,
       	    data: JSON.stringify(obj),
       	    success: function (response) {
       	      $('#loader').hide();
       	      console.log(response)

       	      if (response.respCode == 1) {   	     
       	        successBlock("#success_block", response.respData.msg);
       	        getAllConfiguredLocation();
       	      } else if (response.respCode == 0) {
       	        errorBlock("#error_block", response.respData.msg);
       	      } else {
       	        errorBlock("#error_block", response.respData);
       	      }
       	      $('#loader').hide();
       	    },
       	    error: function (error) {
       	      console.log(error)
       	      if (error.responseJSON != undefined) {
       	        errorBlock("#error_block", error.responseJSON.respData);
       	      } else {
       	        errorBlock("#error_block", "Server Error! Please contact administrator");
       	      }
       	      $('#loader').hide();
       	    }
       	  })
         }
    }

    function getSelectedDestinationLocationForAdd(){
        
        var items = $('input:checkbox[name="addDestinationLocation"]:checked').map(function() {
  		  var val = this.value.trim();		 
  		  return val    
  	  }).get().join(',');
       
       if(items == ""){
    	   swal("Please select location");
       }else{
    	   $('#loader').show();
 	      
     	  var userId = userInfo.id;
     	  var obj = {'userid':userId, 'ids':items};
     	  
     	  $.post({
     	    url: server_url + 'forwarder/addDestinationLocationAlert',
     	    contentType: "application/json; charset=utf-8",
     	    headers: authHeader,
     	    processData: false,
     	    data: JSON.stringify(obj),
     	    success: function (response) {
     	      $('#loader').hide();
     	      console.log(response)

     	      if (response.respCode == 1) {     	        
     	        successBlock("#success_block", response.respData.msg);
     	        getAllConfiguredLocation();
     	      } else if (response.respCode == 0) {
     	        errorBlock("#error_block", response.respData.msg);    	       
     	      } else {
     	        errorBlock("#error_block", response.respData);
     	      }
     	      $('#loader').hide();
     	    },
     	    error: function (error) {
     	      console.log(error)
     	      if (error.responseJSON != undefined) {
     	        errorBlock("#error_block", error.responseJSON.respData);
     	      } else {
     	        errorBlock("#error_block", "Server Error! Please contact administrator");
     	      }
     	      $('#loader').hide();
     	    }
     	  })
       } 
    }
    
    function getSelectedDestinationLocationForRemove(){

    	var items = $('input:checkbox[name="removeDestinationLocation"]:checked').map(function() {
  		  var val = this.value.trim();  		  
  		  return val    
  	  }).get().join(',');

      if(items == ""){
       	   swal("Please select location");
      }else{
          $('#loader').show();	      
     	  var userId = userInfo.id;
     	  var obj = {'userid':userId, 'ids':items};
     	  
     	 $.ajax({
     		type: 'PUT',
     	    url: server_url + 'forwarder/removeDestinationLocationAlert',
     	    contentType: "application/json; charset=utf-8",
     	    headers: authHeader,
     	    processData: false,
     	    data: JSON.stringify(obj),
     	    success: function (response) {
     	      $('#loader').hide();
     	      console.log(response)

     	      if (response.respCode == 1) {     	        
     	        successBlock("#success_block", response.respData.msg);
     	        getAllConfiguredLocation();
     	      } else if (response.respCode == 0) {
     	        errorBlock("#error_block", response.respData.msg);    	       
     	      } else {
     	        errorBlock("#error_block", response.respData);
     	      }
     	      $('#loader').hide();
     	    },
     	    error: function (error) {
     	      console.log(error)
     	      if (error.responseJSON != undefined) {
     	        errorBlock("#error_block", error.responseJSON.respData);
     	      } else {
     	        errorBlock("#error_block", "Server Error! Please contact administrator");
     	      }
     	      $('#loader').hide();
     	    }
     	  })
      }  
    	 
      	 
    }

    function getAllCountryList(){
        $('#loader').show();
	  	$.ajax({	  			
	  		     type: 'GET', 
	               url : server_url+'utility/getAllCountry',	     
	               enctype: 'multipart/form-data',
	               headers: authHeader,
	               processData: false,
	               contentType: false,
	               data : null,	      
	               success : function(response) {	                	 	        	
	  	            if(response.respCode == 1){  		  	            		    
	  	            	var cardOrg = '';
	  	            	var cardDest = '';	  	         
	  	            	for(var i=0;i< response.respData.length;i++){
		  	            	var countryname = response.respData[i].countryname;
		  	            	var countrycode = response.respData[i].countrycode;
		  	            	cardOrg = cardOrg + '<div class="card" origin-add-data-filter-item origin-add-data-filter-name="'+countryname.toLowerCase()+'">'+
	  	                         '<div class="card-header" id="headingOne">'+
	  	                           '<h2 class="mb-0">'+
	  	                             '<button type="button" class="list_btnBl" data-toggle="collapse" data-target="#collapseAddOrg'+countrycode+'" onclick="getLocationByCountryCodeForOrigin(\'' + countrycode + '\');"><i class="fa fa-plus"></i>'+countryname+'</button>'+
	  	                           '</h2>'+
	  	                         '</div>'+
	  	                         '<div id="collapseAddOrg'+countrycode+'" class="collapse" aria-labelledby="headingOne" data-parent="#accordionOrgAdd">'+
	  	                         '<div class="card-body">'+	
	  	                           '<ul id="locationOrgAddCard'+countrycode+'"></ul>'+  	                           
	  	                         '</div>'+
	  	                        '</div>'+
	  	                       '</div>';	

	  	                     cardDest = cardDest + '<div class="card" destination-add-data-filter-item destination-add-data-filter-name="'+countryname.toLowerCase()+'">'+
 	                         '<div class="card-header" id="headingOne">'+
 	                           '<h2 class="mb-0">'+
 	                             '<button type="button" class="list_btnBl" data-toggle="collapse" data-target="#collapseAddDest'+countrycode+'" onclick="getLocationByCountryCodeForDestination(\'' + countrycode + '\');"><i class="fa fa-plus"></i>'+countryname+'</button>'+
 	                           '</h2>'+
 	                         '</div>'+
 	                         '<div id="collapseAddDest'+countrycode+'" class="collapse" aria-labelledby="headingOne" data-parent="#accordionDestAdd">'+
 	                         '<div class="card-body">'+	
 	                           '<ul id="locationDestAddCard'+countrycode+'"></ul>'+  	                           
 	                         '</div>'+
 	                        '</div>'+
 	                       '</div>';  	            	
			  	        }       
	  	            	$('#accordionOrgAdd').append(cardOrg);
	  	            	$('#accordionDestAdd').append(cardDest);

	  	            	plusMinusIconInit();
	  	            	
	  	            	$('#loader').hide();        	            		             	       
	  	            }else{
	  		            errorBlock("#error_block",response.respData)	  		           
	                  }
	  	                $('#loader').hide();
	               },
	               error: function (error) {
	            	   $('#loader').hide();
	  	                console.log(error)
	                      if( error.responseJSON != undefined){
	   	                   errorBlock("#error_block",error.responseJSON.respData);	   	                  
	                      }else{
	   	                   errorBlock("#error_block","Server Error! Please contact administrator");
	                      }         
	               }
	      })
	  
  }

  function getLocationByCountryCodeForOrigin(countrycode){
	  getLocationByCountryCode(countrycode,"addOriginLocation");
  }

  function getLocationByCountryCodeForDestination(countrycode){
	  getLocationByCountryCode(countrycode,"addDestinationLocation");
  }
  
  function getLocationByCountryCode(countrycode,checkboxname){
	  	$.ajax({	  			
 		     type: 'GET', 
              url : server_url+'utility/getLocationByCountryCode?countrycode='+countrycode,	     
              enctype: 'multipart/form-data',
              headers: authHeader,
              processData: false,
              contentType: false,
              data : null,	      
              success : function(response) {
              $('#'+countrycode).empty();  	 	        	
 	            if(response.respCode == 1){  		  	            		    
 	            	var locationCard = '';	  	         
 	            	for(var i=0;i< response.respData.length;i++){
 	            		var locationid = response.respData[i].id;
 	 	            	var locationname =  response.respData[i].locationname; 	 
 	 	            	var locationcode = 	response.respData[i].locationcode;
 	 	            	locationCard = locationCard + '<li><input type="checkbox" name="'+checkboxname+'" value="'+locationid+'">'+locationname+' ('+locationcode+')</li>';     	  	            	
		  	        }       
 	            	$('#locationOrgAddCard'+countrycode).empty();	
 	            	$('#locationDestAddCard'+countrycode).empty();		  
 	            	$('#locationOrgAddCard'+countrycode).append(locationCard);	
 	            	$('#locationDestAddCard'+countrycode).append(locationCard);	  
 	            	         		             	       
 	            }else{
 		            errorBlock("#error_block",response.respData)	  		           
                 }
              },
              error: function (error) {
 	                console.log(error)
                     if( error.responseJSON != undefined){
  	                   errorBlock("#error_block",error.responseJSON.respData);	   	                  
                     }else{
  	                   errorBlock("#error_block","Server Error! Please contact administrator");
                     }         
              }
     })
  }  

  function getAllConfiguredLocation(){
	  $('#loader').show();
	  var userId = userInfo.id;  
	  $.ajax({	  			
		     type: 'GET', 
           url : server_url+'forwarder/getAllConfiguredLocation?userId='+userId,	     
           enctype: 'multipart/form-data',
           headers: authHeader,
           processData: false,
           contentType: false,
           data : null,	      
           success : function(response) {
           //$('#'+countrycode).empty();  	 	        	
	            if(response.respCode == 1){  	  	            		    
	            	var cardOrgRemove = '';
	            	var countryOrgArray = [];    
	            	$('#accordionOrgRemove').empty();    
	            	if(response.respData.originLocationResponse != null){
	            		for(var i=0;i< response.respData.originLocationResponse.length;i++){
	            		       			
		            		var locationid = response.respData.originLocationResponse[i].id;
		 	            	var locationname =  response.respData.originLocationResponse[i].locationname; 	 
		 	            	var locationcode = 	response.respData.originLocationResponse[i].locationcode;
		 	            	var countrycode = 	response.respData.originLocationResponse[i].countrycode;
		 	            	var countryname = 	response.respData.originLocationResponse[i].countryname;
		 	            	
		 	            	if(!countryOrgArray.includes(countrycode)){
		 	            		countryOrgArray.push(countrycode);
		 	            		cardOrgRemove = '<div class="card" origin-remove-data-filter-item origin-remove-data-filter-name="'+countryname.toLowerCase()+'">'+
	 	                         '<div class="card-header" id="headingOne">'+
	 	                           '<h2 class="mb-0">'+
	 	                             '<button type="button" class="list_btn" data-toggle="collapse" data-target="#collapseRemoveOrg'+countrycode+'" ><i class="fa fa-plus"></i>'+countryname+'</button>'+
	 	                           '</h2>'+
	 	                         '</div>'+
	 	                         '<div id="collapseRemoveOrg'+countrycode+'" class="collapse" aria-labelledby="headingOne" data-parent="#accordionOrgRemove">'+
	 	                         '<div class="card-body">'+	
	 	                           '<ul id="locationOrgRemoveCard'+countrycode+'">'+
	 	                            '<li><input type="checkbox" name="removeOriginLocation" value="'+locationid+'">'+locationname+' ('+locationcode+')</li>'+
	 	                           '</ul>'+  	  	 	                                                    
	 	                         '</div>'+
	 	                        '</div>'+
	 	                       '</div>';	 	                       
		 	            	  $('#accordionOrgRemove').append(cardOrgRemove);
				 	        }else{
				 	        	var locationCard = '<li><input type="checkbox" name="removeOriginLocation" value="'+locationid+'">'+locationname+' ('+locationcode+')</li>';     	  	            							  	     
				 	        	$('#locationOrgRemoveCard'+countrycode).append(locationCard);	
					 	    }                      	 	            	
				  	    } 	           		
		            }
		            
	            	var cardDestRemove = '';
	            	var countryDestArray = [];
	            	$('#accordionDestRemove').empty();
	            	if(response.respData.destinationLocationResponse != null){
	            		for(var i=0;i< response.respData.destinationLocationResponse.length;i++){
	            		       			
		            		var locationid = response.respData.destinationLocationResponse[i].id;
		 	            	var locationname =  response.respData.destinationLocationResponse[i].locationname; 	 
		 	            	var locationcode = 	response.respData.destinationLocationResponse[i].locationcode;
		 	            	var countrycode = 	response.respData.destinationLocationResponse[i].countrycode;
		 	            	var countryname = 	response.respData.destinationLocationResponse[i].countryname;
		 	            	
		 	            	if(!countryDestArray.includes(countrycode)){
		 	            		countryDestArray.push(countrycode);
		 	            		cardDestRemove = '<div class="card" destination-remove-data-filter-item destination-remove-data-filter-name="'+countryname.toLowerCase()+'">'+
	 	                         '<div class="card-header" id="headingOne">'+
	 	                           '<h2 class="mb-0">'+
	 	                             '<button type="button" class="list_btn" data-toggle="collapse" data-target="#collapseRemoveDest'+countrycode+'" ><i class="fa fa-plus"></i>'+countryname+'</button>'+
	 	                           '</h2>'+
	 	                         '</div>'+
	 	                         '<div id="collapseRemoveDest'+countrycode+'" class="collapse" aria-labelledby="headingOne" data-parent="#accordionDestRemove">'+
	 	                         '<div class="card-body">'+	
	 	                           '<ul id="locationDestRemoveCard'+countrycode+'">'+
	 	                            '<li><input type="checkbox" name="removeDestinationLocation" value="'+locationid+'">'+locationname+' ('+locationcode+')</li>'+
	 	                           '</ul>'+  	  	 	                                                    
	 	                         '</div>'+
	 	                        '</div>'+
	 	                       '</div>';	 	                       
		 	            	  $('#accordionDestRemove').append(cardDestRemove);
				 	        }else{
				 	        	var locationCard = '<li><input type="checkbox" name="removeDestinationLocation" value="'+locationid+'">'+locationname+' ('+locationcode+')</li>';     	  	            							  	     
				 	        	$('#locationDestRemoveCard'+countrycode).append(locationCard);	
					 	    }                      	 	            	
				  	    } 
	            		
		            }
	            	   	            			            		            	         		             	       
	            }else{
		            errorBlock("#error_block",response.respData)	  		           
              }
	          $('#loader').hide();
           },
           error: function (error) {
	                console.log(error)
                  if( error.responseJSON != undefined){
	                   errorBlock("#error_block",error.responseJSON.respData);	   	                  
                  }else{
	                   errorBlock("#error_block","Server Error! Please contact administrator");
                  }     
	              $('#loader').hide();    
           }
     })
  }
    </script>
    <script>
    function plusMinusIconInit(){
    	// Add minus icon for collapse element which is open by default
        $(".collapse.show").each(function(){
        	$(this).prev(".card-header").find(".fa").addClass("fa-minus").removeClass("fa-plus");
        });
        
        // Toggle plus minus icon on show hide of collapse element
        $(".collapse").on('show.bs.collapse', function(){
        	$(this).prev(".card-header").find(".fa").removeClass("fa-plus").addClass("fa-minus");
        }).on('hide.bs.collapse', function(){
        	$(this).prev(".card-header").find(".fa").removeClass("fa-minus").addClass("fa-plus");
        });
    }   
	</script>
</body>
</html>