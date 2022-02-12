<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Dashboard</title>
<link href="http://code.jquery.com/ui/1.10.2/themes/smoothness/jquery-ui.css" rel="stylesheet">
<link href="https://cdn.datatables.net/1.10.22/css/jquery.dataTables.min.css" type="text/css" rel="stylesheet">
<link rel="stylesheet" href="static/css/intlTelInput.css">
<script src="static/js/intlTelInput.js"></script>
<link rel="stylesheet" href="https://use.fontawesome.com/releases/v5.6.3/css/all.css">
<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/font-awesome/4.7.0/css/font-awesome.min.css">
<script src="https://cdn.jsdelivr.net/npm/popper.js@1.16.0/dist/umd/popper.min.js"></script> 
<link rel="stylesheet" href="static/css/bootstrap-datetimepicker.min.css">
<script src="static/js/bootstrap-datetimepicker.min.js"></script> 
<script src="http://cdn.datatables.net/1.10.1/js/jquery.dataTables.min.js"></script> 
<script src="https://cdn.datatables.net/responsive/1.0.7/js/dataTables.responsive.min.js"></script>
<script src="static/js/_service/forwarderDashboardFilter.js"></script>
<script src="static/js/_service/HomeService.js"></script>

<!--Datatable Export-->
<link rel="stylesheet" href="static/css/buttons.dataTables.css">
<script src="https://cdn.datatables.net/buttons/1.7.1/js/dataTables.buttons.min.js"></script> 
<script src="https://cdnjs.cloudflare.com/ajax/libs/jszip/3.1.3/jszip.min.js"></script><!-- excel-->
<script src="https://cdnjs.cloudflare.com/ajax/libs/pdfmake/0.1.53/pdfmake.min.js"></script> 
<script src="https://cdnjs.cloudflare.com/ajax/libs/pdfmake/0.1.53/vfs_fonts.js"></script> 
<script src="https://cdn.datatables.net/buttons/1.7.1/js/buttons.html5.min.js"></script>
<script src="https://cdn.datatables.net/buttons/1.7.1/js/buttons.print.min.js"></script> 
<!--Datatable Export-->
<script src="https://cdn.datatables.net/plug-ins/1.10.25/dataRender/ellipsis.js"></script> 
<style>
input.form-control {
    width: auto;
}
.widthSpl100 input.form-control {
    width: 40%;
}
select.form-control {
    width: auto;
}
#chrgTable table th:last-child {
    width: 150px;
}
#chrgTable a {
    cursor: pointer;
    display: contents;
    margin: 0 5px;
    min-width: 24px;
}
#chrgTable a.add {
    color: #27C46B;
}
#chrgTable a.edit {
    color: #FFC107;
}
#chrgTable a.delete {
    color: grey;
}
/* i {
    font-size: 16px;
} */
#chrgTable a.add i {
    font-size: 16px;
    margin-right: -1px;
    position: relative;
    top: 3px;
}
.form-control.error {
    border-color: #f50000;
}
#chrgTable .add {
    display: none;
}
@mixin modal-fullscreen() {
  padding: 0 !important; // override inline padding-right added from js
  
  .modal-dialog {
    width: 100%;
    height: 100%;
    margin: 0;
    padding: 0;
  }
  
  .modal-content {
    height: auto;
    min-height: 100%;
    border: 0 none;
    border-radius: 0;
    box-shadow: none;
  }
  
}

@media (max-width: 767px) {
  .modal-fullscreen-xs-down {
    @include modal-fullscreen();
  }
}

@media (max-width: 991px) {
  .modal-fullscreen-sm-down {
    @include modal-fullscreen();
  }
}

@media (max-width: 1199px) {
  .modal-fullscreen-md-down {
    @include modal-fullscreen();
  }
}

