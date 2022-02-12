<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>New Booking</title>
<link rel="stylesheet" href="static/css/bootstrap-datetimepicker.min.css">
<script src="static/js/bootstrap-datetimepicker.min.js"></script>
<link rel="stylesheet" href="https://cdn.datatables.net/1.10.24/css/jquery.dataTables.min.css">
<link rel="stylesheet" href="https://cdn.datatables.net/select/1.3.3/css/select.dataTables.min.css">
<script src="https://cdn.datatables.net/1.10.24/js/jquery.dataTables.min.js"></script> 
<script src="https://gyrocode.github.io/jquery-datatables-checkboxes/1.2.10/js/dataTables.checkboxes.min.js"></script>
<link href="http://code.jquery.com/ui/1.10.2/themes/smoothness/jquery-ui.css" rel="Stylesheet">
<script type="text/javascript">
   $(function () {
	 activeNavigationClass();
     $("#userId").val(userInfo.id);

     getUploadOfferData();

     $('#btnFormReset').click(function () {
       $('#booking-trans-details')[0].reset();
       $("#lclData").hide();
       $("#fclData").show();
     });

     $('#originInputId').autocomplete({
       source: function (search, success) {
         $.ajax({
           url: server_url + 'utility/getAllLocation?location=' + search.term,
           headers: authHeader,
           method: 'GET',
           dataType: 'json',
           data: null,
           success: function (data) {
             success(getLocationList(data.respData));
           }
         });
       }
     });

     $("#destinationInputId").autocomplete({
       source: function (search, success) {
         $.ajax({
           url: server_url + 'utility/getAllLocation?location=' + search.term,
           headers: authHeader,
           method: 'GET',
           dataType: 'json',
           data: null,
           success: function (data) {
             success(getLocationList(data.respData));
           }
         });
       }
     });

     $('#lclLengthUnitId').on('change', function () {
       var selectedVal = this.value;
       $('#lclBreadthUnitId').val(selectedVal);
       $('#lclHeightUnitId').val(selectedVal);
       calculateVolume();
     });

     showRecentSearchData();

     if (window.location.href.indexOf("?search_data=") > -1) {

       var searchParam = location.search.split('search_data=')[1];
       var searchTransdata = decodeURIComponent(searchParam);

       let objSearchTransData;

       try {
         // this is how you parse a string into JSON    
         objSearchTransData = JSON.parse(searchTransdata);


         Object.keys(objSearchTransData).map(function (k) {

           console.log("key with value: " + k + " = " + objSearchTransData[k])

           if (k == "origin") {
             $("#originInputId").val(objSearchTransData[k]);
           } else if (k == "destination") {
             $("#destinationInputId").val(objSearchTransData[k]);
           } else if (k == "cargoCategory") {

             if (objSearchTransData[k] == "GEN") {
               $("#genRadiobtnId").prop("checked", true);
             } else if (objSearchTransData[k] == "GAZ") {
               $("#hazRadioBtnId").prop("checked", true);
             } else if (objSearchTransData[k] == "REEFER") {
               $("#reeferRadioBtnId").prop("checked", true);
             }

           } else if (k == "commodity") {
             $("#gencommodity").val(objSearchTransData[k]);
           } else if (k == "cargoReadyDate") {
             $("#cargoReadyDateId").val(objSearchTransData[k]);
           } else if (k == "shipmentType" && objSearchTransData[k] == "fcl") {

             $("#shipTypeFclId").prop("checked", true);
             $("#lclData").hide();
             $("#fclData").show();
             $(".search_btn").show();


           } else if (k == "twentyFtCount") {
             if (objSearchTransData[k] != 0) {
               $("#twentyFtCountInId").val(objSearchTransData[k]);
             }
           } else if (k == "fourtyFtCount") {
             if (objSearchTransData[k] != 0) {
               $("#fourtyFtCountInId").val(objSearchTransData[k]);
             }
           } else if (k == "fourtyFtHcCount") {
             if (objSearchTransData[k] != 0) {
               $("#fourtyFtHcCountInId").val(objSearchTransData[k]);
             }
           } else if (k == "fourtyFiveFtCount") {
             if (objSearchTransData[k] != 0) {
               $("#fourtyFiveFtCountInId").val(objSearchTransData[k]);
             }
           }

         })

       } catch (ex) {
         console.error(ex);
       };
     }


     /*  Submit form using Ajax */
     $("#booking-trans-details").submit(function (event) {
       $('#loader').show();
       //Prevent default submission of form
       event.preventDefault();

       var form_data = $(this).serializeJSON({
         useIntKeysAsArrayIndex: true
       });

       /*
	      var form_data = new FormData();
	      
	      form_data.append("userId", userInfo.id);
	      
	      form_data.append("origin",$("#originInputId").val());
	      form_data.append("destination", $("#destinationInputId").val());

	      var cargoCategory = $("input[name='cargoCategory']:checked").val();
	      form_data.append("cargoCategory", cargoCategory);
	      form_data.append("cargoReadyDate", $("#cargoReadyDateId").val());

	      var shipmentType = $("input[name='shipmentType']:checked").val();;
	      form_data.append("shipmentType", shipmentType);

	      form_data.append("twentyFtCount", $("#twentyFtCountInId").val());
	      form_data.append("fourtyFtCount", $("#fourtyFtCountInId").val());
	      form_data.append("fourtyFtHcCount", $("#fourtyFtHcCountInId").val());
	      form_data.append("fourtyFiveFtCount", $("#fourtyFiveFtCountInId").val());
           */

       $.post({
         url: server_url + 'user/checkSearchTransDetails',
         contentType: "application/json",
         headers: authHeader,
         data: JSON.stringify(form_data),
         success: function (response) {

           if (response.respCode == 1) {
             window.location.href = contextPath + "/search_result?search_data=" + encodeURI(JSON.stringify(form_data));
           } else if (response.respCode == 0) {
             console.log(response.respData);
             if(response.respData.popularForwarderResponseList.length > 0){
               var popforwarder = '';  
               for(var i=0 ; i< response.respData.popularForwarderResponseList.length ; i++){
            	   var popId = response.respData.popularForwarderResponseList[i].id;
                   var forwarder = response.respData.popularForwarderResponseList[i].forwarder;
                   var newDiv = '<div class="col">'+
                                   '<div id="ck-button">'+
                                      '<label><input type="checkbox" value="'+popId+'" id="'+popId+'" name="typePopforwarderid" onclick="popCheckBoxEvent(this);"><span>'+forwarder+'</span> </label>'+
                                   '</div>'+
                                '</div>';

                 popforwarder = popforwarder + newDiv;
               }
               $("#popularForwarderDiv").empty();
               $("#popularForwarderDiv").append(popforwarder);
             }
             loadForwarderListTable(response.respData.forwarderDetailsResponseList, "forcha_table");
             $('#fedcha_modal').modal('show');

           } else {
             errorBlock("#error_block", response.respData);
           }
           $('#loader').hide();
         },
         error: function (error) {

           console.log(error)

           console.log(error.responseJSON)

           if (error.responseJSON != undefined) {

             //errorBlock("#error_block",error.responseJSON.respData);
             swal(error.responseJSON.respData);

           } else {
             errorBlock("#error_block", "Server Error! Please contact administrator");

           }
           $('#loader').hide();
         }
       })

     });

     getAllAdsList();

     getAllPackageUnits();

   });

   function popCheckBoxEvent(obj){
	   var id = obj.id;
	   var value = obj.value;
	   if(obj.checked) {           
            $("input[type='checkbox'][value='"+value+"']").prop('checked',true);
         }else if(!obj.checked){       
        	 $("input[type='checkbox'][value='"+value+"']").prop('checked',false);
         }
   }
   
   function getAllAdsList() {
     $.ajax({
       type: 'GET',
       url: server_url + 'utility/getAllAds',
       enctype: 'multipart/form-data',
       headers: authHeader,
       processData: false,
       contentType: false,
       data: null,
       success: function (response) {
         console.log(response)
         if (response.respCode == 1) {
           var content = '';
           for (var i = 0; i < response.respData.length; i++) {
             content = content + '<span style="margin-right:20px;">' + response.respData[i].content + '</span>';
           }
           $('#scrollingTextId').append(content);
         } else {
           errorBlock("#error_block", response.respData)
         }
       },
       error: function (error) {
         console.log(error)
         if (error.responseJSON != undefined) {
           errorBlock("#error_block", error.responseJSON.respData);
         } else {
           errorBlock("#error_block", "Server Error! Please contact administrator");
         }
       }
     })

   }

   function checkboxValidation() {
     if ($('input:checkbox[name="typeforwarderid"]:checked').length > 5) {
       $(this).prop('checked', false)
       errorBlock("#error_block", "Allow only 5 Forwarders to select");
     }
   }
   
   function submitEnquirySearchRequest() {

     $('#loader').show();
     //Prevent default submission of form
     event.preventDefault();

     // var form_data = $(this).serializeJSON({useIntKeysAsArrayIndex: true});

     // var form_data = new FormData();
     var forwarderIds = $('input:checkbox[name="typeforwarderid"]:checked').map(function () {
       var val = this.value.trim();
       return val
     }).get().join(',');

     if (forwarderIds != "") {

       var form_data = {};
       form_data["userId"] = userInfo.id;
       form_data["origin"] = $("#originInputId").val();
       form_data["destination"] = $("#destinationInputId").val();
       var cargoCategory = $("input[name='cargoCategory']:checked").val();
       form_data["cargoCategory"] = cargoCategory;
       form_data["commodity"] = $("#gencommodity").val();
       form_data["imco"] = $("#imco").val();
       form_data["temprange"] = $("#temprangeId").val();
       form_data["cargoReadyDate"] = $("#cargoReadyDateId").val();
       var shipmentType = $("input[name='shipmentType']:checked").val();
       form_data["shipmentType"] = shipmentType;
       form_data["twentyFtCount"] = $("#twentyFtCountInId").val();
       form_data["fourtyFtCount"] = $("#fourtyFtCountInId").val();
       form_data["fourtyFtHcCount"] = $("#fourtyFtHcCountInId").val();
       form_data["fourtyFiveFtCount"] = $("#fourtyFiveFtCountInId").val();
       form_data["forwarderIds"] = forwarderIds;

       form_data["lcltotalweight"] = $("#lclTotalWeightInId").val();
       form_data["lclweightunit"] = $("#lclweightunitId").val();
       form_data["lclvolume"] =  $("#lclCubicVolumeId").val();
       form_data["lclvolumeunit"] = $("#lclvolumeunitId").val();
       form_data["lclnumberpackage"] = $("#lclNumPackId").val();
       form_data["lclpackageunit"] =  $("#packUnitDropdownId").val();

       $.post({
         url: server_url + 'user/sendEnquirySearchRequest',
         contentType: "application/json",
         headers: authHeader,
         data: JSON.stringify(form_data),
         success: function (response) {

           if (response.respCode == 1) {
             $('#loader').hide();
             $('#fedcha_modal').modal('hide');
             
             $('#booking-trans-details')[0].reset();
             $("#lclData").hide();
             $("#fclData").show();
             
             swal(response.respData.msg);
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
     } else {
       $('#loader').hide();
       errorBlock("#error_block", "Please choose atleast one Forwarder / CHA ");
     }

   }

   function loadForwarderListTable(data, tableId) {

     $('#' + tableId).dataTable().fnClearTable();

     var oTable = $('#' + tableId).DataTable({
       'responsive': true,
       "destroy": true,
       "data": data,
       "dom": 'lBfrtip',
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
             var id = data.id;
             var checkbox = '<input type="checkbox" id="' + id + '" name="typeforwarderid" value="' + id + '" onchange="checkboxValidation();">';
             return checkbox;
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
             var location = data.location;

             return location;
           }
         }

       ]

     });

   }

   function calculateVolume() {

     var lclLength = $('#lclLengthId').val();
     var lclBreadth = $('#lclBreadthId').val();
     var lclHeight = $('#lclHeightId').val();

     if (lclLength == '') {
       errorBlock("#error_block", "Please enter length ");
     } else if (lclBreadth == '') {
       errorBlock("#error_block", "Please enter breadth ");
     } else if (lclHeight == '') {
       errorBlock("#error_block", "Please enter height ");
     }
     var cbm = '';
     if (lclLength != '' && lclBreadth != '' && lclHeight != '') {
       var lclLengthUnitId = $('#lclLengthUnitId').val();

       if (lclLengthUnitId == "mm") {
         var lengthInMeter = lclLength * 0.001;
         var breadthInMeter = lclBreadth * 0.001;
         var heightInMeter = lclHeight * 0.001;
         cbm = lengthInMeter * breadthInMeter * heightInMeter;
         cbm = cbm.toFixed(4);
       } else if (lclLengthUnitId == "cm") {
         var lengthInMeter = lclLength * 0.01;
         var breadthInMeter = lclBreadth * 0.01;
         var heightInMeter = lclHeight * 0.01;
         cbm = lengthInMeter * breadthInMeter * heightInMeter;
         cbm = cbm.toFixed(4);
       } else if (lclLengthUnitId == "in") {
         var lengthInMeter = lclLength * 0.0254;
         var breadthInMeter = lclBreadth * 0.0254;
         var heightInMeter = lclHeight * 0.0254;
         cbm = lengthInMeter * breadthInMeter * heightInMeter;
         cbm = cbm.toFixed(4);
       } else if (lclLengthUnitId == "ft") {
         var lengthInMeter = lclLength * 0.3048;
         var breadthInMeter = lclBreadth * 0.3048;
         var heightInMeter = lclHeight * 0.3048;
         cbm = lengthInMeter * breadthInMeter * heightInMeter;
         cbm = cbm.toFixed(4);
       } else if (lclLengthUnitId == "m") {
         var lengthInMeter = lclLength;
         var breadthInMeter = lclBreadth;
         var heightInMeter = lclHeight;
         cbm = lengthInMeter * breadthInMeter * heightInMeter;
       }

       if (cbm < 60.000 && cbm > 0.0001) {
         $('#lclCalcModalVolumeId').val(cbm);
         $('#lclCubicVolumeId').val(cbm);
         // $('#need_help_modal').modal('hide');
       }else if(cbm > 60.000) {
         $('#lclCalcModalVolumeId').val(cbm);
         errorBlock("#error_block", "Please recheck the dimensions entered");
       }else if(cbm < 0.0001){
    	$('#lclCalcModalVolumeId').val(cbm);
        errorBlock("#error_block", "Please recheck the dimensions entered");
       }
     }
     return cbm;
   }

   function calculateLCLVolume() {
     var cbm = calculateVolume();
     if (cbm < 60.000 && cbm > 0.0001) {
       $('#need_help_modal').modal('hide');
     }
   }

</script>
</head>

<form method="post" id="booking-trans-details">
  <div class="container-fluid">
    <div class="bg_white_main">
      <div class="row minht400 spl_padd">
        <div class="col-md-12 padd0">
          <h2 class="book_cargo_hd">Book your cargo online by making an informed choice!</h2>
        </div>
        <div class="col-md-12">
          <div class="bg_white31 row">
            <div class="col-md-8 col-xs-12">
              <div class="bg_white3 mb-0">
                <div class="row">
                  <div class="col-md-6">
                    <div class="bg_white3">
                      <input type="hidden" id="userId" name="userId" >
                      <label class="form-label mt-0">Shipment Origin</label>
                      <input type="text" class="form-control font14" name="origin" id="originInputId" oninvalid="this.setCustomValidity('Please select shipment origin')" oninput="setCustomValidity('')" required>
                      <label class="form-label">Shipment Destination</label>
                      <input type="text" class="form-control font14" name="destination" id="destinationInputId" oninvalid="this.setCustomValidity('Please select shipment destination')" oninput="setCustomValidity('')" required>
                    </div>
                    <div class="bg_white3">
                      <label class="form-label mt-0">Cargo Category</label>
                      <input type="radio" class="form-control1 radio_val" name="cargoCategory" value="GEN" id="genRadiobtnId" checked>
                      <span class="radio_label">General</span>
                      <input type="radio" class="form-control1 radio_val ml-4" name="cargoCategory" value="HAZ" id="hazRadioBtnId" >
                      <span class="radio_label">Hazardous</span>
                      <input type="radio" class="form-control1 radio_val ml-4" name="cargoCategory" value="REEFER" id="reeferRadioBtnId" >
                      <span class="radio_label">Reefer</span> 
                    
                      <div class="row mt-3">
                        <div class="gen" >
                          <div class="col-md-12">
                            <div class="row">
                              <div class="col-md-6" id="genDivId">
                                <label class="form-label">Commodity </label>
                                <input type="text" class="form-control font14 capitalize" placeholder="" name="commodity" id="gencommodity" onkeypress="return isAlphaNumericKey(event)" autocomplete="off">
                              </div>
                              <div class="col-md-6" id="hideDivId">
                                <label class="form-label"></label>
                                <input type="text" class="" placeholder="" name="" id="" disabled>
                              </div>
                               <div class="col-md-6" id="hazDivId" style="display:none;">
                                <label class="form-label">IMCO</label>
                                <input type="text" class="form-control font14 capitalize" placeholder="" name="imco" id="imco" autocomplete="off" >
                              </div>
                              <div class="col-md-6" id="reeferDivId" style="display:none;">
                                <label class="form-label">Temperature Range</label>
                                <input type="text" class="form-control font14 capitalize" placeholder="" name="temprange" id="temprangeId" autocomplete="off">
                              </div>
                            </div>
                          </div>
                        </div>
  
                      </div>
                      
                    </div>
                    <div class="bg_white3 mb-0">
                      <label class="form-label3 mt-0">Recent Searches</label>
                      <div class="recent_search_div" id="recentSearchAppId"> </div>
                      <i class="fa fa-chevron-down recent_arrow" aria-hidden="true" ></i> 
                      
                      <!-- <a href="#" class="recent_links">INNSA to BEANR <span class="recent_date">- Dec 15</span></a><br>
      			<a href="#" class="recent_links recent_hidden_link">GOYRA to DJURY <span class="recent_date">- Dec 20</span></a>
      			<a href="#" class="recent_links recent_hidden_link">BEANR to INNSA <span class="recent_date">- Dec 22</span></a>
      			<a href="#" class="recent_links recent_hidden_link">INNSA to DJURY <span class="recent_date">- Dec 24</span></a>
      			<a href="#" class="recent_links recent_hidden_link">BEANR to INNSA <span class="recent_date">- Dec 28</span></a> --> 
                    </div>
                  </div>
                  <div class="col-md-6">
                    <div class="bg_white3">
                      <label class="form-label mt-0">Shipment Type</label>
                      <input type="radio" class="form-control1 radio_val" name="shipmentType" value="FCL" id="shipTypeFclId" checked>
                      <span class="radio_label">FCL</span>
                      <input type="radio" class="form-control1 radio_val ml-4" name="shipmentType" value="LCL" id="shipTypeLclId">
                      <span class="radio_label">LCL</span>
                      <div id="fclData" class="mt32">
                        <div class="number">
                          <label class="ft_label">20' FT</label>
                          <span class="minus">-</span>
                          <input type="text" value="0" name="twentyFtCount" class="ft_no" maxlength="1" id="twentyFtCountInId" onkeypress="return isNumberKey(event,this)"/>
                          <span class="plus">+</span> </div>
                        <div class="number">
                          <label class="ft_label">40' FT</label>
                          <span class="minus">-</span>
                          <input type="text" value="0" name="fourtyFtCount" class="ft_no" maxlength="1" id="fourtyFtCountInId" onkeypress="return isNumberKey(event,this)"/>
                          <span class="plus">+</span> </div>
                        <div class="number">
                          <label class="ft_label">40' FT HC</label>
                          <span class="minus">-</span>
                          <input type="text" value="0" name="fourtyFtHcCount" class="ft_no" maxlength="1" id="fourtyFtHcCountInId" onkeypress="return isNumberKey(event,this)"/>
                          <span class="plus">+</span> </div>
                        <div class="number">
                          <label class="ft_label">45' FT HC</label>
                          <span class="minus">-</span>
                          <input type="text" value="0" name="fourtyFiveFtCount" class="ft_no" maxlength="1" id="fourtyFiveFtCountInId" onkeypress="return isNumberKey(event,this)"/>
                          <span class="plus">+</span> </div>
                        <div class="row mt-3">                          
                        </div>
                      </div>
                      <div id="lclData" class="mt13">
                        <div class="clearfix"></div>
                        <div class="row">
                          <div class="col">
                            <label class="form-label">Total Weight</label>                           
                            <input type="text" class="form-control2 font14 text-right" maxlength="6" name="lcltotalweight" id="lclTotalWeightInId" oninput='numberOnly(this.id);'>
                            <select class="form-control3 ml-3 font14" name="lclweightunit" id="lclweightunitId">
                              <option value="Kgs">Kgs</option>
                              <option value="Pounds">Pounds</option>
                            </select>
                          </div>
                        </div>
                        <div class="clearfix"></div>
                        <div class="row">
                          <div class="col">
                            <label class="form-label col-md-8 padding-0">Volume &nbsp; &nbsp; &nbsp;                               
                              <span class="form-label-kg"><a class="need_help">Need help to calculate?</a></span></label>
                          </div>
                        </div>
                        <input type="text" class="form-control2 font14 text-right" maxlength="6" name="lclvolume" id="lclCubicVolumeId" onkeypress="return isNumberKey(event,this)">
                        <select class="form-control3 ml-3 font14" name="lclvolumeunit" id="lclvolumeunitId">
                          <option value="CBM">CBM</option>
                        </select>                       
                        <label class="form-label">Number of Packages</label>
                        <input type="text" class="form-control2 font14 text-right" maxlength="4" name="lclnumberpackage" id="lclNumPackId" oninput='numberOnly(this.id);'>
                        <select class="form-control3 ml-3 font14" id="packUnitDropdownId" name="lclpackageunit">                         
                        </select>
                        <div class="clearfix"></div>
                      </div>
                    </div>
                    <div class="bg_white3 orangetxtfont">
                      <label class="form-label mt-0">Cargo Ready Date</label>
                      <input type="text" class="form-control font14" autocomplete="off" name ="cargoReadyDate" id="cargoReadyDateId" onkeypress="return isNotAllowKey(event,this)" required>
                    </div>
                  </div>
                  <div class="col-md-6"> </div>
                  <div class="col-md-6">
                    <button type="submit" value="Search" class="search_btn"><span>Submit</span></button>
                    <button type="button" value="Clear" class="clear_btn" id="btnFormReset"><span>Clear</span></button>
                  </div>
                </div>
              </div>
            </div>
            <div class="col-md-4 col-xs-12">
              <div class="bg_white6">
                <div id="demo" class="carousel slide" data-ride="carousel"> 
                  
                  <!-- Indicators -->
                  <ul class="carousel-indicators" id="offerCarouselId">
                    <li data-target="#demo" data-slide-to="0" class="active"></li>
                    <li data-target="#demo" data-slide-to="1"></li>
                    <li data-target="#demo" data-slide-to="2"></li>
                  </ul>
                  
                  <!-- The slideshow -->
                  <div class="carousel-inner" id="offerCarouselInnerId"> 
                    <!--  
			    <div class="carousel-item active">
                   <img src="static/images/place.jpg" alt="Los Angeles" width="100%" height="auto">
                   <h3 class="place_hd">Special Rates for Antwerp</h3>
		           <p class="place_line">Valid till 30 Nov 20?</p>
		           <p class="place_line"> <a  data-target="#viewMoreModal" data-toggle="modal"  href="#viewMoreModal">....more</a></p>
               </div>
               
               <div class="carousel-item ">
                    <img src="static/images/place2.jpg" alt="Chicago" width="100%" height="auto">
                   <h3 class="place_hd">Special Rates for Antwerp</h3>
		           <p class="place_line">Valid till 30 Nov 20?</p>
		           <p class="place_line"> <a data-target="#viewMoreModal" data-toggle="modal"  href="#viewMoreModal">....more</a></p>
               </div>
               
               <div class="carousel-item ">
                   <img src="static/images/place.jpg" alt="New York" width="100%" height="auto">
                   <h3 class="place_hd">Special Rates for Antwerp</h3>
		           <p class="place_line">Valid till 30 Nov 20?</p>
		           <p class="place_line"><a data-target="#viewMoreModal" data-toggle="modal"  href="#viewMoreModal">....more</a></p>
               </div>
			      --> 
                  </div>
                  
                  <!-- Left and right controls --> 
                  <a class="carousel-control-prev" href="#demo" data-slide="prev"> <span class="carousel-control-prev-icon"></span> </a> <a class="carousel-control-next" href="#demo" data-slide="next"> <span class="carousel-control-next-icon"></span> </a> </div>
              </div>
            </div>
          </div>
        </div>
        
        <!-- Codes by HTMLcodes.ws -->
        <div class="col-md-12">
          <marquee class="scroll_text" behavior="scroll" direction="left" id="scrollingTextId">
          <!--  We provide you the ability to digitally manage all your logistics requirements. -->
          </marquee>
          <div class="highlight_text_wrap">
            <div class="row">
              <div class="col-md-3"><a href="#videoModal" data-toggle="modal" data-target="#videoModal"> <img src="static/images/icon1.png" alt="img" class="icon_img"></a>
                <h3 class="highlight_hd">Quotation</h3>
              </div>
              <div class="col-md-3"><a href="#videoModalB" data-toggle="modal" data-target="#videoModalB"> <img src="static/images/icon2.png" alt="img" class="icon_img"></a>
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
        <div class="col-md-12 mt-4">
          <div class="bg_white3">
            <label class="form-label mt-0">Select a country to find out location specific requirements before you make a booking</label>
            <div class="flex_box"> <a class="country_link country_linkA country_link_active">A</a> <a class="country_link country_linkB">B</a> <a class="country_link country_linkC">C</a> <a class="country_link country_linkD">D</a> <a class="country_link country_linkE">E</a> <a class="country_link country_linkF">F</a> <a class="country_link country_linkG">G</a> <a class="country_link country_linkH">H</a> <a class="country_link country_linkI">I</a> <a class="country_link country_linkJ">J</a> <a class="country_link country_linkK">K</a> <a class="country_link country_linkL">L</a> <a class="country_link country_linkM">M</a> <a class="country_link country_linkN">N</a> <a class="country_link country_linkO">O</a> <a class="country_link country_linkP">P</a> <a class="country_link country_linkQ">Q</a> <a class="country_link country_linkR">R</a> <a class="country_link country_linkS">S</a> <a class="country_link country_linkT">T</a> <a class="country_link country_linkU">U</a> <a class="country_link country_linkV">V</a> <a class="country_link country_linkW">W</a> <a class="country_link country_linkX">X</a> <a class="country_link country_linkY">Y</a> <a class="country_link country_linkZ">Z</a> </div>
            <div class="country_listA">
              <ul class="list-unstyled card-columns">
                <li><a class="country_list_link" setvalue="- At present, specific requirements for this country are not available with us." id="AF">Afghanistan</a></li>
                <li><a class="country_list_link" setvalue="- At present, specific requirements for this country are not available with us." id="AL">Albania</a></li>
                <li><a class="country_list_link" setvalue="- At present, specific requirements for this country are not available with us." id="DZ">Algeria</a></li>
                <li><a class="country_list_link" setvalue="- At present, specific requirements for this country are not available with us." id="AS">American Samoa</a></li>
                <li><a class="country_list_link" setvalue="- At present, specific requirements for this country are not available with us." id="AD">Andorra</a></li>
                <li><a class="country_list_link" setvalue="- At present, specific requirements for this country are not available with us." id="AO">Angola</a></li>
                <li><a class="country_list_link" setvalue="- At present, specific requirements for this country are not available with us." id="AI">Anguilla</a></li>
                <li><a class="country_list_link" setvalue="- At present, specific requirements for this country are not available with us." id="AQ">Antarctica</a></li>
                <li><a class="country_list_link" setvalue="- At present, specific requirements for this country are not available with us." id="AG">Antigua and Barbuda</a></li>
                <li><a class="country_list_link" setvalue="- At present, specific requirements for this country are not available with us." id="AR">Argentina</a></li>
                <li><a class="country_list_link" setvalue="- At present, specific requirements for this country are not available with us." id="AM">Armenia</a></li>
                <li><a class="country_list_link" setvalue="- At present, specific requirements for this country are not available with us." id="AW">Aruba</a></li>
                <li><a class="country_list_link" setvalue="- At present, specific requirements for this country are not available with us." id="AU">Australia</a></li>
                <li><a class="country_list_link" setvalue="- At present, specific requirements for this country are not available with us." id="AT">Austria</a></li>
                <li><a class="country_list_link" setvalue="- At present, specific requirements for this country are not available with us." id="AZ">Azerbaijan</a></li>
              </ul>
            </div>
            <div class="country_listB">
              <ul class="list-unstyled card-columns">
                <li><a class="country_list_link" setvalue="- At present, specific requirements for this country are not available with us." id="BS">Bahamas</a></li>
                <li><a class="country_list_link" setvalue="- At present, specific requirements for this country are not available with us." id="BH">Bahrain</a></li>
                <li><a class="country_list_link" setvalue="- At present, specific requirements for this country are not available with us." id="BD">Bangladesh</a></li>
                <li><a class="country_list_link" setvalue="- At present, specific requirements for this country are not available with us." id="BB">Barbados</a></li>
                <li><a class="country_list_link" setvalue="- At present, specific requirements for this country are not available with us." id="BY">Belarus</a></li>
                <li><a class="country_list_link" setvalue="- At present, specific requirements for this country are not available with us." id="BE">Belgium</a></li>
                <li><a class="country_list_link" setvalue="- At present, specific requirements for this country are not available with us." id="BZ">Belize</a></li>
                <li><a class="country_list_link" setvalue="- At present, specific requirements for this country are not available with us." id="BJ">Benin</a></li>
                <li><a class="country_list_link" setvalue="- At present, specific requirements for this country are not available with us." id="BM">Bermuda</a></li>
                <li><a class="country_list_link" setvalue="- At present, specific requirements for this country are not available with us." id="BT">Bhutan</a></li>
                <li><a class="country_list_link" setvalue="- At present, specific requirements for this country are not available with us." id="BO">Bolivia</a></li>
                <li><a class="country_list_link" setvalue="- At present, specific requirements for this country are not available with us." id="BQ">Bonaire</a></li>
                <li><a class="country_list_link" setvalue="- At present, specific requirements for this country are not available with us." id="BA">Bosnia and Herzegovina</a></li>
                <li><a class="country_list_link" setvalue="- At present, specific requirements for this country are not available with us." id="BW">Botswana</a></li>
                <li><a class="country_list_link" setvalue="- At present, specific requirements for this country are not available with us." id="BR">Brazil</a></li>
                <li><a class="country_list_link" setvalue="- At present, specific requirements for this country are not available with us." id="IO">British Indian Ocean Territory</a></li>
                <li><a class="country_list_link" setvalue="- At present, specific requirements for this country are not available with us." id="BN">Brunei Darussalam</a></li>
                <li><a class="country_list_link" setvalue="- At present, specific requirements for this country are not available with us." id="BG">Bulgaria</a></li>
                <li><a class="country_list_link" setvalue="- At present, specific requirements for this country are not available with us." id="BF">Burkina Faso</a></li>
                <li><a class="country_list_link" setvalue="- At present, specific requirements for this country are not available with us." id="BI">Burundi</a></li>
              </ul>
            </div>
            <div class="country_listC">
              <ul class="list-unstyled card-columns">
                <li><a class="country_list_link" setvalue="- At present, specific requirements for this country are not available with us." id="CV">Cabo Verde</a></li>
                <li><a class="country_list_link" setvalue="- At present, specific requirements for this country are not available with us." id="KH">Cambodia</a></li>
                <li><a class="country_list_link" setvalue="- At present, specific requirements for this country are not available with us." id="CM">Cameroon</a></li>
                <li><a class="country_list_link" setvalue="- At present, specific requirements for this country are not available with us." id="CA">Canada</a></li>
                <li><a class="country_list_link" setvalue="- At present, specific requirements for this country are not available with us." id="KY">Cayman Islands</a></li>
                <li><a class="country_list_link" setvalue="- At present, specific requirements for this country are not available with us." id="CF">Central African Republic</a></li>
                <li><a class="country_list_link" setvalue="- At present, specific requirements for this country are not available with us." id="TD">Chad</a></li>
                <li><a class="country_list_link" setvalue="- At present, specific requirements for this country are not available with us." id="CL">Chile</a></li>
                <li><a class="country_list_link" setvalue="- At present, specific requirements for this country are not available with us." id="CN">China</a></li>
                <li><a class="country_list_link" setvalue="- At present, specific requirements for this country are not available with us." id="CC">Cocos (Keeling) Islands</a></li>
                <li><a class="country_list_link" setvalue="- At present, specific requirements for this country are not available with us." id="CO">Colombia</a></li>
                <li><a class="country_list_link" setvalue="- At present, specific requirements for this country are not available with us." id="KM">Comoros</a></li>
                <li><a class="country_list_link" setvalue="- At present, specific requirements for this country are not available with us." id="CD">Congo</a></li>
                <li><a class="country_list_link" setvalue="- At present, specific requirements for this country are not available with us." id="CK">Cook Islands</a></li>
                <li><a class="country_list_link" setvalue="- At present, specific requirements for this country are not available with us." id="CR">Costa Rica</a></li>
                <li><a class="country_list_link" setvalue="- At present, specific requirements for this country are not available with us." id="CI">Cote d'Ivoire</a></li>
                <li><a class="country_list_link" setvalue="- At present, specific requirements for this country are not available with us." id="HR">Croatia</a></li>
                <li><a class="country_list_link" setvalue="- At present, specific requirements for this country are not available with us." id="CU">Cuba</a></li>
                <li><a class="country_list_link" setvalue="- At present, specific requirements for this country are not available with us." id="CY">Cyprus</a></li>
                <li><a class="country_list_link" setvalue="- At present, specific requirements for this country are not available with us." id="CZ">Czech Republic</a></li>
              </ul>
            </div>
            <div class="country_listD">
              <ul class="list-unstyled card-columns">
                <li><a class="country_list_link" setvalue="- At present, specific requirements for this country are not available with us." id="DK">Denmark</a></li>
                <li><a class="country_list_link" setvalue="- At present, specific requirements for this country are not available with us." id="DJ">Djibouti</a></li>
                <li><a class="country_list_link" setvalue="- At present, specific requirements for this country are not available with us." id="DM">Dominica</a></li>
                <li><a class="country_list_link" setvalue="- At present, specific requirements for this country are not available with us." id="DO">Dominican Republic</a></li>
                <li>&nbsp;</li>
              </ul>
            </div>
            <div class="country_listE">
              <ul class="list-unstyled card-columns">
                <li><a class="country_list_link" setvalue="- At present, specific requirements for this country are not available with us." id="EC">Ecuador</a></li>
                <li><a class="country_list_link" setvalue="- At present, specific requirements for this country are not available with us." id="EG">Egypt</a></li>
                <li><a class="country_list_link" setvalue="- At present, specific requirements for this country are not available with us." id="SV">El Salvador</a></li>
                <li><a class="country_list_link" setvalue="- At present, specific requirements for this country are not available with us." id="GQ">Equatorial Guinea</a></li>
                <li><a class="country_list_link" setvalue="- At present, specific requirements for this country are not available with us." id="ER">Eritrea</a></li>
                <li><a class="country_list_link" setvalue="- At present, specific requirements for this country are not available with us." id="EE">Estonia</a></li>
                <li><a class="country_list_link" setvalue="- At present, specific requirements for this country are not available with us." id="ET">Ethiopia</a></li>
                <li>&nbsp;</li>
                <li>&nbsp;</li>
                <li>&nbsp;</li>
              </ul>
            </div>
            <div class="country_listF">
              <ul class="list-unstyled card-columns">
                <li><a class="country_list_link" setvalue="- At present, specific requirements for this country are not available with us." id="FK">Falkland Islands</a></li>
                <li><a class="country_list_link" setvalue="- At present, specific requirements for this country are not available with us." id="FO">Faroe Islands</a></li>
                <li><a class="country_list_link" setvalue="- At present, specific requirements for this country are not available with us." id="FJ">Fiji</a></li>
                <li><a class="country_list_link" setvalue="- At present, specific requirements for this country are not available with us." id="FI">Finland</a></li>
                <li><a class="country_list_link" setvalue="- At present, specific requirements for this country are not available with us." id="FR">France</a></li>
                <li><a class="country_list_link" setvalue="- At present, specific requirements for this country are not available with us." id="PF">French Polynesia</a></li>
                <li>&nbsp;</li>
                <li>&nbsp;</li>
                <li>&nbsp;</li>
                <li>&nbsp;</li>
              </ul>
            </div>
            <div class="country_listG">
              <ul class="list-unstyled card-columns">
                <li><a class="country_list_link" setvalue="- At present, specific requirements for this country are not available with us." id="GA">Gabon</a></li>
                <li><a class="country_list_link" setvalue="- At present, specific requirements for this country are not available with us." id="GM">Gambia</a></li>
                <li><a class="country_list_link" setvalue="- At present, specific requirements for this country are not available with us." id="GE">Georgia</a></li>
                <li><a class="country_list_link" setvalue="- At present, specific requirements for this country are not available with us." id="DE">Germany</a></li>
                <li><a class="country_list_link" setvalue="- At present, specific requirements for this country are not available with us." id="GH">Ghana</a></li>
                <li><a class="country_list_link" setvalue="- At present, specific requirements for this country are not available with us." id="GI">Gibraltar</a></li>
                <li><a class="country_list_link" setvalue="- At present, specific requirements for this country are not available with us." id="GR">Greece</a></li>
                <li><a class="country_list_link" setvalue="- At present, specific requirements for this country are not available with us." id="GL">Greenland</a></li>
                <li><a class="country_list_link" setvalue="- At present, specific requirements for this country are not available with us." id="GD">Grenada</a></li>
                <li><a class="country_list_link" setvalue="- At present, specific requirements for this country are not available with us." id="GP">Guadeloupe</a></li>
                <li><a class="country_list_link" setvalue="- At present, specific requirements for this country are not available with us." id="GU">Guam</a></li>
                <li><a class="country_list_link" setvalue="- At present, specific requirements for this country are not available with us." id="GT">Guatemala</a></li>
                <li><a class="country_list_link" setvalue="- At present, specific requirements for this country are not available with us." id="GG">Guernsey</a></li>
                <li><a class="country_list_link" setvalue="- At present, specific requirements for this country are not available with us." id="GN">Guinea</a></li>
                <li><a class="country_list_link" setvalue="- At present, specific requirements for this country are not available with us." id="GW">Guinea-Bissau</a></li>
                <li><a class="country_list_link" setvalue="- At present, specific requirements for this country are not available with us." id="GY">Guyana</a></li>
              </ul>
            </div>
            <div class="country_listH">
              <ul class="list-unstyled card-columns">
                <li><a class="country_list_link" setvalue="- At present, specific requirements for this country are not available with us." id="HT">Haiti</a></li>
                <li><a class="country_list_link" setvalue="- At present, specific requirements for this country are not available with us." id="HM">Heard Island and McDonald Islands</a></li>
                <li><a class="country_list_link" setvalue="- At present, specific requirements for this country are not available with us." id="HN">Honduras</a></li>
                <li><a class="country_list_link" setvalue="- At present, specific requirements for this country are not available with us." id="HK">Hong Kong</a></li>
                <li><a class="country_list_link" setvalue="- At present, specific requirements for this country are not available with us." id="HU">Hungary</a></li>
              </ul>
            </div>
            <div class="country_listI">
              <ul class="list-unstyled card-columns">
                <li><a class="country_list_link" setvalue="- At present, specific requirements for this country are not available with us." id="IS">Iceland</a></li>
                <li><a class="country_list_link" setvalue="- At present, specific requirements for this country are not available with us." id="IN">India</a></li>
                <li><a class="country_list_link" setvalue="- At present, specific requirements for this country are not available with us." id="ID">Indonesia</a></li>
                <li><a class="country_list_link" setvalue="- At present, specific requirements for this country are not available with us." id="IR">Iran</a></li>
                <li><a class="country_list_link" setvalue="- At present, specific requirements for this country are not available with us." id="IQ">Iraq</a></li>
                <li><a class="country_list_link" setvalue="- At present, specific requirements for this country are not available with us." id="IE">Ireland</a></li>
                <li><a class="country_list_link" setvalue="- At present, specific requirements for this country are not available with us." id="IM">Isle of Man</a></li>
                <li><a class="country_list_link" setvalue="- At present, specific requirements for this country are not available with us." id="IL">Israel</a></li>
                <li><a class="country_list_link" setvalue="- At present, specific requirements for this country are not available with us." id="IT">Italy</a></li>
                <li>&nbsp;</li>
              </ul>
            </div>
            <div class="country_listJ">
              <ul class="list-unstyled card-columns">
                <li><a class="country_list_link" setvalue="- At present, specific requirements for this country are not available with us." id="JM">Jamaica</a></li>
                <li><a class="country_list_link" setvalue="- At present, specific requirements for this country are not available with us." id="JP">Japan</a></li>
                <li><a class="country_list_link" setvalue="- At present, specific requirements for this country are not available with us." id="JE">Jersey</a></li>
                <li><a class="country_list_link" setvalue="- At present, specific requirements for this country are not available with us." id="JO">Jordan</a></li>
                <li>&nbsp;</li>
              </ul>
            </div>
            <div class="country_listK">
              <ul class="list-unstyled card-columns">
                <li><a class="country_list_link" setvalue="- At present, specific requirements for this country are not available with us." id="KZ">Kazakhstan</a></li>
                <li><a class="country_list_link" setvalue="- At present, specific requirements for this country are not available with us." id="KE">Kenya</a></li>
                <li><a class="country_list_link" setvalue="- At present, specific requirements for this country are not available with us." id="KI">Kiribati</a></li>
                <li><a class="country_list_link" setvalue="- At present, specific requirements for this country are not available with us." id="KW">Kuwait</a></li>
                <li><a class="country_list_link" setvalue="- At present, specific requirements for this country are not available with us." id="KG">Kyrgyzstan</a></li>
              </ul>
            </div>
            <div class="country_listL">
              <ul class="list-unstyled card-columns">
                <li><a class="country_list_link" setvalue="- At present, specific requirements for this country are not available with us." id="LA">Laos</a></li>
                <li><a class="country_list_link" setvalue="- At present, specific requirements for this country are not available with us." id="LV">Latvia</a></li>
                <li><a class="country_list_link" setvalue="- At present, specific requirements for this country are not available with us." id="LB">Lebanon</a></li>
                <li><a class="country_list_link" setvalue="- At present, specific requirements for this country are not available with us." id="LS">Lesotho</a></li>
                <li><a class="country_list_link" setvalue="- At present, specific requirements for this country are not available with us." id="LR">Liberia</a></li>
                <li><a class="country_list_link" setvalue="- At present, specific requirements for this country are not available with us." id="LY">Libya</a></li>
                <li><a class="country_list_link" setvalue="- At present, specific requirements for this country are not available with us." id="LT">Lithuania</a></li>
                <li><a class="country_list_link" setvalue="- At present, specific requirements for this country are not available with us." id="LU">Luxembourg</a></li>
                <li>&nbsp;</li>
                <li>&nbsp;</li>
              </ul>
            </div>
            <div class="country_listM">
              <ul class="list-unstyled card-columns">
                <li><a class="country_list_link" setvalue="- At present, specific requirements for this country are not available with us." id="MO">Macao</a></li>
                <li><a class="country_list_link" setvalue="- At present, specific requirements for this country are not available with us." id="MK">Macedonia</a></li>
                <li><a class="country_list_link" setvalue="- At present, specific requirements for this country are not available with us." id="MG">Madagascar</a></li>
                <li><a class="country_list_link" setvalue="- At present, specific requirements for this country are not available with us." id="MW">Malawi</a></li>
                <li><a class="country_list_link" setvalue="- At present, specific requirements for this country are not available with us." id="MY">Malaysia</a></li>
                <li><a class="country_list_link" setvalue="- At present, specific requirements for this country are not available with us." id="MV">Maldives</a></li>
                <li><a class="country_list_link" setvalue="- At present, specific requirements for this country are not available with us." id="ML">Mali</a></li>
                <li><a class="country_list_link" setvalue="- At present, specific requirements for this country are not available with us." id="MT">Malta</a></li>
                <li><a class="country_list_link" setvalue="- At present, specific requirements for this country are not available with us." id="MH">Marshall Islands</a></li>
                <li><a class="country_list_link" setvalue="- At present, specific requirements for this country are not available with us." id="MQ">Martinique</a></li>
                <li><a class="country_list_link" setvalue="- At present, specific requirements for this country are not available with us." id="MR">Mauritania</a></li>
                <li><a class="country_list_link" setvalue="- At present, specific requirements for this country are not available with us." id="MU">Mauritius</a></li>
                <li><a class="country_list_link" setvalue="- At present, specific requirements for this country are not available with us." id="MX">Mexico</a></li>
                <li><a class="country_list_link" setvalue="- At present, specific requirements for this country are not available with us." id="FM">Micronesia</a></li>
                <li><a class="country_list_link" setvalue="- At present, specific requirements for this country are not available with us." id="MD">Moldova</a></li>
                <li><a class="country_list_link" setvalue="- At present, specific requirements for this country are not available with us." id="MC">Monaco</a></li>
                <li><a class="country_list_link" setvalue="- At present, specific requirements for this country are not available with us." id="MN">Mongolia</a></li>
                <li><a class="country_list_link" setvalue="- At present, specific requirements for this country are not available with us." id="ME">Montenegro</a></li>
                <li><a class="country_list_link" setvalue="- At present, specific requirements for this country are not available with us." id="MS">Montserrat</a></li>
                <li><a class="country_list_link" setvalue="- At present, specific requirements for this country are not available with us." id="MA">Morocco</a></li>
                <li><a class="country_list_link" setvalue="- At present, specific requirements for this country are not available with us." id="MZ">Mozambique</a></li>
                <li><a class="country_list_link" setvalue="- At present, specific requirements for this country are not available with us." id="MM">Myanmar</a></li>
              </ul>
            </div>
            <div class="country_listN">
              <ul class="list-unstyled card-columns">
                <li><a class="country_list_link" setvalue="- At present, specific requirements for this country are not available with us." id="NA">Namibia</a></li>
                <li><a class="country_list_link" setvalue="- At present, specific requirements for this country are not available with us." id="NR">Nauru</a></li>
                <li><a class="country_list_link" setvalue="- At present, specific requirements for this country are not available with us." id="NP">Nepal</a></li>
                <li><a class="country_list_link" setvalue="- At present, specific requirements for this country are not available with us." id="NL">Netherlands</a></li>
                <li><a class="country_list_link" setvalue="- At present, specific requirements for this country are not available with us." id="NC">New Caledonia</a></li>
                <li><a class="country_list_link" setvalue="- At present, specific requirements for this country are not available with us." id="NZ">New Zealand</a></li>
                <li><a class="country_list_link" setvalue="- At present, specific requirements for this country are not available with us." id="NI">Nicaragua</a></li>
                <li><a class="country_list_link" setvalue="- At present, specific requirements for this country are not available with us." id="NE">Niger</a></li>
                <li><a class="country_list_link" setvalue="- At present, specific requirements for this country are not available with us." id="NG">Nigeria</a></li>
                <li><a class="country_list_link" setvalue="- At present, specific requirements for this country are not available with us." id="NU">Niue</a></li>
                <li><a class="country_list_link" setvalue="- At present, specific requirements for this country are not available with us." id="NF">Norfolk Island</a></li>
                <li><a class="country_list_link" setvalue="- At present, specific requirements for this country are not available with us." id="KP">North Korea</a></li>
                <li><a class="country_list_link" setvalue="- At present, specific requirements for this country are not available with us." id="MP">Northern Mariana Islands</a></li>
                <li><a class="country_list_link" setvalue="- At present, specific requirements for this country are not available with us." id="NO">Norway</a></li>
              </ul>
            </div>
            <div class="country_listO">
              <ul class="list-unstyled card-columns">
                <li><a class="country_list_link" setvalue="- At present, specific requirements for this country are not available with us." id="OM">Oman</a></li>
                <li>&nbsp;</li>
                <li>&nbsp;</li>
                <li>&nbsp;</li>
                <li>&nbsp;</li>
              </ul>
            </div>
            <div class="country_listP">
              <ul class="list-unstyled card-columns">
                <li><a class="country_list_link" setvalue="- At present, specific requirements for this country are not available with us." id="PK">Pakistan</a></li>
                <li><a class="country_list_link" setvalue="- At present, specific requirements for this country are not available with us." id="PW">Palau</a></li>
                <li><a class="country_list_link" setvalue="- At present, specific requirements for this country are not available with us." id="PS">Palestine</a></li>
                <li><a class="country_list_link" setvalue="- At present, specific requirements for this country are not available with us." id="PA">Panama</a></li>
                <li><a class="country_list_link" setvalue="- At present, specific requirements for this country are not available with us." id="PG">Papua New Guinea</a></li>
                <li><a class="country_list_link" setvalue="- At present, specific requirements for this country are not available with us." id="PY">Paraguay</a></li>
                <li><a class="country_list_link" setvalue="- At present, specific requirements for this country are not available with us." id="PE">Peru</a></li>
                <li><a class="country_list_link" setvalue="- At present, specific requirements for this country are not available with us." id="PH">Philippines</a></li>
                <li><a class="country_list_link" setvalue="- At present, specific requirements for this country are not available with us." id="PN">Pitcairn</a></li>
                <li><a class="country_list_link" setvalue="- At present, specific requirements for this country are not available with us." id="PL">Poland</a></li>
                <li><a class="country_list_link" setvalue="- At present, specific requirements for this country are not available with us." id="PT">Portugal</a></li>
                <li><a class="country_list_link" setvalue="- At present, specific requirements for this country are not available with us." id="PR">Puerto Rico</a></li>
              </ul>
            </div>
            <div class="country_listQ">
              <ul class="list-unstyled card-columns">
                <li><a class="country_list_link" setvalue="- At present, specific requirements for this country are not available with us." id="QA">Qatar</a></li>
                <li>&nbsp;</li>
                <li>&nbsp;</li>
                <li>&nbsp;</li>
                <li>&nbsp;</li>
              </ul>
            </div>
            <div class="country_listR">
              <ul class="list-unstyled card-columns">
                <li><a class="country_list_link" setvalue="- At present, specific requirements for this country are not available with us." id="RE">Reunion</a></li>
                <li><a class="country_list_link" setvalue="- At present, specific requirements for this country are not available with us." id="RO">Romania</a></li>
                <li><a class="country_list_link" setvalue="- At present, specific requirements for this country are not available with us." id="RU">Russia</a></li>
                <li><a class="country_list_link" setvalue="- At present, specific requirements for this country are not available with us." id="RW">Rwanda</a></li>
                <li>&nbsp;</li>
              </ul>
            </div>
            <div class="country_listS">
              <ul class="list-unstyled card-columns">
                <li><a class="country_list_link" setvalue="- At present, specific requirements for this country are not available with us." id="BL">Saint Barthelemy</a></li>
                <li><a class="country_list_link" setvalue="- At present, specific requirements for this country are not available with us." id="SH">Saint Helena, Ascension and Tristan da Cunha</a></li>
                <li><a class="country_list_link" setvalue="- At present, specific requirements for this country are not available with us." id="KN">Saint Kitts and Nevis</a></li>
                <li><a class="country_list_link" setvalue="- At present, specific requirements for this country are not available with us." id="LC">Saint Lucia</a></li>
                <li><a class="country_list_link" setvalue="- At present, specific requirements for this country are not available with us." id="MF">Saint Martin</a></li>
                <li><a class="country_list_link" setvalue="- At present, specific requirements for this country are not available with us." id="PM">Saint Pierre and Miquelon</a></li>
                <li><a class="country_list_link" setvalue="- At present, specific requirements for this country are not available with us." id="SM">San Marino</a></li>
                <li><a class="country_list_link" setvalue="- At present, specific requirements for this country are not available with us." id="ST">Sao Tome and Principe</a></li>
                <li><a class="country_list_link" setvalue="- At present, specific requirements for this country are not available with us." id="SA">Saudi Arabia</a></li>
                <li><a class="country_list_link" setvalue="- At present, specific requirements for this country are not available with us." id="SN">Senegal</a></li>
                <li><a class="country_list_link" setvalue="- At present, specific requirements for this country are not available with us." id="RS">Serbia</a></li>
                <li><a class="country_list_link" setvalue="- At present, specific requirements for this country are not available with us." id="SC">Seychelles</a></li>
                <li><a class="country_list_link" setvalue="- At present, specific requirements for this country are not available with us." id="SL">Sierra Leone</a></li>
                <li><a class="country_list_link" setvalue="- At present, specific requirements for this country are not available with us." id="SG">Singapore</a></li>
                <li><a class="country_list_link" setvalue="- At present, specific requirements for this country are not available with us." id="SX">Sint Maarten</a></li>
                <li><a class="country_list_link" setvalue="- At present, specific requirements for this country are not available with us." id="SK">Slovakia</a></li>
                <li><a class="country_list_link" setvalue="- At present, specific requirements for this country are not available with us." id="SI">Slovenia</a></li>
                <li><a class="country_list_link" setvalue="- At present, specific requirements for this country are not available with us." id="SB">Solomon Islands</a></li>
                <li><a class="country_list_link" setvalue="- At present, specific requirements for this country are not available with us." id="SO">Somalia</a></li>
                <li><a class="country_list_link" setvalue="- At present, specific requirements for this country are not available with us." id="GS">South Georgia and the South Sandwich Islands</a></li>
                <li><a class="country_list_link" setvalue="- At present, specific requirements for this country are not available with us." id="KR">South Korea</a></li>
                <li><a class="country_list_link" setvalue="- At present, specific requirements for this country are not available with us." id="SS">South Sudan</a></li>
                <li><a class="country_list_link" setvalue="- At present, specific requirements for this country are not available with us." id="ES">Spain</a></li>
                <li><a class="country_list_link" setvalue="- At present, specific requirements for this country are not available with us." id="LK">Sri Lanka</a></li>
                <li><a class="country_list_link" setvalue="- At present, specific requirements for this country are not available with us." id="SD">Sudan</a></li>
                <li><a class="country_list_link" setvalue="- At present, specific requirements for this country are not available with us." id="SR">Suriname</a></li>
                <li><a class="country_list_link" setvalue="- At present, specific requirements for this country are not available with us." id="SJ">Svalbard and Jan Mayen</a></li>
                <li><a class="country_list_link" setvalue="- At present, specific requirements for this country are not available with us." id="SZ">Swaziland</a></li>
                <li><a class="country_list_link" setvalue="- At present, specific requirements for this country are not available with us." id="SE">Sweden</a></li>
                <li><a class="country_list_link" setvalue="- At present, specific requirements for this country are not available with us." id="CH">Switzerland</a></li>
                <li><a class="country_list_link" setvalue="- At present, specific requirements for this country are not available with us." id="SY">Syria</a></li>
              </ul>
            </div>
            <div class="country_listT">
              <ul class="list-unstyled card-columns">
                <li><a class="country_list_link" setvalue="- At present, specific requirements for this country are not available with us." id="TW">Taiwan</a></li>
                <li><a class="country_list_link" setvalue="- At present, specific requirements for this country are not available with us." id="TJ">Tajikistan</a></li>
                <li><a class="country_list_link" setvalue="- At present, specific requirements for this country are not available with us." id="TZ">Tanzania</a></li>
                <li><a class="country_list_link" setvalue="- At present, specific requirements for this country are not available with us." id="TH">Thailand</a></li>
                <li><a class="country_list_link" setvalue="- At present, specific requirements for this country are not available with us." id="TL">Timor-Leste</a></li>
                <li><a class="country_list_link" setvalue="- At present, specific requirements for this country are not available with us." id="TG">Togo</a></li>
                <li><a class="country_list_link" setvalue="- At present, specific requirements for this country are not available with us." id="TK">Tokelau</a></li>
                <li><a class="country_list_link" setvalue="- At present, specific requirements for this country are not available with us." id="TO">Tonga</a></li>
                <li><a class="country_list_link" setvalue="- At present, specific requirements for this country are not available with us." id="TT">Trinidad and Tobago</a></li>
                <li><a class="country_list_link" setvalue="- At present, specific requirements for this country are not available with us." id="TN">Tunisia</a></li>
                <li><a class="country_list_link" setvalue="- At present, specific requirements for this country are not available with us." id="TR">Turkey</a></li>
                <li><a class="country_list_link" setvalue="- At present, specific requirements for this country are not available with us." id="TM">Turkmenistan</a></li>
                <li><a class="country_list_link" setvalue="- At present, specific requirements for this country are not available with us." id="TC">Turks and Caicos Islands</a></li>               
                <li><a class="country_list_link" setvalue="- At present, specific requirements for this country are not available with us." id="TV">Tuvalu</a></li>
              </ul>
            </div>
            <div class="country_listU">
              <ul class="list-unstyled card-columns">
                <li><a class="country_list_link" setvalue="- At present, specific requirements for this country are not available with us." id="UG">Uganda</a></li>
                <li><a class="country_list_link" setvalue="- At present, specific requirements for this country are not available with us." id="UA">Ukraine</a></li>
                <li><a class="country_list_link" setvalue="- At present, specific requirements for this country are not available with us." id="AE">United Arab Emirates</a></li>
                <li><a class="country_list_link" setvalue="- At present, specific requirements for this country are not available with us." id="GB">United Kingdom</a></li>
                <li><a class="country_list_link" setvalue="- At present, specific requirements for this country are not available with us." id="UM">United States Minor Outlying Islands</a></li>
                <li><a class="country_list_link" setvalue="- At present, specific requirements for this country are not available with us." id="US">United States of America</a></li>
                <li>&nbsp;</li>
                <li>&nbsp;</li>
                <li>&nbsp;</li>
                <li>&nbsp;</li>
              </ul>
            </div>
            <div class="country_listV">
              <ul class="list-unstyled card-columns">
                <li><a class="country_list_link2" setvalue="- At present, specific requirements for this country are not available with us.">There are no countries with letter V</a></li>
                <li>&nbsp;</li>
                <li>&nbsp;</li>
                <li>&nbsp;</li>
              </ul>
            </div>
            <div class="country_listW">
              <ul class="list-unstyled card-columns">
                <li><a class="country_list_link" setvalue="- At present, specific requirements for this country are not available with us." id="EH">Western Sahara</a></li>
                <li>&nbsp;</li>
                <li>&nbsp;</li>
                <li>&nbsp;</li>
                <li>&nbsp;</li>
              </ul>
            </div>
            <div class="country_listX">
              <ul class="list-unstyled card-columns">
                <li><a class="country_list_link2" setvalue="- At present, specific requirements for this country are not available with us.">There are no countries with letter X</a></li>
                <li>&nbsp;</li>
                <li>&nbsp;</li>
                <li>&nbsp;</li>
              </ul>
            </div>
            <div class="country_listY">
              <ul class="list-unstyled card-columns">
                <li><a class="country_list_link2" setvalue="- At present, specific requirements for this country are not available with us.">There are no countries with letter Y</a></li>
                <li>&nbsp;</li>
                <li>&nbsp;</li>
                <li>&nbsp;</li>
              </ul>
            </div>
            <div class="country_listZ">
              <ul class="list-unstyled card-columns">
                <li><a class="country_list_link2" setvalue="- At present, specific requirements for this country are not available with us.">There are no countries with letter Z</a></li>
                <li>&nbsp;</li>
                <li>&nbsp;</li>
                <li>&nbsp;</li>
              </ul>
            </div>
          </div>
        </div>
      </div>
    </div>
  </div>
</form>
<div id="need_help_modal" class="modal fade" tabindex="-1" role="dialog" aria-labelledby="myLargeModalLabel" aria-hidden="true">
  <div class="modal-dialog modal-dialog-centered">
    <div class="modal-content">
      <div class="modal-header modal-header-spl">
        <h5 class="modal-title">Calculate Volume</h5>
        <button type="button" class="close btn_close" data-dismiss="modal" aria-label="Close"> <span aria-hidden="true">&times;</span> </button>
      </div>
      <div class="modal-body"> 
        <!-- <form method="post" id="user-signup-form" > -->
        <h3 class="viewMoreHd2">Enter the values below to calculate volume</h3>
        <label class="form-label">Length</label>
        <input type="text" class="form-control2 font14 text-right" maxlength="6" id="lclLengthId" autocomplete="off" oninput='numberOnly(this.id);'>
        <select class="form-control3 ml-3 font14" id="lclLengthUnitId">
          <option value="mm">Millimeters (mm)</option>
          <option value="cm">Centimeters (cm)</option>
          <option value="in">Inches (in)</option>
          <option value="ft">Feet (ft)</option>
          <option value="m">Meters (m)</option>
        </select>
        <label class="form-label">Breadth</label>
        <input type="text" class="form-control2 font14 text-right" maxlength="6" id="lclBreadthId" autocomplete="off" oninput='numberOnly(this.id);'>
        <select class="form-control3 ml-3 font14" id="lclBreadthUnitId" disabled>
          <option value="mm">Millimeters (mm)</option>
          <option value="cm">Centimeters (cm)</option>
          <option value="in">Inches (in)</option>
          <option value="ft">Feet (ft)</option>
          <option value="m">Meters (m)</option>
        </select>
        <label class="form-label">Height</label>
        <input type="text" class="form-control2 font14 text-right" maxlength="6" id="lclHeightId" autocomplete="off" oninput='numberOnly(this.id);'>
        <select class="form-control3 ml-3 font14" id="lclHeightUnitId" disabled>
          <option value="mm">Millimeters (mm)</option>
          <option value="cm">Centimeters (cm)</option>
          <option value="in">Inches (in)</option>
          <option value="ft">Feet (ft)</option>
          <option value="m">Meters (m)</option>
        </select>
        <label class="form-label">Calculated Valume</label>
        <input type="text" class="form-control2 font-weight-bold text-right" id="lclCalcModalVolumeId" readonly>
        <label class="form-control3 ml-3 font14">CBM</label>
      </div>
      <div class="modal-footer">
        <input type="Button" class="btn btn-theme font14" onclick="calculateVolume();" value="Calculate">
        <input type="Button" class="btn btn-theme font14" onclick="calculateLCLVolume();" value="Submit">
      </div>
      <!-- </form> --> 
    </div>
  </div>
</div>

<div id="viewMoreModal" class="modal fade" tabindex="-1" role="dialog" aria-labelledby="myLargeModalLabel" aria-hidden="true">
  <div class="modal-dialog modal-md modal-dialog-centered">
    <div class="modal-content"> <img src="static/images/place.jpg" id="modalImgId" alt="place" class="place_img2">
      <div id="offerBodyId">
      <h3 class="viewMoreHd"><label id="moreOrgId"></label> & <label id="moreDestId"></label></h3>
      <h4 class="viewMoreSub">Special Promotional Rates from
        <label id="modalOfValidDateFromId"></label>
        to
        <label id="modalOfValidDateToId"></label>
      </h4>
      <h4 class="viewMoreSub"><label id="moreDesc"></label></h4>
      <img alt="img" src="static/images/viewMoreModalImg.png" id="moreFooterImgId" class="viewModalImg">
      <h4 class="viewMoreSub"><label id="moreFooter"></label></h4>
      </div>
      <h4 class="viewMoreSub mb-3">Book Now using campaign code <span class="color_theme" id="campaigncode"></span></h4>
    </div>
  </div>
</div>

<div id="location_detail_modal" class="modal fade" tabindex="-1" role="dialog" aria-labelledby="myLargeModalLabel" aria-hidden="true">
  <div class="modal-dialog modal-lg modal-dialog-centered">
    <div class="modal-content">
      <div class="modal-header modal-header-spl">
        <h5 class="modal-title">Country specific requirements</h5>
        <button type="button" class="close btn_close" data-dismiss="modal" aria-label="Close"> <span aria-hidden="true">&times;</span> </button>
      </div>
      <div class="modal-body">
        <h3 class="viewMoreHd2">Below are the country specific requirements <small id="locUpdDateSpanId">(Last updated on <span id="locSpecUpdateDateId"></span>)</small></h3>
        <p class="viewMoreSub2" id="locSpecReqId"></p>
      </div>
    </div>
  </div>
</div>
<!-- Fwd/Cha -->
<div id="fedcha_modal" class="modal fade" tabindex="-1" role="dialog" aria-labelledby="myLargeModalLabel" aria-hidden="true">
  <div class="modal-dialog modal-lg modal-dialog-centered">
    <div class="modal-content">
      <div class="modal-header modal-header-spl">
        <h5 class="modal-title">Select Entity to send Enquiry</h5>
        <button type="button" class="close btn_close" data-dismiss="modal" aria-label="Close"> <span aria-hidden="true">&times;</span> </button>
      </div>
      <div class="modal-body">
     
      <div class="row">
        <div class="col-md-12">
            <label class="form-label mt-0">Popular Forwarder(s)</label>
            <div class="" id="popularForwarderDiv">
               <!-- <div class="col">
                 <div id="ck-button">
                    <label><input type="checkbox" value="1"><span>Express Global Logistics Pvt. Ltd.</span> </label>
                 </div>
               </div> -->
           </div>
       </div>
      </div>
    
          <div class="">
          <table class="table table-bordered table_fontsize m-0" style="width:100%" id="forcha_table">
            <thead class="thead-light">
              <tr>
                <th>#</th>
                <th>Forwarder / CHA</th>
                <th>Location</th>
              </tr>
            </thead>
          </table>
        </div>
      </div>
      <div class="modal-footer">
        <button type="button" class="btn clear_btn" data-dismiss="modal">Close</button>
        <button type="button" class="btn advt_btn" onclick="submitEnquirySearchRequest();">Submit</button>
      </div>
    </div>
  </div>
</div>
<!-- video modal -->
  <div id="videoModal" class="modal fade">
    <div class="modal-dialog modal-lg">
      <div class="modal-content">
        <div class="modal-body">
        <video controls autoplay style="height:573px; width:760px">
    <source src="static/video/Quotation_Deck.mp4" type="video/mp4" autoplay>
    Your browser does not support the video tag.
</video>
        </div>
      </div>
    </div>
  </div>
  <!-- Video MODAL -->
  <!-- Booking video modal -->
  <div id="videoModalB" class="modal fade">
    <div class="modal-dialog modal-lg">
      <div class="modal-content">
        <div class="modal-body">
        <video controls autoplay style="height:573px; width:760px" class="embed-responsive">
    <source src="static/video/Booking.mp4" type="video/mp4">
    Your browser does not support the video tag.
</video>
        </div>
      </div>
    </div>
  </div>
 <!-- Booking video modal -->
<script src="http://code.jquery.com/ui/1.10.2/jquery-ui.js" ></script> 
<script>
if (window.history.replaceState) {
  window.history.replaceState(null, null, window.location.href);
}

$(document).ready(function () {
  $(".recent_hidden_link").hide();
  $(".recent_arrow").click(function () {
    $(".recent_hidden_link").toggle(100);
  });

  $("#shipTypeFclId").prop("checked", true);
  $("#lclData").hide();
  $("#fclData").show();
  $(".search_btn").show();

  $('.minus').click(function () {
    var $input = $(this).parent().find('input');
    var input = $input.val();
    if(input == ""){
    	input = 0;
    }
    var count = parseInt(input) - 1;
    count = count < 1 ? 0 : count;
    $input.val(count);
    $input.change();
    return false;
  });
  $('.plus').click(function () {
    var $input = $(this).parent().find('input');
    var input = $input.val();
    if(input == ""){
    	input = 0;
    }
    var count = parseInt(input) + 1;
    count = count > 9 ? 0 : count;
    $input.val(count);
    $input.change();
    return false;
  });

  $('input[type=radio][name=shipmentType]').change(function () {

	$("#twentyFtCountInId").val(0);  							  				
	$("#fourtyFtCountInId").val(0);		  								  				
	$("#fourtyFtHcCountInId").val(0);	  							  				
    $("#fourtyFiveFtCountInId").val(0);
    $("#lclTotalWeightInId").val('');  							  						  								  				
	$("#lclCubicVolumeId").val('');	  							  				
	$("#lclNumPackId").val('');	  							  				
				
    if (this.value == 'FCL') {
      $("#lclData").hide();
      $("#fclData").show();
      $(".search_btn").show();
    } else if (this.value == 'LCL') {
      //getAllPackageUnits();

      $("#fclData").hide();
      $("#lclData").show();
      $(".search_btn").show();
    }
  });

  $('.need_help').click(function () {
    $('#need_help_modal').modal('show');
  });

  $('#view_more_btn').click(function () {
    $('#viewMoreModal').modal('show');
  });

  $('.country_list_link').click(function () {
	  var countrycode = $(this).attr('id');
	  var locSpecReqVal = $(this).attr('setvalue');	  

	  $.ajax({
	    type: 'GET',
	    url: server_url + 'utility/getCountrySpecByCode',
	    contentType: "application/json",	   
	    data: "countrycode=" + countrycode,
	    success: function (response) {	
	    	$('#locSpecUpdateDateId').text(response.respData.updateddate);	    	    	 
	    	$('#locSpecReqId').text(response.respData.specification);  
	    	$('#location_detail_modal').modal('show'); 
	    	$("#locUpdDateSpanId").show();    	    
	    },
	    error: function (error) {
	    	$('#locSpecReqId').text(locSpecReqVal);  
	    	$('#location_detail_modal').modal('show');   
	    	$("#locUpdDateSpanId").hide(); 
	    }
	  }) 
  });

  $('.country_linkA').click(function () {
    $('.country_listB, .country_listC, .country_listD, .country_listE, .country_listF, .country_listG, .country_listH, .country_listI, .country_listJ, .country_listK, .country_listL, .country_listM, .country_listN, .country_listO, .country_listP, .country_listQ, .country_listR, .country_listS, .country_listT, .country_listU, .country_listV, .country_listW, .country_listX, .country_listU, .country_listX, .country_listY, .country_listZ').hide();
    $('.country_listA').show();
    $('.country_linkB, .country_linkC, .country_linkD, .country_linkE, .country_linkF, .country_linkG, .country_linkH, .country_linkI, .country_linkJ, .country_linkK, .country_linkL, .country_linkM, .country_linkN, .country_linkO, .country_linkP, .country_linkQ, .country_linkR, .country_linkS, .country_linkT, .country_linkU, .country_linkV, .country_linkW, .country_linkX, .country_linkY, .country_linkZ').removeClass("country_link_active");
    $('.country_linkA').addClass("country_link_active");
  });
  $('.country_linkB').click(function () {
    $('.country_listA, .country_listC, .country_listD, .country_listE, .country_listF, .country_listG, .country_listH, .country_listI, .country_listJ, .country_listK, .country_listL, .country_listM, .country_listN, .country_listO, .country_listP, .country_listQ, .country_listR, .country_listS, .country_listT, .country_listU, .country_listV, .country_listW, .country_listX, .country_listU, .country_listX, .country_listY, .country_listZ').hide();
    $('.country_listB').show();
    $('.country_linkA, .country_linkC, .country_linkD, .country_linkE, .country_linkF, .country_linkG, .country_linkH, .country_linkI, .country_linkJ, .country_linkK, .country_linkL, .country_linkM, .country_linkN, .country_linkO, .country_linkP, .country_linkQ, .country_linkR, .country_linkS, .country_linkT, .country_linkU, .country_linkV, .country_linkW, .country_linkX, .country_linkY, .country_linkZ').removeClass("country_link_active");
    $('.country_linkB').addClass("country_link_active");
  });
  $('.country_linkC').click(function () {
    $('.country_listB, .country_listA, .country_listD, .country_listE, .country_listF, .country_listG, .country_listH, .country_listI, .country_listJ, .country_listK, .country_listL, .country_listM, .country_listN, .country_listO, .country_listP, .country_listQ, .country_listR, .country_listS, .country_listT, .country_listU, .country_listV, .country_listW, .country_listX, .country_listU, .country_listX, .country_listY, .country_listZ').hide();
    $('.country_listC').show();
    $('.country_linkB, .country_linkA, .country_linkD, .country_linkE, .country_linkF, .country_linkG, .country_linkH, .country_linkI, .country_linkJ, .country_linkK, .country_linkL, .country_linkM, .country_linkN, .country_linkO, .country_linkP, .country_linkQ, .country_linkR, .country_linkS, .country_linkT, .country_linkU, .country_linkV, .country_linkW, .country_linkX, .country_linkY, .country_linkZ').removeClass("country_link_active");
    $('.country_linkC').addClass("country_link_active");
  });
  $('.country_linkD').click(function () {
    $('.country_listB, .country_listA, .country_listC, .country_listE, .country_listF, .country_listG, .country_listH, .country_listI, .country_listJ, .country_listK, .country_listL, .country_listM, .country_listN, .country_listO, .country_listP, .country_listQ, .country_listR, .country_listS, .country_listT, .country_listU, .country_listV, .country_listW, .country_listX, .country_listU, .country_listX, .country_listY, .country_listZ').hide();
    $('.country_listD').show();
    $('.country_linkB, .country_linkA, .country_linkC, .country_linkE, .country_linkF, .country_linkG, .country_linkH, .country_linkI, .country_linkJ, .country_linkK, .country_linkL, .country_linkM, .country_linkN, .country_linkO, .country_linkP, .country_linkQ, .country_linkR, .country_linkS, .country_linkT, .country_linkU, .country_linkV, .country_linkW, .country_linkX, .country_linkY, .country_linkZ').removeClass("country_link_active");
    $('.country_linkD').addClass("country_link_active");
  });
  $('.country_linkE').click(function () {
    $('.country_listB, .country_listA, .country_listC, .country_listD, .country_listF, .country_listG, .country_listH, .country_listI, .country_listJ, .country_listK, .country_listL, .country_listM, .country_listN, .country_listO, .country_listP, .country_listQ, .country_listR, .country_listS, .country_listT, .country_listU, .country_listV, .country_listW, .country_listX, .country_listU, .country_listX, .country_listY, .country_listZ').hide();
    $('.country_listE').show();
    $('.country_linkB, .country_linkA, .country_linkC, .country_linkD, .country_linkF, .country_linkG, .country_linkH, .country_linkI, .country_linkJ, .country_linkK, .country_linkL, .country_linkM, .country_linkN, .country_linkO, .country_linkP, .country_linkQ, .country_linkR, .country_linkS, .country_linkT, .country_linkU, .country_linkV, .country_linkW, .country_linkX, .country_linkY, .country_linkZ').removeClass("country_link_active");
    $('.country_linkE').addClass("country_link_active");
  });
  $('.country_linkF').click(function () {
    $('.country_listB, .country_listA, .country_listC, .country_listD, .country_listE, .country_listG, .country_listH, .country_listI, .country_listJ, .country_listK, .country_listL, .country_listM, .country_listN, .country_listO, .country_listP, .country_listQ, .country_listR, .country_listS, .country_listT, .country_listU, .country_listV, .country_listW, .country_listX, .country_listU, .country_listX, .country_listY, .country_listZ').hide();
    $('.country_listF').show();
    $('.country_linkB, .country_linkA, .country_linkC, .country_linkD, .country_linkE, .country_linkG, .country_linkH, .country_linkI, .country_linkJ, .country_linkK, .country_linkL, .country_linkM, .country_linkN, .country_linkO, .country_linkP, .country_linkQ, .country_linkR, .country_linkS, .country_linkT, .country_linkU, .country_linkV, .country_linkW, .country_linkX, .country_linkY, .country_linkZ').removeClass("country_link_active");
    $('.country_linkF').addClass("country_link_active");
  });
  $('.country_linkG').click(function () {
    $('.country_listB, .country_listA, .country_listC, .country_listD, .country_listE, .country_listF, .country_listH, .country_listI, .country_listJ, .country_listK, .country_listL, .country_listM, .country_listN, .country_listO, .country_listP, .country_listQ, .country_listR, .country_listS, .country_listT, .country_listU, .country_listV, .country_listW, .country_listX, .country_listU, .country_listX, .country_listY, .country_listZ').hide();
    $('.country_listG').show();
    $('.country_linkB, .country_linkA, .country_linkC, .country_linkD, .country_linkE, .country_linkF, .country_linkH, .country_linkI, .country_linkJ, .country_linkK, .country_linkL, .country_linkM, .country_linkN, .country_linkO, .country_linkP, .country_linkQ, .country_linkR, .country_linkS, .country_linkT, .country_linkU, .country_linkV, .country_linkW, .country_linkX, .country_linkY, .country_linkZ').removeClass("country_link_active");
    $('.country_linkG').addClass("country_link_active");
  });
  $('.country_linkH').click(function () {
    $('.country_listB, .country_listA, .country_listC, .country_listD, .country_listE, .country_listF, .country_listG, .country_listI, .country_listJ, .country_listK, .country_listL, .country_listM, .country_listN, .country_listO, .country_listP, .country_listQ, .country_listR, .country_listS, .country_listT, .country_listU, .country_listV, .country_listW, .country_listX, .country_listU, .country_listX, .country_listY, .country_listZ').hide();
    $('.country_listH').show();
    $('.country_linkB, .country_linkA, .country_linkC, .country_linkD, .country_linkE, .country_linkF, .country_linkG, .country_linkI, .country_linkJ, .country_linkK, .country_linkL, .country_linkM, .country_linkN, .country_linkO, .country_linkP, .country_linkQ, .country_linkR, .country_linkS, .country_linkT, .country_linkU, .country_linkV, .country_linkW, .country_linkX, .country_linkY, .country_linkZ').removeClass("country_link_active");
    $('.country_linkH').addClass("country_link_active");
  });
  $('.country_linkI').click(function () {
    $('.country_listB, .country_listA, .country_listC, .country_listD, .country_listE, .country_listF, .country_listG, .country_listH, .country_listJ, .country_listK, .country_listL, .country_listM, .country_listN, .country_listO, .country_listP, .country_listQ, .country_listR, .country_listS, .country_listT, .country_listU, .country_listV, .country_listW, .country_listX, .country_listU, .country_listX, .country_listY, .country_listZ').hide();
    $('.country_listI').show();
    $('.country_linkB, .country_linkA, .country_linkC, .country_linkD, .country_linkE, .country_linkF, .country_linkG, .country_linkH, .country_linkJ, .country_linkK, .country_linkL, .country_linkM, .country_linkN, .country_linkO, .country_linkP, .country_linkQ, .country_linkR, .country_linkS, .country_linkT, .country_linkU, .country_linkV, .country_linkW, .country_linkX, .country_linkY, .country_linkZ').removeClass("country_link_active");
    $('.country_linkI').addClass("country_link_active");
  });
  $('.country_linkJ').click(function () {
    $('.country_listB, .country_listA, .country_listC, .country_listD, .country_listE, .country_listF, .country_listG, .country_listH, .country_listI, .country_listK, .country_listL, .country_listM, .country_listN, .country_listO, .country_listP, .country_listQ, .country_listR, .country_listS, .country_listT, .country_listU, .country_listV, .country_listW, .country_listX, .country_listU, .country_listX, .country_listY, .country_listZ').hide();
    $('.country_listJ').show();
    $('.country_linkB, .country_linkA, .country_linkC, .country_linkD, .country_linkE, .country_linkF, .country_linkG, .country_linkH, .country_linkI, .country_linkK, .country_linkL, .country_linkM, .country_linkN, .country_linkO, .country_linkP, .country_linkQ, .country_linkR, .country_linkS, .country_linkT, .country_linkU, .country_linkV, .country_linkW, .country_linkX, .country_linkY, .country_linkZ').removeClass("country_link_active");
    $('.country_linkJ').addClass("country_link_active");
  });
  $('.country_linkK').click(function () {
    $('.country_listB, .country_listA, .country_listC, .country_listD, .country_listE, .country_listF, .country_listG, .country_listH, .country_listI, .country_listJ, .country_listL, .country_listM, .country_listN, .country_listO, .country_listP, .country_listQ, .country_listR, .country_listS, .country_listT, .country_listU, .country_listV, .country_listW, .country_listX, .country_listU, .country_listX, .country_listY, .country_listZ').hide();
    $('.country_listK').show();
    $('.country_linkB, .country_linkA, .country_linkC, .country_linkD, .country_linkE, .country_linkF, .country_linkG, .country_linkH, .country_linkI, .country_linkJ, .country_linkL, .country_linkM, .country_linkN, .country_linkO, .country_linkP, .country_linkQ, .country_linkR, .country_linkS, .country_linkT, .country_linkU, .country_linkV, .country_linkW, .country_linkX, .country_linkY, .country_linkZ').removeClass("country_link_active");
    $('.country_linkK').addClass("country_link_active");
  });
  $('.country_linkL').click(function () {
    $('.country_listB, .country_listA, .country_listC, .country_listD, .country_listE, .country_listF, .country_listG, .country_listH, .country_listI, .country_listJ, .country_listK, .country_listM, .country_listN, .country_listO, .country_listP, .country_listQ, .country_listR, .country_listS, .country_listT, .country_listU, .country_listV, .country_listW, .country_listX, .country_listU, .country_listX, .country_listY, .country_listZ').hide();
    $('.country_listL').show();
    $('.country_linkB, .country_linkA, .country_linkC, .country_linkD, .country_linkE, .country_linkF, .country_linkG, .country_linkH, .country_linkI, .country_linkJ, .country_linkK, .country_linkM, .country_linkN, .country_linkO, .country_linkP, .country_linkQ, .country_linkR, .country_linkS, .country_linkT, .country_linkU, .country_linkV, .country_linkW, .country_linkX, .country_linkY, .country_linkZ').removeClass("country_link_active");
    $('.country_linkL').addClass("country_link_active");
  });
  $('.country_linkM').click(function () {
    $('.country_listB, .country_listA, .country_listC, .country_listD, .country_listE, .country_listF, .country_listG, .country_listH, .country_listI, .country_listJ, .country_listK, .country_listL, .country_listN, .country_listO, .country_listP, .country_listQ, .country_listR, .country_listS, .country_listT, .country_listU, .country_listV, .country_listW, .country_listX, .country_listU, .country_listX, .country_listY, .country_listZ').hide();
    $('.country_listM').show();
    $('.country_linkB, .country_linkA, .country_linkC, .country_linkD, .country_linkE, .country_linkF, .country_linkG, .country_linkH, .country_linkI, .country_linkJ, .country_linkK, .country_linkL, .country_linkN, .country_linkO, .country_linkP, .country_linkQ, .country_linkR, .country_linkS, .country_linkT, .country_linkU, .country_linkV, .country_linkW, .country_linkX, .country_linkY, .country_linkZ').removeClass("country_link_active");
    $('.country_linkM').addClass("country_link_active");
  });
  $('.country_linkN').click(function () {
    $('.country_listB, .country_listA, .country_listC, .country_listD, .country_listE, .country_listF, .country_listG, .country_listH, .country_listI, .country_listJ, .country_listK, .country_listL, .country_listM, .country_listO, .country_listP, .country_listQ, .country_listR, .country_listS, .country_listT, .country_listU, .country_listV, .country_listW, .country_listX, .country_listU, .country_listX, .country_listY, .country_listZ').hide();
    $('.country_listN').show();
    $('.country_linkB, .country_linkA, .country_linkC, .country_linkD, .country_linkE, .country_linkF, .country_linkG, .country_linkH, .country_linkI, .country_linkJ, .country_linkK, .country_linkL, .country_linkM, .country_linkO, .country_linkP, .country_linkQ, .country_linkR, .country_linkS, .country_linkT, .country_linkU, .country_linkV, .country_linkW, .country_linkX, .country_linkY, .country_linkZ').removeClass("country_link_active");
    $('.country_linkN').addClass("country_link_active");
  });
  $('.country_linkO').click(function () {
    $('.country_listB, .country_listA, .country_listC, .country_listD, .country_listE, .country_listF, .country_listG, .country_listH, .country_listI, .country_listJ, .country_listK, .country_listL, .country_listM, .country_listN, .country_listP, .country_listQ, .country_listR, .country_listS, .country_listT, .country_listU, .country_listV, .country_listW, .country_listX, .country_listU, .country_listX, .country_listY, .country_listZ').hide();
    $('.country_listO').show();
    $('.country_linkB, .country_linkA, .country_linkC, .country_linkD, .country_linkE, .country_linkF, .country_linkG, .country_linkH, .country_linkI, .country_linkJ, .country_linkK, .country_linkL, .country_linkM, .country_linkN, .country_linkP, .country_linkQ, .country_linkR, .country_linkS, .country_linkT, .country_linkU, .country_linkV, .country_linkW, .country_linkX, .country_linkY, .country_linkZ').removeClass("country_link_active");
    $('.country_linkO').addClass("country_link_active");
  });
  $('.country_linkP').click(function () {
    $('.country_listB, .country_listA, .country_listC, .country_listD, .country_listE, .country_listF, .country_listG, .country_listH, .country_listI, .country_listJ, .country_listK, .country_listL, .country_listM, .country_listN, .country_listO, .country_listQ, .country_listR, .country_listS, .country_listT, .country_listU, .country_listV, .country_listW, .country_listX, .country_listU, .country_listX, .country_listY, .country_listZ').hide();
    $('.country_listP').show();
    $('.country_linkB, .country_linkA, .country_linkC, .country_linkD, .country_linkE, .country_linkF, .country_linkG, .country_linkH, .country_linkI, .country_linkJ, .country_linkK, .country_linkL, .country_linkM, .country_linkN, .country_linkO, .country_linkQ, .country_linkR, .country_linkS, .country_linkT, .country_linkU, .country_linkV, .country_linkW, .country_linkX, .country_linkY, .country_linkZ').removeClass("country_link_active");
    $('.country_linkP').addClass("country_link_active");
  });
  $('.country_linkQ').click(function () {
    $('.country_listB, .country_listA, .country_listC, .country_listD, .country_listE, .country_listF, .country_listG, .country_listH, .country_listI, .country_listJ, .country_listK, .country_listL, .country_listM, .country_listN, .country_listO, .country_listP, .country_listR, .country_listS, .country_listT, .country_listU, .country_listV, .country_listW, .country_listX, .country_listU, .country_listX, .country_listY, .country_listZ').hide();
    $('.country_listQ').show();
    $('.country_linkB, .country_linkA, .country_linkC, .country_linkD, .country_linkE, .country_linkF, .country_linkG, .country_linkH, .country_linkI, .country_linkJ, .country_linkK, .country_linkL, .country_linkM, .country_linkN, .country_linkO, .country_linkP, .country_linkR, .country_linkS, .country_linkT, .country_linkU, .country_linkV, .country_linkW, .country_linkX, .country_linkY, .country_linkZ').removeClass("country_link_active");
    $('.country_linkQ').addClass("country_link_active");
  });
  $('.country_linkR').click(function () {
    $('.country_listB, .country_listA, .country_listC, .country_listD, .country_listE, .country_listF, .country_listG, .country_listH, .country_listI, .country_listJ, .country_listK, .country_listL, .country_listM, .country_listN, .country_listO, .country_listP, .country_listQ, .country_listS, .country_listT, .country_listU, .country_listV, .country_listW, .country_listX, .country_listU, .country_listX, .country_listY, .country_listZ').hide();
    $('.country_listR').show();
    $('.country_linkB, .country_linkA, .country_linkC, .country_linkD, .country_linkE, .country_linkF, .country_linkG, .country_linkH, .country_linkI, .country_linkJ, .country_linkK, .country_linkL, .country_linkM, .country_linkN, .country_linkO, .country_linkP, .country_linkQ, .country_linkS, .country_linkT, .country_linkU, .country_linkV, .country_linkW, .country_linkX, .country_linkY, .country_linkZ').removeClass("country_link_active");
    $('.country_linkR').addClass("country_link_active");
  });
  $('.country_linkS').click(function () {
    $('.country_listB, .country_listA, .country_listC, .country_listD, .country_listE, .country_listF, .country_listG, .country_listH, .country_listI, .country_listJ, .country_listK, .country_listL, .country_listM, .country_listN, .country_listO, .country_listP, .country_listQ, .country_listR, .country_listT, .country_listU, .country_listV, .country_listW, .country_listX, .country_listU, .country_listX, .country_listY, .country_listZ').hide();
    $('.country_listS').show();
    $('.country_linkB, .country_linkA, .country_linkC, .country_linkD, .country_linkE, .country_linkF, .country_linkG, .country_linkH, .country_linkI, .country_linkJ, .country_linkK, .country_linkL, .country_linkM, .country_linkN, .country_linkO, .country_linkP, .country_linkQ, .country_linkR, .country_linkT, .country_linkU, .country_linkV, .country_linkW, .country_linkX, .country_linkY, .country_linkZ').removeClass("country_link_active");
    $('.country_linkS').addClass("country_link_active");
  });
  $('.country_linkT').click(function () {
    $('.country_listB, .country_listA, .country_listC, .country_listD, .country_listE, .country_listF, .country_listG, .country_listH, .country_listI, .country_listJ, .country_listK, .country_listL, .country_listM, .country_listN, .country_listO, .country_listP, .country_listQ, .country_listR, .country_listS, .country_listU, .country_listV, .country_listW, .country_listX, .country_listU, .country_listX, .country_listY, .country_listZ').hide();
    $('.country_listT').show();
    $('.country_linkB, .country_linkA, .country_linkC, .country_linkD, .country_linkE, .country_linkF, .country_linkG, .country_linkH, .country_linkI, .country_linkJ, .country_linkK, .country_linkL, .country_linkM, .country_linkN, .country_linkO, .country_linkP, .country_linkQ, .country_linkR, .country_linkS, .country_linkU, .country_linkV, .country_linkW, .country_linkX, .country_linkY, .country_linkZ').removeClass("country_link_active");
    $('.country_linkT').addClass("country_link_active");
  });
  $('.country_linkU').click(function () {
    $('.country_listB, .country_listA, .country_listC, .country_listD, .country_listE, .country_listF, .country_listG, .country_listH, .country_listI, .country_listJ, .country_listK, .country_listL, .country_listM, .country_listN, .country_listO, .country_listP, .country_listQ, .country_listR, .country_listS, .country_listT, .country_listV, .country_listW, .country_listX, .country_listU, .country_listX, .country_listY, .country_listZ').hide();
    $('.country_listU').show();
    $('.country_linkB, .country_linkA, .country_linkC, .country_linkD, .country_linkE, .country_linkF, .country_linkG, .country_linkH, .country_linkI, .country_linkJ, .country_linkK, .country_linkL, .country_linkM, .country_linkN, .country_linkO, .country_linkP, .country_linkQ, .country_linkR, .country_linkS, .country_linkT, .country_linkV, .country_linkW, .country_linkX, .country_linkY, .country_linkZ').removeClass("country_link_active");
    $('.country_linkU').addClass("country_link_active");
  });
  $('.country_linkV').click(function () {
    $('.country_listB, .country_listA, .country_listC, .country_listD, .country_listE, .country_listF, .country_listG, .country_listH, .country_listI, .country_listJ, .country_listK, .country_listL, .country_listM, .country_listN, .country_listO, .country_listP, .country_listQ, .country_listR, .country_listS, .country_listT, .country_listU, .country_listW, .country_listX, .country_listU, .country_listX, .country_listY, .country_listZ').hide();
    $('.country_listV').show();
    $('.country_linkB, .country_linkA, .country_linkC, .country_linkD, .country_linkE, .country_linkF, .country_linkG, .country_linkH, .country_linkI, .country_linkJ, .country_linkK, .country_linkL, .country_linkM, .country_linkN, .country_linkO, .country_linkP, .country_linkQ, .country_linkR, .country_linkS, .country_linkT, .country_linkU, .country_linkW, .country_linkX, .country_linkY, .country_linkZ').removeClass("country_link_active");
    $('.country_linkV').addClass("country_link_active");
  });
  $('.country_linkW').click(function () {
    $('.country_listB, .country_listA, .country_listC, .country_listD, .country_listE, .country_listF, .country_listG, .country_listH, .country_listI, .country_listJ, .country_listK, .country_listL, .country_listM, .country_listN, .country_listO, .country_listP, .country_listQ, .country_listR, .country_listS, .country_listT, .country_listU, .country_listV, .country_listX, .country_listU, .country_listX, .country_listY, .country_listZ').hide();
    $('.country_listW').show();
    $('.country_linkB, .country_linkA, .country_linkC, .country_linkD, .country_linkE, .country_linkF, .country_linkG, .country_linkH, .country_linkI, .country_linkJ, .country_linkK, .country_linkL, .country_linkM, .country_linkN, .country_linkO, .country_linkP, .country_linkQ, .country_linkR, .country_linkS, .country_linkT, .country_linkU, .country_linkV, .country_linkX, .country_linkY, .country_linkZ').removeClass("country_link_active");
    $('.country_linkW').addClass("country_link_active");
  });
  $('.country_linkX').click(function () {
    $('.country_listB, .country_listA, .country_listC, .country_listD, .country_listE, .country_listF, .country_listG, .country_listH, .country_listI, .country_listJ, .country_listK, .country_listL, .country_listM, .country_listN, .country_listO, .country_listP, .country_listQ, .country_listR, .country_listS, .country_listT, .country_listU, .country_listV, .country_listW, .country_listU, .country_listX, .country_listY, .country_listZ').hide();
    $('.country_listX').show();
    $('.country_linkB, .country_linkA, .country_linkC, .country_linkD, .country_linkE, .country_linkF, .country_linkG, .country_linkH, .country_linkI, .country_linkJ, .country_linkK, .country_linkL, .country_linkM, .country_linkN, .country_linkO, .country_linkP, .country_linkQ, .country_linkR, .country_linkS, .country_linkT, .country_linkU, .country_linkV, .country_linkW, .country_linkY, .country_linkZ').removeClass("country_link_active");
    $('.country_linkX').addClass("country_link_active");
  });
  $('.country_linkY').click(function () {
    $('.country_listB, .country_listA, .country_listC, .country_listD, .country_listE, .country_listF, .country_listG, .country_listH, .country_listI, .country_listJ, .country_listK, .country_listL, .country_listM, .country_listN, .country_listO, .country_listP, .country_listQ, .country_listR, .country_listS, .country_listT, .country_listU, .country_listV, .country_listW, .country_listU, .country_listX, .country_listX, .country_listZ').hide();
    $('.country_listY').show();
    $('.country_linkB, .country_linkA, .country_linkC, .country_linkD, .country_linkE, .country_linkF, .country_linkG, .country_linkH, .country_linkI, .country_linkJ, .country_linkK, .country_linkL, .country_linkM, .country_linkN, .country_linkO, .country_linkP, .country_linkQ, .country_linkR, .country_linkS, .country_linkT, .country_linkU, .country_linkV, .country_linkW, .country_linkX, .country_linkZ').removeClass("country_link_active");
    $('.country_linkY').addClass("country_link_active");
  });
  $('.country_linkZ').click(function () {
    $('.country_listB, .country_listA, .country_listC, .country_listD, .country_listE, .country_listF, .country_listG, .country_listH, .country_listI, .country_listJ, .country_listK, .country_listL, .country_listM, .country_listN, .country_listO, .country_listP, .country_listQ, .country_listR, .country_listS, .country_listT, .country_listU, .country_listV, .country_listW, .country_listU, .country_listX, .country_listX, .country_listY').hide();
    $('.country_listZ').show();
    $('.country_linkB, .country_linkA, .country_linkC, .country_linkD, .country_linkE, .country_linkF, .country_linkG, .country_linkH, .country_linkI, .country_linkJ, .country_linkK, .country_linkL, .country_linkM, .country_linkN, .country_linkO, .country_linkP, .country_linkQ, .country_linkR, .country_linkS, .country_linkT, .country_linkU, .country_linkV, .country_linkW, .country_linkX, .country_linkY').removeClass("country_link_active");
    $('.country_linkZ').addClass("country_link_active");
  });

  /* radio button input */
  $('input[type="radio"][name=cargoCategory]').click(function () {
    var inputValue = $(this).attr("value");

    $("#imco").val('');
    $("#temprangeId").val('');
    
    if (inputValue == "GEN") {
        $("#hazDivId").hide();
        $("#reeferDivId").hide();
        $("#hideDivId").show();
      } else if (inputValue == "HAZ") {  
        $("#reeferDivId").hide();
        $("#hideDivId").hide();
        $("#hazDivId").show();
      } else if (inputValue == "REEFER") {
        $("#hazDivId").hide();
        $("#hideDivId").hide();
        $("#reeferDivId").show();
      }
    });
  /* radio button input */
});

</script> 
<script type="text/javascript">
  $(function () {
    $('#cargoReadyDateId').datetimepicker({
      /* format: 'L' */
      format: "DD-MMM-yyyy",
      minDate: moment(),
      widgetPositioning: {
        horizontal: "auto",
        vertical: "top"
      },
    });
  });

</script> 
</body>
</html>