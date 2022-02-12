<%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="ISO-8859-1">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Upload Rate</title>
<!-- <!-- <link href="http://code.jquery.com/ui/1.10.2/themes/smoothness/jquery-ui.css" rel="stylesheet"> 
<link href="https://cdn.datatables.net/1.10.22/css/jquery.dataTables.min.css" type="text/css" rel="stylesheet">
<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/font-awesome/4.7.0/css/font-awesome.min.css">
<link rel="stylesheet" href="https://use.fontawesome.com/releases/v5.6.3/css/all.css"><link rel="stylesheet" href="static/css/bootstrap-datetimepicker.min.css">
<script src="static/js/bootstrap-datetimepicker.min.js"></script> <script src="http://code.jquery.com/ui/1.10.2/jquery-ui.js" ></script>  
<script src="http://cdn.datatables.net/1.10.1/js/jquery.dataTables.min.js"></script> 
<script src="https://cdn.datatables.net/responsive/1.0.7/js/dataTables.responsive.min.js"></script> -->

<script src="https://cdn.jsdelivr.net/npm/popper.js@1.16.0/dist/umd/popper.min.js"></script> 
<style>
.no-sort::after {
    display: none !important;
}

</style>
<script type="text/javascript">
  $(function() {
	  activeNavigationClass();
	  getAllForwarderCha();
	  getAllCarrier();
	  getAllChargeGrouping();
	  getUploadRateHistoryData();
	  $('#rate-update-modal-form').submit(function(event) {

	        //Prevent default submission of form
	         event.preventDefault();
	
	         var form_data = $(this).serializeJSON({useIntKeysAsArrayIndex: true});
	    
	         console.log(form_data);
	         	      
	         $.post({
	         url : server_url+'admin/updateRateTemplateRecord',
	         contentType: "application/json",
	         headers: authHeader,
	         data : JSON.stringify(form_data),
	         success : function(response) {
		         
	        	if(response.respCode == 1){
	        		successBlock("#success_block",response.respData.msg); 
	        		$('#preview_update_modal').modal('hide');
	        		$("#previewBtn").click();
	        		
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

	            
	     	}
	      })
	   });
	    
	     $("#uploadDirTemplateBtnId").click(function(){

	    	 var forwarderCha =  $("#forwChaDropdownId").val();
		     var carrierName =  $("#carrierDropdownId").val();
		     var carrierSelectVal = $("#carrierDropdownId option:selected").text();

		     var chargeTypeName =  $("#chargeTypeDropdownId").val();
		     var shipmentType =  $("#shiptypeDropdownId").val();
		     var chargeTypeSelectVal = $("#chargeTypeDropdownId option:selected").text();
		     
		     var carrierAPI = "";
		     
             if(carrierSelectVal.includes("MXCN") && chargeTypeSelectVal.startsWith("Freight Charges"))
		     {
            	 carrierAPI = "convertFileMaxiconToSys";          	
       		 }else if(carrierSelectVal.includes("RCL") && chargeTypeSelectVal.startsWith("Freight Charges")){
       			 carrierAPI = "convertFileRCLToSys";
             }
		     
	    	 var formData = new FormData();
	            
             formData.append("userId", userInfo.id);
             formData.append("forwarderCha",forwarderCha);
             formData.append("carrier",carrierName);

             formData.append("chargeType", chargeTypeName);
             formData.append("shipmentType",shipmentType);
             formData.append("validDateFrom", $("#validDateFromId").val());
             formData.append("validDateTo", $("#validDateToId").val());
  
             //get carrier rate file
             var carrierRateFileInput = document.getElementById('carrierRateFileId');
             var fileRate = carrierRateFileInput.files[0];
             formData.append("carrierRateFileToConvert", fileRate);

             $.post({
                 url : server_url+'admin/'+carrierAPI,	         
                 enctype: 'multipart/form-data',
                 headers: authHeader,
                 processData: false,
	             contentType: false,
                 data : formData,
	         
                 success : function(response) {

      	          console.log(response)
      	 	        	
      	          if(response.respCode == 1){
      		                  		   
      		            //$("#carrierDownNameId").val(response.respData.carriername);
      		            var ddl = document.getElementById("carrierDownNameId");
	                    var option = document.createElement("OPTION");
					    option.innerHTML = response.respData.carriername;
				        option.value = response.respData.carrierid;
				        ddl.options.add(option);

				        var ddl1 = document.getElementById("chargeTypeDropStepTwoId");
	                    var option1 = document.createElement("OPTION");
					    option1.innerHTML = response.respData.chargegrouping;
				        option1.value = response.respData.chargegroupingid;
				        ddl1.options.add(option1);

      		            $("#templateNameLblDownId").val(response.respData.filename);

      		            $("#step1_wrap").hide();
      				    $("#step2_wrap").show();
      		            successBlock("#success_block",response.respData.msg);    		       
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

	     $("#downTemplateBtnId").click(function(){

	    	 var carrierName = $("#carrierDownNameId").val();
	    	 var templateName = $("#templateNameLblDownId").val();
	    	 var userId =  userInfo.id;
	    	 
	    	 var url = server_url+'download/downloadTemplate';
	    	 window.location.href = url+"?userId="+ userId + "&carrierName=" + carrierName +"&templateName="+templateName;
	    	 	    	 
	     });

	     $("#previewBtn").click(function(){
	    	 
	    	 var carrierName = $("#carrierDownNameId").val();
	    	 var templateName = $("#templateNameLblDownId").val();
	    	 var userId =  userInfo.id;
	    	    	
             $.ajax({
     			
  			     type: 'GET', 
                 url : server_url+'admin/previewTemplateData',	         
                 enctype: 'multipart/form-data',
                 headers: authHeader,
                 processData: false,
	             contentType: false,

                 data : "userId="+ userId + "&carrierName=" + carrierName +"&templateName="+templateName,
	         
                 success : function(response) {

      	          console.log(response)
      	 	        	
      	          if(response.respCode == 1){
      		         
      		            loadPreviewRateDatatable(response.respData);
      		            loadPreviewrateErrorDatatable(response.respData);
      		           	
      		            //successBlock("#success_block",response.respData.msg);   
      		             	       
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
	    	 
	    	 	    	 
	     });

	     $("#uploadTemplateDataBtnId").click(function(){

	    	 var carrierName = $("#carrierDownNameId").val();
	    	 var chargeType = $("#chargeTypeDropdownId").val();
	    	 var templateName = $("#templateNameLblDownId").val();
	    	 var userId =  userInfo.id;
	    	    	
             $.ajax({
     			
  			     type: 'GET', 
                 url : server_url+'admin/uploadTemplateData',	         
                 enctype: 'multipart/form-data',
                 headers: authHeader,
                 processData: false,
	             contentType: false,

                 data : "userId="+ userId + "&carrierName=" + carrierName +"&chargeType="+chargeType+"&templateName="+templateName,
	         
                 success : function(response) {

      	          console.log(response)
      	 	        	
      	          if(response.respCode == 1){
      	        	swal("Template data uploaded Sucessfully");   
      		            window.location.href = contextPath+"/uploadRate"; 	
      		            successBlock("#success_block",response.respData.msg);   
      		             	       
     		          }else{
				        errorBlock("#error_block",response.respData)
                    }
                 },
                 error: function (error) {
      	           console.log(error)
                    if( error.responseJSON != undefined){
          	       errorBlock("#error_block",error.responseJSON.error);
                    }else{
          	       errorBlock("#error_block","Server Error! Please contact administrator");
                    }         
                   // $('.spinner-border').hide()
   	            }
             })
            
	     });

	     
          /*
          //Direct upload template file 
	     $("#uploadTemplateDataBtnId").click(function(){

	    	 var formData = new FormData();
	            
             formData.append("userId", userInfo.id);
  
             //get carrier rate file
             var carrierRateFileInput = document.getElementById('carrierRateTempFileId');
             var fileRate = carrierRateFileInput.files[0];
             formData.append("carrierRateTempFileToUpload", fileRate);

             $.post({
                 url : server_url+'admin/uploadDirTemplateFile',	         
                 enctype: 'multipart/form-data',
                 headers: authHeader,
                 processData: false,
	             contentType: false,
                 data : formData,
	         
                 success : function(response) {

      	          console.log(response)
      	 	        	
      	          if(response.respCode == 1){
      		           
      		            
      		            successBlock("#success_block",response.respData.msg);    		       
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

		 */
	     
	  
	});

  function getAllForwarderCha(){
		 
		$.ajax({
			
			   type: 'GET',  		     	
			   contentType: "application/json",
			   url : server_url+'admin/getForwarderCha',
			   headers: authHeader,
			   data: null
			})
			.done(function(response) {
				try{
					
					var ddl = document.getElementById("forwChaDropdownId");
	                var option = document.createElement("OPTION");
	                
					if(response != null && response.respData.length !=0){
				        $('#forwChaDropdownId').empty();	             
	                    option.innerHTML = 'Choose Forwarder/CHA';
					    option.value = '0';
					    ddl.options.add(option);	
											
						for( i=0 ; i< response.respData.length ; i++){
									  
						       var option = document.createElement("OPTION");
						       option.innerHTML = response.respData[i].tradename;
						       option.value = response.respData[i].id;
						       ddl.options.add(option);			
						} 
											  		   
					}else{
						$('#forwChaDropdownId').empty();
						option.innerHTML = 'No Forwarder/CHA available';
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
  
	function getColumnValue(e,id){
		
		var tr = $(e).closest('tr');
		  var serialnumber = tr.children('td:eq(0)').text();
		  var origin = tr.children('td:eq(1)').text(); 
		  var destination = tr.children('td:eq(2)').text(); 

		  var chargeTypeInp = tr.children('td:eq(4)').text(); 
		  
		  var rate = tr.children('td:eq(16)').text(); 

		  var carrierName = $("#carrierDownNameId").val();
	      var templateName = $("#templateNameLblDownId").val();

	      $("#recordInputId").val(id); 
	      $("#serielNumberInpId").val(serialnumber);
     	  $("#templateNameInpId").val(templateName);
     	 
     	  $("#carrierNameInpId").val(carrierName);
     	 var carrierSelectVal = $("#carrierDownNameId option:selected").text();
     	  $("#carrierNameMdlInpId").val(carrierSelectVal);
     	  $("#chargeTypeInpId").val(chargeTypeInp); 
     	 
     	  $("#originInpId").val(origin); 
     	  $("#destinationInpId").val(destination);
     	  $("#rateInputId").val(rate);
     	  
     	  
		  $('#preview_update_modal').modal('show');
		  
    }
    
  function loadPreviewRateDatatable(data){
	  var tableId = "previewRateSuccessTableId";
	  $(".preview_wrap").show();

	  $("#rateFilenameId").text(data.templatename);
	  
	  	var rateData = data.commonRateTemplateRespList;
	  	
		  	$('#'+tableId).dataTable().fnClearTable();
		  	
		  	var oTable = $('#'+tableId).DataTable({
		  		'responsive': true,
		  	 	"destroy" : true,
		  		"data" : rateData,     	
		       "dom": 'lBfrtip',

		  		"columns": 	[
		  			           {        
         	                          "data": null,
	                                    sortable: true,					    	          
	                                    render: function (data,type,row) {
			                            var serialnumber = data.serialnumber;

				                        return serialnumber;
				
			                         }
                                },
		  			            {        
		  			            	 "data": null,
					    	           sortable: true,					    	          
					    	           render: function (data,type,row) {
		               				   var origin = data.origin;

		               					return origin;
		               					
		               				}
		  			            },
		  						{				    	        	  
					      	           "data": null,
					      	           className: 'editable',
					    	           sortable: true,					    	          
					    	           render: function (data,type,row) {
		               				   var destination = data.destination;

		               					return destination;
		               					
		               				}
								},
		  						{
		  							      
									    "data": null,
	                        	        sortable: true,	
	                     				render: function (data,type,row) {
	                     					var carrier = data.carrierid;
	                     					return carrier;
	                     					
	                     				}	
		                        },
		  	    	            {          
		                        	     
		                        	       "data": null,
		                        	        sortable: true,	
		                     				render: function (data,type,row) {
		                     					 var chargesGrouping = data.chargesgroupingid;
		                     					return chargesGrouping;
		                     					
		                     				}
				    	                   
		  					    },			    	         
		                  		{
		  	                  		      
		  	                  		       "data": null,
		  	                  		        sortable: true,
		                				    render: function (data,type,row) {
		                    				    var chargesGroupingCode = data.chargesgroupingcode;
		                					    return chargesGroupingCode;
		                					
		                				    }
			    	                        
		  						},
		                  		{        
		  	                  		        "data": null,
		  	                  		         sortable: true,
		  	                  		         render: function (data,type,row) {
		  	  	                  		         var chargesType = data.chargetype;
		         					             return chargesType;
		         					
		         				             }
		  						},
		  						{          
		  							        "data": null,
		  							        sortable: true,
		  							        render: function (data,type,row) {		  							  		  							
		  							        	 var chargesTypeCode = data.chargetypecode;
		         					             return chargesTypeCode;
		              					
		              				        }
		                		            
							    },
		                  		{        
  	                  		        "data": null,
  	                  		         sortable: true,
  	                  		         render: function (data,type,row) {

  	                  		        	var cargoCategory = '';
  	  	                  		         if(data.cargocategory == null){
  	  	                  		             cargoCategory = "NA";
  	  	  	  	                  		 }else{
  	  	  	  	                         	 cargoCategory = data.cargocategory;
  	  	  	  	  	  	                 }
  	  	                  		        
         					             return cargoCategory;
         					
         				             }
  						        },
		                  		{        
  	                  		        "data": null,
  	                  		         sortable: true,
  	                  		         render: function (data,type,row) {
  	  	                  		         var validDateFrom = data.validdatefrom;
         					             return validDateFrom;
         					
         				             }
  						        },
		                  		{        
  	                  		        "data": null,
  	                  		         sortable: true,
  	                  		         render: function (data,type,row) {
  	  	                  		         var validDateTo = data.validdateto;
         					             return validDateTo;
         					
         				             }
  						        },
		                  		{        
  	                  		        "data": null,
  	                  		         sortable: true,
  	                  		         render: function (data,type,row) {
  	  	                  		         var routing = data.routing;
         					             return routing;
         					
         				             }
  						        },
		                  		{        
  	                  		        "data": null,
  	                  		         sortable: true,
  	                  		         render: function (data,type,row) {
  	  	                  		         var transitTime = data.transittime;
         					             return transitTime;
         					
         				             }
  						        },
		                  		{        
  	                  		        "data": null,
  	                  		         sortable: true,
  	                  		         render: function (data,type,row) {
  	  	                  		         var currency = data.currency;
         					             return currency;
         					
         				             }
  						        },
		                  		{        
  	                  		        "data": null,
  	                  		         sortable: true,
  	                  		         render: function (data,type,row) {
  	  	                  		         var basis = data.basis;
         					             return basis;
         					
         				             }
  						        },
		                  		{        
  	                  		        "data": null,
  	                  		         sortable: true,
  	                  		         render: function (data,type,row) {
  	  	                  		         var quantity = data.quantity;
         					             return quantity;
         					
         				             }
  						        },
		                  		{        
  	                  		        "data": null,
  	                  		         sortable: true,
  	                  		         render: function (data,type,row) {
  	  	                  		         var rate = data.rate;
         					             return rate;
         					
         				             }
  						        },
		                  		{        
  	                  		        "data": null,
  	                  		         sortable: true,
  	                  		         render: function (data,type,row) {
  	  	                  		         var id = data.id;
         					             return '<button type="submit" value="Submit" class="login_btn3 pull-right" onclick="getColumnValue(this,\''+id+'\');" >Edit</button>';
         					
         				             }
  						        }
		              			
		                  	]
		  						
		      		                  
		      		     });
  
  }

  function loadPreviewrateErrorDatatable(data){

	  var tableId = "previewRateErrorTableId";
	  $(".preview_wrap2").show();

	  	var rateData = data.commonRateTemplateRespErrorList;
	  	
		  	$('#'+tableId).dataTable().fnClearTable();
		  	
		  	var oTable = $('#'+tableId).DataTable({
		  		'responsive': true,
		  	 	"destroy" : true,
		  		"data" : rateData,     	
		       "dom": 'lBfrtip',

		  		"columns": 	[
		  			             {        
			            	           "data": null,
		    	                        sortable: true,					    	          
		    	                        render: function (data,type,row) {
          				                var serialnumber = data.serialnumber;

          					            return serialnumber;
          					
          				             }
			                     },
		  			            {        
		  			            	 "data": null,
					    	           sortable: true,					    	          
					    	           render: function (data,type,row) {
		               				   var origin = data.origin;

		               					return origin;
		               					
		               				}
		  			            },
		  						{				    	        	  
					      	           "data": null,
					    	           sortable: true,					    	          
					    	           render: function (data,type,row) {
		               				   var destination = data.destination;

		               					return destination;
		               					
		               				}
								},
		  						{
		  							      
									    "data": null,
	                        	        sortable: true,	
	                     				render: function (data,type,row) {
	                     					var carrier = data.carrierid;
	                     					return carrier;
	                     					
	                     				}	
		                        },
		  	    	            {          
		                        	     
		                        	       "data": null,
		                        	        sortable: true,	
		                     				render: function (data,type,row) {
		                     					 var chargesGrouping = data.chargesgroupingid;
		                     					return chargesGrouping;
		                     					
		                     				}
				    	                   
		  					    },			    	         
		                  		{
		  	                  		      
		  	                  		       "data": null,
		  	                  		        sortable: true,
		                				    render: function (data,type,row) {
		                    				    var chargesGroupingCode = data.chargesgroupingcode;
		                					    return chargesGroupingCode;
		                					
		                				    }
			    	                        
		  						},
		                  		{        
		  	                  		        "data": null,
		  	                  		         sortable: true,
		  	                  		         render: function (data,type,row) {
		  	  	                  		         var chargesType = data.chargetype;
		         					             return chargesType;
		         					
		         				             }
		  						},
		  						{          
		  							        "data": null,
		  							        sortable: true,
		  							        render: function (data,type,row) {		  							  		  							
		  							        	 var chargesTypeCode = data.chargetypecode;
		         					             return chargesTypeCode;
		              					
		              				        }
		                		            
							    },
		                  		{        
  	                  		        "data": null,
  	                  		         sortable: true,
  	                  		         render: function (data,type,row) {

  	                  		        	var cargoCategory = '';
  	  	                  		         if(data.cargocategory == null){
  	  	                  		             cargoCategory = "NA";
  	  	  	  	                  		 }else{
  	  	  	  	                         	 cargoCategory = data.cargocategory;
  	  	  	  	  	  	                 }
  	  	                  		        
         					             return cargoCategory;
         					
         				             }
  						        },
		                  		{        
  	                  		        "data": null,
  	                  		         sortable: true,
  	                  		         render: function (data,type,row) {
  	  	                  		         var validDateFrom = data.validdatefrom;
         					             return validDateFrom;
         					
         				             }
  						        },
		                  		{        
  	                  		        "data": null,
  	                  		         sortable: true,
  	                  		         render: function (data,type,row) {
  	  	                  		         var validDateTo = data.validdateto;
         					             return validDateTo;
         					
         				             }
  						        },
		                  		{        
  	                  		        "data": null,
  	                  		         sortable: true,
  	                  		         render: function (data,type,row) {
  	  	                  		         var routing = data.routing;
         					             return routing;
         					
         				             }
  						        },
		                  		{        
  	                  		        "data": null,
  	                  		         sortable: true,
  	                  		         render: function (data,type,row) {
  	  	                  		         var transitTime = data.transittime;
         					             return transitTime;
         					
         				             }
  						        },
		                  		{        
  	                  		        "data": null,
  	                  		         sortable: true,
  	                  		         render: function (data,type,row) {
  	  	                  		         var currency = data.currency;
         					             return currency;
         					
         				             }
  						        },
		                  		{        
  	                  		        "data": null,
  	                  		         sortable: true,
  	                  		         render: function (data,type,row) {
  	  	                  		         var basis = data.basis;
         					             return basis;
         					
         				             }
  						        },
		                  		{        
  	                  		        "data": null,
  	                  		         sortable: true,
  	                  		         render: function (data,type,row) {
  	  	                  		         var quantity = data.quantity;
         					             return quantity;
         					
         				             }
  						        },
		                  		{        
  	                  		        "data": null,
  	                  		         sortable: true,
  	                  		         render: function (data,type,row) {
  	  	                  		         var rate = data.rate;
         					             return rate;
         					
         				             }
  						        },
		                  		{        
  	                  		        "data": null,
  	                  		         sortable: true,
  	                  		         render: function (data,type,row) {
  	  	                  		          var id = data.id;
         					             return '<button type="submit" value="Submit" class="login_btn3 pull-right" onclick="getColumnValue(this,\''+id+'\');">Edit</button>';
         					
         				             }
  						        }
		              			
		                  	]
		  						
		      		                  
		      		     });
  }

  function getAllCarrier(){
		 
		$.ajax({
			
			   type: 'GET',  		     	
			   contentType: "application/json",
			   url : server_url+'utility/getCarriers',
			  // headers: authHeader,
			   data: null
			})
			.done(function(response) {
				try{
					
					var ddl = document.getElementById("carrierDropdownId");
	                var option = document.createElement("OPTION");
	                
					if(response != null && response.respData.length !=0){
				        $('#carrierDropdownId').empty();	             
	                    option.innerHTML = 'Choose Carrier';
					    option.value = '0';
					    ddl.options.add(option);	
											
						for( i=0 ; i< response.respData.length ; i++){
									  
						       var option = document.createElement("OPTION");
						       option.innerHTML = response.respData[i].carriername+" ("+response.respData[i].scaccode+")";
						       option.value = response.respData[i].id;
						       ddl.options.add(option);			
						} 
											  		   
					}else{
						$('#carrierDropdownId').empty();
						option.innerHTML = 'No Carriers available';
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

  function getAllChargeGrouping(){
		 
		$.ajax({
			
			   type: 'GET',  		     	
			   contentType: "application/json",
			   url : server_url+'utility/getChargeGrouping',			  
			   data: null
			})
			.done(function(response) {
				try{
					
					var ddl = document.getElementById("chargeTypeDropdownId");
	                var option = document.createElement("OPTION");
	                
					if(response != null && response.respData.length !=0){
				        $('#chargeTypeDropdownId').empty();	             
	                    option.innerHTML = 'Choose Charge Type';
					    option.value = '0';
					    ddl.options.add(option);	
											
						for( i=0 ; i< response.respData.length ; i++){
									  
						       var option = document.createElement("OPTION");
						       option.innerHTML = response.respData[i].chargesgrouping;
						       option.value = response.respData[i].id;
						       ddl.options.add(option);			
						} 
											  		   
					}else{
						$('#chargeTypeDropdownId').empty();
						option.innerHTML = 'No Charge Type available';
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

function getUploadRateHistoryData(){

	$.ajax({
			
		     type: 'GET', 
             url : server_url+'admin/getUploadRateHistory',	     
             enctype: 'multipart/form-data',
             headers: authHeader,
             processData: false,
             contentType: false,

             data : null,
    
             success : function(response) {

	         console.log(response)
	 	        	
	            if(response.respCode == 1){
		        
		            var tableId = "upload_rate_history";
		            loadUploadRateHistoryTable(response.respData,tableId);
		            		             	       
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

function downloadFile(carriershortname,filename){
	
	 var userId =  userInfo.id;


	 $.ajax({
			
		 type: 'GET', 
         url : server_url+'download/checkFileExists',	         
         enctype: 'multipart/form-data',
         headers: authHeader,
         processData: false,
         contentType: false,

         data : "userId="+ userId + "&carrierName=" + carriershortname +"&templateName="+filename,
     
         success : function(response) { 	        	
	          if(response.respCode == 1){		           
		            //successBlock("#success_block",response.respData.msg);  
		            var url = server_url+'download/downloadTemplate';
		       	    window.location.href = url+"?userId="+ userId + "&carrierName=" + carriershortname +"&templateName="+filename; 		             	       
		          }else{
		             errorBlock("#error_block",response.respData.msg)
                  }
         },
         error: function (error) {

            if( error.responseJSON != undefined){
  	       errorBlock("#error_block",error.responseJSON);
            }else{
  	       errorBlock("#error_block","Server Error! Please contact administrator");
            }         
          
           }
     })
	 
	
}

function deletePendingRecord(recordId){

	var userId =  userInfo.id;
	
	 $.ajax({
			
		 type: 'GET', 
         url : server_url+'admin/deleteRateRecord',	         
         enctype: 'multipart/form-data',
         headers: authHeader,
         processData: false,
         contentType: false,

         data : "userId="+ userId + "&recordId=" + recordId,
     
         success : function(response) { 	        	
	          if(response.respCode == 1){		           
		            successBlock("#success_block",response.respData.msg);  
		            getUploadRateHistoryData();             	       
		          }else{
		             errorBlock("#error_block",response.respData.msg)
                  }
         },
         error: function (error) {

            if( error.responseJSON != undefined){
  	       errorBlock("#error_block",error.responseJSON);
            }else{
  	       errorBlock("#error_block","Server Error! Please contact administrator");
            }         
          
           }
     })
}

function loadUploadRateHistoryTable(data,tableId){
	  	
		  	$('#'+tableId).dataTable().fnClearTable();
		  	
		  	var oTable = $('#'+tableId).DataTable({
		  		'responsive': true,
		  	 	"destroy" : true,
		  		"data" : data,     	
		       "dom": 'lBfrtip',

		  		"columns": 	[
		  			           {        
        	                          "data": null,
	                                    sortable: true,					    	          
	                                    render: function (data,type,row) {
			                            var serialnumber = data.serialnumber;

				                        return serialnumber;
				
			                         }
                               },
                               {        
     	                              "data": null,
	                                    sortable: true,					    	          
	                                    render: function (data,type,row) {
			                            var forwarder = data.forwarder;

				                        return forwarder;
				
			                         }
                                },
		  			            {        
		  			            	 "data": null,
					    	           sortable: true,					    	          
					    	           render: function (data,type,row) {
		               				   var carriername = data.carriername;

		               					return carriername;
		               					
		               				}
		  			            },
		  						{				    	        	  
					      	           "data": null,					      	       
					    	           sortable: true,					    	          
					    	           render: function (data,type,row) {
					    	        	 var filename = data.filename;
	                                     var carriershortname = data.carriershortname;
		               				   
		               					return '<a href="#" onclick="downloadFile(\''+carriershortname+'\',\''+filename+'\');">'+filename+' </a>';
		               					
		               				}
								},
		  						{
		  							      
									    "data": null,
	                        	        sortable: true,	
	                     				render: function (data,type,row) {
	                     					var chargetype = data.chargetype;
	                     					return chargetype;
	                     					
	                     				}	
		                        },
		                        {
	  							      
								        "data": null,
                        	            sortable: true,	
                     				    render: function (data,type,row) {
                     					   var shipmenttype = data.shipmenttype;
                     					   return shipmenttype;
                     					
                     				}	
	                            },
		  	    	            {          
		                        	     
		                        	       "data": null,
		                        	        sortable: true,	
		                     				render: function (data,type,row) {
		                     					 var uploadeddate = data.uploadeddate;
		                     					return uploadeddate;
		                     					
		                     				}
				    	                   
		  					    },			    	         
		                  		{
	  	                  		      
	  	                  		       "data": null,
	  	                  		        sortable: true,
	                				    render: function (data,type,row) {
	                    				    var status = data.status;
	                					    return status;
	                					
	                				    }
		    	                        
	  						    },			    	         
		                  		{
		  	                  		      
		  	                  		       "data": null,
		  	                  		        sortable: true,
		                				    render: function (data,type,row) {
		                    				    var recordscount = data.recordscount;
		                					    return recordscount;
		                					
		                				    }
			    	                        
		  						},
		  						{
	  	                  		      
	  	                  		       "data": null,
	  	                  		        sortable: true,
	  	                  		    className: 'text-center',
	                				    render: function (data,type,row) {
		                				    var id = data.id;
	                				    	 var filename = data.filename;
	                                         var carriershortname = data.carriershortname;
	                                         var status = data.status;

	                                         var disabledClass="";
	                                         if(status == "Uploaded"){
	                                        	 disabledClass='remRowDisabled';
			                                 }
				                             
	                					    return '<button type="submit" value="Submit" class="remRow '+disabledClass+'" onclick="deletePendingRecord(\''+id+'\');"><i class="fas fa-trash-alt"></i></button>';
	                					   
	                					
	                				    }
		    	                        
	  						}
		                  		
		              			
		                  	]
		  						
		      		                  
		      		     });
	
}
  </script>
</head>
<body>
<div class="container-fluid">
  <div class="bg_white_main mb-4 mt-4">
    <div class="row">
      <div class="col-md-3 mb-4">
        <h2 class="book_cargo_hd mt-3">Upload Rates</h2>
        <p class="upload_subline">Please fill the forms to upload your carrier rates</p>
        <div id="step1_wrap">
          <label class="form-label mt-3">Select Forwarder/CHA</label>
          <select class="form-control font14" id="forwChaDropdownId" >
           <!--  <option>Choose Forwarder/CHA</option>
            <option>1</option>
            <option>2</option> -->
          </select>
          <label class="form-label mt-3">Select Carrier</label>
          <select class="form-control font14" id="carrierDropdownId" >
            <!-- <option disabled=true>Maxicon</option> -->
          </select>
          
          <label class="form-label mt-3" >Select Charge Type</label>
          <select class="form-control font14" name="chargeTypeDropdown" id="chargeTypeDropdownId">
          </select>
          <label class="form-label mt-3">Select Shipment Type</label>
          <select class="form-control font14" id="shiptypeDropdownId" >
            <option value="0">Choose Shipment Type</option>
            <option value="FCL">FCL</option>
            <option value="LCL">LCL</option>
          </select>         
          <label class="form-label mt-3">Valid Date From</label>
          <input type="text" class="form-control font14" autocomplete="off" name ="validDateFrom" id="validDateFromId" required>
          <label class="form-label mt-3">Valid Date To</label>
          <input type="text" class="form-control font14" autocomplete="off" name ="validDateTo" id="validDateToId" required>
          <label class="form-label mt-3">Upload Carrier Rate File </label>
          <input type="file" class="form-control-file font14" name="carrierRateFile" id="carrierRateFileId" >
          <button type="submit" value="Submit" class="login_btn2 mt-4 mb-1" id="uploadDirTemplateBtnId"><span>Upload</span></button>
        </div>
        <div id="step2_wrap">
          <label class="form-label mt-3">Carrier Name</label>
          
          <!-- <input type="text" class="form-control font14" name="carrierDownName" id="carrierDownNameId"  readonly=""> -->
          <select class="form-control font14" name="carrierDownName" id="carrierDownNameId" >
            <!-- <option disabled=true>Maxicon</option> -->
          </select>
          <label class="form-label mt-3">Charge Type</label>
          <select class="form-control font14" name="chargeTypeDropStepTwo" id="chargeTypeDropStepTwoId" >
          </select>
          <label class="form-label mt-3">File Name</label>
          <input type="text" class="form-control font14" name="templateDownName" id="templateNameLblDownId"  readonly="">
          <div class="width50">
            <button type="submit" value="Download" class="login_btn2" id="downTemplateBtnId"><span>Download</span></button>
          </div>
          <div class="width50">
            <button type="button" value="Preview" id="previewBtn" class="login_btn2 pull-right mr-0">Preview</button>
          </div>
        </div>
      </div>
      <div class="col-md-1 mb-4">
        <div class="vertical_seperator"></div>
      </div>
      <div class="col-md-8 mb-4">
        <div id="">
          <h2 class="book_cargo_hd mt-4">Upload Rate History</h2>
          <p class="upload_subline mb-4">Below is the full list of Carrier rates</p>
          <!-- <div class="table-responsive"> --><!-- to remove unwanted scroll -->
        <div class="">
            <table class="table table-bordered" id="upload_rate_history">
              <thead class="thead-light">
                <tr>
                  <th class="sr_width">Sr. no.</th>
                  <th class="rcp_width">Forwarder/CHA</th>
                  <th>Carrier</th>
                  <th class="filnam_width">File Name</th>
                  <th class="chty_width">Charge Type</th>
                  <th class="rcp_width">Shipment Type</th>
                  <th class="upl_width">Upload Date & Time</th>
                  <th class="rcp_width">Upload Status</th>
                  <th class="rcp_width">Records Processed</th>
                  <th class="rcp_width">Action</th>
                </tr>
              </thead>
            </table>
          </div>
        </div>
      </div>
    </div>
    <div class="row">
      <div class="col-md-12">
        <div class="preview_wrap">
          <div class="width50">
            <h2 class="book_cargo_hd">Preview -
              <label id="rateFilenameId"></label>
            </h2>
          </div>
          <div class="width50"> </div>
          <div class="table-responsive">
            <table class="table table-responsive rate_popup_table" id="previewRateSuccessTableId">
              <thead>
                <tr>
                  <th>Id</th>
                  <th>Origin</th>
                  <th>Destination</th>
                  <th>Carrier</th>
                  <th>Charges Grouping</th>
                  <th>Charges Grouping Code</th>
                  <th>Charges Type</th>
                  <th>Charges Type Code</th>
                  <th>Cargo Category</th>
                  <th>Valid Date Form</th>
                  <th>Valid Date To</th>
                  <th>Routing</th>
                  <th>Transit Time</th>
                  <th>Currency</th>
                  <th>Basis</th>
                  <th>Quantity</th>
                  <th>Rate</th>
                  <th>Action</th>
                </tr>
              </thead>
            </table>
          </div>
          <button type="button" value="" class="login_btn2" id="uploadTemplateDataBtnId">Confirm</button>
        </div>
      </div>
      <div class="col-md-12">
        <div class="preview_wrap2 mt-4">
          <div class="width50">
            <h2 class="book_cargo_hd">Not Uploaded Records</h2>
          </div>
          <div class="table-responsive">
            <table class="table table-responsive rate_popup_table" id="previewRateErrorTableId">
              <thead>
                <tr>
                  <th>Id</th>
                  <th>Origin</th>
                  <th>Destination</th>
                  <th>Carrier</th>
                  <th>Charges Grouping</th>
                  <th>Charges Grouping Code</th>
                  <th>Charges Type</th>
                  <th>Charges Type Code</th>
                  <th>Cargo Category</th>
                  <th>Valid Date Form</th>
                  <th>Valid Date To</th>
                  <th>Routing</th>
                  <th>Transit Time</th>
                  <th>Currency</th>
                  <th>Basis</th>
                  <th>Quantity</th>
                  <th>Rate</th>
                  <th>Action</th>
                </tr>
              </thead>
            </table>
          </div>
        </div>
      </div>
    </div>
  </div>
</div>
<div id="preview_update_modal" class="modal fade" tabindex="-1" role="dialog" aria-labelledby="myLargeModalLabel" aria-hidden="true">
  <div class="modal-dialog modal-dialog-centered">
    <div class="modal-content">
      <div class="modal-header modal-header-spl">
        <h5 class="modal-title">Update Record</h5>
        <button type="button" class="close btn_close" data-dismiss="modal" aria-label="Close"> <span aria-hidden="true">&times;</span> </button>
      </div>
      <div class="modal-body">
        <form method="post" id="rate-update-modal-form" name="rate-update-modal-form" >
          <input type="hidden" id="recordInputId" name="recordId">
          
          <!-- <label class="form-label mt-4">Serial Number</label>
			      <input type="datetime" class="form-control font14" autocomplete="off" name ="serialNumber" id="serielNumberInpId" readonly required> -->
          <input type="hidden" id="serielNumberInpId" name="serialNumber">
          <input type="hidden" id="carrierNameInpId" name="carrierName">
          <label class="form-label mt-4">Carrier Name</label>
          <input type="datetime" class="form-control font14" autocomplete="off" name ="carrierNameMdlInpShow" id="carrierNameMdlInpId" readonly required>
          <label class="form-label mt-4">Charge Type</label>
          <input type="datetime" class="form-control font14" autocomplete="off" name ="chargeTypeInp" id="chargeTypeInpId" readonly required>
          <label class="form-label mt-4">File Name</label>
          <input type="datetime" class="form-control font14" autocomplete="off" name ="templateName" id="templateNameInpId" readonly required>
          <label class="form-label mt-4">Origin</label>
          <input type="datetime" class="form-control font14" autocomplete="off" name ="origin" id="originInpId" readonly required>
          <label class="form-label mt-4">Destination</label>
          <input type="datetime" class="form-control font14" autocomplete="off" name ="destination" id="destinationInpId" required>
          <label class="form-label mt-4">Rate</label>
          <input type="datetime" class="form-control font14" autocomplete="off" name ="rate" id="rateInputId" required>
          <input type="submit" class="btn btn-theme mt-4 mb-1" value="Update">
        </form>
      </div>
    </div>
  </div>
</div>
<script>
	
	$(document).ready( function () {
	    $('#upload_rate_history').DataTable();
		$('#preview_wrap').DataTable();
	} );
	</script> 
<!-- <script>
		$(document).ready(function() {
/*
			$("#uploadDirTemplateBtnId").click(function(){
				$("#step1_wrap").hide();
				$("#step2_wrap").show();
			});
			
			$("#previousStepBtn").click(function(){
				$("#step2_wrap").hide();
				$("#step1_wrap").show();
			});
			$("#previewBtn").click(function(){
				$(".preview_wrap").show();
				$(".preview_wrap2").show();
			});
			$("#convertBtnId").click(function(){
				$("#step2_wrap").hide();
				$("#step3_wrap").show();
			});
			$("#previousStepBtn2").click(function(){
				$("#step3_wrap").hide();
				$("#step2_wrap").show();
			});
			$("#previewModalBtn").click(function(){
				$('#preview_modal').modal('show')
			});

			*/
			
			/* $(function() {
				$( "#validDateFromId" ).datepicker({ 
					dateFormat: 'dd-M-yy',
					minDate: 0,
					beforeShow: function (textbox, instance) {
			            instance.dpDiv.css({
			                    marginTop: (-textbox.offsetHeight) + 'px',
			                    marginLeft: textbox.offsetWidth + 'px'
			            });
			          }
				});

				$( "#validDateToId" ).datepicker({ 
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
		}) */
	<!-- </script> -->
	<script type="text/javascript">
   $(function () {
	// Linked date and time picker 
		// start date date and time picker 
		$('#validDateFromId').datetimepicker({
	 	   format: 'DD-MMM-YYYY',
           minDate : moment()
	    });

		// End date date and time picker 
		$('#validDateToId').datetimepicker({
			format: 'DD-MMM-YYYY',
			useCurrent: false 
		});
		
		// start date picke on chagne event [select minimun date for end date datepicker]
		$("#validDateFromId").on("dp.change", function (e) {
			$('#validDateToId').data("DateTimePicker").minDate(e.date);
		});
		// Start date picke on chagne event [select maxmimum date for start date datepicker]
		$("#validDateToId").on("dp.change", function (e) {
			$('#validDateFromId').data("DateTimePicker").maxDate(e.date);
		});
   });

</script> 
<!--  Filter Datetimepicker --> 
</body>
</html>