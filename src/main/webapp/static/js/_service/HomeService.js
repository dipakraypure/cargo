//**********Offer Carousel*************//
  function getUploadOfferData(){

    	
      	$.ajax({
      			
      		     type: 'GET', 
                   url : server_url+'utility/getUploadOfferData',	     
                   enctype: 'multipart/form-data',
                   processData: false,
                   contentType: false,

                   data : null,
          
                   success : function(response) {

      	           console.log(response)
      	 	        	
      	            if(response.respCode == 1){  		            
      	            	getCarouselOffer(response.respData); 		            		             	       
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
                          // $('.spinner-border').hide()
                   }
          })
      }
  
  function showOfferDetailModal(origin,destination,offerImgPath,fromDate,toDate,campCode,desc,footer,templateType,footerImgPath){

      $("#modalImgId").attr("src",offerImgPath); 
      $("#moreOrgId").text(origin);
      $("#moreDestId").text(destination);
      $("#modalOfValidDateFromId").text(fromDate);
      $("#modalOfValidDateToId").text(toDate);
      $("#campaigncode").text(campCode);
      
      if(templateType == "template1"){
    	  $("#offerBodyId").hide();
      }else if(templateType == "template2"){
    	  $("#offerBodyId").show();
    	  $("#moreDesc").text(desc);
    	  $("#moreFooter").text(footer);
    	  $("#moreFooterImgId").attr("src",footerImgPath); 
      }
           
  	$('#viewMoreModal').modal('show');
   }
  
  function getCarouselOffer(data){

	     var elementLi = '';
	     var carDiv  = '';
		 
	     for(var i=0 ; i < data.length  ; i++){

	       var origin = data[i].origin;
	       var destination = data[i].destination;
	       var offerImgPath = data[i].offerimagefullpath;
	       var toDate = data[i].toDate;
	       var fromDate = data[i].fromDate;
	       var tital = data[i].tital;
	       var campCode = data[i].campaigncode;
	       
	       var desc = data[i].description;
	       var footer = data[i].footer;	       
	       var templateType = data[i].templateType;	       	      
	   	   var footerImgPath  = data[i].footerimagefullpath;
	       
		   var className = '';

		   if(i == 0 ){
		       className = "active";
		   }else{
		       className = "";
		   }
		     elementLi = elementLi + '<li data-target="#myCarousel" data-slide-to="'+i+'" class="'+className+'"></li>';
		     
          carDiv = carDiv + '<div class="carousel-item '+className+'">'+
                            '<img class="place_img" src="'+offerImgPath+'" alt="Los Angeles" width="100%" height="auto">'+
                            '<h3 class="place_hd">'+tital+'</h3>'+
	                           '<p class="place_line">Valid till '+toDate+'</p>'+
	                           '<p class="place_line"> <a href="#" onclick="showOfferDetailModal(\''+origin+'\',\''+destination+'\',\''+offerImgPath+'\',\''+fromDate+'\',\''+toDate+'\',\''+campCode+'\',\''+desc+'\',\''+footer+'\',\''+templateType+'\',\''+footerImgPath+'\');">....more</a></p>'+
                           '</div>';
		 }
	     
 	     //<a  data-target="#viewMoreModal" data-toggle="modal"  href="#viewMoreModal">....more</a>
		 $("#offerCarouselId").append(elementLi);
		 $("#offerCarouselInnerId").append(carDiv);
		 
}
  
//**********end of offer carousel**********//

 function getLocationList(data){
	 var locationList=[];
	 
	 for(var key in data)
     { 
  	   var locationCode = data[key].locationcode;
  	   var locationName = data[key].locationname;
  	   var locationNameCode = locationName+" ("+locationCode+")";
  	   locationList.push(locationNameCode);
     }
	 
	 return locationList;
 } 
  
//**********Suggetion list show in origin, Destination input text******************//
 /*
function getSuggetionLocationList(locationInput){
		
		 var locationList=[]; 
		 
		 $.ajax({
			   type: 'GET',  		     	
			   contentType: "application/json",
			   url : server_url+'utility/getAllLocation?location='+locationInput,
			   headers: authHeader,
			   data: null
			})
			.done(function(response) {
				try{
									
                   if( response != null){
                	  
                       for(var key in response.respData)
                       { 
                    	   var locationCode = response.respData[key].locationcode;
                    	   var locationName = response.respData[key].locationname;
                    	   var locationNameCode = locationName+" ("+locationCode+")";
                    	   locationList.push(locationNameCode);
                       }
                   }
					
				}catch(err){				
					console.log("No Data Found");					
				}
			})
			.fail(function(err) {			
				    console.log("Failed");				   
		    });

		    return locationList;
	}
*/	
function getAllPackageUnits(){
		 
			$.ajax({
				
				   type: 'GET',  		     	
				   contentType: "application/json",
				   url : server_url+'utility/packageUnits',
				   data: null
				})
				.done(function(response) {
					try{
						
						var ddl = document.getElementById("packUnitDropdownId");
		                var option = document.createElement("OPTION");
		                
						if(response != null && response.respData.length !=0){
					        $('#packUnitDropdownId').empty();	             
		                   /* option.innerHTML = 'Choose Unit';
						    option.value = '0';
						    ddl.options.add(option);*/	
												
							for( i=0 ; i< response.respData.length ; i++){
										  
							       var option = document.createElement("OPTION");
							       option.innerHTML = response.respData[i].units;
							       option.value = response.respData[i].id;
							       ddl.options.add(option);			
							} 
												  		   
						}else{
							$('#packUnitDropdownId').empty();
							option.innerHTML = 'No Package Units available';
						    option.value = '0';
						    ddl.options.add(option);
						}
						 
					}catch(err){				
						console.log(response.respData);
					}
				})
				.fail(function(err) {			
					    console.log("Failed");
			    });
	}
	
	
//*******Start Home page Recent Search functionality*******//
	
	function showRecentSearchData(){

		$.ajax({
			   type: 'GET',  		     	
			   contentType: "application/json",
			   url : server_url+'utility/recentSearch',
			   data: null
			})
			.done(function(response) {
				try{
									
                if( response != null){
             	  
                   showRecentSearchDataOnDiv(response.respData);
                }
					
				}catch(err){				
					console.log("No Data Found");		
					$("#recentSearchAppId" ).append( '<span>No Data Found</span>' );
				}
			})
			.fail(function(err) {			
				$("#recentSearchAppId" ).append( '<span>No Data Found</span>' );
				    console.log("Failed");				   
		    });
		

	}

	var monthNames = ["Jan", "Feb", "Mar", "Apr", "May", "Jun",
		 "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"];
	 
	function dateFormat(d){
		  var t = new Date(d);
		//  return t.getDate()+'-'+monthNames[t.getMonth()]+'-'+t.getFullYear();
		  return monthNames[t.getMonth()]+' '+t.getDate();
	}
	
   function showRecentSearchDataOnDiv(data){

   	var recentSearch = '';
   	for (var i=0; i <data.length ;i++){

   		var className = 'recent_links recent_hidden_link';
   		if(i == 0){
   			className = 'recent_links';
       	}
       	var searchDate = data[i].searchdate;
       	var origin = data[i].origincode;
       	var destination = data[i].destinationcode;
       	      	
		    var shortMonthDateName = dateFormat(searchDate);
       	var appendVar = '<a href="#" class="'+className+'" onclick="setRecentSearchDataOnSearchField('+data[i].id+')">'+origin+'<span class="black_txt">to</span> '+destination+' <span class="recent_date">- ('+shortMonthDateName+')</span></a>';
   		recentSearch = recentSearch + appendVar;
       }
   	$("#recentSearchAppId" ).append( recentSearch );
       
   }
   
 //*******End Home page Recent Search functionality*******//
   
 //*******Start Cargo Ready Date in dd-Month-yyyy***************//
   function cargoReadyDateFormat(d){
	   
	   var dateMomentObject = moment(d, "DD-MM-YYYY"); // 1st argument - string, 2nd argument - format
	   var t = dateMomentObject.toDate(); // convert moment.js object to Date object
	  // var t = new Date(d);
	   return t.getDate()+'-'+monthNames[t.getMonth()]+'-'+t.getFullYear();
		
   }
 //*******End Cargo Ready Date in dd-Month-yyyy***************//  
   
 //*********Start Recent Search data show in form**************//
   function setRecentSearchDataOnSearchField(id){
       
       $.ajax({
			   type: 'GET',  		     	
			   contentType: "application/json",
			   url : server_url+'utility/recentSearchById?id='+id,
			   data: null
			})
			.done(function(response) {
				try{
									
                if( response != null){

                	var origin = response.respData.origin;
                	var originCode = response.respData.origincode;
                	
                	var destination = response.respData.destination;
                	var destinationCode = response.respData.destinationcode;
                	
             	   $("#originInputId").val(origin+" ("+originCode+")");
             	   $("#destinationInputId").val(destination+" ("+destinationCode+")");

             	   if(response.respData.cargocategory == "GEN"){
	  					$("#genRadiobtnId").prop("checked", true);	
	  					$("#hazDivId").hide();
	  			        $("#reeferDivId").hide();
		  		   }else if(response.respData.cargocategory == "GAZ"){
		  				$("#hazRadioBtnId").prop("checked", true);
		  				$("#reeferDivId").hide();
		  		        $("#hazDivId").show();
		  				$("#imco").val(response.respData.imco);		  				
				   }else if(response.respData.cargocategory == "REEFER"){
				  		$("#reeferRadioBtnId").prop("checked", true);		
				  		$("#hazDivId").hide();
				  		$("#reeferDivId").show();
				  	    $("#temprangeId").val(response.respData.temprange);
   
				   }

             	  $('#gencommodity').val(response.respData.commodity);
             	   
             	   var cargoReadyDate = response.respData.cargoreadydate;
             	   var cargoNewDateFormat = cargoReadyDate;             	   
             	   $("#cargoReadyDateId").val(''); 
             	   
             	   if(response.respData.shipmenttype == "FCL"){		  				
	  					$("#shipTypeFclId").prop("checked", true);
	  					$("#lclData").hide();
	  			        $("#fclData").show();
	  			        
	  			        $("#twentyFtCountInId").val(response.respData.twentyftcount);  							  				
		  				$("#fourtyFtCountInId").val(response.respData.fourtyftcount);		  								  				
		  				$("#fourtyFtHcCountInId").val(response.respData.fourtyfthccount);	  							  				
		  				$("#fourtyFiveFtCountInId").val(response.respData.fourtyfiveftcount);
	  			         					 					
			  		}else if(response.respData.shipmenttype == "LCL"){
			  			//getAllPackageUnits();
			  			$("#shipTypeLclId").prop("checked", true);
	  					$("#fclData").hide();
	  			        $("#lclData").show();
	  			        
	  			        $("#lclTotalWeightInId").val(response.respData.lcltotalweight);  							  				
		  				$("#lclweightunitId").val(response.respData.lclweightunit);		  								  				
		  				$("#lclCubicVolumeId").val(response.respData.lclvolume);	  							  				
		  				$("#lclvolumeunitId").val(response.respData.lclvolumeunit);
		  				$("#lclNumPackId").val(response.respData.lclnumberpackage);	  							  				
		  				$("#packUnitDropdownId").val(response.respData.lclpackageunit);	  				
			  		}	
	  				 $(".recent_hidden_link").toggle(100);	  				
                }					
				}catch(err){				
					console.log("No Data Found");					
				}
			})
			.fail(function(err) {			
				    console.log("Failed");				   
		    });
   }
   //********* End Recent Search data show in form**************//
   
