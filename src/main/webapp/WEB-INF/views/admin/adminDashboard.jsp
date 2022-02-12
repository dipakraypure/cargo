<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Admin Dashboard</title>

<!--Datatable Export-->
<link rel="stylesheet" href="static/css/buttons.dataTables.css">
<script src="https://cdn.datatables.net/buttons/1.7.1/js/dataTables.buttons.min.js"></script> 
<script src="https://cdnjs.cloudflare.com/ajax/libs/jszip/3.1.3/jszip.min.js"></script><!-- excel-->
<script src="https://cdnjs.cloudflare.com/ajax/libs/pdfmake/0.1.53/pdfmake.min.js"></script> 
<script src="https://cdnjs.cloudflare.com/ajax/libs/pdfmake/0.1.53/vfs_fonts.js"></script> 
<script src="https://cdn.datatables.net/buttons/1.7.1/js/buttons.html5.min.js"></script>
<script src="https://cdn.datatables.net/buttons/1.7.1/js/buttons.print.min.js"></script> 
<!--Datatable Export-->
<script src="static/js/_service/adminDashboard.js"></script>
<script src="static/js/_service/adminDashboardFilter.js"></script>

<script type="text/javascript">

var enqUserTable;
var bkUserTable;

var enqForwarderTable;
var bkForwarderTable;

var minDate;
var maxDate;

