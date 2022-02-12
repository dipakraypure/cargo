<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Dashboard</title>
<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/font-awesome/4.7.0/css/font-awesome.min.css">
<link rel="stylesheet" href="https://use.fontawesome.com/releases/v5.6.3/css/all.css">
<link href="static/css/jquery.dataTables.min.css" type="text/css" rel="stylesheet">
<link rel="stylesheet" href="static/css/intlTelInput.css">
<link rel="stylesheet" href="static/css/bootstrap-datetimepicker.min.css">
<script src="static/js/intlTelInput.js"></script> 
<script src="static/js/bootstrap-datetimepicker.min.js"></script> 
<script src="static/js/_service/userDashboardFilter.js"></script> 
<script src="static/js/jquery.dataTables.min.js"></script> 
<script src="static/js/dataTables.responsive.min.js"></script> 
<script src="https://momentjs.com/downloads/moment.min.js"></script> 
<!--Datatable Export-->
<link rel="stylesheet" href="static/css/buttons.dataTables.css">
<script src="https://cdn.datatables.net/buttons/1.7.1/js/dataTables.buttons.min.js"></script> 
<script src="https://cdnjs.cloudflare.com/ajax/libs/jszip/3.1.3/jszip.min.js"></script><!-- excel--> 
<script src="https://cdnjs.cloudflare.com/ajax/libs/pdfmake/0.1.53/pdfmake.min.js"></script> 
<script src="https://cdnjs.cloudflare.com/ajax/libs/pdfmake/0.1.53/vfs_fonts.js"></script> 
<script src="https://cdn.datatables.net/buttons/1.7.1/js/buttons.html5.min.js"></script> 
<script src="https://cdn.datatables.net/buttons/1.7.1/js/buttons.print.min.js"></script> 
<!--Datatable Export--> 
<script type="text/javascript">
var enqtable;
var bktable;
var minDate;
var maxDate;
var createdAt = [];
var forwarderFilterArray = [];
var originFilterArray = [];
var destinationFilterArray = [];

var monthNames = ["Jan", "Feb", "Mar", "Apr", "May", "Jun",
  "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"
];

function shortDateFormat(d) {

  var dateMomentObject = moment(d, "YYYY-MM-DD"); // 1st argument - string, 2nd argument - format
  var t = dateMomentObject.toDate(); // convert moment.js object to Date object
  // var t = new Date(d);
  return t.getDate() + '-' + monthNames[t.getMonth()] + '-' + t.getFullYear();

}

$(function () {
  activeNavigationClass();
  
  var shipmentType = $('#shipmenttypefilter').val();
  // load counts for booking, enquiry
  getUserEnquiryCountByStatus(userInfo.id, shipmentType);
  getUserBookingCountByStatus(userInfo.id, shipmentType);

  getUserEnquiryDetailsAllList(userInfo.id, shipmentType, "");

  enqtable = $('#Enquiry_table').dataTable();
  bktable = $('#Booking_table').dataTable();

  $('#shipmenttypefilter').on('change', function () {
    var shipType = this.value;
    getUserEnquiryCountByStatus(userInfo.id, shipType);
    getUserBookingCountByStatus(userInfo.id, shipType);

    getUserEnquiryDetailsAllList(userInfo.id, shipType, "");
  });
});

/*******Start Booking details functions *******/