.modal-fullscreen {
  @include modal-fullscreen();
}
div.dataTables_wrapper {
        margin-bottom: 3em;
    }
 #update_charges  textarea {
    resize: none;
    height: 113px !important;
}
</style>
<script type="text/javascript">
$(document).ready(function() {
    $('table.display').DataTable();
} );



  var enqtable;
  var bktable;

  var minDate;
  var maxDate;

  var createdAt = [];
  var customerFilterArray = [];
  var originFilterArray = [];
  var destinationFilterArray = [];
  
  var monthNames = ["Jan", "Feb", "Mar", "Apr", "May", "Jun",
		 "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"];
	 
  const carriers = {};
  const incoterm = {};

  function shortDateFormat(d){
	   
	   var dateMomentObject = moment(d, "YYYY-MM-DD"); // 1st argument - string, 2nd argument - format
	   var t = dateMomentObject.toDate(); // convert moment.js object to Date object
	  // var t = new Date(d);
	   return t.getDate()+'-'+monthNames[t.getMonth()]+'-'+t.getFullYear();
		
  }

  $(function() {
	   activeNavigationClass();
	  // load counts for booking, enquiry
       var shipmentType = $('#shipmenttypefilter').val();	
       getForwarderEnquiryCountByStatus(userInfo.id,shipmentType);
	   getForwarderBookingCountByStatus(userInfo.id,shipmentType);
	
	   getForwarderEnquiryDetailsAllList(userInfo.id,shipmentType,"");

	   $('#shipmenttypefilter').on('change', function() {
		     var shipType = this.value;
		     getForwarderEnquiryCountByStatus(userInfo.id,shipType);
			 getForwarderBookingCountByStatus(userInfo.id,shipType);
			
			 getForwarderEnquiryDetailsAllList(userInfo.id,shipType,"");
	   });

	    getAllCarrier();
	    
		getAllChargeGrouping();
    	getAllChargesSubType();		            	
    	getIncotermList();
    	getAllChargeBasis(); 

	   enqtable = $('#Enquiry_table').dataTable();
	   bktable = $('#Booking_table').dataTable();
	   	  
	   $("#submit-schedule-data").submit(function(e) {
		          e.preventDefault();
			      $('#loader').show();	
			    	
			      var table = $('#scheduleTable').DataTable({
			    	    "bPaginate": false,
			    	    "searching": false,
			    	    "bLengthChange": false,
			    	    "bFilter": true,
			    	    "bInfo": false,
			    	    "bAutoWidth": false })
                  var enquiryReference = $('#schEnquiryReferenceId').val();
			      var enquiryId = $('#schForwEnquiryId').val();
			      var org = $('#orgScheduleUpdInputId').val();
			      var dest = $('#destScheduleUpdInputId').val();
			      var scheduleType = $('#scheduleType option:selected').val();
			      var legsCount = 0;
			      if(scheduleType == 'Direct'){
			    	  legsCount = 0;
				  }else{
					  legsCount = $('#legsId option:selected').val();
			      }
			      
			      var cutoffdate = $('#cutOffDateId').val();

			      var mainRequest = {};

			      mainRequest['enquiryreference'] = enquiryReference;
			      mainRequest['enquiryid'] = enquiryId;
			      mainRequest["origin"] = org;
			      mainRequest["destination"] = dest;
			      mainRequest["scheduletype"] = scheduleType;
			      mainRequest["legscount"] = legsCount;
			      mainRequest["cutoffdate"] = cutoffdate;

			      var fieldNames = [],
			        json = []

			      fieldNames.push("origin");
			      fieldNames.push("destination");
			      fieldNames.push("mode");
			      fieldNames.push("carrier");
			      fieldNames.push("vessel");
			      fieldNames.push("voyage");
			      fieldNames.push("etddate");
			      fieldNames.push("etadate");
			      fieldNames.push("transittime");


			      var rowCount = $('#scheduleTable tr').length;
			      for (var i = 1; i < rowCount; i++) {
			        var item = {}
			        for (var index = 0; index < 9; index++) {

			          switch (index) {
			            case 0:
			              var scheduleType = $('#scheduleType option:selected').val()
			              item[fieldNames[index]] = $('#origin' + i).val();
			              break;
			            case 1:
			              item[fieldNames[index]] = $('#destination' + i).val();
			              break;
			            case 2:
			              item[fieldNames[index]] = $('#mode' + i + ' option:selected').val();
			              break;
			            case 3:
			              var mode = $('#mode' + i + ' option:selected').val()
			              if (mode == "Sea") {
			                item[fieldNames[index]] = $('#carrierdrop' + i + ' option:selected').val();
			              } else {
			                item[fieldNames[index]] = $('#carrier' + i).val();
			              }
			              break;
			            case 4:
			              item[fieldNames[index]] = $('#vessel' + i).val();
			              break;
			            case 5:
			              item[fieldNames[index]] = $('#voyage' + i).val();
			              break;
			            case 6:
			              item[fieldNames[index]] = $('#etd' + i).val();
			              break;
			            case 7:
			              item[fieldNames[index]] = $('#eta' + i).val();
			              break;
			            case 8:
			              item[fieldNames[index]] = $('#transittime' + i).val();
			              break;

			          }


			        }
			        json.push(item)

			      }
			      mainRequest["addScheduleLegsRequest"] = json;
			      console.log(mainRequest)

			      $('#loader').hide();
			      submitScheduleData(mainRequest);

	   });

	   $("#submit-charges-data").submit(function(e) {
		          e.preventDefault();
			      $('#loader').show();	
			      var enquiryId = $('#chargeForwEnquiryId').val();
			      var enquiryReference = $('#chargeEnquiryReferenceId').val();

			      var org = $('#orgChargesUpdInputId').val();
			      var dest = $('#destChargesUpdInputId').val();
			      var validdatefrom = $('#chrgFrom').val();
			      var validdateto = $('#chrgTo').val();
			      var incoterm = $('#chrgIncotermId').val();
			      var remark = $('#remark').val();
			      //var weight = $('#weightId').val();
			      //var volume = $('#volumeId').val();

			      var mainRequest = {};

			      mainRequest['enquiryreference'] = enquiryReference;
			      mainRequest["enquiryid"] = enquiryId;
			      mainRequest["origin"] = org;
			      mainRequest["destination"] = dest;
			      mainRequest["validdatefrom"] = validdatefrom;
			      mainRequest["validdateto"] = validdateto;
			      mainRequest["incoterm"] = incoterm;
			      mainRequest["remark"] = remark;
			      //mainRequest["weight"] = weight;
			      //mainRequest["volume"] = volume;
				      
			      
			      var fieldNames = [],
			        json = [];

			      fieldNames.push("chargegrouping");
			      fieldNames.push("chargetype");			     
			      fieldNames.push("currency");
			      fieldNames.push("rate");
			      fieldNames.push("basis");
			      fieldNames.push("quantity");
			      fieldNames.push("freighttotalval");

			      var length = $('input[name^="rate"]').length;

			      for (var i = 0; i < length; i++) {
				      
			        var item = {};
			        var chargesGrouping = document.getElementsByName("chrgGro[]")[i].value;
			        var chargeType = document.getElementsByName("chrgTyp[]")[i].value;			        
			        var currency = document.getElementsByName("currency[]")[i].value;
			        var rate = document.getElementsByName("rate[]")[i].value;
			        var chrgBasis = document.getElementsByName("chrgBasis[]")[i].value;
			        var quantity = document.getElementsByName("quant[]")[i].value;
			        var freightTotalVal = document.getElementsByName("FTV[]")[i].value;
			        
			        for (var index = 0; index < 7; index++) {

			          switch (index) {
			            case 0:
			              item[fieldNames[index]] = chargesGrouping;
			              break;
			            case 1:
			              item[fieldNames[index]] = chargeType;
			              break;			            
			            case 2:
			              item[fieldNames[index]] = currency;
			              break;
			            case 3:
			              item[fieldNames[index]] = rate;
			              break;
			            case 4:
			              item[fieldNames[index]] = chrgBasis;
			              break;
			            case 5:
			              item[fieldNames[index]] = quantity;
			              break;
			            case 6:
			              item[fieldNames[index]] = freightTotalVal;
			              break;

			          }
			        }

			        json.push(item)
			      }

			      mainRequest["addChargesTypeRequest"] = json;
			      console.log(mainRequest);

			      $('#loader').hide();
			      submitChargeData(mainRequest);
			    	   
	   });
	  
  });

  function getChargeGroupingVal(sel){
		var chargeGpSelId = sel.id;  	
		var chargeGpArr = chargeGpSelId.split("_");
		var index = chargeGpArr[1];
		var chargeGroupingId = sel.value;
		var setIndex = 0;
	    getAllChargesSubType(index,chargeGroupingId,setIndex);
	    
	  }
  /*******Start Booking details functions *******/
	
	 function getForwarderBookingCountByStatus(userId,shipmentType){
	    $('#loader').show();
	  	$.ajax({
	  			
	  		     type: 'GET', 
	               url : server_url+'forwarder/getForwarderBookingCountByStatus',	     
	               enctype: 'multipart/form-data',
	               headers: authHeader,
	               processData: false,
	               contentType: false,

	               data: "userId=" + userId + "&shipmentType=" + shipmentType,
	      
	               success : function(response) {

	  	           console.log(response)
	  	 	        	
	  	            if(response.respCode == 1){  		            

	  	            	$("#bkRequestCount").text(response.respData.requestCount);
	  	            	$("#bkAcceptedCount").text(response.respData.acceptedCount);
	  	            	$("#bkCancelledCount").text(response.respData.cancelledCount);
	  	            	$("#bkRejectedCount").text(response.respData.rejectedCount);
	  	            	 	            		             	       
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

	 function getForwarderBookingDetailsListByStatus(bookingStatus){
		 var shipmentType = $('#shipmenttypefilter').val();
		  getForwarderBookingDetailsAllList(userInfo.id,shipmentType,bookingStatus);
	 }

	 function getForwarderBookingDetailsAllList(userId,shipmentType,bookingStatus){

			$("#enquiryTableContId").hide();
			$("#bookingTableContId").show();
			
			$('#loader').show();
			var tableId = "Booking_table";  

		  	$.ajax({
		  			
		  		     type: 'GET', 
		               url : server_url+'forwarder/getForwarderBookingList',	     
		               enctype: 'multipart/form-data',
		               headers: authHeader,
		               processData: false,
		               contentType: false,
		               "scrollX": true,
		               "autoWidth": true,

		               data : "userId="+userId+"&shipmentType="+shipmentType+"&bookingStatus="+bookingStatus,
		      
		               success : function(response) {

		  	           console.log(response)
		  	 	        	
		  	            if(response.respCode == 1){  		    
			  	                    
		  		          loadForwarderBookingListTable(response.respData,tableId); 	
		  		          generateFilterDataArrayListFromBooking(response.respData); 
		  		          prepareCustomerFilter(customerFilterArray);   	  
		  		          prepareOriginFilter(originFilterArray);
		  		          prepareDestinationFilter(destinationFilterArray);      
		  		              		             	       
		  	            }else{
		  		            errorBlock("#error_block",response.respData)
		  		            loadForwarderBookingListTable(null,tableId);
		                  }
		  	            $('#loader').hide();
		               },
		               error: function (error) {
		  	                console.log(error)
		                      if( error.responseJSON != undefined){
		                    	  loadForwarderBookingListTable(null,tableId);
		   	                   errorBlock("#error_block",error.responseJSON.respData);
		                      }else{
		                    	  loadForwarderBookingListTable(null,tableId);
		   	                   errorBlock("#error_block","Server Error! Please contact administrator");
		                      }         
		  	                $('#loader').hide();
		               }
		      })
		  }

	 function updateBookingStatus(id,status){

		 swal({
	          //title: "Are you sure, please confirm?",
	          text: "Are you sure, please confirm?",
	          buttons: [
	            'Cancel',
	            'Ok'
	          ],
	        }).then(function(isConfirm) {
	          if (isConfirm) {
	        	  $('#loader').show();
	        	  var userId =  userInfo.id;
					$.ajax({
						
					     type: 'GET', 
			            url : server_url+'forwarder/updateBookingStatus',	     
			            enctype: 'multipart/form-data',
			            headers: authHeader,
			            processData: false,
			            contentType: false,
			            "scrollX": true,
			            "autoWidth": true,

			            data : "id="+id+"&userId="+ userId+"&bookingStatus="+status,
			   
			            success : function(response) {

				           console.log(response)
				 	        	
				            if(response.respCode == 1){  		            
				            	$('#loader').hide();
					           successBlock("#success_block",response.respData.msg);
					           var shipmentType = $('#shipmenttypefilter').val();
					           getForwarderBookingDetailsAllList(userInfo.id,shipmentType,status);
					           getForwarderBookingCountByStatus(userInfo.id,shipmentType);
					    	   getForwarderEnquiryCountByStatus(userInfo.id,shipmentType);
				  		          	            		             	       
				            }else{
					            errorBlock("#error_block",response.respData);
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
	        });
		 
	}


	 function updateEnquiryStatus(id,status){

		 swal({
	          text: "Are you sure, please confirm?",
	          buttons: [
	            'Cancel',
	            'Ok'
	          ],
	        }).then(function(isConfirm) {
	          if (isConfirm) {
	        	  $('#loader').show();
	        	  var userId =  userInfo.id;
					$.ajax({
						
					     type: 'GET', 
			            url : server_url+'forwarder/updateEnquiryStatus',	     
			            enctype: 'multipart/form-data',
			            headers: authHeader,
			            processData: false,
			            contentType: false,
			               "autoWidth": true,
			            "scrollX": true,
			            data : "id="+id+"&userId="+ userId+"&enquiryStatus="+status,
			   
			            success : function(response) {
				           console.log(response)
				 	        	
				            if(response.respCode == 1){  		            
				            	$('#loader').hide();
					           successBlock("#success_block",response.respData.msg);
					           var shipmentType = $('#shipmenttypefilter').val();
					           getForwarderEnquiryDetailsAllList(userInfo.id,shipmentType,status);
					           getForwarderBookingCountByStatus(userInfo.id,shipmentType);
					    	   getForwarderEnquiryCountByStatus(userInfo.id,shipmentType);
	          	            		             	       
				            }else{
					            errorBlock("#error_block",response.respData);
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
	        });
	        
	}
	 //onclick function for get booking details after click on booking reff
	 function getForwarderBookingDetailsById(bookingreff){
		 getForwarderBookingDetailsByBookingReff(bookingreff);
     }

	 function getForwarderBookingDetailsByBookingReff(bookingReff){
			$('#loader').show();
		  	$.ajax({		  			
		  		     type: 'GET', 
		               url : server_url+'forwarder/getForwarderBookingDetailsById?bookingReff='+bookingReff,	     
		               enctype: 'multipart/form-data',
		               headers: authHeader,
		               processData: false,
		               contentType: false,
		               "scrollX": true,
		               "autoWidth": true,

		               data : null,
		      
		               success : function(response) {

		  	           console.log(response)
		  	           $('#loader').hide();
		  	 	        	
		  	            if(response.respCode == 1){  		            

		  	            	//booking reff
		  	            	$("#bkBookingReffLbl").text(response.respData.bookingreff);
		  	            	
		  	            	$("#bkBookByLbl").text(response.respData.bookedby);
		  	            	$("#bkCargoReadyDateLbl").text(response.respData.cargoreadydate);
		  	            	$("#bkDateOfBookingLbl").text(response.respData.dateofbooking);
		  	            	$("#bkBookingStatusLbl").text(response.respData.bookingstatus);

		  	                //booking party
		  	            	$("#bkBookingPartyLbl").text(response.respData.bookingparty);

		  	                //schedule details
		  	            	$("#bkBookingDateLbl").text(response.respData.bookingdate);
	  	            	    $("#bkOriginLbl").text(response.respData.origin);
	  	            	    $("#bkDestinationLbl").text(response.respData.destination);
	  	            	    $("#bkCutOffDateLbl").text(response.respData.cutoffdate);
	  	            	    $("#bkIncotermLbl").text(response.respData.incoterm);
	  	            	    
	  	            	    $('#tbodyBookingDetailsPopUpId').empty();
		  	            	$('#tbodyBookingChargesPopUpId').empty();
	  	            	    
	  	            	  var tRows = '';
	  	            	  if(response.respData.scheduleLegsResponse != null){
		  	            	 
		  	            	for(var i = 0 ;i<response.respData.scheduleLegsResponse.length ;i++){
			  	            	var org = response.respData.scheduleLegsResponse[i].origin;
			  	            	var dest = response.respData.scheduleLegsResponse[i].destination;
			  	            	var mode = response.respData.scheduleLegsResponse[i].mode;
			  	            	var carrier = response.respData.scheduleLegsResponse[i].carrier;
			  	            	var vessel = response.respData.scheduleLegsResponse[i].vessel;
			  	            	var voyage = response.respData.scheduleLegsResponse[i].voyage;
			  	            	var etddate = response.respData.scheduleLegsResponse[i].etddate;
				  	            var etadate = response.respData.scheduleLegsResponse[i].etadate;
					  	        var transittime = response.respData.scheduleLegsResponse[i].transittime;

			  	            	var daysLable = ""
				  	            if(transittime > 1){
				  	            	daysLable = "Days";
					  	         }else{
					  	        	daysLable = "Day";
						  	     }

			  	            	transittime = transittime+" "+daysLable;
						  	     
		  	            		tRows = tRows + '<tr><td>'+org+'</td><td>'+dest+'</td><td>'+mode+'</td><td>'+carrier+'</td><td class="capitalize">'+vessel+'</td><td class="capitalize">'+voyage+'</td><td>'+transittime+'</td><td>'+etddate+'</td><td>'+etadate+'</td></tr>';		  	            	
			  	            }
	  	            	 }
		  	            	$('#tbodyBookingDetailsPopUpId').append(tRows);

		  	            	var tRowsCharges = '';
		  	            	 var json = [];
		                     var totalCharges = [];
		  	            	if(response.respData.chargesRateResponseList != null){
		  	            	    for(var i = 0 ;i<response.respData.chargesRateResponseList.length ;i++){
			  	            	    var chargesgrouping = response.respData.chargesRateResponseList[i].chargesgrouping;
			  	            	    var chargestype = response.respData.chargesRateResponseList[i].chargestype;
			  	            	    var currency = response.respData.chargesRateResponseList[i].currency;
			  	            	    var rate = response.respData.chargesRateResponseList[i].rate;
			  	            	    var basis = response.respData.chargesRateResponseList[i].basis;
			  	            	    var quantity = response.respData.chargesRateResponseList[i].quantity;
			  	            	    var totalAmount = rate * quantity;

			  	            	    var totalChargesUsd = 0;
		                            var totalChargesInr = 0;
			  	            	    if(currency == "USD"){
				  	            	    totalChargesUsd =  totalAmount;
					  	            }else if(currency == "INR"){
					  	            	totalChargesInr =  totalAmount;
						  	        }	

			  	            	    if (json.some(e => e.ChargeGroup == chargesgrouping)) {
				  	            		totalCharges = json.map(item => {
						                    if (item.ChargeGroup == chargesgrouping) {
						                      	 return {
						                      	    ...item,
						                         USD:  item.USD + totalChargesUsd,
						                     	 INR:  item.INR + totalChargesInr
						                      	};
						                     }
						                     return item;
						               });
				  	            		json = totalCharges;
				  	            	}else{
				  	            		/* vendors contains the element we're looking for */
					  	            	    var itemObject = {};
					  	            	    itemObject["ChargeGroup"] = chargesgrouping;
					  	            	    itemObject["USD"] = totalChargesUsd;
					  	            	    itemObject["INR"] = totalChargesInr;
					  	            	    json.push(itemObject);						  	            	    	  	            	    		  	            	    
					  	            }	
									 			  	            	
			  	            	    totalAmount = parseFloat(totalAmount.toFixed(2));
			  	            	     	
					  	            tRowsCharges = tRowsCharges + '<tr><td>'+chargesgrouping+'</td>'+
					  	            '<td>'+chargestype+'</td>'+
					  	            '<td>'+currency+'</td>'+
					  	            '<td style="text-align: right;">'+rate+'</td>'+
					  	            '<td>'+basis+'</td>'+
					  	            '<td>'+quantity+'</td>'+
					  	            '<td style="text-align: right;">'+totalAmount.toFixed(2)+'</td></tr>';		  	            	
			  	                }
		  	            	} 
		  	            	$('#tbodyBookingChargesPopUpId').append(tRowsCharges);

		  	            	var chargeSummary = '';
						    if(json != null){
							    var totalUsd = 0;
							    var totalInr = 0;
				            	for(var i=0; i< json.length ; i++){
	                                var chargesGrouping = json[i].ChargeGroup;
	                                var usdAmount = json[i].USD;
	                                var inrAmount = json[i].INR;
	                                totalUsd = totalUsd + usdAmount;
	                                totalInr = totalInr + inrAmount;
	                                chargeSummary = chargeSummary + '<tr><td class="text-center">'+chargesGrouping+'</td>'
	                                                              + '<td class="text-center">'+usdAmount.toFixed(2)+'</td>'
	                                                              + '<td class="text-center">'+inrAmount.toFixed(2)+'</td></tr>';
					            }
				            	chargeSummary = chargeSummary + '<tr><td class="text-center"><b>Total Amount</b></td>'
	                            + '<td class="text-center"><b>'+totalUsd.toFixed(2)+'</b></td>'
	                            + '<td class="text-center"><b>'+totalInr.toFixed(2)+'</b></td></tr>';
				            }
						    $('#tbodyBkSummaryChargesPopUpId').empty();
						    $('#tbodyBkSummaryChargesPopUpId').append(chargeSummary);
		  	            		
		  	            	$("#bkDestReqInfoLbl").text(response.respData.origincode+" "+response.respData.destinationcode);
		  	            	
	    				    $("#forwarder_booking_details").modal('show'); 	
	    				             		             	       
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
	 
	 function loadForwarderBookingListTable(data,tableId){
		  	
		  	$('#'+tableId).dataTable().fnClearTable();
		  	
		  	var oTable = $('#'+tableId).DataTable({
		  	 	"destroy" : true,
		  		"data" : data,     	
		       "dom": 'lBfrtip',
		       "lengthChange": true,
		       "buttons": [{
		           extend: 'pdfHtml5',
		           filename: 'forwader_booking_data_pdf',
		           title: "",
		           text: '<i class="fas fa-file-pdf"></i>',
		           exportOptions: {
		             columns: [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10]
		           },
		           customize: function (doc) {
		          	 doc.defaultStyle.alignment = 'left';
		          	  doc.styles.tableHeader.alignment = 'left';
		            doc.content.splice(1, 0, {
		              margin: [1, 1, 7, 1],
		              alignment: 'left',
		              image: 'data:image/png;base64,/9j/4QAYRXhpZgAASUkqAAgAAAAAAAAAAAAAAP/sABFEdWNreQABAAQAAAA8AAD/4QMtaHR0cDovL25zLmFkb2JlLmNvbS94YXAvMS4wLwA8P3hwYWNrZXQgYmVnaW49Iu+7vyIgaWQ9Ilc1TTBNcENlaGlIenJlU3pOVGN6a2M5ZCI/PiA8eDp4bXBtZXRhIHhtbG5zOng9ImFkb2JlOm5zOm1ldGEvIiB4OnhtcHRrPSJBZG9iZSBYTVAgQ29yZSA3LjAtYzAwMCA3OS5kYWJhY2JiLCAyMDIxLzA0LzE0LTAwOjM5OjQ0ICAgICAgICAiPiA8cmRmOlJERiB4bWxuczpyZGY9Imh0dHA6Ly93d3cudzMub3JnLzE5OTkvMDIvMjItcmRmLXN5bnRheC1ucyMiPiA8cmRmOkRlc2NyaXB0aW9uIHJkZjphYm91dD0iIiB4bWxuczp4bXA9Imh0dHA6Ly9ucy5hZG9iZS5jb20veGFwLzEuMC8iIHhtbG5zOnhtcE1NPSJodHRwOi8vbnMuYWRvYmUuY29tL3hhcC8xLjAvbW0vIiB4bWxuczpzdFJlZj0iaHR0cDovL25zLmFkb2JlLmNvbS94YXAvMS4wL3NUeXBlL1Jlc291cmNlUmVmIyIgeG1wOkNyZWF0b3JUb29sPSJBZG9iZSBQaG90b3Nob3AgMjIuNCAoV2luZG93cykiIHhtcE1NOkluc3RhbmNlSUQ9InhtcC5paWQ6RERGRkJCOEFGNjg3MTFFQjg5NDE4NjM4MjhGODZFODAiIHhtcE1NOkRvY3VtZW50SUQ9InhtcC5kaWQ6RERGRkJCOEJGNjg3MTFFQjg5NDE4NjM4MjhGODZFODAiPiA8eG1wTU06RGVyaXZlZEZyb20gc3RSZWY6aW5zdGFuY2VJRD0ieG1wLmlpZDpEREZGQkI4OEY2ODcxMUVCODk0MTg2MzgyOEY4NkU4MCIgc3RSZWY6ZG9jdW1lbnRJRD0ieG1wLmRpZDpEREZGQkI4OUY2ODcxMUVCODk0MTg2MzgyOEY4NkU4MCIvPiA8L3JkZjpEZXNjcmlwdGlvbj4gPC9yZGY6UkRGPiA8L3g6eG1wbWV0YT4gPD94cGFja2V0IGVuZD0iciI/Pv/uAA5BZG9iZQBkwAAAAAH/2wCEAAYEBAQFBAYFBQYJBgUGCQsI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'
		            });
		           },
		           title: " ",
		           orientation: 'landscape',
		           pageSize: 'LEGAL'
		           /* messageTop: "User Enquiry Data" */
		         },
		         {
		           extend: 'excel',
		           filename: 'forwader_booking_data_xsl',
		           title: "",
		           className: 'excel',
		           text: '<i class="fas fa-file-excel"></i>',
		           exportOptions: {
		             columns: [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10]
		           }
		           /* messageTop: "User Enquiry Data" */
		         },
		       ],
		       /* "scrollX": true,
		        "autoWidth": true, */
		       "columnDefs": [
		         /* origin */
		         {
		           "targets": 0,
		           "className": "dt-body-left",
		           "width": "10%",
		         },
		         /* destination */
		         {
		           "targets": 1,
		           "className": "dt-body-left",
		           "width": "10%",
		         },
		         /* imp exp */
		         {
		           "targets": 2,
		           "className": "dt-body-left",
		           "width": "15%",
		         },
		         /* book date */
		         {
		           "targets": 3,
		           "className": "dt-body-center",
		           "width": "8%",
		         },
		         /* ref */
		         {
		           "targets": 4,
		           "className": "dt-body-center",
		           "width": "10%",
		         },
		         /* cut date */
		         {
		           "targets": 5,
		           "className": "dt-body-center",
		           "width": "8%",
		         },
		         /* status */
		         {
		           "targets": 6,
		           "className": "dt-body-center",
		           "width": "8%",
		         },
		         /*action*/
		         {
		           "targets": 7,
		           "className": "text-center",
		           "width": "10%",
		         }
		       ], 
		  		"columns": 	[
		  			           
		  			            {        
		  			            	 "data": null,
					    	           sortable: true,					    	          
					    	           render: function (data,type,row) {
		               				   var originwithcode = data.originwithcode;

		               					return originwithcode;
		               					
		               				}
		  			            },
		  						{				    	        	  
					      	           "data": null,					      	       
					    	           sortable: true,					    	          
					    	           render: function (data,type,row) {
		               				   var destinationwithcode = data.destinationwithcode;

		               					return destinationwithcode;
		               					
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
		                     					 var bookingdate = data.bookingdate.split(" ");
		                     					return bookingdate[0];
		                     					
		                     				}
				    	                   
		  					    },
		  					    {
	  							      
								    "data": null,
                      	             sortable: true,	
                   				     render: function (data,type,row) {
                       			    	var id = data.id;
                   					    var bookingreff = data.bookingreff;
                   					    return '<u><a href="#" onclick="getForwarderBookingDetailsById(\''+bookingreff+'\');" class="book_link">'+bookingreff+'</a></u>';
                   					
                   				      }	
	                            },		  					    		  					    
							    {
		                  		      
		                  		       "data": null,
		                  		        sortable: true,
	              				    render: function (data,type,row) {
	                  				    var cutoffdate = data.cutoffdate;
		              					   return cutoffdate;
	              					
	              				    }
		    	                        
							    },	
							    {
		                  		      
		                  		       "data": null,
		                  		        sortable: true,
	           				          render: function (data,type,row) {
	               				            var status = data.bookingstatus;	    
	           					            return status;
	           					
	           				         }
		    	                        
							    },					  
							    {
		                  		      
		                  		       "data": null,
		                  		        sortable: true,
	              				    render: function (data,type,row) {
	                  				    var id = data.id;
	                  				    var status = data.bookingstatus;
		
		                    			var submitDisClass = '';	                    			
	              				    	var cancelDisClass = '';
		                    			var rejectDisClass = '';
		                    			var cancelDisClass = '';
		                    			var deleteDisClass = ''; 
                    			                    			
		                    			if(status == 'Requested'){	
		                    				submitDisClass = '';		                    				
		                    				cancelDisClass = '';
		                    				rejectDisClass = '';	
		                    				cancelDisClass = 'disabled'; 
		                    				deleteDisClass = 'disabled';             			                  				
	       			                    }
		                    		    if(status == 'Accepted'){		                    		    
		                    				submitDisClass = 'disabled';		                    				
		                    		    	cancelDisClass = 'disabled';
		                    		    	rejectDisClass = 'disabled';	
		                    		    	cancelDisClass = 'disabled';  
		                    		    	deleteDisClass = 'disabled';                    					                    				
				                        }  			                        
		                    		    if(status == 'Cancelled'){		                    		    	
		                    				submitDisClass = 'disabled';		                    					                    			
		                    		    	cancelDisClass = 'disabled';
		                    		    	rejectDisClass = 'disabled';	
		                    		    	cancelDisClass = 'disabled'; 	
		                    		    	deleteDisClass = '';                     		                     					                    				
				                        }    
		                    		    if(status == 'Rejected'){		                    		    	
		                  				    submitDisClass = 'disabled';		                  				    	                    		    	
		                    		    	cancelDisClass = 'disabled';
		                    		    	rejectDisClass = 'disabled';	
		                    		    	cancelDisClass = 'disabled';    
		                    		    	deleteDisClass = ''; 		                    				                    				
				                        }
	                  				  
	                  				    var pending = "Pending";
	                  				    var accept = "Accepted";	                  				    
	                                    var cancel = "Cancelled";
	                                    var reject = "Rejected";
	                                  

	                  				    return '<button title="Accept" type="button" value="A" onclick="updateBookingStatus(\'' + id + '\',\'' + accept + '\');"class="green_sub actbtn '+submitDisClass+'" '+submitDisClass+'><i class="fas fa-check-circle"></i></button>'+  
	                  				    '<button title="Cancel" type="button"  value="C"  onclick="updateBookingStatus(\'' + id + '\',\'' + cancel + '\');" class="can_btn actbtn '+cancelDisClass+'" '+cancelDisClass+'><i class="fas fa-times"></i></button>'+
	                  		            '<button title="Reject" type="button"  value="R" onclick="updateBookingStatus(\'' + id + '\',\'' + reject + '\');" class="rej_btn actbtn '+rejectDisClass+'" '+rejectDisClass+'><i class="fas fa-times-circle"></i></button>'+
	                  		            '<button type="button" class="del_btn '+deleteDisClass+'" onclick="deleteForwarderBookingById(\''+id+'\');" '+deleteDisClass+'><i class="fas fa-trash actbtn"></i></button>';
	                  		            	              									       	              					 	            					   
	              				    }
		    	                        
							    }
		                  		
		              			
		                  	],
		                  	"order": [[ 3, "desc" ]],		  								      		                  
		      		     });

	}  

	 function deleteForwarderBookingById(id){
		 swal({
	         text: "Are you sure, please confirm?",
	         buttons: [
	           'Cancel',
	           'Ok'
	         ],
	       }).then(function(isConfirm) {
	         if (isConfirm) {
	       	  $('#loader').show();
	       	  var userId =  userInfo.id;  
	         
					$.ajax({
						
					     type: 'DELETE', 
			            url : server_url+'forwarder/deleteForwarderBookingById/'+id+"/"+userId,	     
			            enctype: 'multipart/form-data',
			            headers: authHeader,
			            processData: false,
			            contentType: false,
			               "autoWidth": true,
			            "scrollX": true,
			            data :  null,
			   
			            success : function(response) {
				           console.log(response)
				 	        	
				            if(response.respCode == 1){  		            
				            	$('#loader').hide();
					           successBlock("#success_block",response.respData.msg);
					           var shipmentType = $('#shipmenttypefilter').val();
					           getForwarderBookingDetailsAllList(userInfo.id,shipmentType,"");
					           getForwarderBookingCountByStatus(userInfo.id,shipmentType);
					    	   getForwarderEnquiryCountByStatus(userInfo.id,shipmentType);
	         	            		             	       
				            }else{
					            errorBlock("#error_block",response.respData);
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
	       });
	 }	
	  /*******End Booking details functions *******/
	  
	/******Start Enquiry details functions ******/
	
	function getForwarderEnquiryCountByStatus(userId,shipmentType){
	    $('#loader').show();
	  	$.ajax({
	  			
	  		     type: 'GET', 
	               url : server_url+'forwarder/getForwarderEnquiryCountByStatus',	     
	               enctype: 'multipart/form-data',
	               headers: authHeader,
	               processData: false,
	               contentType: false,
	               "scrollX": true,
	               "autoWidth": true,

	               data: "userId=" + userId + "&shipmentType=" + shipmentType,
	      
	               success : function(response) {

	  	           console.log(response)
	  	 	        	
	  	            if(response.respCode == 1){  		            

	  	            	$("#eqRequestCount").text(response.respData.requestCount);
	  	            	$("#eqAcceptedCount").text(response.respData.acceptedCount);
	  	            	$("#eqCancelledCount").text(response.respData.cancelledCount);
	  	            	$("#eqRejectedCount").text(response.respData.rejectedCount);
	  	            	 	            		             	       
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
	  	              $('#loader').show();
	               }
	      })
	  }  

	function getForwarderEnquiryDetailsListByStatus(enquiryStatus){
		var shipmentType = $('#shipmenttypefilter').val();
		getForwarderEnquiryDetailsAllList(userInfo.id,shipmentType,enquiryStatus);
	}

	function getForwarderEnquiryDetailsAllList(userId,shipmentType,enquiryStatus){

		$("#bookingTableContId").hide();
		$("#enquiryTableContId").show();

		$('#loader').show();
		
		var tableId = "Enquiry_table";  

	  	$.ajax({
	  			
	  		     type: 'GET', 
	               url : server_url+'forwarder/getForwarderEnquiryList',	     
	               enctype: 'multipart/form-data',
	               headers: authHeader,
	               processData: false,
	               contentType: false,
	               "autoWidth": true,

	               data : "userId="+userId+"&shipmentType="+shipmentType+"&enquiryStatus="+enquiryStatus,
	     	      
	               success : function(response) {

	  	           console.log(response)
	  	 	        	
	  	            if(response.respCode == 1){  
		  	            		            
	  	            	loadForwarderEnquiryListTable(response.respData,tableId);
	  	            	generateFilterDataArrayListFromEnquiry(response.respData);  
	  	            	prepareCustomerFilter(customerFilterArray); 	
	  	            	prepareOriginFilter(originFilterArray);
		  		        prepareDestinationFilter(destinationFilterArray);      
		  		              		             	       
	  	            }else{
	  		            errorBlock("#error_block",response.respData)
	  		            loadForwarderEnquiryListTable(null,tableId);
	                  }
	  	             $('#loader').hide();
	               },
	               error: function (error) {
	  	                console.log(error)
	                      if( error.responseJSON != undefined){
	                    	  loadForwarderEnquiryListTable(null,tableId);
	   	                   errorBlock("#error_block",error.responseJSON.respData);
	                      }else{
	                    	  loadForwarderEnquiryListTable(null,tableId);
	   	                   errorBlock("#error_block","Server Error! Please contact administrator");
	                      }         
	  	               $('#loader').hide();
	               }
	      })
	  }

	function updateEnquirySchedule(id,enquiryreference){
	   $('#loader').show();	
       $.ajax({
 			
		     type: 'GET', 
             url : server_url+'forwarder/getForwarderEnquiryScheduleById',	     
             enctype: 'multipart/form-data',
             headers: authHeader,
             processData: false,
             contentType: false,
             "autoWidth": true,

             data : "id="+id,
   	      
             success : function(response) {
            	 $('#loader').hide();
	           console.log(response)
	 	        var ddl = document.getElementById("carrierdrop1");
	            var option = document.createElement("OPTION");
	            
	            if(response.respCode == 1){  	
	            	 /* $('#submit-schedule-data').trigger("reset"); */
	            	/*****Start Reset modal value *****/
	            	
	            	 $("#legsDivId").hide();	            	
	            	 $('#legsId').prop('selectedIndex',0);
	            	 $("#legsId").prop("disabled", true);
	            	 $('#scheduleType').prop('selectedIndex',0);
	            	 $('#cutOffDateId').val('');
	            	 $("#vessel1").val('');
	            	 $("#voyage1").val('');
	            	 $("#etd1").val('');
	            	 $("#eta1").val('');
	            	 $("#transittime1").val('');
	            	 
	            	 /*****End Reset modal value *****/
	            	 
	            	 $("#schForwEnquiryId").val(id);	
	            	 $("#schEnquiryReferenceId").val(enquiryreference);
	            	 $("#orgScheduleUpdInputId").val(response.respData.origin);
	            	 $("#destScheduleUpdInputId").val(response.respData.destination);

	            	 $("#origin1").val(response.respData.origin);
	            	 $("#destination1").val(response.respData.destination);
	            	 
		            // $("#shipmentTypeVId").val(response.respData.shipmenttype);	            	 
	            	 $('#cutOffDateId').data("DateTimePicker").minDate(response.respData.cargoreadydate);

	            	 $('#carrierdrop1').empty();	             
	                 option.innerHTML = 'Choose Carrier';
					 option.value = '0';
					 ddl.options.add(option);
					 
	            	 for( var key in carriers){										  
	            	    var option = document.createElement("OPTION");
	            	    option.innerHTML = carriers[key];
	            	    option.value = key;
	            	    ddl.options.add(option);			
	            	 } 

	            	 if(response.respData.transDetailsResponse != null){

		            	 var scheduleType = response.respData.transDetailsResponse.scheduleType;
		            	 var numberOfLegs = response.respData.transDetailsResponse.numberOfLegs
	            		 $("#scheduleType").val(scheduleType);

	            		 if(scheduleType == "Transhipment"){
	            			 $("#legsDivId").show();
	            			 $("#legsId").prop("disabled", false);
	            			 $("#legsId").val(numberOfLegs);	            			 
		            	 }
		            	 var cutOffDate = response.respData.transDetailsResponse.cutOffDate;
	            		 $('#cutOffDateId').val(cutOffDate);	

	            		 setScheduleLegsDataOnModal(response.respData.transDetailsResponse);            		 
		             }
                   	 
	            	$("#update_schedule").modal('show');	  		          	            		             	       
	            }else{
		            
	            	$('#carrierdrop1').empty();
					option.innerHTML = 'No Carrier available';
				    option.value = '0';
				    ddl.options.add(option);
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

	function setScheduleLegsDataOnModal(data){

		$('#scheduleTable tbody').empty();

        var cutOffDate = $('#cutOffDateId').val();
        var rowsCount = data.scheduleLegsResponseList.length;
        var markup = '';
        var index = 1;

        var origin = $('#orgScheduleUpdInputId').val();
        var destination = $('#destScheduleUpdInputId').val();

        for (var i = 0; i < rowsCount; i++) {
          var modeid = "mode" + index;
          var carrierid = "carrier" + index;
          var carrierdropid = "carrierdrop" + index;

          var mode = data.scheduleLegsResponseList[i].mode;          
          var vessel = data.scheduleLegsResponseList[i].vessel;
          var voyage = data.scheduleLegsResponseList[i].voyage;
          var etdVal = '';
          
          if(i==0){
        	  etdVal = data.scheduleLegsResponseList[i].etddate;
          }else{
        	etdVal = data.scheduleLegsResponseList[i].etddate;
          }
          
          var etaVal = data.scheduleLegsResponseList[i].etadate;
          
          var options = '<option value="0">Choose Carrier</option>';
          for (var key in carriers) {        	  
            options = options + '<option value=' + key + '>' + carriers[key] + '</option>';
          }
          
          var originVal = '';
          var destinationVal = '';
          var orgReadOnlyStatus = '';
          var destReadOnlyStatus = '';
          if (i == 0) {
            originVal = origin;
            orgReadOnlyStatus = "readonly";
          }else{
        	originVal = data.scheduleLegsResponseList[i].origin;
          }
          
          if (i == rowsCount-1) {
            destinationVal = destination;
            destReadOnlyStatus = "readonly";
          }else{
        	  destinationVal = data.scheduleLegsResponseList[i].destination;
          }

          var transitTime = data.scheduleLegsResponseList[i].transittime;

          var seaSelected = '';
          var roadSelected = '';
          var trainSelected = '';
          var airSelected = '';
          
          if(mode == "Sea"){
        	  seaSelected = 'selected';
          }else if(mode == "Road"){
        	  roadSelected = 'selected';
          }else if(mode == "Train"){
        	  trainSelected = 'selected';
          }else if(mode == "Air"){
        	  airSelected = 'selected';
          }
          
          markup =  '<tr>'
            + '<td><input type="text" class="form-control font14 caltd" name="origin" id="origin' + index + '" value="' + originVal + '" ' + orgReadOnlyStatus + ' style="z-index:999;" required></td>'
            + '<td><input type="text" class="form-control font14 caltd" name="destination" id="destination' + index + '" value="' + destinationVal + '" ' + destReadOnlyStatus + ' style="z-index:999;" required></td>'          
            + '<td><select class="form-control font14" name="mode" id="mode' + index + '" onchange="changeCarrierInput(\'' + modeid + '\',\'' + carrierid + '\',\'' + carrierdropid + '\');">'
            + '<option value="Sea" '+seaSelected+'>Sea</option>'
            + '<option value="Road" '+roadSelected+'>Road</option>'
            + '<option value="Train" '+trainSelected+'>Train</option>'
            + '<option value="Air" '+airSelected+'>Air</option>'
            + '</select></td>'
            + '<td><input type="text" class="form-control font14 widthp250" name="carrier" id="carrier'+index+'" value="'+carrier+'" style="display:none;">'
            + '<select class="form-control font14 caltd widthp250" name="mode" id="carrierdrop'+index+'">' + options + '</select></td>'
            + '<td><input type="text" class="form-control font14 capitalize" name="vessel" id="vessel' + index + '" value="'+vessel+'" autocomplete="off" required></td>'
            + '<td><input type="text" class="form-control font14 capitalize" name="voyage" id="voyage' + index + '" value="'+voyage+'" autocomplete="off" required></td>'
            + '<td><input type="text" class="form-control font14 datetime caltd datetime_etd widthp120" value="'+etdVal+'" name="etd" id="etd' + index + '" autocomplete="off" required></td>'
            + '<td><input type="text" class="form-control font14 datetime caltd datetime_eta widthp120" value="'+etaVal +'" name="eta" id="eta' + index + '" autocomplete="off" required></td>'
            + '<td><input type="text" class="form-control font14 widthp110" name="transittime" id="transittime' + index + '" value="' + transitTime + '" readonly required></td>'
            + '</tr>';
            
          index++;
          $("#scheduleTable tbody").append(markup);
          
          if(mode == 'Sea'){
        	  $('#'+carrierid).hide();
        	  $('#'+carrierdropid).show();
        	  var carrier = data.scheduleLegsResponseList[i].carrierid;
        	  $('#'+carrierdropid).val(carrier);
          }else{
        	  $('#'+carrierdropid).hide();
        	  $('#'+carrierid).show();
        	  var carrier = data.scheduleLegsResponseList[i].carrier;
        	  $('#'+carrierid).val(carrier);
          }
         
        }      

        $('.datetime_etd').datetimepicker({
            format: 'DD-MMM-YYYY',
            //minDate: moment(),               
          });
          $('.datetime_eta').datetimepicker({
              format: 'DD-MMM-YYYY',
              useCurrent: false               
          });

          if(cutOffDate != ''){
           	 $('.datetime_etd').data("DateTimePicker").minDate(cutOffDate);
          	 $('.datetime_eta').data("DateTimePicker").minDate(cutOffDate);
           }

          $("#etd1, #etd2, #etd3, #etd4, #etd5").on("dp.change", function (e) {
        	    var index = this.id.charAt(this.id.length - 1);        	    
      		    var etdDate = $('#etd'+index).val();
      		    var etaDate = $('#eta'+index).val();
      		    
      		  if(etdDate != "" && etaDate != ""){  
      			var future = moment(etaDate);
      			var start = moment(etdDate);
      			var d = future.diff(start, 'days');			
      			$('#transittime'+index).val(d);
      		  }			
      		  $('#eta'+index).data("DateTimePicker").minDate(e.date);    
     	      $('#etd'+index).data("DateTimePicker").minDate(e.date);
      	  });

          $("#eta1, #eta2, #eta3, #eta4, #eta5").on("dp.change", function (e) {
        	    var index = this.id.charAt(this.id.length - 1);
        	    let ind = this.id.charAt(this.id.length - 1);
        	    var newIndex = ++ind;
        	    
        		var etdDate = $('#etd'+index).val();
        		var etaDate = $('#eta'+index).val();	
        		$('#etd'+newIndex).val(etaDate);
        		
        		if(etdDate != "" && etaDate != ""){  
        			var future = moment(etaDate);
        			var start = moment(etdDate);
        			var d = future.diff(start, 'days');			
        			$('#transittime'+index).val(d);
        		}		        		
        		$('#eta'+newIndex).data("DateTimePicker").minDate(e.date);
        	    $('#etd'+newIndex).data("DateTimePicker").minDate(e.date);	
          });

          $('#destination1, #destination2, #destination3, #destination4, #destination5').autocomplete({
    	 		source: function(search,success) {
    	 		    $.ajax({
    	 		      url : server_url+'utility/getAllLocation?location='+search.term,
    	 		      headers: authHeader,
    	 		      method: 'GET',
    	 		      dataType: 'json',
    	 		      data: null,
    	 		      success: function(data) {
    	 		        success(getLocationList(data.respData));
    	 		      }
    	 		    });
    	 		  },
    	 		 select: function (event, ui) {
    	 		    var label = ui.item.label;
    	 		    var value = ui.item.value;
    	 		    let index = this.id.charAt(this.id.length - 1);
    	 		    var newIndex = ++index;
                    $('#origin'+newIndex).val(value); 
    	 		}
    	 	});	
        
	}
	
	function updateEnquiryCharges(id,enquiryreference,shipmentType){
		$('#loader').show();
	       $.ajax({
	 			
			     type: 'GET', 
	             url : server_url+'forwarder/getForwarderEnquiryChargesById',	     
	             enctype: 'multipart/form-data',
	             headers: authHeader,
	             processData: false,
	             contentType: false,
	               "autoWidth": true,

	             data : "id="+id,
	   	      
	             success : function(response) {
	            	$('#loader').hide();
		           console.log(response)
		 	        var ddl = document.getElementById("carrierdrop1");
	                var option = document.createElement("OPTION");
	                
		            if(response.respCode == 1){  	              
                         
                         /*****Start Reset modal value *****/
		            	 var rowCount = $('#chrgTable tr').length;
		            	 for(var i=1;i<rowCount-1;i++){
		            	    document.getElementById("uploadrow_"+i).remove();
		            	 }
		            	 
     	            	 $("#chrgFrom").val('');
     	            	 $("#chrgTo").val('');
     	            	 $("#totalUsdAmount").val('');
     	            	 $("#totalInrAmount").val('');
     	            	 $("#remark").val('');    	            	   	            		            	
    	            	 $('#chrgIncotermId').prop('selectedIndex',0);
    	            	 $("#rate_0").val('');
    	            	 $("#quant_0").val('');
    	            	 $("#FTV_0").val('');
	 
    	            	 /*****End Reset modal value *****/
			            	  
		            	 $("#schForwEnquiryId").val(id);
                         $("#chargeForwEnquiryId").val(id);
                         $("#chargeEnquiryReferenceId").val(enquiryreference);
                         $("#chargeShipmentTypeId").val(shipmentType);
                         		            	 
		            	 $("#orgChargesUpdInputId").val(response.respData.origin);
		            	 $("#destChargesUpdInputId").val(response.respData.destination);

		            	 if(shipmentType == "FCL"){
		            		$('#divWeightInput').hide();
				            $('#divVolumeInput').hide();
				            $('#divContainersInput').show();
				            $('#containersId').val(response.respData.selectedfcl);
			             }else if(shipmentType == "LCL"){
			            	 $('#divContainersInput').hide();
			            	 $('#divWeightInput').show();
					         $('#divVolumeInput').show();
			            	 var weight = response.respData.lcltotalweight;
		            		 $('#weightId').val(weight);
						     $('#volumeId').val(response.respData.lclvolume);
						     //var weightInTon = weight / 1000;
						     //$('table#chrgTable tr:last input[name="quant[]"]').val(weightInTon);
			             }

		            	 $('#carrierdrop1').empty();	             
		                 option.innerHTML = 'Choose Carrier';
						 option.value = '0';
						 ddl.options.add(option);
						 
		            	 for( var key in carriers){										  
		            	    var option = document.createElement("OPTION");
		            	    option.innerHTML = carriers[key];
		            	    option.value = key;
		            	    ddl.options.add(option);			
		            	 } 

		            	$("#update_charges").modal('show');	  	
		            	
		            	if(response.respData.chargesRateResponseList.length != 0){
		            		var remark = '';
                            var chargeValidFrom = '';
                            var chargeValidTo = '';
                            var incotermid = '';
			            	for(var i=0;i<response.respData.chargesRateResponseList.length;i++){
			            	   remark = response.respData.chargesRateResponseList[i].remark;
                               chargeValidFrom = response.respData.chargesRateResponseList[i].validdatefrom;
                               chargeValidTo = response.respData.chargesRateResponseList[i].validdateto;
                               incotermid = response.respData.chargesRateResponseList[i].incotermid;

                               var chargesgroupingid = response.respData.chargesRateResponseList[i].chargesgroupingid;
                               var chargestypeid = response.respData.chargesRateResponseList[i].chargestypeid;
                               var currency = response.respData.chargesRateResponseList[i].currency;                             
                               var rate = response.respData.chargesRateResponseList[i].rate;
                               var basiscode = response.respData.chargesRateResponseList[i].basiscode;
                               var quantity = response.respData.chargesRateResponseList[i].quantity;
                              
                               if(i > 0 ){
                            	   $("#addMore").trigger("click");                            	                               	                                 
                               }
                               
                               getAllChargesSubType(i, chargesgroupingid,chargestypeid);
                                                           
                               $("#chrgGroId_"+i).val(chargesgroupingid);
                               //$("#chrgTypeId_"+i).val(chargestypeid);                               
                               $("#currency_"+i).val(currency);
                               
                               $("#rate_"+i).val(rate);
                               $("#rate_"+i).trigger("input");
                               
                               $("#basis_"+i).val(basiscode);
                               
                               $("#quant_"+i).val(quantity);
                               $("#quant_"+i).trigger("input");
                               
                               
				            }
		            		 $("#chrgFrom").val(chargeValidFrom);
	     	            	 $("#chrgTo").val(chargeValidTo);
	     	            	 $("#remark").val(remark);
	     	            		     	            	 
	     	            	 var incoid = incotermid - 1;    		            	
	    	            	 $('#chrgIncotermId').prop('selectedIndex',incoid);
			            }
		            		            	
		            		          	            		             	       
		            }else{

		            	$('#carrierdrop1').empty();
						option.innerHTML = 'No Carrier available';
					    option.value = '0';
					    ddl.options.add(option);
					    
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

	function viewEnquiryScheduleChargesDetailsById(id){
		   $('#loader').show();
	       $.ajax({
				
			   type: 'GET', 
	           url : server_url+'forwarder/getForwEnqScheduleChargeDetailsById',	     
	           enctype: 'multipart/form-data',
	           headers: authHeader,
	           processData: false,
	           contentType: false,
               "autoWidth": true,
	           data : "id="+id+"&userId="+userInfo.id,
	                     	      
	           success : function(response) {
		           console.log(response)
		 	        	$('#loader').hide();
		            if(response.respCode == 1){  
			            		  
		            	 $("#enqReffLbl").text(response.respData.enquiryreference);
		            	 $("#enqOriginLbl").text(response.respData.origin);
		            	 $("#enqDestinationLbl").text(response.respData.destination);
		            	 $("#enqScheduleTypeLbl").text(response.respData.scheduletype);

		            	 var numberLegs = response.respData.numberoflegs;
		            	 var legs = "";
			             if(numberLegs == 0){
                             legs = "Direct";
				         }else{
				        	 legs = numberLegs; 
					     }
		            	 $("#enqNoOfLegsLbl").text(legs);
		            	 
		            	 
		            	 $("#enqCargoCatLbl").text(response.respData.cargocategory);
		            	 $("#enqFclLclLbl").text(response.respData.shipmenttype);
		            	 $("#enqEnquiryStatusLbl").text(response.respData.status);
		            	 $("#enqIncotermLbl").text(response.respData.incoterm);

		            	 $('#tbodyEnquiryDetailsPopUpId').empty();
		  	             $('#tbodyEnquiryChargesPopUpId').empty();
		  	            	
		            	 var trBody = '';
		            	 
		            	if(response.respData.scheduleLegsResponseList != null){
			            	for(var i=0; i< response.respData.scheduleLegsResponseList.length ; i++){
                                var transittime = response.respData.scheduleLegsResponseList[i].transittime;
			            		var daysLable = ""
					  	        if(transittime > 1){
					  	            	daysLable = "Days";
						  	    }else{
						  	        	daysLable = "Day";
							  	}
				  	            transittime = transittime+" "+daysLable;
				  	            
			            		trBody = trBody + '<tr><td class="text-left">'+response.respData.scheduleLegsResponseList[i].origin+'</td>'+
			                    '<td class="text-left">'+response.respData.scheduleLegsResponseList[i].destination+'</td>'+
			            	    '<td class="text-left">'+response.respData.scheduleLegsResponseList[i].mode+'</td>'+
			                    '<td class="text-left">'+response.respData.scheduleLegsResponseList[i].carrier+'</td>'+
			                    '<td class="text-left">'+response.respData.scheduleLegsResponseList[i].vessel+'</td>'+
			                    '<td class="text-left">'+response.respData.scheduleLegsResponseList[i].voyage+'</td>'+
			                    '<td class="text-center">'+transittime+'</td>'+
			                    '<td class="text-center">'+response.respData.scheduleLegsResponseList[i].etddate+'</td>'+
			                    '<td class="text-center">'+response.respData.scheduleLegsResponseList[i].etadate+'</td></tr>';
				            }	            		
			            }
			            $('#tbodyEnquiryDetailsPopUpId').append(trBody);	        	 

                        var tRowsCharges = '';

                        var json = [];
                        var totalCharges = [];
	  	            	if(response.respData.chargesRateResponseList != null){
	  	            	   for(var i = 0 ;i<response.respData.chargesRateResponseList.length ;i++){
		  	            	  var chargesgrouping = response.respData.chargesRateResponseList[i].chargesgrouping;
		  	            	  var chargestype = response.respData.chargesRateResponseList[i].chargestype;
		  	            	  var currency = response.respData.chargesRateResponseList[i].currency;
		  	            	  var rate = response.respData.chargesRateResponseList[i].rate;
		  	            	  var basis = response.respData.chargesRateResponseList[i].basis;
		  	            	  var quantity = response.respData.chargesRateResponseList[i].quantity;
		  	            	  var totalAmount = rate * quantity;

		  	            	  var totalChargesUsd = 0;
	                          var totalChargesInr = 0;
	                          
		  	            	  if(currency == "USD"){
		  	            		totalChargesUsd =  totalAmount;
			  	              }else if(currency == "INR"){
			  	            	totalChargesInr =  totalAmount;
				  	          }	
				  	         
		  	            	  if (json.some(e => e.ChargeGroup == chargesgrouping)) {
		  	            		totalCharges = json.map(item => {
				                    if (item.ChargeGroup == chargesgrouping) {
				                      	 return {
				                      	    ...item,
				                         USD:  item.USD + totalChargesUsd,
				                     	 INR:  item.INR + totalChargesInr
				                      	};
				                     }
				                     return item;
				               });
		  	            		json = totalCharges;
		  	            	  }else{
		  	            		/* vendors contains the element we're looking for */
			  	            	    var itemObject = {};
			  	            	    itemObject["ChargeGroup"] = chargesgrouping;
			  	            	    itemObject["USD"] = totalChargesUsd;
			  	            	    itemObject["INR"] = totalChargesInr;
			  	            	    json.push(itemObject);				  	            	  			  	            	    		  	            	    		  	            	    
			  	              }
			  	              				  	            			  	              		  	            	  	  	     		   			    		  	            			                 	                       		                		                    				  	          			  	          
		  	            	  totalAmount = parseFloat(totalAmount.toFixed(2));

				  	          tRowsCharges = tRowsCharges + '<tr><td>'+chargesgrouping+'</td>'+
				  	          '<td>'+chargestype+'</td>'+
				  	          '<td>'+currency+'</td>'+
				  	          '<td style="text-align: right;">'+rate+'</td>'+
				  	          '<td>'+basis+'</td>'+
				  	          '<td  style="text-align: right;">'+quantity+'</td>'+
				  	          '<td style="text-align: right;">'+totalAmount.toFixed(2)+'</td></tr>';		  	            	
		  	               }
	  	            	}

	  	            	$('#tbodyEnquiryChargesPopUpId').append(tRowsCharges);
	  	            	
					    var chargeSummary = '';
					    if(json != null){
						    var totalUsd = 0;
						    var totalInr = 0;
			            	for(var i=0; i< json.length ; i++){
                                var chargesGrouping = json[i].ChargeGroup;
                                var usdAmount = json[i].USD;
                                var inrAmount = json[i].INR;
                                totalUsd = totalUsd + usdAmount;
                                totalInr = totalInr + inrAmount;
                                chargeSummary = chargeSummary + '<tr><td class="text-left">'+chargesGrouping+'</td>'
                                                              + '<td class="text-right">'+usdAmount.toFixed(2)+'</td>'
                                                              + '<td class="text-right">'+inrAmount.toFixed(2)+'</td></tr>';
				            }
			            	chargeSummary = chargeSummary + '<tr><td class="text-left"><b>Total Amount</b></td>'
                            + '<td class="text-right"><b>'+totalUsd.toFixed(2)+'</b></td>'
                            + '<td class="text-right"><b>'+totalInr.toFixed(2)+'</b></td></tr>';
			            }
					    $('#tbodyEnqSummaryChargesPopUpId').empty();
					    $('#tbodyEnqSummaryChargesPopUpId').append(chargeSummary);
					                   		
	  	            	$("#bkDestReqInfoLbl").text(response.respData.origincode+" "+response.respData.destinationcode);	            
		            	$("#view_enq_schedule_charges_details").modal('show');	  	
		            		          	            		             	       
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
	/*****Schedule and charges update call end ***** */
	
	 function loadForwarderEnquiryListTable(data,tableId){
		  	
		  	$('#'+tableId).dataTable().fnClearTable();
		  	var shipType = "";
		  	var oTable = $('#'+tableId).DataTable({
		  		/* 'responsive': true, */
		  	 	"destroy" : true,
		  		"data" : data,     	
		       "dom": 'lBfrtip',
		       "scrollX": true,
		        "autoWidth": true,
			       "lengthChange": true,
			       "buttons": [{
			           extend: 'pdf',
			           filename: 'forwader_enquiry_data_pdf',
			           /* className: 'pdf', */
			           text: '<i class="far fa-file-pdf"></i> ',
			           customize: function (doc) {
			          	 doc.defaultStyle.alignment = 'left';
			          	  doc.styles.tableHeader.alignment = 'left';
			            doc.content.splice(1, 0, {
			              margin: [1, 1, 7, 1],
			              alignment: 'left',
			              image: 'data:image/png;base64,/9j/4QAYRXhpZgAASUkqAAgAAAAAAAAAAAAAAP/sABFEdWNreQABAAQAAAA8AAD/4QMtaHR0cDovL25zLmFkb2JlLmNvbS94YXAvMS4wLwA8P3hwYWNrZXQgYmVnaW49Iu+7vyIgaWQ9Ilc1TTBNcENlaGlIenJlU3pOVGN6a2M5ZCI/PiA8eDp4bXBtZXRhIHhtbG5zOng9ImFkb2JlOm5zOm1ldGEvIiB4OnhtcHRrPSJBZG9iZSBYTVAgQ29yZSA3LjAtYzAwMCA3OS5kYWJhY2JiLCAyMDIxLzA0LzE0LTAwOjM5OjQ0ICAgICAgICAiPiA8cmRmOlJERiB4bWxuczpyZGY9Imh0dHA6Ly93d3cudzMub3JnLzE5OTkvMDIvMjItcmRmLXN5bnRheC1ucyMiPiA8cmRmOkRlc2NyaXB0aW9uIHJkZjphYm91dD0iIiB4bWxuczp4bXA9Imh0dHA6Ly9ucy5hZG9iZS5jb20veGFwLzEuMC8iIHhtbG5zOnhtcE1NPSJodHRwOi8vbnMuYWRvYmUuY29tL3hhcC8xLjAvbW0vIiB4bWxuczpzdFJlZj0iaHR0cDovL25zLmFkb2JlLmNvbS94YXAvMS4wL3NUeXBlL1Jlc291cmNlUmVmIyIgeG1wOkNyZWF0b3JUb29sPSJBZG9iZSBQaG90b3Nob3AgMjIuNCAoV2luZG93cykiIHhtcE1NOkluc3RhbmNlSUQ9InhtcC5paWQ6RERGRkJCOEFGNjg3MTFFQjg5NDE4NjM4MjhGODZFODAiIHhtcE1NOkRvY3VtZW50SUQ9InhtcC5kaWQ6RERGRkJCOEJGNjg3MTFFQjg5NDE4NjM4MjhGODZFODAiPiA8eG1wTU06RGVyaXZlZEZyb20gc3RSZWY6aW5zdGFuY2VJRD0ieG1wLmlpZDpEREZGQkI4OEY2ODcxMUVCODk0MTg2MzgyOEY4NkU4MCIgc3RSZWY6ZG9jdW1lbnRJRD0ieG1wLmRpZDpEREZGQkI4OUY2ODcxMUVCODk0MTg2MzgyOEY4NkU4MCIvPiA8L3JkZjpEZXNjcmlwdGlvbj4gPC9yZGY6UkRGPiA8L3g6eG1wbWV0YT4gPD94cGFja2V0IGVuZD0iciI/Pv/uAA5BZG9iZQBkwAAAAAH/2wCEAAYEBAQFBAYFBQYJBgUGCQsI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'
			            });
			           },
			           title: " ",
			           exportOptions: {
			             columns: [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10],
			           },
			           orientation: 'landscape',
			           pageSize: 'LEGAL'
			           /* messageTop: "User Enquiry Data" */
			         },
			         {
			           extend: 'excel',
			           filename: 'forwader_enquiry_data_xsl',
			           title: '',
			           /* className: 'excel', */
			           text: '<i class="far fa-file-excel-o"></i>',
			           exportOptions: {
			             columns: [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10]
			           }
			           /*messageTop: "User Enquiry Data" */
			         },
			       ],

			       "order": [
			         [3, "desc"]
			       ],
			       "columnDefs": [
			         /* origin */
			         {
			           "targets": 0,
			           "className": "dt-body-left",
			           "width": "10%",
			         },
			         /* destination */
			         {
			           "targets": 1,
			           "className": "dt-body-left",
			           "width": "10%",
			         },
			         /* imp exp */
			         {
			           "targets": 2,
			           "className": "dt-body-left",
			           render: function (data, type, row) {
			             return data.substr(0, 2);
			           }
			         },
			         /* date */
			         {
			           "targets": 3,
			           "className": "dt-body-center",
			           "width": "9%",
			         },
			         /* category */
			         {
			           "targets": 4,
			           "className": "dt-body-center",
			           "width": "8%",
			         },
			         /* FCL LCL */
			         {
			           "targets": 5,
			           "className": "dt-body-center",
			           "width": "6%",
			         },
			         /* container */
			         {
			           "targets": 6,
			           "className": "dt-body-left",
			         },
			         /* weight */
			         {
			           "targets": 7,
			           "className": "dt-body-right",
			           "width": "5%",
			         },
			         /* volume */
			         {
			           "targets": 8,
			           "className": "dt-body-right",
			         },
			         /* ready date */
			         {
			           "targets": 9,
			           "className": "dt-body-center",
			           "width": "9%",
			         },
			         /* status */
			         {
			           "targets": 10,
			           "className": "dt-body-center",
			           "width": "8%",
			         },
			         /* action */
			         {
			           "targets": 11,
			           "className": "text-center",
			           "width": "15%",
			         }
			       ],
		  		"columns": 	[
		  			           
		  			            {        
		  			            	 "data": null,
					    	           sortable: true,					    	          
					    	           render: function (data,type,row) {
		               				   var originwithcode = data.origin;

		               					return originwithcode;		               					
		               				}

		  			            },
		  						{				    	        	  
					      	           "data": null,					      	       
					    	           sortable: true,					    	          
					    	           render: function (data,type,row) {
		               				   var destinationwithcode = data.destination;

		               					return destinationwithcode;		               					
		               				}
								},
								{
								       "data": null,
	                  	               sortable: true,
	                  	            // className: 'limited',	
	               				       render: function (data,type,row) {
	               					   var customer = data.customer;
	               					   return customer;               					
	               				    }	
	                            },
		  						{	  							      
									    "data": null,
	                      	        sortable: true,	
	                   				render: function (data,type,row) {
	                       				var searchdate = data.searchdate.split(" ");
	                   					
	                   					return searchdate[0];	                   					
	                   				}	
		                        },
		                        	
		                        {	  							      
							        "data": null,
                  	                sortable: true,	
               				         render: function (data,type,row) {
                   				        var cargocategory = data.cargocategory;                   					

               					        return cargocategory;              					
               				        }	
                                },
		                        {	  							      
								        "data": null,
                      	            sortable: true,	
                   				    render: function (data,type,row) {
                       				   var shipmentType = data.shipmenttype;   
                       				   shipType = data.shipmenttype;                					
                   					   return shipmentType;
                   					
                   				    }	
	                            },
	                            {	  							      
							        "data": null,
                  	                sortable: true,	
               				         render: function (data,type,row) {                  				                       					
                                        var selectedfcl = data.selectedfcl;
                 					           return selectedfcl;              					
               				        }	
                                },
                                {	  							      
							        "data": null,
                  	                sortable: true,	
               				         render: function (data,type,row) {                  				                       					
               				        	var lcltotalweight = data.lcltotalweight;               				       	    
               				            return lcltotalweight;             					
               				        }	
                                },
                                {	  							      
							        "data": null,
                  	                sortable: true,	
               				         render: function (data,type,row) {                  				                       					
               				        	var lclvolume = data.lclvolume;              			            	
               			                return lclvolume;              					
               				        }	
                                },	
		                        {		                  		      
		                  		       "data": null,
		                  		        sortable: true,
	           				          render: function (data,type,row) {
	               				            var cargoreadydate = data.cargoreadydate;                                      				    
	           					            return cargoreadydate;           					
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
	                  				    var id = data.id;

	                  				    //Status 
	                  				    var status = data.status;	                  				 	
	                  				    var isscheduleupload = data.isscheduleupload;
	                  				    var ischargesupload = data.ischargesupload;
	                  				    
	                  				    var scheduleDisClass = '';
		                    			var chargeDisClass = '';		                    			

		                    			var viewDisClass = '';
		                    			var submitDisClass = '';
		                    			
	              				    	var cancelDisClass = '';
	              				    	var deleteDisClass = '';
		                    			                   			                    			
		                    			if(status == 'Requested'){
		                    				scheduleDisClass = '';
		                    				chargeDisClass = ''; 

		                    				viewDisClass = '';
		                    				
		                    				if(isscheduleupload == "Y" && ischargesupload == "Y"){		                    					
		                  				    	submitDisClass = '';
		                  				    	
				                  		    }else{
				                  		    	submitDisClass = 'disabled';
						                    }
		                    				cancelDisClass = '';	
		                    				deleteDisClass = 'disabled';	                    			              			                  				
	       			                    }
		                    		    if(status == 'Accepted'){
		                    		    	scheduleDisClass = 'disabled';
		                    				chargeDisClass = 'disabled'; 

		                    				viewDisClass = '';
		                    				submitDisClass = 'disabled';
		                    				
		                    		    	cancelDisClass = '';
		                    		    	deleteDisClass = 'disabled';		                    		    		                    					                    				
				                        }  			                        
		                    		    if(status == 'Cancelled'){
		                    		    	scheduleDisClass = 'disabled';
		                    				chargeDisClass = 'disabled'; 

		                    				viewDisClass = '';
		                    				submitDisClass = 'disabled';
		                    					                    			
		                    		    	cancelDisClass = 'disabled';
		                    		    	deleteDisClass = '';		                    		    		                    		                     					                    				
				                        }    
		                    		    if(status == 'Rejected'){
		                    		    	scheduleDisClass = 'disabled';
		                    				chargeDisClass = 'disabled'; 

		                    				viewDisClass = '';
		                  				    submitDisClass = 'disabled';
		                  				    	                    		    	
		                    		    	cancelDisClass = 'disabled';
		                    		    	deleteDisClass = '';		                    		    	    		                    				                    				
				                        }		                    		     	   
			                    	    
	                  				    var accept = "Accepted";
	                  				    var reject = "Rejected";
	                                    var cancel = "Cancelled";
	                                   

	                                  var enquiryreference = data.enquiryreference;
	                                  var shipmentType = data.shipmenttype; 
	                                    	                  				 		    
		                  			  return '<button type="button" value="Update" class="update_btn actbtn ' + scheduleDisClass + '"  title="Update Schedule" onclick="updateEnquirySchedule(\'' + id + '\',\''+enquiryreference+'\');" '+scheduleDisClass+'><i class="fas fa-pencil-alt"></i></button>'
		                              + '<button type="button" value="Update" class="chrg_btn actbtn '+ chargeDisClass +'" title="Update Charges" onclick="updateEnquiryCharges(\'' + id + '\',\''+enquiryreference+'\',\''+shipmentType+'\');" '+chargeDisClass+'><i class="fas fa-pencil-alt"></i></button>'
		                              + '<button type="button" value="V" class="view_btn actbtn '+viewDisClass+'"  title="View" onclick="viewEnquiryScheduleChargesDetailsById(\'' + id + '\');" '+viewDisClass+'><i class="fas fa-eye"></i></button>'
		                              + '<button type="button" value="Submit" class="green_sub actbtn '+submitDisClass+'"  title="Submit" onclick="updateEnquiryStatus(\'' + id + '\',\'' + accept + '\');" '+submitDisClass+'> <i class="fas fa-check-circle"></i></button>'		                             
		                              + '<button type="button"  value="C" class="can_btn actbtn '+cancelDisClass+'" '+cancelDisClass+' title="Cancel"  onclick="updateEnquiryStatus(\'' + id + '\',\'' + cancel + '\');" ><i class="fas fa-times"></i></button>'
		                  			  + '<button type="button"  title="Delete" class="del_btn1 actbtn '+deleteDisClass+'" onclick="deleteForwarderEnquiryById(\''+id+'\');" '+deleteDisClass+'><i class="fas fa-trash" ></i></button>';
		                  			  
	              				    }
		    	                        
							    }
		                  		
		                  	]
		      		                  
		      		     });
		  if(shipType=="FCL" && shipType!=""){
				oTable.column(7).visible( false );	
				oTable.column(8).visible( false );
		  }else if(shipType=="LCL" && shipType!=""){
				oTable.column(6).visible( false );	
		  }

	}
		   
/****** End Enquiry details functions ******/ 
 function deleteForwarderEnquiryById(id){
	 swal({
         //title: "Are you sure, please confirm?",
         text: "Are you sure, please confirm?",
         buttons: [
           'Cancel',
           'Ok'
         ],
       }).then(function(isConfirm) {
         if (isConfirm) {
       	  $('#loader').show();
       	  var userId =  userInfo.id;  
         
				$.ajax({
					
				     type: 'DELETE', 
		            url : server_url+'forwarder/deleteForwarderEnquiryById/'+id+"/"+userId,	     
		            enctype: 'multipart/form-data',
		            headers: authHeader,
		            processData: false,
		            contentType: false,
		               "autoWidth": true,
		            "scrollX": true,
		            data :  null,
		   
		            success : function(response) {
			           console.log(response)
			 	        	
			            if(response.respCode == 1){  		            
			            	$('#loader').hide();
				           successBlock("#success_block",response.respData.msg);
				           var shipmentType = $('#shipmenttypefilter').val();
				           getForwarderEnquiryDetailsAllList(userInfo.id,shipmentType,"");
				           getForwarderBookingCountByStatus(userInfo.id,shipmentType);
				    	   getForwarderEnquiryCountByStatus(userInfo.id,shipmentType);
         	            		             	       
			            }else{
				            errorBlock("#error_block",response.respData);
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
					
					if(response != null && response.respData.length !=0){											
						for( i=0 ; i< response.respData.length ; i++){
													      						     
						     var key = response.respData[i].id;
						     var  value = response.respData[i].carriername+" ("+response.respData[i].scaccode+")";
						     carriers[key] = value;  			
						} 											  		   
					}					 
				}catch(err){				
					console.log(response.respData);
				}
			})
			.fail(function(err) {			
				    console.log("Failed");
		    });
      }

	  function getIncotermList(){
		  $.ajax({
				
			   type: 'GET',  		     	
			   contentType: "application/json",
			   url : server_url+'utility/getIncoterm',
			   data: null
			})
			.done(function(response) {
				try{
					
					 var options = '';
			         if (response != null && response.respData.length != 0) {
			            for (i = 0; i < response.respData.length; i++) {
			                var id = response.respData[i].id;
			                var incoterm = response.respData[i].incoterm;
			                var description = response.respData[i].description;
			                var incoDesc = description +" ("+incoterm+")";
			                options = options + '<option value=' + id + '>' + incoDesc + '</option>';
			             }
			             $('#chrgIncotermId').empty();
			             $('#chrgIncotermId').append(options);
			         
			          } else {
			             $('#chrgIncotermId').append(options);
			          }					 
				}catch(err){				
					console.log(response.respData);
				}
			})
			.fail(function(err) {			
				    console.log("Failed");
		    });
      }
	  
	  $('body').tooltip({
			selector : '[data-toggle="tooltip"]'
		});
		$('[data-toggle="tooltip"]').tooltip({ trigger: 'hover' });

	  $(document).on("hover",function()
			    {
			    setTimeout(function()
			    {

			  $('[data-toggle="tooltip"]').tooltip('hide');

			},200);    // Hides tooltip in 500 milliseconds
			    });
	  

	 function calculateFTV(evt,obj){
		 	 
			 var id = obj.id;
			 var index = id.charAt(id.length-1);
			 var currency = document.getElementsByName("currency[]")[index].value;
			 var rate = document.getElementsByName("rate[]")[index].value;
		     var quantity = document.getElementsByName("quant[]")[index].value;	     
		     var shipmentType = $('#chargeShipmentTypeId').val();

		     //var totalUsdAmount = $('#totalUsdAmount').val();
		     //var totalInrAmount = $('#totalInrAmount').val();
		     
		     		     
		     if(shipmentType == "FCL"){
		    	 if(rate != "" && quantity != ""){
		        	 document.getElementsByName("FTV[]")[index].value = rate * quantity;                    
				     var totalUsdAmount = 0;
				     var totalInrAmount = 0;
				     var rowCount = $('#chrgTable tr').length;
		        	 for(var i=0;i<rowCount-1;i++){
		        		 var totRate = document.getElementsByName("FTV[]")[i].value;
		        		 var totCurrency = document.getElementsByName("currency[]")[i].value;
		        		 if(totCurrency == "USD"){
		        			 totalUsdAmount = parseFloat(totalUsdAmount) + parseFloat(totRate);
		                 }else{
		                	 totalInrAmount = parseFloat(totalInrAmount) + parseFloat(totRate);
		                 }             		  
		        	 }
		        	 $('#totalUsdAmount').val(totalUsdAmount);
				     $('#totalInrAmount').val(totalInrAmount);
		         }
			 }else if(shipmentType == "LCL"){
				 var weight = $('#weightId').val();
			     var volume = $('#volumeId').val();
			     var basis = document.getElementsByName("chrgBasis[]")[index].value;
	             var totalAmount = '';
	             
	             if(basis == "PERWEIGHT"){
			         var weightInTons = weight / 1000;
			         quantity = weightInTons;
			     }else if(basis == "PERVOLUME"){				 
			    	 quantity = volume;
		         }else if(basis == "PERWM"){	
		    	    var weightInTons = weight / 1000;		    	 		    	 
		    	    quantity = weightInTons > volume ? weightInTons : volume;		    	 
		         }
			     document.getElementsByName("FTV[]")[index].value = (rate * quantity).toFixed(2);

			     var totalUsdAmount = 0;
			     var totalInrAmount = 0;
			     var rowCount = $('#chrgTable tr').length;
	        	 for(var i=0;i<rowCount-1;i++){
	        		 var totRate = document.getElementsByName("FTV[]")[i].value;
	        		 var totCurrency = document.getElementsByName("currency[]")[i].value;
	        		 if(totCurrency == "USD"){
	        			 totalUsdAmount = parseFloat(totalUsdAmount) + parseFloat(totRate);
	                 }else{
	                	 totalInrAmount = parseFloat(totalInrAmount) + parseFloat(totRate);
	                 }             		  
	        	 }
	        	 $('#totalUsdAmount').val(totalUsdAmount);
			     $('#totalInrAmount').val(totalInrAmount);
		     }
		       
     }

	function getBasisVal(obj){
		 var id = obj.id;
		 var index = id.charAt(id.length-1);
		 var basis = obj.value;
		 var currency = document.getElementsByName("currency[]")[index].value;
		 var rate = document.getElementsByName("rate[]")[index].value;
	     var shipmentType = $('#chargeShipmentTypeId').val();

	     var totalUsdAmount = $('#totalUsdAmount').val();
	     var totalInrAmount = $('#totalInrAmount').val();
	     
	     if(shipmentType == "LCL"){
			 var weight = $('#weightId').val();
		     var volume = $('#volumeId').val();
		    
             var quantity = '';
             if(rate != ""){
		         if(basis == "PERWEIGHT"){
			         var weightInTons = weight / 1000;
			         quantity = weightInTons;
			     }else if(basis == "PERVOLUME"){				 
			    	 quantity = volume;
		         }else if(basis == "PERWM"){	
		    	    var weightInTons = weight / 1000;		    	 		    	 
		    	    quantity = weightInTons > volume ? weightInTons : volume;		    	 
		         }
		         document.getElementsByName("quant[]")[index].value = quantity;//.toFixed(2);
		         document.getElementsByName("FTV[]")[index].value = (rate * quantity).toFixed(2);

		         var totalUsdAmount = 0;
			     var totalInrAmount = 0;
			     var rowCount = $('#chrgTable tr').length;
	        	 for(var i=0;i<rowCount-1;i++){
	        		 var totRate = document.getElementsByName("FTV[]")[i].value;
	        		 var totCurrency = document.getElementsByName("currency[]")[i].value;
	        		 if(totCurrency == "USD"){
	        			 totalUsdAmount = parseFloat(totalUsdAmount) + parseFloat(totRate);
	                 }else{
	                	 totalInrAmount = parseFloat(totalInrAmount) + parseFloat(totRate);
	                 }             		  
	        	 }
	        	 $('#totalUsdAmount').val(totalUsdAmount);
			     $('#totalInrAmount').val(totalInrAmount);
             }
	     }  
	}
  </script>
</head>
<!--   container-fluid -->

<div class="container-fluid">
  <div class="row mb20 mt-3 bg_white_dash">
    <div class="col-lg-2 col-xs-12">
      <div class="side_filters">
        <h3 class="filter_hd2">Filter Results</h3>
        <a type="button" class="reset_btn" onclick="resetFilter();">Reset</a>
        <h4 class="filter_subhd">Period</h4>
        
        <div class="widthSpl100"><input type="radio" name="period_input" class="filter_checkbox" value="DAY" onchange="filterme()"><label class="filter_label">Today</label></div>
        <div class="widthSpl100"><input type="radio" name="period_input" class="filter_checkbox" value="WEEK" onchange="filterme()"><label class="filter_label">This Week</label></div>
        <div class="widthSpl100"><input type="radio" name="period_input" class="filter_checkbox" value="MONTH" onchange="filterme()"><label class="filter_label">This Month</label></div>
        <div class="widthSpl100"><input type="radio" name="period_input" class="filter_checkbox" value="RANGE" ><label class="filter_label">Date Range</label></div>
        <div class="widthSpl100"> 
           <span class="filter_checkbox"></span>
             <input type="datetime" autocomplete="off" class="form-control date_range  datepicker" id="fdaterange1">
             <label class="filter_label_spl">to</label>
             <input type="datetime" autocomplete="off" class="form-control date_range datepicker" id="fdaterange2">
        </div>
        <div class="clearfix"></div>
        <!-- Customer -->
        <div id="customerFilterMainDiv">
           <h4 class="filter_subhd">Importer/Exporter</h4>          
           <div id="customerFilterSectionId">            
           </div> 
           <div id="customerFilterMoreLessSectionId" style="display: none;"> 
             <div class="clearfix"></div>
             <a href="#" class ="more_link " onclick="moreCustomerItems();">more...</a>
             <div class="clearfix"></div>
             <a  href="#" style="display: none;" class ="less_link" onclick="lessCustomerItems();">less</a>
           </div> 
         </div>
        <!-- Customer -->
        <div class="clearfix"></div>
        
        <!-- Origin -->
        <div id="originFilterMainDiv">
           <h4 class="filter_subhd">Origin</h4>
           <div id="originFilterSectionId">        
           </div>
           <div id="originFilterMoreLessSectionId" style="display: none;">  
              <div class="clearfix"></div>
              <a href="#" class ="more_linkO" onclick="moreOriginItems();">more...</a>
              <div class="clearfix"></div>
              <a  href="#" style="display: none;" class ="less_linkO" onclick="lessOriginItems();">less</a>
           </div>
        </div>
        
        <div class="clearfix"></div>
        
        <!-- Origin --> 
        
        <!-- Destination -->
        <div id="destinationFilterMainDiv">
           <h4 class="filter_subhd">Destination</h4>
           <div id="destinationFilterSectionId">
           </div>
           <div id="destinationFilterMoreLessSectionId" style="display: none;">
              <div class="clearfix"></div>
              <a href="#" class ="more_linkD " onclick="moreDestinationItems();">more...</a>
              <div class="clearfix"></div>
              <a  href="#" style="display: none;" class ="less_linkD" onclick="lessDestinationItems();">less</a>
            </div>
        </div>
        
        <div class="clearfix"></div>
        
        <!-- Destination --> 
      </div>
    </div>
    <div class="col-lg-10 col-xs-12">
      <div class="row">
        <div class="col-md-12 nav-tabs">
          <ul class="nav mb-n1" id="myTab" role="tablist">
            <li class="nav-item">
              <h2 class="book_cargo_hd mr-4 mb-0" style="line-height:2;">My Dashboard</h2>
            </li>
            <!-- <li class="nav-item"> <a class="nav-link active tabnav" id="fcl-tab" data-toggle="tab" href="#fcl" role="tab" aria-controls="fcl" aria-selected="true">FCL</a> </li>
            <li class="nav-item"> <a class="nav-link tabnav id="lcl-tab" data-toggle="tab" href="#lcl" role="tab" aria-controls="lcl" aria-selected="false">LCL</a> </li>
            <li class="nav-item"> <a class="nav-link tabnav" id="both-tab" data-toggle="tab" href="#both" role="tab" aria-controls="both" aria-selected="false">Both</a> </li> -->
            <li class="nav-item" style="width: 200px;">
              <div class="form-group row mb-0">
                <label for="usertype" class="col-md-5 form-label-new ml-2 pr-0 mb-0" >Shipment Type</label>
                <div class="col-md-6">
                  <select class="form-control font14" name="shipmenttype" id="shipmenttypefilter">
					  <option value="FCL">FCL</option>
					  <option value="LCL">LCL</option>
					</select>
                </div>
              </div>
            </li>
          </ul>
        </div>
      </div>
      <div class="row tabDiv pt-3 pb-3 mb-4">
        <div class="col-md-12 ">
          <div class="tab-content" id="myTabContent">
            <div class="row mb-4">
              <div class="col">
                <div class="stats_box_wrap">
                  <div class="stat_color_purpol">
                    <div class="row">
                      <h3 class="stat_head">Enquiry</h3>
                    </div>
                  </div>
                  <div class="stats_wrap">
                    <div class="row">
                      <div class="col-6">
                        <p class="stat_text"><a href="#" onclick="getForwarderEnquiryDetailsListByStatus('Requested');">Requested</a></p>
                        <p class="stat_text"><a href="#" onclick="getForwarderEnquiryDetailsListByStatus('Accepted');">Accepted</a></p>
                        <p class="stat_text"><a href="#" onclick="getForwarderEnquiryDetailsListByStatus('Cancelled');">Cancelled</a></p>
                        <p class="stat_text"><a href="#" onclick="getForwarderEnquiryDetailsListByStatus('Rejected');">Rejected</a></p>
                      </div>
                      <div class="col-6">
                        <p class="stat_text_val" id="eqRequestCount">0</p>
                        <p class="stat_text_val" id="eqAcceptedCount">0</p>
                        <p class="stat_text_val" id="eqCancelledCount">0</p>
                        <p class="stat_text_val" id="eqRejectedCount">0</p>
                      </div>
                    </div>
                  </div>
                </div>
              </div>
              <div class="col">
                <div class="stats_box_wrap">
                  <div class="stat_color_yellow">
                    <div class="row">
                      <h3 class="stat_head">Booking</h3>
                    </div>
                  </div>
                  <div class="stats_wrap">
                    <div class="row">
                      <div class="col-6">
                        <p class="stat_text"><a href="#" onclick="getForwarderBookingDetailsListByStatus('Requested');">Requested</a></p>
                        <p class="stat_text"><a href="#" onclick="getForwarderBookingDetailsListByStatus('Accepted');">Accepted</a></p>
                        <p class="stat_text"><a href="#" onclick="getForwarderBookingDetailsListByStatus('Cancelled');">Cancelled</a></p>
                        <p class="stat_text"><a href="#" onclick="getForwarderBookingDetailsListByStatus('Rejected');">Rejected</a></p>
                      </div>
                      <div class="col-6">
                        <p class="stat_text_val" id="bkRequestCount">0</p>
                        <p class="stat_text_val" id="bkAcceptedCount">0</p>
                        <p class="stat_text_val" id="bkCancelledCount">0</p>
                        <p class="stat_text_val" id="bkRejectedCount">0</p>
                      </div>
                    </div>
                  </div>
                </div>
              </div>
              <div class="col">
                <div class="stats_box_wrap">
                  <div class="stat_color_green">
                    <div class="row">
                      <h3 class="stat_head">Shipping Bill</h3>
                    </div>
                  </div>
                  <div class="stats_wrap">
                    <div class="row">
                      <div class="col-6">
                        <p class="stat_text">Checklist</p>
                        <p class="stat_text">Final</p>
                      </div>
                      <div class="col-6">
                        <p class="stat_text_val">0</p>
                        <p class="stat_text_val">0</p>
                      </div>
                    </div>
                  </div>
                </div>
              </div>
              <div class="col">
                <div class="stats_box_wrap">
                  <div class="stat_color_ltblue">
                    <div class="row">
                      <h3 class="stat_head">Invoice</h3>
                    </div>
                  </div>
                  <div class="stats_wrap">
                    <div class="row">
                      <div class="col-6">
                        <p class="stat_text">Proforma</p>
                        <p class="stat_text">Final</p>
                      </div>
                      <div class="col-6">
                        <p class="stat_text_val">0</p>
                        <p class="stat_text_val">0</p>
                      </div>
                    </div>
                  </div>
                </div>
              </div>
              <div class="col">
                <div class="stats_box_wrap">
                  <div class="stat_color_blue">
                    <div class="row">
                      <h3 class="stat_head">Bill of Lading</h3>
                    </div>
                  </div>
                  <div class="stats_wrap">
                    <div class="row">
                      <div class="col-6">
                        <p class="stat_text">First Draft</p>
                        <p class="stat_text">Final</p>
                      </div>
                      <div class="col-6">
                        <p class="stat_text_val">0</p>
                        <p class="stat_text_val">0</p>
                      </div>
                    </div>
                  </div>
                </div>
              </div>
            </div>
            <div class="table-responsive" id="enquiryTableContId" >
              <table id="Enquiry_table" class="row-border table_fontsize " style="width:100%;">
                <!-- " -->
                
                <thead>
                  <tr>
                    <th>Origin</th>
                    <th>Destination</th>
                    <th>Importer/Exporter</th>
                    <th>Enquiry Date</th>
                    <th>Cargo Category</th>
                    <th>FCL/LCL</th>
                    <th>Containers</th>
                    <th>Weight(Kgs)</th>
                    <th>Volume(CBM)</th>
                    <th>Cargo Ready Date</th>
                    <th>Status</th>
                    <th align="center">Action</th>
                  </tr>
                </thead>
              </table>
            </div>
            <div class="table-responsive" id="bookingTableContId" style="display:none;">
              <table id="Booking_table" class="row-border table_fontsize " style="width:100%">
                <thead>
                  <tr>
                    <th>Origin</th>
                    <th>Destination</th>
                    <th>Importer/Exporter</th>
                    <th>Booking Date</th>
                    <th>Booking Ref</th>
                    <th>Cut Off Date</th>
                    <th align="center">Status</th>
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
</div>
<!--   container-fluid --> 

<!-- Update Schedule Modal-->
<div id="update_schedule" class="modal fade modal-fullscreen" tabindex="-1" role="dialog" aria-labelledby="myLargeModalLabel" aria-hidden="true">
  <div class="modal-dialog modal-dialog-centered modal-xxl">
    <div class="modal-content">
     <form method="post" id="submit-schedule-data">
      <div class="modal-header modal-header-spl">
        <h5 class="modal-title">Update Schedule</h5>
        <button type="button" class="close btn_close" data-dismiss="modal" aria-label="Close"> <span aria-hidden="true">&times;</span> </button>
      </div>
      <div class="modal-body">
        <div class="row mt-0" id="">
          <input type="hidden" id="schForwEnquiryId" name="schForwEnquiryName" value="">
          <input type="hidden" id="schEnquiryReferenceId" name="schEnquiryReferenceName" value="">
          <div class="form-group col-md-3">
            <label class="form-label-new">Origin: </label>
            <input type="text" class="form-control font14" id="orgScheduleUpdInputId" readonly>
          </div>
          <div class="form-group col-md-3">
            <label class="form-label-new">Destination: </label>
            <input type="text" class="form-control font14" id="destScheduleUpdInputId" readonly>
          </div>
          <div class="form-group col-md-2">
            <label class="form-label-new" for="scheduleTypeName">Schedule Type:</label>
            <select class="form-control font14" name="scheduleTypeName" id="scheduleType">
              <option value="Direct">Direct</option>
              <option value="Transhipment">Transhipment</option>
            </select>
          </div>
          <div class="form-group col-md-1 pr-0" style="display:none;" id="legsDivId">
            <label class="form-label-new" for="legs">Legs:</label>
            <select class="form-control font14" name="legs" id="legsId">
              <option value="1">1</option>
              <option value="2">2</option>
              <option value="3">3</option>
              <option value="4">4</option>
            </select>
          </div>
          <div class="form-group col-md-2">
            <label class="form-label-new">Cut Off Date: </label>
            <input type="text" class="form-control font14" id="cutOffDateId" onkeypress="return isNotAllowKey(event,this)" required>
          </div>
          <br>
          <br>
          <div class="table-responsive">
            <table id="scheduleTable" class="table row-border  table_fontsize" style="width:100%">
              <thead>
                <tr>
                  <th>Origin</th>
                  <th>Destination/Transhipment</th>
                  <th>Mode</th>
                  <th>Carrier</th>
                  <th>Vessel</th>
                  <th>Voyage</th>
                  <th>ETD</th>
                  <th>ETA</th>
                  <th>Transit Time</th>
                </tr>
              </thead>
              <tbody>
                <tr>
                  <td><input type="text" class="form-control font14" name="origin" id="origin1" readonly required></td>
                  <td><input type="text" class="form-control font14" name="destination" id="destination1" readonly required></td>
                  <td><select class="form-control font14" name="mode" id="mode1" onchange="changeCarrierInput('mode1','carrier1','carrierdrop1');" >
                      <option value="Sea">Sea</option>
                      <option value="Road">Road</option>
                      <option value="Train">Train</option>
                      <option value="Air">Air</option>
                    </select></td>
                  <td><input type="text" class="form-control font14 widthp250" name="carrier" id="carrier1" style="display:none;" >
                    <select class="form-control font14 widthp250" name="carrier" id="carrierdrop1" >
                    </select></td>
                  <td><input type="text" class="form-control font14 capitalize" name="vessel" id="vessel1" autocomplete="off" required></td>
                  <td><input type="text" class="form-control font14 capitalize" name="voyage" id="voyage1" autocomplete="off" required></td>
                  <td><input type="text" class="form-control font14 datetime caltd widthp120" name="etd" id="etd1" autocomplete="off" onkeypress="return isNotAllowKey(event,this)" required></td>
                  <td><input type="text" class="form-control font14 datetime caltd widthp120" name="eta" id="eta1" autocomplete="off" onkeypress="return isNotAllowKey(event,this)" required></td>
                  <td><input type="text" class="form-control font14 widthp110" name="transittime" id="transittime1" readonly required></td>
                </tr>
              </tbody>
            </table>
          </div>
        </div>
      </div>
      <div class="modal-footer ">
        <fieldset class="w-100">
          <!-- <button type="submit" class="btn btn-theme float-right" value="Submit"  onclick="getScheduleData();">Submit</button>    -->   
          <button type="submit" class="btn btn-theme float-right" value="Submit">Submit</button>      
        </fieldset>
      </div>
      </form>
    </div> 
  </div>
</div>
<!-- Update Schedule Modal--> 

<!-- Charges Modal-->
<div id="update_charges" class="modal fade" tabindex="-1" role="dialog" aria-labelledby="myLargeModalLabel" aria-hidden="true">
  <div class="modal-dialog modal-xxl" role="document">
   <form method="post" id="submit-charges-data"> 
    <div class="modal-content">
      <div class="modal-header modal-header-spl">
        <h5 class="modal-title">Update Charges</h5>
        <button type="button" class="close btn_close" data-dismiss="modal" aria-label="Close"> <span aria-hidden="true">&times;</span> </button>
      </div>
      <div class="modal-body">
        <div class="row mt-0" id="">
         <input type="hidden" id="chargeForwEnquiryId" name="chargeForwEnquiryName" value="">
         <input type="hidden" id="chargeEnquiryReferenceId" name="chargeEnquiryReferenceName" value="">
         <input type="hidden" id="chargeShipmentTypeId" name="chargeShipmentTypeName" value="">         
          <div class="col-lg-6 col-sm-12 mt-2">
            <div class="row">
              <div class="col-md-4">
                <label for="" class="form-label-new">Origin</label>
              </div>
              <div class="col-md-7">
                <input type="text" class="form-control font14" name="" id="orgChargesUpdInputId" readonly required>
              </div>
            </div>
          </div>
          <div class="col-lg-6 col-sm-12 mt-2">
            <div class="row">
              <div class="col-md-4">
                <label for="" class="form-label-new">Destination</label>
              </div>
              <div class="col-md-7">
                <input type="text" class="form-control font14" name="" id="destChargesUpdInputId" readonly required>
              </div>
            </div>
          </div>
          <div class="col-lg-6 col-sm-12 mt-2">
            <div class="row">
              <div class="col-md-4">
                <label for="" class="form-label-new">Valid Date From</label>
              </div>
              <div class="col-md-7">
                <input type="text" class="form-control font14 datepicker" name="" id="chrgFrom" autocomplete="off" onkeypress="return isNotAllowKey(event,this)" required>
              </div>
            </div>
          </div>
          <div class="col-lg-6 col-sm-12 mt-2">
            <div class="row">
              <div class="col-md-4">
                <label for="" class="form-label-new">Valid Date To</label>
              </div>
              <div class="col-md-7">
                <input type="text" class="form-control font14 " name="" id="chrgTo" autocomplete="off" onkeypress="return isNotAllowKey(event,this)" required>
              </div>
            </div>
          </div>
          <div class="col-lg-6 col-sm-12 mt-2">
            <div class="row">
              <div class="col-md-4">
                <label for="" class="form-label-new">Total USD Amount</label>
              </div>
              <div class="col-md-7">
                <input type="text" class="form-control font14" name="" id="totalUsdAmount" readonly>
              </div>
            </div>
          </div>
          <div class="col-lg-6 col-sm-12 mt-2">
            <div class="row">
              <div class="col-md-4">
                <label for="" class="form-label-new">Total INR Amount</label>
              </div>
              <div class="col-md-7">
                <input type="text" class="form-control font14" name="" id="totalInrAmount" readonly>
              </div>
            </div>
          </div>
          <div class="col-lg-6 col-sm-12 mt-2">
            <div class="row">
              <div class="col-md-4">
                <label for="" class="form-label-new">Terms of Shipment</label>
              </div>
              <div class="col-md-7">
                <select class="form-control font14 widthp186" id="chrgIncotermId" name="chrgIncoterm" required> 
                </select>
              </div>
            </div>
            <div class="row mt-1" id="divWeightInput">
              <div class="col-md-4">
                <label for="" class="form-label-new">Weight (Kgs)</label>
              </div>
              <div class="col-md-7" >
                <input type="text" class="form-control font14" name="" id="weightId" autocomplete="off" readonly>
              </div>
            </div>
            <div class="row mt-2" id="divVolumeInput">
              <div class="col-md-4">
                <label for="" class="form-label-new">Volume (CBM)</label>
              </div>
              <div class="col-md-7">
                <input type="text" class="form-control font14" name="" id="volumeId" autocomplete="off" readonly>
              </div>
            </div>
          
          <div class="row mt-2" id="divContainersInput">
              <div class="col-md-4">
                <label for="" class="form-label-new">Containers</label>
              </div>
              <div class="col-md-7">
                <input type="text" class="form-control font14" name="" id="containersId" autocomplete="off" readonly>
              </div>
            </div>
          </div>
          <div class="col-lg-6 col-sm-12 mt-2">
            <div class="row">
              <div class="col-md-4">
                <label for="" class="form-label-new">Remarks</label>
              </div>
              <div class="col-md-4">
                <textarea class="form-control font14 widthp186" name="" id="remark"></textarea>
              </div>
            </div>
          </div>
          
          <br> <br><br> <br>
              <div class="table-responsive mt-3" style="max-height: 250px; overflow-x: auto;" >
                <table  class="table row-border table_fontsize" style="width:100%" id="chrgTable">
                  <thead>
                    <tr>
                      <th>Charge Grouping</th>
                      <th>Charge Type</th>                     
                      <th>Select Currency</th>
                      <th>Rate</th>
                      <th>Basis</th>
                      <th>Quantity</th>
                      <th>Total Amount</th>
                      <th><button type="button" href="javascript:void(0);"  id="addMore" class="addRow"><i class="fas fa-plus"></i></button></th>
                    </tr>
                  </thead>
                  <tbody >
                    <tr id="uploadrow_0">
                      <td><select class="form-control font14 widthp180" id="chrgGroId_0" name="chrgGro[]" onchange="getChargeGroupingVal(this);" required> </select></td>
                      <td><select class="form-control font14 widthp140" id="chrgTypeId_0" name="chrgTyp[]" required> </select></td>                        
                      <td><select class="form-control font14" id="currency_0" name="currency[]" required>
                          <option>INR</option>
                          <option>USD</option>
                        </select></td>
                      <td><input type="text" style="text-align: right;" class="form-control font14 inputwidth100" id="rate_0" name="rate[]" id="rate" onkeyup="twoDecimalAllow(this);" oninput="calculateFTV(event,this)" autocomplete="off" required></td>
                      <td><select class="form-control font14 widthp140" id="basis_0" name="chrgBasis[]" onchange="getBasisVal(this);" required>
                          <!-- 
                          <option value="PER20FT">Per 20' Container</option>   
                          <option value="PER40FT">Per 40' Container</option>
                          <option value="PER40FTHC">Per 40' HC Container</option> 
                          <option value="PER45FTHC">Per 45' HC Container</option>   
                          <option value="PERDOC">Per Document</option>  
                          <option value="PERWEIGHT">Per Weight (Tons)</option>  
                          <option value="PERVOLUME">Per volume (CBM)</option>
                          <option value="PERWM">Per W/M</option>    
                          -->            
                        </select></td>
                      <td><input type="text" style="text-align: right;" class="form-control font14 widthp95" id="quant_0" name="quant[]" oninput="calculateFTV(event,this)" autocomplete="off" required></td>
                      <td><input type="text" style="text-align: right;" class="form-control font14 inputwidth100" id="FTV_0" name="FTV[]" readonly></td>
                      <td><button type="button" href='javascript:void(0);'  class='remove remRow'><i class="fas fa-trash-alt"></i></button></td>
                    </tr>
                  </tbody>
                </table>
              </div>
            
        </div>
      </div>
      <div class="modal-footer ">
        <fieldset class="w-100">
          <button type="submit" class="btn btn-theme float-right" value="Submit">Submit</button>
          <!-- <button type="submit" class="btn btn-theme float-right" value="Submit"  onclick="getChargesData();">Submit</button>  -->         
        </fieldset>
      </div>
    </div>
   </form>
  </div>
</div>
<!-- Charges Modal--> 

<!-- View PDF Modal-->
<div id="view_enq_schedule_charges_details" class="modal fade" tabindex="-1" role="dialog" aria-labelledby="myLargeModalLabel" aria-hidden="true">
  <div class="modal-dialog modal-dialog-scrollable modal-dialog-centered modal-lg">
    <div class="modal-content">
      <div class="modal-header modal-header-spl">
        <h5 class="modal-title">Enquiry Details</h5>
        <button type="button" class="close btn_close" data-dismiss="modal" aria-label="Close"> <span aria-hidden="true">&times;</span> </button>
      </div>
      <div class="modal-body" style="overflow-x: auto; height: 600px;">
      
      <!-- body code start -->
       <div class="row">
          <div class="col-md-12">
            <lable class="bookingmodal_label">Enquiry Reference</lable>
            <label class="bookingmodal_label_val" id="enqReffLbl"> </label>
            <div class="table-responsive">
              <table class="table booking_modal_table table-bordered">
                <thead>
                  <tr>
                    <th class="text-left">Cargo Category</th>
                    <th class="text-left">FCL/LCL</th>                  
                    <th class="text-left">Enquiry Status</th>
                  </tr>
                </thead>
                <tbody>
                  <tr>
                    <td class="text-left"><label id="enqCargoCatLbl"></label></td>
                    <td class="text-center"><label id="enqFclLclLbl"></label></td>                   
                    <td class="text-center"><label id="enqEnquiryStatusLbl"></label></td>
                  </tr>
                </tbody>
              </table>
            </div>
            <lable class="bookingmodal_label">Schedule Details</lable>
            <div class="table-responsive">
              <table class="table booking_modal_table modal_table_padd table-bordered mb-4">
                <thead>
                  <tr>               
                    <th class="text-left">Origin</th>
                    <th class="text-left">Destination</th>
                    <th class="text-left">Schedule Type</th>
                    <th class="text-left">No of Legs</th>
                  </tr>
                </thead>
                <tbody>
                  <tr>
                    <td class="text-left"><label id="enqOriginLbl"></label></td>
                    <td class="text-left"><label id="enqDestinationLbl"></label></td>
                    <td class="text-left"><label id="enqScheduleTypeLbl"></label></td>
                    <td class="text-right"><label id="enqNoOfLegsLbl"></label></td>                   
                  </tr>
                </tbody>
              </table>
            </div>
           
            <div class="table-responsive">
              <table class="table booking_modal_table modal_table_padd table-bordered mb-4" >
                <thead>
                  <tr>
                    <th class="text-left">Origin</th>
                    <th class="text-left">Destination</th>
                    <th class="text-left">Mode</th>
                    <th class="text-left">Carrier</th>
                    <th class="text-left">Vessel Name</th>
                    <th class="text-left">Voyage Name</th>
                    <th class="text-center">Transit Time</th>
                    <th class="text-center">ETD</th>
                    <th class="text-center">ETA</th>                  
                  </tr>
                </thead>
                <tbody id="tbodyEnquiryDetailsPopUpId">
                </tbody>
              </table>
            </div>
            <lable class="bookingmodal_label">Charges Summary</lable>
            <div class="table-responsive">
              <table class="table booking_modal_table table-bordered mb-4">
                <thead>
                 <tr>
			          <th class="text-left">Charges Grouping</th>
			          <th class="text-left">Charge Type</th>
			          <th class="text-left">Currency</th>
			          <th class="text-left">Rate</th>
			          <th class="text-left">Basis</th>
			          <th class="text-left">Quantity</th>
			          <th class="text-left">Total</th>
			    </tr>
                </thead>              
                  <tbody id="tbodyEnquiryChargesPopUpId">			                    			
			      </tbody>
              </table>
            </div>
            <lable class="bookingmodal_label">Total Charges</lable>
             <div class="table-responsive">
              <table class="table booking_modal_table table-bordered mb-4"> 
              <thead>
                 <tr>
                      <th class="text-left">Charges Summary</th>
			          <th class="text-left">USD</th>
			          <th class="text-left">INR</th>
			      </tr>                          
			      </thead>  
                  <tbody id = "tbodyEnqSummaryChargesPopUpId">	                                        			
			      </tbody>
              </table>
            </div>
            <div class="table-responsive">
              <table class="table booking_modal_table table-bordered mb-4">
                <thead>
                 <tr>
			          <th class="text-left">Terms of Shipment</th>
			    </tr>
                </thead>              
                  <tbody>	
                    <tr>
                      <td class="text-left"><label id="enqIncotermLbl"></label></td>
                    </tr>	                    			
			      </tbody>
              </table>
            </div>
            
          </div>
        </div>
      </div>
      <!-- body code end -->
      
    </div>
  </div>
</div>
<!-- View PDF Modal--> 

<!-- Booking Details Modal -->
<div class="modal" id="forwarder_booking_details" tabindex="-1" role="dialog" aria-labelledby="ModalTitle" aria-hidden="true">
  <div class="modal-dialog modal-dialog-centered modal-lg" role="document">
    <div class="modal-content">
      <div class="modal-header modal_hd_sec">
        <p class="h5 modal-title modal_hd" id="ModalTitle">Booking Details</p>
        <button type="button" class="close modal_close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
      </div>
      <div class="modal-body">
        <div class="row">
          <div class="col-md-12">
            <lable class="bookingmodal_label">Booking Reference</lable>
            <label class="bookingmodal_label_val" id="bkBookingReffLbl"></label>
            <div class="table-responsive">
              <table class="table booking_modal_table table-bordered">
                <thead>
                  <tr>
                    <th>Booked By</th>
                    <th>Cargo Ready Date</th>
                    <th>Date of Booking</th>
                    <th>Booking Status</th>
                  </tr>
                </thead>
                <tbody>
                  <tr>
                    <td><label id="bkBookByLbl"></label></td>
                    <td><label id="bkCargoReadyDateLbl"></label></td>
                    <td><label id="bkDateOfBookingLbl"></label></td>
                    <td><label id="bkBookingStatusLbl"></label></td>
                  </tr>
                </tbody>
              </table>
            </div>
            <div class="table-responsive">
              <table class="table booking_modal_table table-bordered mb-4">
                <thead>
                  <tr>
                    <th>Booking Party</th>
                  </tr>
                </thead>
                <tbody>
                  <tr>
                    <td><label id="bkBookingPartyLbl"></label></td>
                  </tr>
                </tbody>
              </table>
            </div>
            <lable class="bookingmodal_label">Schedule Details</lable>
            <div class="table-responsive">
              <table class="table booking_modal_table modal_table_padd table-bordered mb-4">
                <thead>
                  <tr>
                    <th>Booking Date</th>
                    <th>Origin</th>
                    <th>Destination</th>
                    <th>Cut-off Date</th>
                  </tr>
                </thead>
                <tbody>
                  <tr>
                    <td><label id="bkBookingDateLbl"></label></td>
                    <td><label id="bkOriginLbl"></label></td>
                    <td><label id="bkDestinationLbl"></label></td>
                    <td><label id="bkCutOffDateLbl"></label></td>
                  </tr>
                </tbody>
              </table>
            </div>
            
            <!-- <lable class="bookingmodal_label">Schedule Legs</lable> -->
            <div class="table-responsive">
              <table class="table booking_modal_table modal_table_padd table-bordered mb-4" >
                <thead>
                  <tr>
                    <th>Origin</th>
                    <th>Destination</th>
                    <th>Mode</th>
                    <th>Carrier</th>
                    <th>Vessel Name</th>
                    <th>Voyage Name</th>
                    <th>Transit Time</th>
                    <th>ETD</th>
                    <th>ETA</th>
                  </tr>
                </thead>
                <tbody id="tbodyBookingDetailsPopUpId">
                </tbody>
              </table>
            </div>
            <lable class="bookingmodal_label">Charges Summary</lable>
		    <div class="table-responsive">
			  <table class="table booking_modal_table table-bordered mb-4 text-center">
			    <thead>
			       <tr>
			         <th>Charges Grouping</th>
			         <th>Charge Type</th>
			         <th>Currency</th>
			         <th>Rate</th>
			         <th>Basis</th>
			         <th>Quantity</th>
			         <th>Total</th>
			         </tr>
			    </thead>
			    <tbody id="tbodyBookingChargesPopUpId">			                    			
			    </tbody>
			   </table>
		    </div>
		    <lable class="bookingmodal_label">Total Charges</lable>
             <div class="table-responsive">
              <table class="table booking_modal_table table-bordered mb-4"> 
              <thead>
                 <tr>
                      <th>Charges Summary</th>
			          <th class="text-right">USD</th>
			          <th class="text-right">INR</th>
			      </tr>                          
			      </thead>  
                  <tbody id="tbodyBkSummaryChargesPopUpId">	
                    <!-- <tr>                     
                     <td class="text-center"><label id="">Freight Charges</label></td>
                      <td class="text-center"><label id="bkTotalChargeUsdLbl"></label></td>
                      <td class="text-center"><label id="bkTotalChargeInrLbl"></label></td>
                    </tr>	 -->                    			
			      </tbody>
              </table>
             </div>
		    <div class="table-responsive">
              <table class="table booking_modal_table table-bordered mb-4">
                <thead>
                 <tr>
			          <th>Terms of Shipment</th>
			    </tr>
                </thead>              
                  <tbody>	
                    <tr>
                      <td><label id="bkIncotermLbl"></label></td>
                    </tr>	                    			
			      </tbody>
              </table>
            </div>
            <div class="table-responsive">
              <table class="table booking_modal_table table-bordered mb-4">
                <thead>
                  <tr>
                    <th>Destination Requirements Information</th>
                  </tr>
                </thead>
                <tbody>
                  <tr>
                    <td><label id="bkDestReqInfoLbl"></label></td>
                  </tr>
                </tbody>
              </table>
            </div>
          </div>
        </div>
      </div>
    </div>
  </div>
</div>
<!-- Booking Details Modal --> 

 <script src="http://code.jquery.com/ui/1.10.2/jquery-ui.js" ></script> 
 
<script>

if ( window.history.replaceState ) {
    window.history.replaceState( null, null, window.location.href );
 }

/* Customer */
function moreCustomerItems() {

  $(".customer-hidden-item").show();
  $(".more_link ").hide();
  $(".less_link").show();
}

function lessCustomerItems() {
  $(".customer-hidden-item").hide();
  $(".more_link ").show();
  $(".less_link").hide();
}
/* Customer */

/* Origin */

function moreOriginItems() {

  $(".origin-hidden-item").show();
  $(".more_linkO ").hide();
  $(".less_linkO").show();
}

function lessOriginItems() {
  $(".origin-hidden-item").hide();
  $(".more_linkO ").show();
  $(".less_linkO").hide();
}

/* Origin */

/* Destination */
function moreDestinationItems() {

  $(".destination-hidden-item").show();
  $(".more_linkD ").hide();
  $(".less_linkD").show();
}

function lessDestinationItems() {
  $(".destination-hidden-item").hide();
  $(".more_linkD").show();
  $(".less_linkD").hide();
}
/* Destination */

</script> 
<script> 
    $(document).ready(function () {
      $('input[name="shipport"]').click(function () {
        var shipport = $("input[name='shipport']:checked").val();
        if (shipport == "DIRECT") {
          $("#viaportDivId").hide();
        } else {
          $("#viaportDivId").show();
        }
      });

    });
    </script> 
    <!--   Viaport Table --> 
    <!--   Update Schedule --> 
    <script type = "text/javascript">
     $(document).ready(function () {
        /*schedule code start*/
        var scheduleType = $('#scheduleType option:selected').val();
        if (scheduleType == 'Direct') {
          $("#legsId").prop("disabled", true);
        }

        $("#scheduleType").change(function () {
          var scheduleDropType = $('#scheduleType option:selected').val();
          var cutOffDate = $('#cutOffDateId').val();
          
          if (scheduleDropType == 'Direct') {

           	$("#legsDivId").hide();
            $('#scheduleTable tbody').empty();
            var modeid = "mode1";
            var carrierid = "carrier1";
            var carrierdropid = "carrierdrop1";

            var origin = $('#orgScheduleUpdInputId').val();
            var destination = $('#destScheduleUpdInputId').val();

            var options = '<option value="0">Choose Carrier</option>';
            for (var key in carriers) {
              options = options + '<option value=' + key + '>' + carriers[key] + '</option>';
            }

            var markup = '<tr>'
              + '<td><input type="text" class="form-control font14 caltd" name="origin" id="origin1" value="' + origin + '" readonly style="z-index:999;" required></td>'
              + '<td><input type="text" class="form-control font14 caltd" name="destination" id="destination1" value="' + destination + '" readonly style="z-index:999;" required></td>'
              + '<td><select class="form-control font14 caltd" name="mode" id="mode1" onchange="changeCarrierInput(\'' + modeid + '\',\'' + carrierid + '\',\'' + carrierdropid + '\');">'
              + '<option value="Sea">Sea</option>'
              + '<option value="Road">Road</option>'
              + '<option value="Train">Train</option>'
              + '<option value="Air">Air</option>'
              + '</select></td>'
              + '<td><input type="text" class="form-control font14 widthp250" name="carrier" id="carrier1" style="display:none;">'
              + '<select class="form-control font14 caltd widthp250" name="mode" id="carrierdrop1">' + options + '</select></td>'
              + '<td><input type="text" class="form-control font14 capitalize" name="vessel" id="vessel1" required></td>'
              + '<td><input type="text" class="form-control font14 capitalize" name="voyage" id="voyage1" required></td>'
              + '<td><input type="text" class="form-control font14 datetime caltd datetime_etd widthp120" value="'+cutOffDate+'" name="etd" id="etd1" autocomplete="off" onkeypress="return isNotAllowKey(event,this)" required></td>'
              + '<td><input type="text" class="form-control font14 datetime caltd datetime_eta widthp120" name="eta" id="eta1" autocomplete="off" onkeypress="return isNotAllowKey(event,this)" required></td>'
              + '<td><input type="text" class="form-control font14 widthp110" name="transittime" id="transittime1" readonly required></td>'
              + '</tr>';

            $("#scheduleTable tbody").append(markup);
        	
            $('.datetime_etd').datetimepicker({
              format: 'DD-MMM-YYYY',
              minDate: moment(),  
            });
            $('.datetime_eta').datetimepicker({
                format: 'DD-MMM-YYYY',
                useCurrent: false  
              });

            if(cutOffDate != ''){
            	$('.datetime_etd').data("DateTimePicker").minDate(cutOffDate);
            	$('.datetime_eta').data("DateTimePicker").minDate(cutOffDate);
             }
            
            
            $("#legsId").prop("disabled", true);

            $("#etd1").on("dp.change", function (e) {
            	$('#eta1').data("DateTimePicker").minDate(e.date);
            	$('#etd1').data("DateTimePicker").minDate(e.date);
         	  
        	    var index = this.id.charAt(this.id.length - 1);
      		    var etdDate = $('#etd'+index).val();
      		    var etaDate = $('#eta'+index).val();
      		    var Date = $('#eta'+index).val();	
      		
      		  if(etdDate != "" && etaDate != ""){  
      			var future = moment(etaDate);
      			var start = moment(etdDate);
      			var d = future.diff(start, 'days');			
      			$('#transittime'+index).val(d);
      		  }			
      	  });

            $("#eta1").on("dp.change", function (e) {
            	$('#etd1').data("DateTimePicker").maxDate(e.date);
        	    var index = this.id.charAt(this.id.length - 1);
      		    var etdDate = $('#etd'+index).val();
      		    var etaDate = $('#eta'+index).val();	
      		
      		  if(etdDate != "" && etaDate != ""){  
      			var future = moment(etaDate);
      			var start = moment(etdDate);
      			var d = future.diff(start, 'days');			
      			$('#transittime'+index).val(d);
      		  }			
      	  });
   
          } else {
        	$("#legsDivId").show();
        	$('#legsId').trigger("change");
            $("#legsId").prop("disabled", false);

          }

        });

        $("#legsId").change(function () {
          $('#scheduleTable tbody').empty();

          var cutOffDate = $('#cutOffDateId').val();
          var rowsCount = $('#legsId option:selected').val();
          var markup = '';
          var index = 1;

          var origin = $('#orgScheduleUpdInputId').val();
          var destination = $('#destScheduleUpdInputId').val();

          for (var i = 0; i <= rowsCount; i++) {
            var modeid = "mode" + index;
            var carrierid = "carrier" + index;
            var carrierdropid = "carrierdrop" + index;

            var etdVal = '';
            if(i==0){
            	etdVal = cutOffDate;
            }
            
            var options = '<option value="0">Choose Carrier</option>';
            for (var key in carriers) {
              options = options + '<option value=' + key + '>' + carriers[key] + '</option>';
            }

            var originVal = '';
            var destinationVal = '';
            var orgReadOnlyStatus = '';
            var destReadOnlyStatus = '';
            if (i == 0) {
              originVal = origin;
            }
            orgReadOnlyStatus = "readonly";
            if (i == rowsCount) {
              destinationVal = destination;
              destReadOnlyStatus = "readonly";
            }

            markup = markup + '<tr>'
              + '<td><input type="text" class="form-control font14 caltd" name="origin" id="origin' + index + '" value="' + originVal + '" ' + orgReadOnlyStatus + ' style="z-index:999;" required></td>'
              + '<td><input type="text" class="form-control font14 caltd" name="destination" id="destination' + index + '" value="' + destinationVal + '" ' + destReadOnlyStatus + ' style="z-index:999;" required></td>'
              + '<td><select class="form-control font14" name="mode" id="mode' + index + '" onchange="changeCarrierInput(\'' + modeid + '\',\'' + carrierid + '\',\'' + carrierdropid + '\');">'
              + '<option value="Sea">Sea</option>'
              + '<option value="Road">Road</option>'
              + '<option value="Train">Train</option>'
              + '<option value="Air">Air</option>'
              + '</select></td>'
              + '<td><input type="text" class="form-control font14 caltd widthp250" name="carrier" id="carrier' + index + '" style="display:none;">'
              + '<select class="form-control font14 caltd widthp250" name="mode" id="carrierdrop' + index + '" >' + options + '</select></td>'
              + '<td><input type="text" class="form-control font14 capitalize" name="vessel" id="vessel' + index + '" autocomplete="off" required></td>'
              + '<td><input type="text" class="form-control font14 capitalize" name="voyage" id="voyage' + index + '" autocomplete="off" required></td>'
              + '<td><input type="text" class="form-control font14 datetime caltd datetime_etd widthp120" value="'+etdVal+'" name="etd" id="etd' + index + '" autocomplete="off" onkeypress="return isNotAllowKey(event,this)" required></td>'
              + '<td><input type="text" class="form-control font14 datetime caltd datetime_eta widthp120" name="eta" id="eta' + index + '" autocomplete="off" onkeypress="return isNotAllowKey(event,this)" required></td>'
              + '<td><input type="text" class="form-control font14 widthp110" name="transittime" id="transittime' + index + '" readonly required></td>'
              + '</tr>';

            index++;
          }

          
          $("#scheduleTable tbody").append(markup);
          
          $('.datetime_etd').datetimepicker({
            format: 'DD-MMM-YYYY',
            minDate: moment(),               
          });
          $('.datetime_eta').datetimepicker({
              format: 'DD-MMM-YYYY',
              useCurrent: false               
          });

          if(cutOffDate != ''){
           	 $('.datetime_etd').data("DateTimePicker").minDate(cutOffDate);
          	 $('.datetime_eta').data("DateTimePicker").minDate(cutOffDate);
           }

          $("#etd1, #etd2, #etd3, #etd4, #etd5").on("dp.change", function (e) {
        	    var index = this.id.charAt(this.id.length - 1);        	    
      		    var etdDate = $('#etd'+index).val();
      		    var etaDate = $('#eta'+index).val();
      		    
      		  if(etdDate != "" && etaDate != ""){  
      			var future = moment(etaDate);
      			var start = moment(etdDate);
      			var d = future.diff(start, 'days');			
      			$('#transittime'+index).val(d);
      		  }			
      		  $('#eta'+index).data("DateTimePicker").minDate(e.date);    
     	      $('#etd'+index).data("DateTimePicker").minDate(e.date);
      	  });

          $("#eta1, #eta2, #eta3, #eta4, #eta5").on("dp.change", function (e) {
        	    var index = this.id.charAt(this.id.length - 1);
        	    let ind = this.id.charAt(this.id.length - 1);
        	    var newIndex = ++ind;
        	    
        		var etdDate = $('#etd'+index).val();
        		var etaDate = $('#eta'+index).val();	
        		$('#etd'+newIndex).val(etaDate);
        		
        		if(etdDate != "" && etaDate != ""){  
        			var future = moment(etaDate);
        			var start = moment(etdDate);
        			var d = future.diff(start, 'days');			
        			$('#transittime'+index).val(d);
        		}		        		
        		$('#eta'+newIndex).data("DateTimePicker").minDate(e.date);
        	    $('#etd'+newIndex).data("DateTimePicker").minDate(e.date);	
          });

          $('#destination1, #destination2, #destination3, #destination4, #destination5').autocomplete({
    	 		source: function(search,success) {
    	 		    $.ajax({
    	 		      url : server_url+'utility/getAllLocation?location='+search.term,
    	 		      headers: authHeader,
    	 		      method: 'GET',
    	 		      dataType: 'json',
    	 		      data: null,
    	 		      success: function(data) {
    	 		        success(getLocationList(data.respData));
    	 		      }
    	 		    });
    	 		  },
    	 		 select: function (event, ui) {
    	 		    var label = ui.item.label;
    	 		    var value = ui.item.value;
    	 		    let index = this.id.charAt(this.id.length - 1);
    	 		    var newIndex = ++index;
                    $('#origin'+newIndex).val(value); 
    	 		}
    	 	});	
          
        });

      });


   /*  function getScheduleData() {

      $('#loader').show();	
    	
      var table = $('#scheduleTable').DataTable()

      var enquiryId = $('#schForwEnquiryId').val();
      var org = $('#orgScheduleUpdInputId').val();
      var dest = $('#destScheduleUpdInputId').val();
      var scheduleType = $('#scheduleType option:selected').val();
      var legsCount = $('#legsId option:selected').val();
      var cutoffdate = $('#cutOffDateId').val();

      var mainRequest = {};

      mainRequest['enquiryid'] = enquiryId;
      mainRequest["origin"] = org;
      mainRequest["destination"] = dest;
      mainRequest["scheduletype"] = scheduleType;
      mainRequest["legscount"] = legsCount;
      mainRequest["cutoffdate"] = cutoffdate;

      var fieldNames = [],
        json = []

      fieldNames.push("origin");
      fieldNames.push("destination");
      fieldNames.push("mode");
      fieldNames.push("carrier");
      fieldNames.push("vessel");
      fieldNames.push("voyage");
      fieldNames.push("etddate");
      fieldNames.push("etadate");
      fieldNames.push("transittime");


      var rowCount = $('#scheduleTable tr').length;
      for (var i = 1; i < rowCount; i++) {
        var item = {}
        for (var index = 0; index < 9; index++) {

          switch (index) {
            case 0:
              var scheduleType = $('#scheduleType option:selected').val()
              item[fieldNames[index]] = $('#origin' + i).val();
              break;
            case 1:
              item[fieldNames[index]] = $('#destination' + i).val();
              break;
            case 2:
              item[fieldNames[index]] = $('#mode' + i + ' option:selected').val();
              break;
            case 3:
              var mode = $('#mode' + i + ' option:selected').val()
              if (mode == "Sea") {
                item[fieldNames[index]] = $('#carrierdrop' + i + ' option:selected').val();
              } else {
                item[fieldNames[index]] = $('#carrier' + i).val();
              }
              break;
            case 4:
              item[fieldNames[index]] = $('#vessel' + i).val();
              break;
            case 5:
              item[fieldNames[index]] = $('#voyage' + i).val();
              break;
            case 6:
              item[fieldNames[index]] = $('#etd' + i).val();
              break;
            case 7:
              item[fieldNames[index]] = $('#eta' + i).val();
              break;
            case 8:
              item[fieldNames[index]] = $('#transittime' + i).val();
              break;

          }


        }
        json.push(item)

      }
      mainRequest["addScheduleLegsRequest"] = json;
      console.log(mainRequest)

      $('#loader').hide();
      submitScheduleData(mainRequest);

    } */

    function submitScheduleData(mainRequest) {
    	$('#loader').show();
      var scheduledata = JSON.stringify(mainRequest);

      $.ajax({
        type: 'POST',
        url: server_url + 'forwarder/addSchedule/' + userInfo.id,
        headers: authHeader,
        processData: false,
        contentType: "application/json; charset=utf-8",
        data: scheduledata,

        success: function (response) {
          if (response.respCode == 1) {
        	 $('#loader').hide();
            successBlock("#success_block", response.respData.msg);
            $('#update_schedule').modal('hide');          
            var shipmentType = $('#shipmenttypefilter').val();        
	        getForwarderBookingCountByStatus(userInfo.id,shipmentType);
	    	getForwarderEnquiryCountByStatus(userInfo.id,shipmentType);
	    	getForwarderEnquiryDetailsAllList(userInfo.id,shipmentType,"");
	    	   
          } else {
            errorBlock("#error_block", response.respData)
          }
          $('#loader').hide();
        },
        error: function (error) {
          console.log(error)
          if (error.responseJSON != undefined) {
            errorBlock("#error_block", error.responseJSON.respData);
            swal(error.responseJSON.respData);
          } else {
            errorBlock("#error_block", "Server Error! Please contact administrator");
          }
          $('#loader').hide();
        }
      })


    }

    function changeCarrierInput(modeid, carrierid, carrierdropid) {
      var selectValue = $('#' + modeid + ' option:selected').val();
      if (selectValue == "Sea") {
        $('#' + carrierid).hide();
        $('#' + carrierdropid).show();
      } else {
        $('#' + carrierid).show();
        $('#' + carrierdropid).hide();
      }
    }

    <!--   Update Schedule --> 

    function getAllChargeGrouping() {

      $.ajax({

          type: 'GET',
          contentType: "application/json",
          url: server_url + 'utility/getChargeGrouping',
          data: null
        })
        .done(function (response) {
          try {

            var options = '';
            if (response != null && response.respData.length != 0) {
              for (i = 0; i < response.respData.length; i++) {
                var groupText = response.respData[i].chargesgrouping;
                var groupValue = response.respData[i].id;
                options = options + '<option value=' + groupValue + '>' + groupText + '</option>';
              }

              $('#chrgGroId_0').empty();
              $('#chrgGroId_0').append(options);
              var groupingChargeId = $('#chrgGroId_0').val();
              var index = 0;
              var setIndex = 0;
              getAllChargesSubType(index, groupingChargeId,setIndex);

            } else {
              $('#chrgGroId_0').append(options);

            }

          } catch (err) {
            console.log(response.respData);
          }
        })
        .fail(function (err) {
          console.log("Failed");
        });
    }

    function getAllChargesSubType(index, groupingChargeId,setIndex) {

      $.ajax({

          type: 'GET',
          contentType: "application/json",
          url: server_url + 'utility/getChargesSubTypeById',
          data: "groupingChargeId=" + groupingChargeId,
        })
        .done(function (response) {
          try {

            var options = '';
            if (response != null && response.respData.length != 0) {
              for (i = 0; i < response.respData.length; i++) {
                var chargeTypeText = response.respData[i].chargecodedescription;
                var chargeTypeValue = response.respData[i].id;
                var selected = '';
                if(chargeTypeValue == setIndex){
                	selected = 'selected';
                }
                options = options + '<option value=' + chargeTypeValue + ' '+selected+'>' + chargeTypeText + '</option>';
              }
              $('#chrgTypeId_' + index).empty();
              $('#chrgTypeId_' + index).append(options);
            } else {
              $('#chrgTypeId_' + index).append(options);
            }

          } catch (err) {
            console.log(response.respData);
          }
        })
        .fail(function (err) {
          console.log("Failed");
        });
    }

    function getAllChargeBasis() {

        $.ajax({
            type: 'GET',
            contentType: "application/json",
            url: server_url + 'utility/getChargeBasis',
            data: null
          })
          .done(function (response) {
            try {

              var options = '';
              if (response != null && response.respData.length != 0) {
                for (i = 0; i < response.respData.length; i++) {
                  var basis = response.respData[i].basis;
                  var basiscode = response.respData[i].basiscode;
                  options = options + '<option value=' + basiscode + '>' + basis + '</option>';
                }
                $('#basis_0').empty();
                $('#basis_0').append(options);             
              } else {
                $('#basis_0').append(options);
              }

            } catch (err) {
              console.log(response.respData);
            }
          })
          .fail(function (err) {
            console.log("Failed");
          });
      }
    /* function getChargesData() {

      $('#loader').show();	
      var enquiryId = $('#chargeForwEnquiryId').val();

      var org = $('#orgChargesUpdInputId').val();
      var dest = $('#destChargesUpdInputId').val();
      var validdatefrom = $('#chrgFrom').val();
      var validdateto = $('#chrgTo').val();
      var remark = $('#remark').val();

      var mainRequest = {};

      mainRequest["enquiryid"] = enquiryId;
      mainRequest["origin"] = org;
      mainRequest["destination"] = dest;
      mainRequest["validdatefrom"] = validdatefrom;
      mainRequest["validdateto"] = validdateto;
      mainRequest["remark"] = remark;

      var fieldNames = [],
        json = [];

      fieldNames.push("chargegrouping");
      fieldNames.push("chargetype");
      fieldNames.push("currency");
      fieldNames.push("rate");
      fieldNames.push("basis");
      fieldNames.push("quantity");
      fieldNames.push("freighttotalval");

      var length = $('input[name^="rate"]').length;

      for (var i = 0; i < length; i++) {
        var item = {};
        var chargesGrouping = document.getElementsByName("chrgGro[]")[i].value;
        var chargeType = document.getElementsByName("chrgTyp[]")[i].value;
        var currency = document.getElementsByName("currency[]")[i].value;
        var rate = document.getElementsByName("rate[]")[i].value;
        var chrgBasis = document.getElementsByName("chrgBasis[]")[i].value;
        var quantity = document.getElementsByName("quant[]")[i].value;
        var freightTotalVal = document.getElementsByName("FTV[]")[i].value;
        
        for (var index = 0; index < 7; index++) {

          switch (index) {
            case 0:
              item[fieldNames[index]] = chargesGrouping;
              break;
            case 1:
              item[fieldNames[index]] = chargeType;
              break;
            case 2:
              item[fieldNames[index]] = currency;
              break;
            case 3:
              item[fieldNames[index]] = rate;
              break;
            case 4:
              item[fieldNames[index]] = chrgBasis;
              break;
            case 5:
              item[fieldNames[index]] = quantity;
              break;
            case 6:
              item[fieldNames[index]] = freightTotalVal;
              break;

          }
        }

        json.push(item)
      }

      mainRequest["addChargesTypeRequest"] = json;
      console.log(mainRequest);

      $('#loader').hide();
      submitChargeData(mainRequest);
    } */

    function submitChargeData(mainRequest) {
      var scheduleChargedata = JSON.stringify(mainRequest);

      $('#loader').show();
      $.ajax({
        type: 'POST',
        url: server_url + 'forwarder/addScheduleCharge/' + userInfo.id,
        headers: authHeader,
        processData: false,
        contentType: "application/json; charset=utf-8",
        data: scheduleChargedata,

        success: function (response) {
          if (response.respCode == 1) {
        	$('#loader').hide();
            successBlock("#success_block", response.respData.msg);
            $('#update_charges').modal('hide');
            var shipmentType = $('#shipmenttypefilter').val();
            getForwarderBookingCountByStatus(userInfo.id,shipmentType);
	    	getForwarderEnquiryCountByStatus(userInfo.id,shipmentType);
	    	getForwarderEnquiryDetailsAllList(userInfo.id,shipmentType,"");
          } else {
            errorBlock("#error_block", response.respData)
          }
          $('#loader').hide();
        },
        error: function (error) {
          console.log(error)
          if (error.responseJSON != undefined) {
            errorBlock("#error_block", error.responseJSON.respData);
            swal(error.responseJSON.respData);
          } else {
            errorBlock("#error_block", "Server Error! Please contact administrator");
          }
          $('#loader').hide();
        }
      })

    }

 </script> 

<!--   Tooltip --> 
<script>
$(document).ready(function(){
  $('[data-toggle="tooltip"]').tooltip({
	    trigger : 'hover'
  });   
});
</script> 
<!--   Tooltip --> 

<!--   Datetimepicker --> 
<script type="text/javascript">
$(function () {
  $('#etd1').datetimepicker({
    format: 'DD-MMM-YYYY',
    minDate: moment(),
    widgetPositioning: {
        horizontal: "auto",
        vertical: "auto"
      }
  });

  $('#eta1').datetimepicker({
	    format: 'DD-MMM-YYYY',
	    useCurrent: false, 
	    widgetPositioning: {
            horizontal: "auto",
            vertical: "auto"
          }
	  });
  $('#etd1, #eta5').datetimepicker({ 
	  widgetPositioning: {
          horizontal: "auto",
          vertical: "auto"
        }
  });
  $("#etd1").on("dp.change", function (e) {
	  $('#eta1').data("DateTimePicker").minDate(e.date);
		var etdDate = $('#etd1').val();
		var etaDate = $('#eta1').val();	
		
		if(etdDate != "" && etaDate != ""){  
			var future = moment(etaDate);
			var start = moment(etdDate);
			var d = future.diff(start, 'days');			
			$('#transittime1').val(d);
		}			
	}); 

  $("#eta1").on("dp.change", function (e) {
	  $('#etd1').data("DateTimePicker").maxDate(e.date);
		var etdDate = $('#etd1').val();
		var etaDate = $('#eta1').val();	
		
		if(etdDate != "" && etaDate != ""){  
			var future = moment(etaDate);
			var start = moment(etdDate);
			var d = future.diff(start, 'days');			
			$('#transittime1').val(d);
		}			
	}); 

  
});

$(function () {
  $('#cutOffDateId').datetimepicker({
    format: 'DD-MMM-YYYY',
    minDate: moment()
  });

  $("#cutOffDateId").on("dp.change", function (e) {
       var cutOffDate = $('#cutOffDateId').val();	
	   $('#etd1').val(cutOffDate);
	   $('#etd1').data("DateTimePicker").minDate(cutOffDate);
	   $('#eta1').data("DateTimePicker").minDate(cutOffDate);
	   
  });
  
});

</script> 
<script type="text/javascript">
   $(function () {
       $('#chrgFrom').datetimepicker({
    	   format: 'DD-MMM-YYYY',
    	   minDate : moment()
       });
       $('#chrgTo').datetimepicker({
    	   format: 'DD-MMM-YYYY',
   useCurrent: false //Important! See issue #1075
   });
       $("#chrgFrom").on("dp.change", function (e) {
           $('#chrgTo').data("DateTimePicker").minDate(e.date);
       });
       $("#chrgTo").on("dp.change", function (e) {
           $('#chrgFrom').data("DateTimePicker").maxDate(e.date);
       });
   });
</script> 
<!--   Datetimepicker --> 
<!--   Filter Datetimepicker --> 
<script type="text/javascript">
   $(function () {
	// Linked date and time picker 
		// start date date and time picker 
		$('#fdaterange1').datetimepicker({
	 	   format: 'DD-MMM-YYYY',
	 	   maxDate : moment(),
	 	   useCurrent: true 
	    });

		// End date date and time picker 
		$('#fdaterange2').datetimepicker({
			format: 'DD-MMM-YYYY',
			maxDate : moment(),
		    useCurrent: true 
		});
		
		// start date picke on chagne event [select minimun date for end date datepicker]
		$("#fdaterange1").on("dp.change", function (e) {
			$('#fdaterange2').data("DateTimePicker").minDate(e.date);

			var fromDate = $('#fdaterange1').val();
			var toDate = $('#fdaterange2').val();	
			
			if(fromDate != "" && toDate != ""){
                minDate = fromDate;
                maxDate = toDate;  
				filterme();
			}
		});
		// Start date picke on chagne event [select maxmimum date for start date datepicker]
		$("#fdaterange2").on("dp.change", function (e) {
			$('#fdaterange1').data("DateTimePicker").maxDate(e.date);
			
			var fromDate = $('#fdaterange1').val();
			var toDate = $('#fdaterange2').val();	
			
			if(fromDate != "" && toDate != ""){
				minDate = fromDate;
                maxDate = toDate;  
				filterme();
			}			
		});

   });

</script> 
<!--  Filter Datetimepicker --> 
<script>

$(function(){
    $('#addMore').on('click', function() {
    	var row = $("#chrgTable tr").last().clone();
        //row.id = row.id.slice(-1);
        var oldId = Number(row.attr('id').slice(-1));
        var id = 1 + oldId;
        row.attr('id', 'uploadrow_' + id );
      
        row.find('#chrgGroId_' + oldId).attr('id', 'chrgGroId_' + id);
        row.find('#chrgTypeId_' + oldId).attr('id', 'chrgTypeId_' + id);
        row.find('#currency_' + oldId).attr('id', 'currency_' + id);
        row.find('#rate_' + oldId).attr('id', 'rate_' + id);
        row.find('#basis_' + oldId).attr('id', 'basis_' + id);
        row.find('#quant_' + oldId).attr('id', 'quant_' + id);        
        row.find('#FTV_' + oldId).attr('id', 'FTV_' + id);
               
        $('#chrgTable').append(row);
        row.find("input").val('');
                     
     });
     $(document).on('click', '.remove', function() {
         var trIndex = $(this).closest("tr").index();
            if(trIndex>0) {
             $(this).closest("tr").remove();
           } else {
        	   swal("Sorry!! Can't remove first row!");
           }
           var totalUsdAmount = 0;
		   var totalInrAmount = 0;
		   var rowCount = $('#chrgTable tr').length;
       	   for(var i=0;i<rowCount-1;i++){
       		 var totRate = document.getElementsByName("FTV[]")[i].value;
       		 var totCurrency = document.getElementsByName("currency[]")[i].value;
       		 if(totCurrency == "USD"){
       			 totalUsdAmount = parseFloat(totalUsdAmount) + parseFloat(totRate);
                }else{
               	 totalInrAmount = parseFloat(totalInrAmount) + parseFloat(totRate);
                }             		  
       	   }
       	   $('#totalUsdAmount').val(totalUsdAmount);
		   $('#totalInrAmount').val(totalInrAmount);
		      
      });
});    
function twoDecimalAllow(obj) {
    var val = obj.value;
    var re = /^([0-9]+[\.]?[0-9]?[0-9]?|[0-9]+)$/g;
    var re1 = /^([0-9]+[\.]?[0-9]?[0-9]?|[0-9]+)/g;
    if (re.test(val)) {
        //do something here

    } else {
        val = re1.exec(val);
        if (val) {
        	obj.value = val[0];
        } else {
        	obj.value = "";
        }
    }
}
$(document).ready(function() {
    $('table.display').DataTable();
} );
</script> 

<!-- </body> -->
</html>