var createdAt = [];
var customerFilterArray = [];
var forwarderFilterArray = [];
var originFilterArray = [];
var destinationFilterArray = [];

  $(function() {
	  activeNavigationClass();
	  loadUserRoleDropdown();

	   $("#userTypeId").change(function() {
		   var selectedVal = $(this).find(':selected').val();
		    var selectedText = $(this).find(':selected').text();
		    var userId =  userInfo.id;
		    if(selectedVal != ""){
		    	getUserListByRole(selectedVal);
		    }else{
		    	errorBlock("#error_block","Please choose profile");
			}
		    
		});

	   $("#userEntityId").change(function() {
		   var selectedVal = $(this).find(':selected').val();
		    var selectedText = $(this).find(':selected').text();
		    var userId =  userInfo.id;
		    if(selectedVal != ""){ 
               var userTypeId = $('#userTypeId :selected').val();
               if(userTypeId != "" ){
                     if(userTypeId == "CS"){
                    	 var shipmentType = $('#shipmenttypefilter').val();
                    	 getUserBookingCountByStatus(selectedVal,shipmentType);
                  	     getUserEnquiryCountByStatus(selectedVal,shipmentType);                  	    
                  	     getUserEnquiryDetailsAllList(selectedVal,shipmentType,"");
                  	     
                     }else if(userTypeId == "FF"){
                    	 var shipmentType = $('#shipmenttypefilter').val();
                    	 getForwarderBookingCountByStatus(selectedVal,shipmentType);
                  	     getForwarderEnquiryCountByStatus(selectedVal,shipmentType);
                  	     getForwarderEnquiryDetailsAllList(selectedVal,shipmentType,"");
                     }
               }
		    }else{
		    	errorBlock("#error_block","Please choose Entity");
			}
		    
		});

	   $('#shipmenttypefilter').on('change', function() {
		        var shipType = this.value;
			    var selectedVal = $('#userEntityId').val();
			    
			    var userId =  userInfo.id;
			    if(selectedVal != ""){ 
	               var userTypeId = $('#userTypeId :selected').val();
	               if(userTypeId != "" ){
	                     if(userTypeId == "CS"){	                    	
	                    	 getUserBookingCountByStatus(selectedVal,shipType);
	                  	     getUserEnquiryCountByStatus(selectedVal,shipType);                  	    
	                  	     getUserEnquiryDetailsAllList(selectedVal,shipType,"");
	                  	     
	                     }else if(userTypeId == "FF"){	                    	
	                    	 getForwarderBookingCountByStatus(selectedVal,shipType);
	                  	     getForwarderEnquiryCountByStatus(selectedVal,shipType);
	                  	     getForwarderEnquiryDetailsAllList(selectedVal,shipType,"");
	                     }
	               }
			    }else{
			    	errorBlock("#error_block","Please choose Entity");
				}
	   });
	   enqUserTable = $('#Enquiry_User_table').dataTable();
	   bkUserTable = $('#Booking_User_table').dataTable();

	   enqForwarderTable = $('#Enquiry_Forwarder_table').dataTable();
	   bkForwarderTable = $('#Booking_Forwarder_table').dataTable();
		  
  });

  function getUserListByRole(selectedUserRole){

	$('#loader').show();
	  	$.ajax({
	  			
	  		     type: 'GET', 
	               url : server_url+'admin/getUserListByRole',	     
	               enctype: 'multipart/form-data',
	               headers: authHeader,
	               processData: false,
	               contentType: false,

	               data : "selectedUserRole="+selectedUserRole,
	      
	               success : function(response) {

	  	           console.log(response)
	  	 	       var ddl = document.getElementById("userEntityId");
	               var option = document.createElement("OPTION"); 	
	  	 	        	
	  	            if(response.respCode == 1){  		            
	  	            	$('#userEntityId').empty();	             
		                 option.innerHTML = 'Choose Entity';
						 option.value = '0';
						 ddl.options.add(option);
						 
		            	 for(var i=0; i<response.respData.length; i++){										  
		            	    var option = document.createElement("OPTION");
		            	    option.innerHTML = response.respData[i].email;
		            	    option.value = response.respData[i].id;
		            	    ddl.options.add(option);			
		            	 }             		             	       
	  	            }else{
	  	            	$('#userEntityId').empty();
						option.innerHTML = 'No Entity available';
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

  function totalChargesSummary(json,chargesgrouping,totalChargesUsd,totalChargesInr){
	  
	  const totalCharges = json.map(item => {
          if (item.ChargeGroup == chargesgrouping) {
            	 return {
            	    ...item,
               USD:  item.USD + totalChargesUsd,
           	 INR:  item.INR + totalChargesInr
            	};
           }
           return item;
     });
	 return totalCharges
  }
  
  </script>
</head>
<body>

<!--   container-fluid -->
<div class="container-fluid">
  <div class="row mb20 mt-3 bg_white_dash"> 
    <!--Sidebar-->
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
             <input type="datetime" autocomplete="off" class="form-control date_range datepicker" id="fdaterange1">
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
        <!-- forwarder -->
        <div id="forwarderFilterMainDiv">
	      	<h4 class="filter_subhd">Forwarder/CHA</h4>
	        <div id="forwarderFilterSectionId">  
	        </div> 
	        <div id="forwarderFilterMoreLessSectionId" style="display: none;">  
	          <div class="clearfix"></div>
              <a href="#" class="more_linkF" onclick="moreForwarderItems();">more...</a>
              <div class="clearfix"></div>
              <a  href="#" style="display: none;" class ="less_linkF" onclick="lessForwarderItems();">less</a>
             </div>
        </div>
          <!-- forwarder -->
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
    <!--Sidebar--> 
    <!--Main Body-->
    <div class="col-lg-10 col-xs-12">
      <div class="row">
        <div class="col-md-12 ">
          <div class="row nav-tabs">
           <ul class="nav mb-n1" id="myTab" role="tablist">
              <li class="nav-item">
                <h2 class="book_cargo_hd mr-4 mb-0" style="line-height:2;"">My Dashboard</h2>
              </li>
              <li class="nav-item" style="width: 300px;">
                <div class="form-group row mb-0">
                  <label for="usertype" class="col-md-4 form-label-new ml-2 pr-0 mb-0" >Select Profile</label>
                  <div class="col-md-7">
                    <select class="form-control font14" name="usertype" id="userTypeId">
                      <!-- <option value="">Choose Profile</option>
                      <option value="CS">Importer/Exporter</option>
                      <option value="FF">Forwarder/CHA</option> -->                     
                    </select>
                  </div>
                </div>
              </li>
              <li class="nav-item" style="width: 315px;">
                <div class="form-group row mb-0">
                  <label for="usertype" class="col-md-3 form-label-new ml-2 pr-0 mb-0" >Select Entity</label>
                  <div class="col-md-8">
                    <select class="form-control font14 select2" name="userentity" id="userEntityId">
                      <!-- <option>Select</option>
                      <option>Car</option>
                      <option>Bike</option>
                      <option>Scooter</option>
                      <option>Cycle</option>
                      <option>Horse</option> -->
                    </select>
                  </div>
                </div>
              </li>
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
                        <p class="stat_text"><a href="#" onclick="getEnquiryDetailsListByStatus('Requested');">Requested</a></p>
                        <p class="stat_text"><a href="#" onclick="getEnquiryDetailsListByStatus('Accepted');">Accepted</a></p>
                        <p class="stat_text"><a href="#" onclick="getEnquiryDetailsListByStatus('Cancelled');">Cancelled</a></p>
                        <p class="stat_text"><a href="#" onclick="getEnquiryDetailsListByStatus('Rejected');">Rejected</a></p>
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
                        <p class="stat_text"><a href="#" onclick="getBookingDetailsListByStatus('Requested');">Requested</a></p>
                        <p class="stat_text"><a href="#" onclick="getBookingDetailsListByStatus('Accepted');">Accepted</a></p>
                        <p class="stat_text"><a href="#" onclick="getBookingDetailsListByStatus('Cancelled');">Cancelled</a></p>
                        <p class="stat_text"><a href="#" onclick="getBookingDetailsListByStatus('Rejected');">Rejected</a></p>
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
           <!-- Start User Code -->
           <!--Start Datatable User -->
           <div class="table-responsive" id="enquiryUserTableContId" style="display:none;">
	  <table id="Enquiry_User_table" class="row-border table_fontsize" style="width:100%" >   
        <thead>
            <tr>               
                <th>Origin</th>
                <th>Destination</th>
                <th>Enquiry<br>Reference</th>
                <th>Enquiry<br>Date</th>
                <th>Cargo<br>Category</th>
                <th>FCL/<br>LCL</th>
                <th>Containers</th>
                <th>Weight(Kgs)</th>
				<th>Volume(CBM)</th>
                <th>Cargo<br>Ready Date</th>
                <th>Status</th>
                <th>Action</th>
            </tr> 
        </thead>
        </table>
        </div> 	   
        
	 <div class="table-responsive" id="bookingUserTableContId" style="display:none;">
	  <table id="Booking_User_table" class="row-border table_fontsize" style="width:100%" >
        
        <thead>
            <tr>               
                <th>Origin</th>
                <th>Destination</th>
                <th>Booking Ref</th>
                <th>Booking Date</th>
                <th>Forwarder/CHA</th>             
                <th>Cut Off Date</th>
                <th>Status</th>
                <th>Action</th>
            </tr> 
        </thead>
        </table>
        </div>
           <!--End Datatable User  --> 
                      
           <!-- End User Code -->
           
           <!-- Start Forwarder Code -->
           <!-- Start Datatable Forwarder -->
           <div class="table-responsive" id="enquiryForwarderTableContId" style="display:none;">
              <table id="Enquiry_Forwarder_table" class="row-border table_fontsize " style="width:100%;" >
                <!-- " -->
                
                <thead class="text-left">
                  <tr>
                    <th>Origin</th>
                    <th>Destination</th>
                    <th>Importer/Exporter</th>
                    <th>Enquiry Date</th>
                    <th>Cargo<br>Category</th>
                    <th>FCL / <br/>
                      LCL</th>
                    <th>Containers</th>
                    <th>Weight(Kgs)</th>
                    <th>Volume(CBM)</th>
                    <th>Cargo <br/>
                      Ready Date</th>
                    <th>Status</th>
                    <th align="center">Action</th>
                  </tr>
                </thead>
              </table>
            </div>
            <div class="table-responsive" id="bookingForwarderTableContId" style="display:none;">
              <table id="Booking_Forwarder_table" class="row-border table_fontsize" style="width:100%">
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
           <!-- End Datatable Forwarder -->
           <!-- End Forwarder Code -->
          </div>
        </div>
      </div>
    </div>
    <!--Main Body--> 
  </div>
</div>
<!--   container-fluid --> 

<!-- Start User Booking Detail Modal -->
	<div class="modal" id="user_booking_details" tabindex="-1" role="dialog" aria-labelledby="ModalTitle" aria-hidden="true">
	        <div class="modal-dialog modal-dialog-centered modal-lg" role="document">
	            <div class="modal-content">
	                <div class="modal-header modal_hd_sec modal-header-spl">
	                    <p class="h5 modal-title modal_hd" id="ModalTitle">Booking Details</p>
	                    <button type="button" class="close modal_close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">ח</span></button>
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
			                    	<table class="table booking_modal_table table-bordered mb-4 ">
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
			                                <th>USD</th>
			                                <th >INR</th>
			                             </tr>                          
			                           </thead>  
                                       <tbody id="tbodyBkSummaryChargesPopUpId">	
                                                           			
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
<!-- End User Booking Detail Modal -->

<!-- List Modal-->
<div id="enquiry_accepted_list" class="modal fade" tabindex="-1" role="dialog" aria-labelledby="myLargeModalLabel" aria-hidden="true">
  <div class="modal-dialog modal-dialog-scrollable modal-dialog-centered modal-lg">
    <div class="modal-content">
      <div class="modal-header modal-header-spl">
        <h5 class="modal-title">Quotation List</h5>
        <button type="button" class="close btn_close" data-dismiss="modal" aria-label="Close"> <span aria-hidden="true">X</span> </button>
      </div>
      <div class="modal-body"> 
        
        <!-- body code start -->
        <div class="row">
          <div class="col-md-12"> 
          <div id="viewlist" class="table-responsive" >
            <table id="enquiryAcceptedListTableId" class="row-border table_fontsize" style="width:100%">
              <thead>
                <tr>
                  <th>Enquiry Reference</th>
                  <th>Forwarder / CHA</th>
                  <th>Freight Charges</th>
                  <th>Origin Charges</th>
                  <th>Destination Charges</th>
                  <th>Other Charges</th>
                  <th>Total USD Charges</th>
                  <th>Total INR Charges</th>
                  <th>Action</th>
                </tr>
              </thead>
          
            </table>
          </div>
          
          
          </div>
        </div>
        
        <!-- body code end --> 
      </div>
    </div>
  </div>
</div>
<!-- View PDF Modal--> 

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
                    <th>Cargo Category</th>
                    <th>FCL/LCL</th>                  
                    <th>Enquiry Status</th>
                  </tr>
                </thead>
                <tbody>
                  <tr>
                    <td><label id="enqCargoCatLbl"></label></td>
                    <td><label id="enqFclLclLbl"></label></td>                   
                    <td><label id="enqEnquiryStatusLbl"></label></td>
                  </tr>
                </tbody>
              </table>
            </div>
            <lable class="bookingmodal_label">Schedule Details</lable>
            <div class="table-responsive">
              <table class="table booking_modal_table modal_table_padd table-bordered mb-4">
                <thead>
                  <tr>               
                    <th>Origin</th>
                    <th>Destination</th>
                    <th>Schedule Type</th>
                    <th>No of Legs</th>
                  </tr>
                </thead>
                <tbody>
                  <tr>
                    <td><label id="enqOriginLbl"></label></td>
                    <td><label id="enqDestinationLbl"></label></td>
                    <td><label id="enqScheduleTypeLbl"></label></td>
                    <td><label id="enqNoOfLegsLbl"></label></td>                   
                  </tr>
                </tbody>
              </table>
            </div>
           
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
                <tbody id="tbodyEnquiryDetailsPopUpId">
                </tbody>
              </table>
            </div>
            <lable class="bookingmodal_label">Charges Summary</lable>
            <div class="table-responsive">
              <table class="table booking_modal_table table-bordered mb-4">
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
                  <tbody id="tbodyEnquiryChargesPopUpId">			                    			
			      </tbody>
              </table>
            </div>
            <lable class="bookingmodal_label">Total Charges</lable>
             <div class="table-responsive">
              <table class="table booking_modal_table table-bordered mb-4"> 
              <thead>
                 <tr>
                      <th>Charges Summary</th>
			          <th>USD</th>
			          <th>INR</th>
			      </tr>                          
			      </thead>  
                  <tbody id="tbodyEnqSummaryChargesPopUpId">	                    	                    			
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
                      <td><label id="enqIncotermLbl"></label></td>
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
            <label class="bookingmodal_label_val" id="bkBookingReffLbl_FF"></label>
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
                    <td><label id="bkBookByLbl_FF"></label></td>
                    <td><label id="bkCargoReadyDateLbl_FF"></label></td>
                    <td><label id="bkDateOfBookingLbl_FF"></label></td>
                    <td><label id="bkBookingStatusLbl_FF"></label></td>
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
                    <td><label id="bkBookingPartyLbl_FF"></label></td>
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
                    <td><label id="bkBookingDateLbl_FF"></label></td>
                    <td><label id="bkOriginLbl_FF"></label></td>
                    <td><label id="bkDestinationLbl_FF"></label></td>
                    <td><label id="bkCutOffDateLbl_FF"></label></td>
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
                <tbody id="tbodyBookingDetailsPopUpId_FF">
                </tbody>
              </table>
            </div>
            <lable class="bookingmodal_label">Charges Summary</lable>
		    <div class="table-responsive">
			  <table class="table booking_modal_table table-bordered mb-4 ">
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
			    <tbody id="tbodyBookingChargesPopUpId_FF">			                    			
			    </tbody>
			   </table>
		    </div>
		    <lable class="bookingmodal_label">Total Charges</lable>
             <div class="table-responsive">
              <table class="table booking_modal_table table-bordered mb-4"> 
              <thead>
                 <tr>
                      <th>Charges Summary</th>
			          <th>USD</th>
			          <th>INR</th>
			      </tr>                          
			      </thead>  
                  <tbody id="tbodyBkSummaryChargesPopUpId_FF">	                                        			
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
                      <td><label id="bkIncotermLbl_FF"></label></td>
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
                    <td><label id="bkDestReqInfoLbl_FF"></label></td>
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
<!-- View Enquiry Modal -->
<div id="view_enquiry_modal" class="modal fade" tabindex="-1" role="dialog" aria-labelledby="myLargeModalLabel" aria-hidden="true">
  <div class="modal-dialog modal-lg modal-dialog-centered">
    <div class="modal-content">
      <div class="modal-header modal-header-spl">
        <h5 class="modal-title">Enquiry Details </h5>
        <button type="button" class="close btn_close" data-dismiss="modal" aria-label="Close"> <span aria-hidden="true">&times;</span> </button>
      </div>
      <div class="modal-body" style="overflow-x: auto;">  
         
        <!-- body code start -->
       <div class="row">
          <div class="col-md-12">
            <lable class="bookingmodal_label">Enquiry Reference</lable>
            <label class="bookingmodal_label_val" id="enqReffDetLbl"> </label>
            <div class="table-responsive">
              <table class="table booking_modal_table table-bordered">
                <thead>
                  <tr>
                    <th>Origin</th>
                    <th>Destination</th>  
                    <th>FCL/LCL</th>                                     
                    <th>Cargo Ready Date</th>
                  </tr>
                </thead>
                <tbody>
                  <tr>
                    <td><label id="enqOrgDetLbl"></label></td>
                    <td><label id="enqDestDetLbl"></label></td>  
                    <td><label id="enqFclLclDetLbl"></label></td>                                    
                    <td><label id="enqCRDDetLbl"></label></td>
                  </tr>
                </tbody>
              </table>
            </div>           
            <div class="table-responsive">
              <table class="table booking_modal_table table-bordered">
                <thead>
                  <tr>
                    <th>Cargo Category</th>
                    <th>Commodity</th>
                    <th>IMCO</th>
                    <th>Temperature Range</th>                                      
                  </tr>
                </thead>
                <tbody>
                  <tr>
                    <td><label id="enqCargoCatDetLbl"></label></td>
                    <td><label id="enqCommodityDetLbl"></label></td>
                    <td><label id="enqImcoDetLbl"></label></td>                   
                    <td><label id="enqTempRangeDetLbl"></label></td>                    
                  </tr>
                </tbody>
              </table>
            </div>                    
            <lable class="bookingmodal_label">Booking Requirement</lable>           
            <div class="table-responsive" id="fclContainerDiv">
              <table class="table booking_modal_table table-bordered">
                <thead>
                  <tr>
                    <th>Service</th>
                    <th>20</th>
                    <th>40</th>    
                    <th>40 HC</th>   
                    <th>45 HC</th>                                    
                  </tr>
                </thead>
                <tbody>
                  <tr>
                    <td><label id="enqServiceDetLbl"></label></td>
                    <td><label id="enqTwentyCountDetLbl"></label></td>                   
                    <td><label id="enqFourtyCountDetLbl"></label></td>   
                    <td><label id="enqFourtyHCCountDetLbl"></label></td>  
                    <td><label id="enqFourtyFiveHcCountDetLbl"></label></td>                   
                  </tr>
                </tbody>
              </table>
            </div> 
            
            <div class="table-responsive" id="lclContainerDiv">
              <table class="table booking_modal_table table-bordered">
                <thead>
                  <tr>
                    <th>Service</th>
                    <th>Weight (Kgs)</th>
                    <th>Volume (CBM)</th>    
                    <th>Number of Packages</th>                                                        
                  </tr>
                </thead>
                <tbody>
                  <tr>
                    <td><label id="enqServiceDetLclLbl"></label></td>
                    <td><label id="enqWtLclDetLbl"></label></td>                   
                    <td><label id="enqVolLclDetLbl"></label></td>   
                    <td><label id="enqNoPckLclDetLbl"></label></td>                                       
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
<!-- View Enquiry Modal -->
<div id="forwarder_ref_enq_stat_modal" class="modal fade" tabindex="-1" role="dialog" aria-labelledby="myLargeModalLabel" aria-hidden="true">
  <div class="modal-dialog modal-lg modal-dialog-centered">
    <div class="modal-content">
      <div class="modal-header modal-header-spl">
        <h5 class="modal-title">Enquiry Status  </h5>
        <button type="button" class="close btn_close" data-dismiss="modal" aria-label="Close"> <span aria-hidden="true">&times;</span> </button>
      </div>
      <div class="modal-body">
        <div class="">
        <table class="table table-bordered table_fontsize m-0" style="width:100%" id="forwarder_enquiry_refstatus_table"> 
        <thead class="thead-light">
        <tr>
        <th>Enquiry Reference</th>
        <th>Forwarder / CHA</th>
        <th>Status</th>
        </tr>
        </thead>        
        </table>       
        </div>
        
      </div>
    </div>
  </div>
</div>


<script>
    $('.select2').select2();
</script> 
<!--   Tooltip --> 
<script>
$(document).ready(function(){
  $('[data-toggle="tooltip"]').tooltip();   
});
</script> 
<!--   Tooltip --> 

<!--   Datetimepicker --> 
<script type="text/javascript">
$(function () {
	  $('#etd1, #eta1').datetimepicker({
	    format: 'DD-MMM-YYYY'
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
			 //minDate : moment()
	    });

		// End date date and time picker 
		$('#fdaterange2').datetimepicker({
			format: 'DD-MMM-YYYY',
			//useCurrent: false 
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
<!--  Filter Datetimepicker --> 
<script>
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

/* Forwarder */
function moreForwarderItems() {

  $(".forwarder-hidden-item").show();
  $(".more_linkF").hide();
  $(".less_linkF").show();
}

function lessForwarderItems() {
  $(".forwarder-hidden-item").hide();
  $(".more_linkF").show();
  $(".less_linkF").hide();
}
/* Forwarder */

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

</body>
</html>