function getUserBookingCountByStatus(userId, shipmentType) {
  $('#loader').show();
  $.ajax({
    type: 'GET',
    url: server_url + 'user/getUserBookingCountByStatus',
    enctype: 'multipart/form-data',
    headers: authHeader,
    processData: false,
    contentType: false,
    data: "userId=" + userId + "&shipmentType=" + shipmentType,
    success: function (response) {
      console.log(response)
      if (response.respCode == 1) {
        $("#bkRequestCount").text(response.respData.requestCount);
        $("#bkAcceptedCount").text(response.respData.acceptedCount);
        $("#bkCancelledCount").text(response.respData.cancelledCount);
        $("#bkRejectedCount").text(response.respData.rejectedCount);
      } else {
        errorBlock("#error_block", response.respData)
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

function getUserBookingDetailsListByStatus(bookingStatus) {
  var shipmentType = $('#shipmenttypefilter').val();
  getUserBookingDetailsAllList(userInfo.id, shipmentType, bookingStatus);
}

function getUserBookingDetailsAllList(userId, shipmentType, bookingStatus) {

  $("#enquiryTableContId").hide();
  $("#bookingTableContId").show();

  $('#loader').show();
  var tableId = "Booking_table";
  $.ajax({
    type: 'GET',
    url: server_url + 'user/getUserBookingList',
    enctype: 'multipart/form-data',
    headers: authHeader,
    processData: false,
    contentType: false,
    data: "userId=" + userId + "&shipmentType=" + shipmentType + "&bookingStatus=" + bookingStatus,
    success: function (response) {
      console.log(response)
      if (response.respCode == 1) {
        loadUserBookingListTable(response.respData, tableId);
        generateCreatedAtArrayListFromBooking(response.respData);
        prepareForwarderFilter(forwarderFilterArray);
        prepareOriginFilter(originFilterArray);
        prepareDestinationFilter(destinationFilterArray);
      } else {
        errorBlock("#error_block", response.respData)
        loadUserBookingListTable(null, tableId);
      }
      $('#loader').hide();
    },
    error: function (error) {
      console.log(error)
      if (error.responseJSON != undefined) {
        loadUserBookingListTable(null, tableId);
        errorBlock("#error_block", error.responseJSON.respData);
      } else {
        loadUserBookingListTable(null, tableId);
        errorBlock("#error_block", "Server Error! Please contact administrator");
      }
      $('#loader').hide();
    }
  })
}

//onclick function for get booking details after click on booking reff
function getUserBookingDetailsById(bookingreff) {
  getUserBookingDetailsByBookingReff(bookingreff);
}

function getUserBookingDetailsByBookingReff(bookingReff) {
  $('#loader').show();
  $.ajax({
    type: 'GET',
    url: server_url + 'user/getUserBookingDetailsById?bookingReff=' + bookingReff,
    enctype: 'multipart/form-data',
    headers: authHeader,
    processData: false,
    contentType: false,
    data: null,
    success: function (response) {
      $('#loader').hide();
      console.log(response)

      if (response.respCode == 1) {

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
        for (var i = 0; i < response.respData.scheduleLegsResponse.length; i++) {
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
          if (transittime > 1) {
            daysLable = "Days";
          } else {
            daysLable = "Day";
          }
          transittime = transittime + " " + daysLable;

          tRows = tRows + '<tr><td>' + org + '</td><td>' + dest + '</td><td>' + mode + '</td><td>' + carrier + '</td><td>' + vessel + '</td><td>' + voyage + '</td><td>' + transittime + '</td><td>' + etddate + '</td><td>' + etadate + '</td></tr>';
        }

        $('#tbodyBookingDetailsPopUpId').append(tRows);

        var tRowsCharges = '';
        var json = [];
        var totalCharges = [];
        if (response.respData.chargesRateResponseList != null) {
          for (var i = 0; i < response.respData.chargesRateResponseList.length; i++) {
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

            tRowsCharges = tRowsCharges + '<tr><td>' + chargesgrouping + '</td>'
              + '<td>' + chargestype + '</td>'
              + '<td>' + currency + '</td>'
              + '<td style="text-align: right;">' + rate + '</td>'
              + '<td>' + basis + '</td>'
              + '<td>' + quantity + '</td>'
              + '<td style="text-align: right;">' + totalAmount.toFixed(2) + '</td></tr>';
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
        $("#bkDestReqInfoLbl").text(response.respData.origincode + " " + response.respData.destinationcode);

        $("#user_booking_details").modal('show');
        $('#loader').hide();
      } else {
        errorBlock("#error_block", response.respData)

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


function updateBookingStatus(id, status) {

  swal({
    //title: "Are you sure, please confirm?",
    text: "Are you sure, please confirm?",
    buttons: [
      'Cancel',
      'Ok'
    ],
  }).then(function (isConfirm) {
    if (isConfirm) {
      $('#loader').show();
      var userId = userInfo.id;
      $.ajax({

        type: 'GET',
        url: server_url + 'user/updateBookingStatus',
        enctype: 'multipart/form-data',
        headers: authHeader,
        processData: false,
        contentType: false,
        "autoWidth": true,

        data: "id=" + id + "&userId=" + userId + "&bookingStatus=" + status,

        success: function (response) {

          console.log(response)

          if (response.respCode == 1) {
            $('#loader').hide();
            successBlock("#success_block", response.respData.msg);
            var shipmentType = $('#shipmenttypefilter').val();
            getUserBookingDetailsAllList(userInfo.id, shipmentType, status);
            getUserBookingCountByStatus(userInfo.id, shipmentType);
            getUserEnquiryCountByStatus(userInfo.id, shipmentType);

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
  });
}


function updateEnquiryStatus(id, status) {

  swal({
    //title: "Are you sure, please confirm?",
    text: "Are you sure, please confirm?",
    buttons: [
      'Cancel',
      'Ok'
    ],
  }).then(function (isConfirm) {
    if (isConfirm) {
      $('#loader').show();
      var userId = userInfo.id;
      $.ajax({

        type: 'GET',
        url: server_url + 'user/updateEnquiryStatus',
        enctype: 'multipart/form-data',
        headers: authHeader,
        processData: false,
        contentType: false,

        data: "id=" + id + "&userId=" + userId + "&enquiryStatus=" + status,

        success: function (response) {

          console.log(response)

          if (response.respCode == 1) {
            $('#loader').hide();
            successBlock("#success_block", response.respData.msg);
            var shipmentType = $('#shipmenttypefilter').val();
            getUserEnquiryDetailsAllList(userInfo.id, shipmentType, status);
            getUserBookingCountByStatus(userInfo.id, shipmentType);
            getUserEnquiryCountByStatus(userInfo.id, shipmentType);

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
  });
}

/****** End Booking details functions *****/

/******Start Enquiry details functions ******/

function getUserEnquiryCountByStatus(userId, shipmentType) {

  $('#loader').show();
  $.ajax({

    type: 'GET',
    url: server_url + 'user/getUserEnquiryCountByStatus',
    enctype: 'multipart/form-data',
    headers: authHeader,
    processData: false,
    contentType: false,

    data: "userId=" + userId + "&shipmentType=" + shipmentType,

    success: function (response) {

      console.log(response)

      if (response.respCode == 1) {

        $("#eqRequestCount").text(response.respData.requestCount);
        $("#eqAcceptedCount").text(response.respData.acceptedCount);
        $("#eqCancelledCount").text(response.respData.cancelledCount);
        $("#eqRejectedCount").text(response.respData.rejectedCount);

      } else {
        errorBlock("#error_block", response.respData)

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

function getUserEnquiryDetailsAllList(userId, shipmentType, enquiryStatus) {

  $("#bookingTableContId").hide();
  $("#enquiryTableContId").show();

  $('#loader').show();

  var tableId = "Enquiry_table";

  $.ajax({

    type: 'GET',
    url: server_url + 'user/getUserEnquiryList',
    enctype: 'multipart/form-data',
    headers: authHeader,
    processData: false,
    contentType: false,

    data: "userId=" + userId + "&shipmentType=" + shipmentType + "&enquiryStatus=" + enquiryStatus,

    success: function (response) {

      console.log(response)

      if (response.respCode == 1) {
        loadUserEnquiryListTable(response.respData, tableId);
        generateCreatedAtArrayListFromEnquiry(response.respData);
        prepareForwarderFilter(forwarderFilterArray);
        prepareOriginFilter(originFilterArray);
        prepareDestinationFilter(destinationFilterArray);

      } else {
        errorBlock("#error_block", response.respData)
        loadUserEnquiryListTable(null, tableId);
      }
      $('#loader').hide();
    },
    error: function (error) {
      console.log(error)
      if (error.responseJSON != undefined) {
        loadUserEnquiryListTable(null, tableId);
        errorBlock("#error_block", error.responseJSON.respData);
      } else {
        loadUserEnquiryListTable(null, tableId);
        errorBlock("#error_block", "Server Error! Please contact administrator");
      }
      $('#loader').hide();
    }
  })
}

function getUserEnquiryDetailsListByStatus(enquiryStatus) {
  var shipmentType = $('#shipmenttypefilter').val();
  getUserEnquiryDetailsAllList(userInfo.id, shipmentType, enquiryStatus);
}

/****** End Enquiry details functions ******/
/*
function getEnquiryScheduleChargesDetailsByEnquiryReff(enquiryReff, forwarderid) {
  $('#loader').show();
  $.ajax({

    type: 'GET',
    url: server_url + 'user/getEnquiryScheduleChargesDetailsByEnquiryReff',
    enctype: 'multipart/form-data',
    headers: authHeader,
    processData: false,
    contentType: false,

    data: "enquiryReff=" + enquiryReff + "&forwarderid=" + forwarderid,

    success: function (response) {

      $('#loader').hide();
      console.log(response)

      if (response.respCode == 1) {

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

        $('#tbodyEnquiryDetailsPopUpId').empty();
        $('#tbodyEnquiryChargesPopUpId').empty();

        var trBody = '';

        if (response.respData.scheduleLegsResponseList != null) {
          for (var i = 0; i < response.respData.scheduleLegsResponseList.length; i++) {
            var transittime = response.respData.scheduleLegsResponseList[i].transittime;
            var daysLable = ""
            if (transittime > 1) {
              daysLable = "Days";
            } else {
              daysLable = "Day";
            }
            transittime = transittime + " " + daysLable;

            trBody = trBody + '<tr><td>' + response.respData.scheduleLegsResponseList[i].origin + '</td>'
              + '<td>' + response.respData.scheduleLegsResponseList[i].destination + '</td>'
              + '<td>' + response.respData.scheduleLegsResponseList[i].mode + '</td>'
              + '<td>' + response.respData.scheduleLegsResponseList[i].carrier + '</td>'
              + '<td>' + response.respData.scheduleLegsResponseList[i].vessel + '</td>'
              + '<td>' + response.respData.scheduleLegsResponseList[i].voyage + '</td>'
              + '<td>' + transittime + '</td>'
              + '<td>' + response.respData.scheduleLegsResponseList[i].etddate + '</td>'
              + '<td>' + response.respData.scheduleLegsResponseList[i].etadate + '</td></tr>';
          }
        }
        $('#tbodyEnquiryDetailsPopUpId').append(trBody);

        var tRowsCharges = '';
        var json = [];
        var totalCharges = [];
        
        if (response.respData.chargesRateResponseList != null) {
          for (var i = 0; i < response.respData.chargesRateResponseList.length; i++) {
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
            		
	            	    var itemObject = {};
	            	    itemObject["ChargeGroup"] = chargesgrouping;
	            	    itemObject["USD"] = totalChargesUsd;
	            	    itemObject["INR"] = totalChargesInr;
	            	    json.push(itemObject);			            	    	  	            	    		  	            	    
	        }
            totalAmount = parseFloat(totalAmount.toFixed(2));

            tRowsCharges = tRowsCharges + '<tr><td>' + chargesgrouping + '</td>'
              + '<td>' + chargestype + '</td>'
              + '<td>' + currency + '</td>'
              + '<td style="text-align: right;">' + rate + '</td>'
              + '<td>' + basis + '</td>'
              + '<td>' + quantity + '</td>'
              + '<td style="text-align: right;">' + totalAmount.toFixed(2) + '</td></tr>';
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
                chargeSummary = chargeSummary + '<tr><td class="text-center">'+chargesGrouping+'</td>'
                                              + '<td class="text-center">'+usdAmount.toFixed(2)+'</td>'
                                              + '<td class="text-center">'+inrAmount.toFixed(2)+'</td></tr>';
            }
        	chargeSummary = chargeSummary + '<tr><td class="text-center"><b>Total Amount</b></td>'
            + '<td class="text-center"><b>'+totalUsd.toFixed(2)+'</b></td>'
            + '<td class="text-center"><b>'+totalInr.toFixed(2)+'</b></td></tr>';
        }
	    $('#tbodyEnqSummaryChargesPopUpId').empty();
	    $('#tbodyEnqSummaryChargesPopUpId').append(chargeSummary);
	    
        $("#bkDestReqInfoLbl").text(response.respData.origincode + " " + response.respData.destinationcode);

        //$("#enquiry_accepted_list").modal('hide');
        $("#view_enq_schedule_charges_details").modal('show');

      } else {
        errorBlock("#error_block", response.respData)
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
*/

/****** Start Enquiry List Table***********/
function loadUserEnquiryListTable(data, tableId) {

  $('#' + tableId).dataTable().fnClearTable();

  var shipType = "";

  var oTable = $('#' + tableId).DataTable({
    /* 'responsive': true, */
    "destroy": true,
    "data": data,
    "dom": 'lBfrtip',
    "lengthChange": true,
    "buttons": [{
        extend: 'pdf',
        filename: "user_enquiry_data_pdf",
        text: '<i class="fa fa-file-pdf-o"></i>',
        titleAttr: 'Download PDF',
        title: " ",
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
        orientation: 'landscape',
        pageSize: 'LEGAL'
        /* messageTop: "User Enquiry Data" */
      },
      {
        extend: 'excel',
        filename: "user_enquiry_data_xsl",
        title: "",
        text: '<i class="fa fa-file-excel"></i>',
        titleAttr: 'Download Excel',
        exportOptions: {
          columns: [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10]
        }
        /* messageTop: "User Enquiry Data" */
      },
    ],
    "autoWidth": true,
    headers: authHeader,
    "scrollX": true,
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
      /* ref */
      {
        "targets": 2,
        "className": "dt-body-center",
        "width": "10%",
      }, /* date */
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
      }
    ],
    "columns": [

      {
        "data": null,
        sortable: true,
        render: function (data, type, row) {
          var originwithcode = data.origin;

          return originwithcode;

        }
      },
      {
        "data": null,
        sortable: true,
        render: function (data, type, row) {
          var destinationwithcode = data.destination;

          return destinationwithcode;

        }
      },
      {

        "data": null,
        sortable: true,
        render: function (data, type, row) {
          var enquiryreference = data.enquiryreference;

          return '<u><a href="#" onclick="getForwarderEnquiryStatusByReference(\'' + enquiryreference + '\');" class="book_link">' + enquiryreference + '</a></u>';

        }
      },
      {

        "data": null,
        sortable: true,
        render: function (data, type, row) {
          var searchdate = data.searchdate.split(" ");

          return searchdate[0];

        }
      },
      {

        "data": null,
        sortable: true,
        render: function (data, type, row) {
          var cargocategory = data.cargocategory;

          return cargocategory;

        }
      },
      {

        "data": null,
        sortable: true,
        render: function (data, type, row) {
          var shipmenttype = data.shipmenttype;
          shipType = data.shipmenttype;
          return shipmenttype;

        }
      },
      {

        "data": null,
        sortable: true,
        render: function (data, type, row) {
          var selectedfcl = data.selectedfcl;
          return selectedfcl;

        }
      },
      {

        "data": null,
        sortable: true,
        render: function (data, type, row) {
          var lcltotalweight = data.lcltotalweight;
          return lcltotalweight;

        }
      },
      {

        "data": null,
        sortable: true,
        render: function (data, type, row) {
          var lclvolume = data.lclvolume;
          return lclvolume;

        }
      },
      {

        "data": null,
        sortable: true,
        render: function (data, type, row) {
          var cargoreadydate = data.cargoreadydate;

          return cargoreadydate;
        }
      },
      {
        "data": null,
        sortable: true,
        render: function (data, type, row) {
          var status = data.status;

          return status;
        }
      },
      {

        "data": null,
        sortable: true,
        render: function (data, type, row) {

          var id = data.id;
          var status = data.status;
          var enquiryreference = data.enquiryreference;

          var optionsDisClass = '';
          var cancelDisClass = '';
          var deleteDisClass = '';

          if (status == 'Requested') {
            optionsDisClass = 'disabled';
            cancelDisClass = '';
            deleteDisClass = 'disabled';
          }
          if (status == 'Accepted') {
            optionsDisClass = '';
            cancelDisClass = '';
            deleteDisClass = 'disabled';
          }
          if (status == 'Cancelled') {
            optionsDisClass = 'disabled';
            cancelDisClass = 'disabled';
            deleteDisClass = '';
          }
          if (status == 'Rejected') {
            optionsDisClass = 'disabled';
            cancelDisClass = 'disabled';
            deleteDisClass = '';
          }

          var accept = "Accepted";
          var cancel = "Cancelled";

          return '<span title="Options" ><button type="button" onclick="enquiryAcceptedList(\'' + id + '\');"  class="list_btn actbtn ' + optionsDisClass + '" ' + optionsDisClass + '><i class="fas fa-list"></i></button></span>'
            + '<button type="button" value="V" class="view_btn actbtn"  title="View" onclick="viewEnquiryDetailsById(\'' + id + '\');" ><i class="fas fa-eye"></i></button>'
            + '<span title="Cancel"><button type="button"  onclick="updateEnquiryStatus(\'' + id + '\',\'' + cancel + '\');" class="can_btn actbtn ' + cancelDisClass + '" ' + cancelDisClass + '><i class="fas fa-times"></i></button></span>'
            + '<button type="button" title="Delete" class="del_btn ' + deleteDisClass + '" onclick="deleteUserEnquiryById(\'' + id + '\');" ' + deleteDisClass + '><i class="fas fa-trash actbtn"></i></button>';
        }
      }
    ],
    "order": [
      [3, "desc"]
    ],
  });
  if (shipType == "FCL" && shipType != "") {
    oTable.column(7).visible(false);
    oTable.column(8).visible(false);
  } else if (shipType == "LCL" && shipType != "") {
    oTable.column(6).visible(false);
  }
}
/****** End Enquiry List Table***********/

function viewEnquiryDetailsById(enquiryId){
	$('#loader').show();
	  $.ajax({
		    type: 'GET',
		    url: server_url + 'user/getUserEnquiryDetailsById',
		    enctype: 'multipart/form-data',
		    headers: authHeader,
		    processData: false,
		    contentType: false,

		    data: "enquiryId=" + enquiryId,

		    success: function (response) {
		      console.log(response)
		      if (response.respCode == 1) {
			      $("#enqReffDetLbl").text(response.respData.enquiryreference);
			      $("#enqOrgDetLbl").text(response.respData.origin);
			      $("#enqDestDetLbl").text(response.respData.destination);
			      $("#enqFclLclDetLbl").text(response.respData.shipmenttype);
			      $("#enqCRDDetLbl").text(response.respData.cargoreadydate);

			      $("#enqCargoCatDetLbl").text(response.respData.cargocategory);
			      $("#enqCommodityDetLbl").text(response.respData.commodity);
			      $("#enqImcoDetLbl").text(response.respData.imco);
			      $("#enqTempRangeDetLbl").text(response.respData.temprange);
			      
			      if(response.respData.shipmenttype == "FCL"){
			    	 $("#fclContainerDiv").show();
			    	 $("#lclContainerDiv").hide(); 
			         $("#enqServiceDetLbl").text(response.respData.shipmenttype);
			         $("#enqTwentyCountDetLbl").text(response.respData.twentyFtCount);
			         $("#enqFourtyCountDetLbl").text(response.respData.fourtyFtCount);
			         $("#enqFourtyHCCountDetLbl").text(response.respData.fourtyFtHcCount);
			         $("#enqFourtyFiveHcCountDetLbl").text(response.respData.fourtyFiveFtCount);
			      }else if(response.respData.shipmenttype == "LCL"){
			    	 $("#lclContainerDiv").show();
			    	 $("#fclContainerDiv").hide();				     
			         $("#enqServiceDetLclLbl").text(response.respData.shipmenttype);
			         $("#enqWtLclDetLbl").text(response.respData.lcltotalweight);
			         $("#enqVolLclDetLbl").text(response.respData.lclvolume);
			         $("#enqNoPckLclDetLbl").text(response.respData.lclnumberpackage);
			      }
			      
		    	  $('#view_enquiry_modal').modal('show');
		      } else {
		        errorBlock("#error_block", response.respData)		        
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

function deleteUserEnquiryById(id) {
  swal({
    text: "Are you sure, please confirm?",
    buttons: [
      'Cancel',
      'Ok'
    ],
  }).then(function (isConfirm) {
    if (isConfirm) {
      $('#loader').show();
      var userId = userInfo.id;
      $.ajax({

        type: 'DELETE',
        url: server_url + 'user/deleteUserEnquiryById/'+id+"/"+userId,
        enctype: 'multipart/form-data',
        headers: authHeader,
        processData: false,
        contentType: false,
        "autoWidth": true,
        "scrollX": true,
        data: null,

        success: function (response) {
          console.log(response)

          if (response.respCode == 1) {
            $('#loader').hide();
            successBlock("#success_block", response.respData.msg);
            var shipmentType = $('#shipmenttypefilter').val();
            getUserEnquiryDetailsAllList(userInfo.id, shipmentType, "");
            getUserBookingCountByStatus(userInfo.id, shipmentType);
            getUserEnquiryCountByStatus(userInfo.id, shipmentType);

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
  });
}

function getForwarderEnquiryStatusByReference(enquiryReference) {
  $('#loader').show();
  var tableId = "forwarder_enquiry_refstatus_table";
  var userId = userInfo.id;

  $.ajax({

    type: 'GET',
    url: server_url + 'user/getForwarderEnquiryStatusByReference',
    enctype: 'multipart/form-data',
    headers: authHeader,
    processData: false,
    contentType: false,
    data: "userId=" + userId + "&enquiryReference=" + enquiryReference,
    success: function (response) {

      console.log(response)

      if (response.respCode == 1) {

        loadTableForwarderEnquiryStatusList(response.respData, tableId);

        $("#forwarder_ref_enq_stat_modal").modal('show');
      } else {
        loadTableForwarderEnquiryStatusList(null, tableId);
        errorBlock("#error_block", response.respData)
      }
      $('#loader').hide();
    },
    error: function (error) {
      console.log(error)
      if (error.responseJSON != undefined) {
        loadTableForwarderEnquiryStatusList(null, tableId);
        errorBlock("#error_block", error.responseJSON.respData);
      } else {
        loadTableEnquiryAcceptedList(null, tableId);
        errorBlock("#error_block", "Server Error! Please contact administrator");
      }
      $('#loader').hide();
    }
  })
}

function loadTableForwarderEnquiryStatusList(data, tableId) {
  $('#' + tableId).dataTable().fnClearTable();
  var oTable = $('#' + tableId).DataTable({
    'responsive': true,
    "destroy": true,
    "data": data,
    /* "dom": 'lBfrtip', */
    "lengthChange": true,
    
    "autoWidth": true,
    /*  "scrollX": true, */
    "columnDefs": [{
      "width": "5%",
      "targets": 0,
      "orderable": false
    }],
    "columns": [

      {
        "data": null,
        className: 'text-center',
        sortable: true,
        render: function (data, type, row) {
          var enquiryreference = data.enquiryreference;
          return enquiryreference;
        }

      },
      {
        "data": null,
        sortable: true,
        render: function (data, type, row) {
          var forwarder = data.forwarder;

          return forwarder;
        }
      },
      {
        "data": null,
        sortable: true,
        render: function (data, type, row) {
          var status = data.status;
          var updateddate = data.updateddate;
          var statusAndDate = status + " (" + updateddate + ")";

          return statusAndDate;
        }
      }

    ]

  });

}

function enquiryAcceptedList(enquiryId) {

  $('#loader').show();
  var tableId = "enquiryAcceptedListTableId";
  var userId = userInfo.id;

  $.ajax({

    type: 'GET',
    url: server_url + 'user/getEnquiryAcceptedList',
    enctype: 'multipart/form-data',
    headers: authHeader,
    processData: false,
    contentType: false,
    data: "userId=" + userId + "&enquiryId=" + enquiryId,
    success: function (response) {

      console.log(response)

      if (response.respCode == 1) {

        loadTableEnquiryAcceptedList(response.respData, tableId, enquiryId);

        $("#enquiry_accepted_list").modal('show');
      } else {
        loadTableEnquiryAcceptedList(null, tableId, enquiryId);
        errorBlock("#error_block", response.respData)
      }
      $('#loader').hide();
    },
    error: function (error) {
      console.log(error)
      if (error.responseJSON != undefined) {
        loadTableEnquiryAcceptedList(null, tableId, enquiryId);
        errorBlock("#error_block", error.responseJSON.respData);
      } else {
        loadTableEnquiryAcceptedList(null, tableId, enquiryId);
        errorBlock("#error_block", "Server Error! Please contact administrator");
      }
      $('#loader').hide();
    }
  })

}

function loadTableEnquiryAcceptedList(data, tableId, enquiryId) {

  $('#' + tableId).dataTable().fnClearTable();

  var oTable = $('#' + tableId).DataTable({
    'responsive': true,
    "destroy": true,
    "data": data,
    "autoWidth": true,
    "dom": 'lBfrtip',
    "lengthChange": true,
    "buttons": [{
        extend: 'pdf',
        customize: function(doc) {
            doc.defaultStyle.alignment = 'left';
            doc.styles.tableHeader.alignment = 'left';
          },
        filename: 'user_accepted_enquiry_data_pdf',
        title: "",
        text: '<i class="fa fa-file-pdf-o"></i>',
        titleAttr: 'Download Excel',
        exportOptions: {
          columns: [0, 1, 2, 3, 4, 5, 6, 7, 8]
        },
        customize: function (doc) {
          doc.content.splice(1, 0, {
            margin: [1, 1, 1, 1],
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
        filename: 'user_accepted_enquiry_data_pdf',
        title: "",
        text: '<i class="fa fa-file-excel"></i>',
        titleAttr: 'Download Excel',
        exportOptions: {
          columns: [0, 1, 2, 3, 4, 5, 6, 7, 8]
        }
        /* messageTop: "User Enquiry Data" */
      },
    ],
    "columns": [

      {
        "data": null,
        sortable: true,
        render: function (data, type, row) {
          var enquiryreference = data.enquiryreference;

          return enquiryreference;

        }
      },
      {
        "data": null,
        sortable: true,
        render: function (data, type, row) {
          var forwarder = data.forwarder;

          return forwarder;

        }
      },
      {

        "data": null,
        className: 'dt-body-right',
        sortable: true,
        render: function (data, type, row) {
          var ftcharges = data.freightcharges;
          var ftchargescurrency = data.ftchargescurrency;

          var freightcharges = "";

          if (ftcharges == 0) {
            freightcharges = ftcharges;
          } else {
            freightcharges = ftchargescurrency + " " + parseFloat(ftcharges).toFixed(2);
          }

          return freightcharges;

        }
      },
      {

        "data": null,
        className: 'dt-body-right',
        sortable: true,
        render: function (data, type, row) {
          var orgcharges = data.origincharges;
          var orgchargescurrency = data.orgchargescurrency;

          var origincharges = "";

          if (orgcharges == 0) {
            origincharges = orgcharges;
          } else {
            origincharges = orgchargescurrency + " " + parseFloat(orgcharges).toFixed(2);
          }

          return origincharges;

        }

      },
      {
        "data": null,
        className: 'dt-body-right',
        sortable: true,
        render: function (data, type, row) {
          var destcharges = data.destinationcharges;
          var destchargescurrency = data.destchargescurrency;

          var destinationcharges = "";

          if (destcharges == 0) {
            destinationcharges = destcharges;
          } else {
            destinationcharges = destchargescurrency + " " + parseFloat(destcharges).toFixed(2);
          }

          return destinationcharges;

        }
      },
      {

        "data": null,
        className: 'dt-body-right',
        sortable: true,
        render: function (data, type, row) {
          var othcharges = data.othercharges;
          var otherchargescurrency = data.otherchargescurrency;

          var othercharges = "";

          if (othcharges == 0) {
            othercharges = othcharges;
          } else {
            othercharges = otherchargescurrency + " " + parseFloat(othcharges).toFixed(2);
          }
          return othercharges;

        }

      },
      {

        "data": null,
        className: 'dt-body-right',
        sortable: true,
        render: function (data, type, row) {
          var usdtotalcharges = parseFloat(data.usdtotalcharges);
          return usdtotalcharges.toFixed(2);

        }

      },
      {

        "data": null,
        className: 'dt-body-right',
        sortable: true,
        render: function (data, type, row) {
          var inrtotalcharges = parseFloat(data.inrtotalcharges);
          return inrtotalcharges.toFixed(2);

        }

      },
      {

        "data": null,
        className: 'text-center',
        sortable: true,
        render: function (data, type, row) {

          var forwarderid = data.forwarderid;
          var enquiryreference = data.enquiryreference;

          var disabledClass = 'disabled';
        
          return '<button type="button" value="Submit" class="green_sub actbtn" onclick="bookSchedule(\'' + forwarderid + '\',\'' + enquiryreference + '\');" title="Book"> <i class="fas fa-check-circle"></i></button>';

        }
      }
    ]
  });
}

function bookSchedule(forwarderid, enquiryreference) {

  $('#loader').show();
  var formData = new FormData();
  formData.append("userId", userInfo.id);
  formData.append("forwarderid", forwarderid);
  formData.append("enquiryreference", enquiryreference);

  $.post({
    url: server_url + 'user/bookScheduleFromEnquiry',
    enctype: 'multipart/form-data',
    headers: authHeader,
    processData: false,
    contentType: false,
    data: formData,

    success: function (response) {
      $('#loader').hide();
      console.log(response)

      if (response.respCode == 1) {
        window.location.href = contextPath + "/userDashboard";
        successBlock("#success_block", response.respData.msg);
      } else if (response.respCode == 0) {
        errorBlock("#error_block", response.respData.msg);
        window.location.href = contextPath + "/userDashboard";
      } else {
        errorBlock("#error_block", response.respData);
      }

      $('#loader').hide();
    },
    error: function (error) {

      console.log(error)

      console.log(error.responseJSON)

      if (error.responseJSON != undefined) {
        errorBlock("#error_block", error.responseJSON.respData);
      } else {
        errorBlock("#error_block", "Server Error! Please contact administrator");
      }

      $('#loader').hide();
    }
  })
}

function loadUserBookingListTable(data, tableId) {

  $('#' + tableId).dataTable().fnClearTable();

  var oTable = $('#' + tableId).DataTable({
    'responsive': true,
    "destroy": true,
    "data": data,
    "autoWidth": true,
    "dom": 'lBfrtip',
    "lengthChange": true,
    "buttons": [{
        extend: 'pdf',
        filename: 'user_booking_data_pdf',
        title: "",
        text: '<i class="fa fa-file-pdf-o"></i>',
        titleAttr: 'Download PDF',
        exportOptions: {
          columns: [0, 1, 2, 3, 4, 5, 6, 7, 8]
        },
        customize: function (doc) {
          doc.content.splice(1, 0, {
            margin: [1, 1, 1, 1],
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
        filename: 'user_booking_data_xsl',
        titleAttr: 'Download Excel',
        title: "",
        text: '<i class="fa fa-file-excel"></i>',

        exportOptions: {
          columns: [0, 1, 2, 3, 4, 5, 6, 7, 8]
        }
        /* messageTop: "User Enquiry Data" */
      },
    ],
    "columns": [{
        "data": null,
        sortable: true,
        render: function (data, type, row) {
          var originwithcode = data.originwithcode;

          return originwithcode;

        }
      },
      {
        "data": null,
        sortable: true,
        render: function (data, type, row) {
          var destinationwithcode = data.destinationwithcode;

          return destinationwithcode;

        }
      },
      {

        "data": null,
        sortable: true,
        render: function (data, type, row) {
          var id = data.id;
          var bookingreff = data.bookingreff;
          return '<u><a href="#" onclick="getUserBookingDetailsById(\'' + bookingreff + '\');" class="book_link">' + bookingreff + '</a></u>';

        }
      },
      {

        "data": null,
        className: 'text-center',
        sortable: true,
        render: function (data, type, row) {
          var bookingdate = data.bookingdate.split(" ");
          return bookingdate[0];

        }

      },
      {
        "data": null,
        className: 'text-left',
        sortable: true,
        render: function (data, type, row) {
          var forwarder = data.forwarder;
          return forwarder;

        }
      },
      {

        "data": null,
        className: 'text-center',
        sortable: true,
        render: function (data, type, row) {
          var cutoffdate = data.cutoffdate;
          return cutoffdate;

        }

      },
      {

        "data": null,
        className: 'text-center',
        sortable: true,
        render: function (data, type, row) {
          var status = data.bookingstatus;
          var statBTN = '';

          return status;

        }

      },
      {

        "data": null,
        className: 'text-center',
        sortable: true,
        render: function (data, type, row) {
          var id = data.id;

          var status = data.bookingstatus;

          var cancelDisClass = '';
          var rejectDisClass = '';
          var deleteDisClass = '';

          if (status == 'Requested') {
            cancelDisClass = '';
            rejectDisClass = 'disabled';
            deleteDisClass = 'disabled';
          }
          if (status == 'Accepted') {
            cancelDisClass = 'disabled';
            rejectDisClass = 'disabled';
            deleteDisClass = 'disabled';
          }
          if (status == 'Cancelled') {
            cancelDisClass = 'disabled';
            rejectDisClass = 'disabled';
            deleteDisClass = '';
          }
          if (status == 'Rejected') {
            cancelDisClass = 'disabled';
            rejectDisClass = 'disabled';
            deleteDisClass = '';
          }

          var accept = "Accepted";
          var reject = "Rejected";
          var cancel = "Cancelled";

          return ' <button title="Cancel" type="button" value="C" onclick="updateBookingStatus(\'' + id + '\',\'' + cancel + '\');" class="can_btn actbtn ' + cancelDisClass + '"  ' + cancelDisClass + '><i class="fas fa-times"></i></button>'
            + ' <button title="Reject"  type="button"  value="R"  onclick="updateBookingStatus(\'' + id + '\',\'' + reject + '\');" class="rej_btn actbtn ' + rejectDisClass + '" ' + rejectDisClass + '><i class="fas fa-times-circle"></i></button>'
            + '<button type="button" class="del_btn actbtn ' + deleteDisClass + '" onclick="deleteUserBookingById(\'' + id + '\');" ' + deleteDisClass + '><i class="fas fa-trash"></i></button>';
        }
      }
    ],
    "order": [
      [3, "desc"]
    ],
  });
}

function deleteUserBookingById(id) {
  swal({
    text: "Are you sure, please confirm?",
    buttons: [
      'Cancel',
      'Ok'
    ],
  }).then(function (isConfirm) {
    if (isConfirm) {
      $('#loader').show();
      var userId = userInfo.id;
      $.ajax({

        type: 'DELETE',
        url: server_url + 'user/deleteUserBookingById/'+id+"/"+userId,
        enctype: 'multipart/form-data',
        headers: authHeader,
        processData: false,
        contentType: false,
        "autoWidth": true,
        "scrollX": true,
        data: null,

        success: function (response) {
          console.log(response)

          if (response.respCode == 1) {
            $('#loader').hide();
            successBlock("#success_block", response.respData.msg);
            var shipmentType = $('#shipmenttypefilter').val();
            getUserBookingDetailsAllList(userInfo.id, shipmentType, "");
            getUserBookingCountByStatus(userInfo.id, shipmentType);
            getUserEnquiryCountByStatus(userInfo.id, shipmentType);

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
  });
}

$(function () {
  $('[data-toggle="tooltip"]').tooltip({
    trigger: 'hover'
  })
})

</script>
</head>

<div class="container-fluid">
  <div class="row mb30 mt-3 bg_white_dash">
    <div class="col-lg-2 col-xs-12">
      <div class="side_filters">
        <h3 class="filter_hd2">Filter Results</h3>
        <a type="button" class="reset_btn" onclick="resetFilter();">Reset</a>
        <h4 class="filter_subhd">Period</h4>
        <div class="widthSpl100">
          <input type="radio" name="period_input" class="filter_checkbox" value="DAY" onchange="filterme()">
          <label class="filter_label">Today</label>
        </div>
        <div class="widthSpl100">
          <input type="radio" name="period_input" class="filter_checkbox" value="WEEK" onchange="filterme()">
          <label class="filter_label">This Week</label>
        </div>
        <div class="widthSpl100">
          <input type="radio" name="period_input" class="filter_checkbox" value="MONTH" onchange="filterme()">
          <label class="filter_label">This Month</label>
        </div>
        <div class="widthSpl100">
          <input type="radio" name="period_input" class="filter_checkbox" value="RANGE">
          <label class="filter_label">Date Range</label>
        </div>
        <div class="widthSpl100"> <span class="filter_checkbox"></span>
          <input type="text" autocomplete="off" class="form-control date_range " id="fdaterange1">
          <label class="filter_label_spl">to</label>
          <input type="text" autocomplete="off" class="form-control date_range" id="fdaterange2">
        </div>
        <div id="forwarderFilterMainDiv">
          <h4 class="filter_subhd">Forwarder/CHA</h4>
          <div id="forwarderFilterSectionId"> </div>
          <div id="forwarderFilterMoreLessSectionId" style="display: none;">
            <div class="clearfix"></div>
            <a href="#" class="more_linkF" onclick="moreForwarderItems();">more...</a>
            <div class="clearfix"></div>
            <a  href="#" style="display: none;" class ="less_linkF" onclick="lessForwarderItems();">less</a> </div>
        </div>
        <div class="clearfix"></div>
        <div id="originFilterMainDiv">
          <h4 class="filter_subhd">Origin</h4>
          <div id="originFilterSectionId"> </div>
          <div id="originFilterMoreLessSectionId" style="display: none;">
            <div class="clearfix"></div>
            <a href="#" class ="more_linkO" onclick="moreOriginItems();">more...</a>
            <div class="clearfix"></div>
            <a  href="#" style="display: none;" class ="less_linkO" onclick="lessOriginItems();">less</a> </div>
        </div>
        <div class="clearfix"></div>
        <div id="destinationFilterMainDiv">
          <h4 class="filter_subhd">Destination</h4>
          <div id="destinationFilterSectionId"> </div>
          <div id="destinationFilterMoreLessSectionId" style="display: none;">
            <div class="clearfix"></div>
            <a href="#" class ="more_linkD" onclick="moreDestinationItems();">more...</a>
            <div class="clearfix"></div>
            <a  href="#" style="display: none;" class ="less_linkD" onclick="lessDestinationItems();">less</a> </div>
        </div>
        <div class="clearfix"></div>
      </div>
    </div>
    <div class="col-lg-10 col-xs-12">
      <div class="row">
        <div class="col-md-12 nav-tabs">
          <ul class="nav mb-n1" id="myTab" role="tablist">
            <li class="nav-item">
              <h2 class="book_cargo_hd mr-4 mb-0" style="line-height:2;">My Dashboard</h2>
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
                        <p class="stat_text"><a href="#" onclick="getUserEnquiryDetailsListByStatus('Requested');">Requested</a></p>
                        <p class="stat_text"><a href="#" onclick="getUserEnquiryDetailsListByStatus('Accepted');">Accepted</a></p>
                        <p class="stat_text"><a href="#" onclick="getUserEnquiryDetailsListByStatus('Cancelled');">Cancelled</a></p>
                        <p class="stat_text"><a href="#" onclick="getUserEnquiryDetailsListByStatus('Rejected');">Rejected</a></p>
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
                        <p class="stat_text"><a href="#" onclick="getUserBookingDetailsListByStatus('Requested');">Requested</a></p>
                        <p class="stat_text"><a href="#" onclick="getUserBookingDetailsListByStatus('Accepted');">Accepted</a></p>
                        <p class="stat_text"><a href="#" onclick="getUserBookingDetailsListByStatus('Cancelled');">Cancelled</a></p>
                        <p class="stat_text"><a href="#" onclick="getUserBookingDetailsListByStatus('Rejected');">Rejected</a></p>
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
                        <p class="stat_text">Final Draft</p>
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
            <div id="enquiryTableContId" >
              <table id="Enquiry_table" class="row-border table_fontsize" style="width:100%">
                <thead>
                  <tr>
                    <th>Origin</th>
                    <th>Destination</th>
                    <th>Enquiry Reference</th>
                    <th>Enquiry Date</th>
                    <th>Cargo Category</th>
                    <th>FCL / LCL</th>
                    <th>Containers</th>
                    <th>Weight(Kgs)</th>
                    <th>Volume(CBM)</th>
                    <th>Cargo Ready Date</th>
                    <th>Status</th>
                    <th>Action</th>
                  </tr>
                </thead>
              </table>
            </div>
            <div id="bookingTableContId" style="display:none;">
              <table id="Booking_table" class="row-border table_fontsize" style="width:100%">
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
          </div>
        </div>
      </div>
    </div>
  </div>
</div>
<!--user_booking_details-->
<div class="modal" id="user_booking_details" tabindex="-1" role="dialog" aria-labelledby="ModalTitle" aria-hidden="true">
  <div class="modal-dialog modal-dialog-centered modal-lg" role="document">
    <div class="modal-content">
      <div class="modal-header modal_hd_sec">
        <p class="h5 modal-title modal_hd" id="ModalTitle">Booking Details</p>
        <button type="button" class="close modal_close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">×</span></button>
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
              <table class="table booking_modal_table table-bordered mb-4">
                <thead>
                  <tr>
                    <th>Charges Grouping</th>
                    <th>Charge Type</th>
                    <th class="text-center">Currency</th>
                    <th>Rate</th>
                    <th>Basis</th>
                    <th class="text-center">Quantity</th>
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
                      <th class="text-center">Charges Summary</th>
			          <th class="text-center">USD</th>
			          <th class="text-center">INR</th>
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
<!--user_booking_details--> 
<!-- View PDF Modal-->
<div id="view_enq_schedule_charges_details" class="modal fade" tabindex="-1" role="dialog" aria-labelledby="myLargeModalLabel" aria-hidden="true">
  <div class="modal-dialog modal-dialog-scrollable modal-dialog-centered modal-lg">
    <div class="modal-content">
      <div class="modal-header modal-header-spl">
        <h5 class="modal-title">Enquiry Details</h5>
        <button type="button" class="close btn_close" data-dismiss="modal" aria-label="Close"> <span aria-hidden="true">&times;</span> </button>
      </div>
      <div class="modal-body"> 
        
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
              <table class="table booking_modal_table table-bordered mb-4 text-center">
                <thead>
                  <tr>
                    <th>Charges Grouping</th>
                    <th>Charge Type</th>
                    <th class="text-center">Currency</th>
                    <th>Rate</th>
                    <th>Basis</th>
                    <th class="text-center">Quantity</th>
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
                      <th class="text-center">Charges Summary</th>
			          <th class="text-center">USD</th>
			          <th class="text-center">INR</th>
			      </tr>                          
			      </thead>  
                  <tbody id="tbodyEnqSummaryChargesPopUpId">	              	                    			
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

<!-- List Modal-->
<div id="enquiry_accepted_list" class="modal fade" tabindex="-1" role="dialog" aria-labelledby="myLargeModalLabel" aria-hidden="true">
  <div class="modal-dialog modal-dialog-scrollable modal-dialog-centered modal-lg">
    <div class="modal-content">
      <div class="modal-header modal-header-spl">
        <h5 class="modal-title">Quotation List</h5>
        <button type="button" class="close btn_close" data-dismiss="modal" aria-label="Close"> <span aria-hidden="true">×</span> </button>
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
<!-- List Modal-->

<div id="forwarder_ref_enq_stat_modal" class="modal fade" tabindex="-1" role="dialog" aria-labelledby="myLargeModalLabel" aria-hidden="true">
  <div class="modal-dialog modal-lg modal-dialog-centered">
    <div class="modal-content">
      <div class="modal-header modal-header-spl">
        <h5 class="modal-title">Enquiry Status </h5>
        <button type="button" class="close btn_close" data-dismiss="modal" aria-label="Close"> <span aria-hidden="true">&times;</span> </button>
      </div>
      <div class="modal-body">
        <div class=" text-center">
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
<script>
if (window.history.replaceState) {
  window.history.replaceState(null, null, window.location.href);
}
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
  $(".more_linkO").hide();
  $(".less_linkO").show();
}

function lessOriginItems() {
  $(".origin-hidden-item").hide();
  $(".more_linkO").show();
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
  $(".more_linkD ").show();
  $(".less_linkD").hide();
}
/* Destination */
$(document).ready(function () {
  $('#viewlist_table').DataTable({});
});

<!--   Filter Datetimepicker --> 
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

    if (fromDate != "" && toDate != "") {
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

    if (fromDate != "" && toDate != "") {
      minDate = fromDate;
      maxDate = toDate;
      filterme();
    }
  });
});
</script>
</html>