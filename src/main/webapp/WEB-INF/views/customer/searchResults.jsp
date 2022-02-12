<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Search Results</title>
<!-- <link href="static/css/bootstrap.css" type="text/css" rel="stylesheet">
<link href="static/css/style.css" type="text/css" rel="stylesheet">
  <link href="https://cdn.datatables.net/1.10.22/css/jquery.dataTables.min.css" type="text/css" rel="stylesheet">
  <script  src="static/js/bootstrap.min.js"></script> -->
  <script src="static/js/_service/searchResultFilter.js"></script>
  
  <script type="text/javascript">
  $(document).ready(function() {
	    $("body").tooltip({ selector: '[data-toggle=tooltip]' });
	});
	
  var searchTable;
  var forwarderFilterArray = [];

   
  $(function() {
	  activeNavigationClass();
	  searchTable = $('#searchList').dataTable();
	  
	  $('#loader').show();
	  var tableId = "searchList";
	  
	  var searchParam = location.search.split('search_data=')[1];
	  var searchTransdata = decodeURIComponent(searchParam);

	  $("#modifySearchBtnId").click(function(){
	   	   window.location.href = contextPath+"/user_home?search_data="+searchParam;
	  });

	  let objSearchTransData;
	      
		  try {
			  // this is how you parse a string into JSON    
	    	   objSearchTransData = JSON.parse(searchTransdata);  	   
	    	} catch (ex) {
	    	  console.error(ex);
	    	};

	     var fclCountainerCount = '';	
		 Object.keys(objSearchTransData).map(function(k){ 
			 
		    console.log("key with value: "+k +" = "+objSearchTransData[k])   
		     
		    if(k == "origin"){
		    	$("#originSpanLabelId").text(objSearchTransData[k]);
			}
			else if(k == "destination"){
				$("#destSpanLabelId").text(objSearchTransData[k]);
			}
			else if(k == "cargoCategory"){
				if(objSearchTransData[k] != 0 ){
					$("#cargoCatSpanLabelId").text(objSearchTransData[k]);
				}
			}else if(k == "commodity"){
				$("#commoditySpanLabelId").text(objSearchTransData[k]);
			}
			else if(k == "twentyFtCount" ){
				if(objSearchTransData[k] != 0 ){
					fclCountainerCount = fclCountainerCount + objSearchTransData[k]+"x20' ";
				}
			}
			else if(k == "fourtyFtCount"){
				if(objSearchTransData[k] != 0 ){
					fclCountainerCount = fclCountainerCount + objSearchTransData[k]+"x40' ";
				}
			}
			else if(k == "fourtyFtHcCount"){
				if(objSearchTransData[k] != 0 ){
					fclCountainerCount = fclCountainerCount + objSearchTransData[k]+"x40' HC ";
				}
			}
			else if(k == "fourtyFiveFtCount"){
				if(objSearchTransData[k] != 0 ){
					fclCountainerCount = fclCountainerCount + objSearchTransData[k]+"x45' ";
				}
			}
			
			$("#fclContainerCount").text(fclCountainerCount);
			
		 })
	
	     $.post({
	         url : server_url+'user/searchTransDetails',
	         contentType: "application/json",
	         headers: authHeader,
	         data : searchTransdata, 
	         success : function(response) {

	        	console.log(response)
	        	 
	        	if(response.respCode == 1){	        		
	        		 loadSearchResultDataTable(tableId,response.respData);
	        		 generateFilterArrayListFromSearchResult(response.respData);
	        		 prepareForwarderFilter(forwarderFilterArray);  
	        		 
	       		}else{
					errorBlock("#error_block",response.respData)
					loadSearchResultDataTable(tableId,null);
	            }
	        	$('#loader').hide();
	         },
	         error: function (error) {

	        	 console.log(error)
	        	 
	        	 console.log(error.responseJSON )
	             
	             if( error.responseJSON != undefined){

	            	 errorBlock("#error_block",error.responseJSON.respData);
	            	 loadSearchResultDataTable(tableId,null);
	              }else{
	            	  errorBlock("#error_block","Server Error! Please contact administrator");
	            	  loadSearchResultDataTable(tableId,null);
	              }
	        	 $('#loader').hide(); 	        
	     	}
	      })  


	      $('#loader').hide();  
	   	 
   });

  

  function formatDetail ( d ) {

	 
        if(d.chargesRateResponseList != null){ 
             var trBody = ''; 
             var totalFreight = 0;
             for (var i=0 ; i< d.chargesRateResponseList.length ; i++){
                 var rate = eval(d.chargesRateResponseList[i].rate);
                 totalFreight = totalFreight + rate;
                 trBody = trBody +'<tr>'+
  	            '<td>'+d.chargesRateResponseList[i].chargesgrouping+'</td>'+
  	            '<td>'+d.chargesRateResponseList[i].chargestype+'</td>'+
  	            '<td class="text-center">'+d.chargesRateResponseList[i].currency+'</td>'+
  	            '<td class="text-right">'+d.chargesRateResponseList[i].rate+' </td>'+
  	            '<td>'+d.chargesRateResponseList[i].basis+'</td>'+
  	            '<td class="text-center">'+d.chargesRateResponseList[i].quantity+'</td>'+
  	            '<td class="text-right">USD '+d.chargesRateResponseList[i].rate+'</td>'+
  	        '</tr>';
       	          	        
             }
             
     	    // `d` is the original data object for the row
     	    return '<table cellpadding="5" cellspacing="0" border="0" class="inner_table">'+
     			  '<tr>'+
     		        '<td class="inner_table_hd">Charges Grouping</td>'+
     		        '<td class="inner_table_hd">Charge Type</td>'+
     		        '<td class="inner_table_hd text-center">Currency</td>'+
     		        '<td class="inner_table_hd text-right">Rate</td>'+
     		        '<td class="inner_table_hd">Basis</td>'+
     		        '<td class="inner_table_hd text-center">Quantity</td>'+
     		        '<td class="inner_table_hd text-right">Total</td>'+
     		    '</tr>'+ trBody +'<tr>'+
     	            '<td>&nbsp;</td>'+
     	            '<td>&nbsp;</td>'+
     	            '<td>&nbsp;</td>'+
     	            '<td>&nbsp;</td>'+
     	            '<td class="inner_table_hd">Freight Total</td>'+
     	            '<td>&nbsp;</td>'+
     	            '<td class="text-right">USD '+totalFreight+'</td>'+
     	        '</tr>'+
     	    '</table>';
            
        }else{
        	 return '<table cellpadding="5" cellspacing="0" border="0" class="inner_table">'+
			  '<tr><td class="nodatatxt">No Data Found</td></tr>'+ 
			  '</table>';
        }
        
	}

  var monthNames = ["Jan", "Feb", "Mar", "Apr", "May", "Jun",
		 "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"];


  function shortDateFormat(d){
	   
	   var dateMomentObject = moment(d, "YYYY-MM-DD"); // 1st argument - string, 2nd argument - format
	   var t = dateMomentObject.toDate(); // convert moment.js object to Date object
	  // var t = new Date(d);
	   return t.getDate()+'-'+monthNames[t.getMonth()]+'-'+t.getFullYear();
		
  }

  function format ( d ) {
	    // `d` is the original data object for the row
	     var scheduleLegsList = '';

		 if(d.scheduleLegsResponseList != null){

			 for (var i=0 ; i< d.scheduleLegsResponseList.length ; i++){

				    var transDetailsId = d.id;
				   
				    var scheduleId = d.id;

				    var radioBtnName = "schedule"+transDetailsId;

				    var etddate="";

				    if(d.scheduleLegsResponseList[i].etddate != null){
                    	etddate = d.scheduleLegsResponseList[i].etddate;
                    }
                    	
					var etadate="";
					if(d.scheduleLegsResponseList[i].etadate != null){
						etadate = d.scheduleLegsResponseList[i].etadate;
	                }
   						
					scheduleLegsList = scheduleLegsList + '<tr>'+							            
		            '<td class="widthp140">'+d.scheduleLegsResponseList[i].origin+' <br> <span class="table_small_label">ETD </span>'+etddate+'</td>'+
		            '<td class="theme_color"><span class="transit_days">'+d.scheduleLegsResponseList[i].transittime+' days</span><img src="static/images/line.png" alt="line" class="table_line2"> <img src="static/images/table_icon1.png" alt="img" class="table_icon_img"></td>'+
		            '<td>'+d.scheduleLegsResponseList[i].destination+'<br> <span class="table_small_label">ETA</span> '+etddate+'</td>'+
		            '<td><span title="Carrier">'+d.scheduleLegsResponseList[i].carrier+'</span></td>'+
		            '<td><span title="Voyage">'+d.scheduleLegsResponseList[i].voyage+'</span></td>'+
		            '<td><span title="Vessel">'+d.scheduleLegsResponseList[i].vessel+'</span></td>'+			            
		        '</tr>'; 
			    
				 } 
			    
			    return '<table cellpadding="5" cellspacing="0" border="0" class="inner_table">'+scheduleLegsList+'</table>';
			    
		 }else{
			 return '<table cellpadding="5" cellspacing="0" border="0" class="inner_table">'+
			 '<tr><td class="nodatatxt">No Data Found</td></tr>'+ 
			 '</table>';
		 }
	   
	}

  function bothCheck(inp){
    console.log(inp);
  	if (inp.is(':checked')){
  		$('input[name=second_row]').prop('checked', true);
  		$('input[name=first_row]').prop('checked', true);
      }else{
      	$('input[name=second_row]').prop('checked', false);
      	$('input[name=first_row]').prop('checked', false);
      }
  }

function bookSchedule(transDetailsId,twentyFtCount,fourtyFtCount,fourtyFtHcCount,fourtyFiveFtCount,chargerateids){
		bookScheduleAjaxCall(transDetailsId,twentyFtCount,fourtyFtCount,fourtyFtHcCount,fourtyFiveFtCount,chargerateids);	
}

function bookScheduleAjaxCall(transDetailsId,twentyFtCount,fourtyFtCount,fourtyFtHcCount,fourtyFiveFtCount,chargerateids){

	$('#loader').show();
	  var formData = new FormData();      
      formData.append("userId", userInfo.id);
      formData.append("scheduleId", transDetailsId);
      formData.append("twentyFtCount", twentyFtCount);
      formData.append("fourtyFtCount", fourtyFtCount);
      formData.append("fourtyFtHcCount", fourtyFtHcCount);
      formData.append("fourtyFiveFtCount", fourtyFiveFtCount);
      formData.append("chargerateids", chargerateids);
      
      $.post({
          url : server_url+'user/bookSchedule',	         
          enctype: 'multipart/form-data',
          headers: authHeader,
          processData: false,
          contentType: false,
          data : formData,
     
          success : function(response) {

	          console.log(response)
	 	        	
	          if(response.respCode == 1){	        	
	        	  $('#loader').hide();
		           successBlock("#success_block",response.respData.msg); 
		      }else if(response.respCode == 0){
		    	  $('#loader').hide();
		    	    errorBlock("#error_block",response.respData.msg);
		        	window.location.href = contextPath+"/user_myprofile";
			  }else{
			    	  errorBlock("#error_block",response.respData);
			  }
		        
	          $('#loader').hide();
          },
          error: function (error) {
	          console.log(error.responseJSON)    
             if( error.responseJSON != undefined){
   	             errorBlock("#error_block",error.responseJSON.respData);
             }else{
   	             errorBlock("#error_block","Server Error! Please contact administrator");
             }
   
            $('#loader').hide();
            }
      })
      
}
  function loadSearchResultDataTable(tableId,data){
  	
  	$('#'+tableId).dataTable().fnClearTable();
  	
  	var oTable = $('#'+tableId).DataTable({
  		'responsive': true,
  	 	"destroy" : true,
  		"data" : data,     	
       "dom": 'lBfrtip',

  		"columns": 	[
  			            {        
  			      	               data: 'origin',
  			    	               sortable: true,
  			            },  	    	           
  						{
		    	        	  
			      	           "data": null,
			    	           sortable: true,
			    	           className: "text-center",
			    	           render: function (data,type,row) {
               					 var transitValue = data.totaltransittime +" Days";

               					 var tansTimeWithLink = transitValue + '<br> <img src="static/images/line.png" alt="line" class="table_line"> <br> <a class="details-control details-control-style">+ Schedule</a> <a class="table_down_icon details-control"><i class="fa fa-caret-down" aria-hidden="true"></i></a>';
               					return tansTimeWithLink;
               					
               				}
						},
  						{
  							      
			      	               data: 'destination',
			    	               sortable: true,	
                        }, 	    	           			    	         
                  		{
  	                  		      
  	                  		       "data": null,
  	                  		        sortable: true,
                				    render: function (data,type,row) {
                    				    var forwarder = data.forwarder;
                    				    var imgPath = data.forwarderpng;
                					    /* return '<img src="'+imgPath+'" class="carrier_img" alt="carrier">'; */
                					    return forwarder;
                					
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
                                         var cost = data.cost;
                                         if(cost == null || cost == undefined){
                                            cost = 0;
                                         }
  	  	                  		         var usdCost = '<span class="charges_cost mt-4">USD '+cost+'</span>';
         					             return usdCost + '<a class="details_link mt-0">+ Details</a>';
         					
         				             }
  						},
  						{          
  							        "data": null,
  							        sortable: true,
  							        render: function (data,type,row) {
  							        	var chargerateids='';
  							        	var disabledClass='';
  							        	 if(data.chargesRateResponseList == null || data.scheduleLegsResponseList  == null){
  							        		disabledClass='book_btn_disabled';
  	  	  							     }else{
  	  	  							        chargerateids =    data.chargerateids;
  	  	  	  	  						 }
  	  	  							     
   	  	  							    var transDetailsId=data.id;


   	  	  							    var twentyFtCount = data.twentyFtCount;
   	  	  							    var fourtyFtCount = data.fourtyFtCount;
   	  	  							    var fourtyFtHcCount = data.fourtyFtHcCount;
   	  	  						        var fourtyFiveFtCount = data.fourtyFiveFtCount;
   	  	  							    
   	   	  	  							  		  							
              					         return '<input type="button" value="Book" class="book_btn '+disabledClass+'" onclick="bookSchedule(\''+transDetailsId+'\',\''+twentyFtCount+'\',\''+fourtyFtCount+'\',\''+fourtyFtHcCount+'\',\''+fourtyFiveFtCount+'\',\''+chargerateids+'\')">';
              					
              				        }
                		            
					    }
              			
                  	]
  						
      		                  
      		     });

      		 

			  	$('#searchList tbody .details-control').on('click', function () {
			        var tr = $(this).parent().parent();
			        var row = oTable.row( tr );
			        if ( row.child.isShown() ) {
			            // This row is already open - close it
			            row.child.hide();
			            tr.removeClass('shown');
			        }
			        else {
			            // Open this row
			            row.child( format(row.data()) ).show();
			            tr.addClass('shown');
			        }
			    } );

				$('#searchList tbody .details_link').on('click', function () {
			        var tr = $(this).parent().parent();
			        var row = oTable.row( tr );
			        if ( row.child.isShown() ) {
			            // This row is already open - close it
			            row.child.hide();
			            tr.removeClass('shown');
			        }
			        else {
			            // Open this row
			            row.child( formatDetail(row.data()) ).show();
			            tr.addClass('shown');
			        }
			    } );

				$('.inner_table tbody tr td .details-control-select').on('click', function () {		  		 	
			        $(this).parent().parent().parent().parent().parent().parent().hide();
			    } );
			    
		}		
  						

   

  </script>
  
</head>

	<div class="container-fluid">
	    <div class="row mb30 mt-3 bg_white_dash">
	      <div class="col-md-2 col-xs-12">
	      	<div class="side_filters">
	      		<h3 class="filter_hd2">Filter Results</h3>
	      		<a type="button" class="reset_btn" onclick="resetFilter();">Reset</a>
	      	 
	      <div id="forwarderFilterMainDiv">
	      	<h4 class="filter_subhd">Forwarder/CHA</h4>
	      	<div id="forwarderFilterSectionId">  	      		
	      		<!-- 
	      		 <div class="widthSpl100"><input type="checkbox" class="filter_checkbox"> <label class="filter_label" value="abc" onchange="filterme()" name="typeforwarder">Express Global</label></div>
	      		 <div class="widthSpl100 forwarder-hidden-item" style="display: none;" value="abc" onchange="filterme()" name="typeforwarder"><input type="checkbox" class="filter_checkbox"><label class="filter_label">Bajaj</label></div>
           		 <div class="widthSpl100 forwarder-hidden-item" style="display: none;" value="abc" onchange="filterme()" name="typeforwarder"><input type="checkbox" class="filter_checkbox"><label class="filter_label">Bajaj</label></div> 
           		 -->
	      	</div>
	      	<div class="clearfix"></div>
          <a href="#" class ="more_linkF" onclick="moreForwarderItems();">more...</a>
          <div class="clearfix"></div>
          <a  href="#" style="display: none;" class ="less_linkF" onclick="lessForwarderItems();">less</a>
          </div>
          
          <div class="clearfix"></div>
	      		
	      		<h4 class="filter_subhd">Order By</h4>
	      		<div class="widthSpl100"><input type="radio" name="sorting_input" class="filter_checkbox" name="ASC" onchange="filterme()"> <label class="filter_label">Lowest to Highest</label></div>
	      		<div class="widthSpl100"><input type="radio" name="sorting_input" class="filter_checkbox" name="DESC" onchange="filterme()"> <label class="filter_label">Highest to Lowest</label></div>
	      	</div>
	      </div>
	       <div class="col-md-10 col-xs-12">
	       <div class="row">
	       <div class="col-md-11">
	       <div class="row">
	       	<div class="col-md-2 results_line">Showing results for </div>
	       	
	       	<div class="col-md-9" style="font-size:12px;">
	       		<label class="results_label">Origin :</label>
	       		<span class="results_val" id="originSpanLabelId"></span>
	       		<label class="results_label">Destination :</label>
	       		<span class="results_val" id="destSpanLabelId"></span>
	       		<label class="results_label">FCL :</label>
	       		<span class="results_val" id="fclContainerCount"></span>
	       		<label class="results_label">Cargo Category :</label>
	       		<span class="results_val" id="cargoCatSpanLabelId"></span>
	       		<label class="results_label">Commodity  :</label>
	       		<span class="results_val" id="commoditySpanLabelId"></span>
	       		</div>
	       		</div>
	       
	       
	       </div>
	       <div class="col-md-1">
	       <input type="button" class="modify_search" value="Modify Search" id="modifySearchBtnId">
	       </div>
	       </div>
	       
	  <table id="searchList" class="row-border" style="width:100%">
        
        <thead>
            <tr>
                <th>Origin</th>
                <th class=".text-center">Transit Time</th>
                <th>Destination</th>                
                <th>Forwarder / CHA</th>
                <th>Cut-Off-Date</th>
                <th>Charges</th>
                <th>Action</th>
            </tr> 
        </thead>
        
    </table>
	      </div>
	    </div>
    </div>
    
   <script src="http://cdn.datatables.net/1.10.1/js/jquery.dataTables.min.js"></script>
  <script src="https://cdn.datatables.net/responsive/1.0.7/js/dataTables.responsive.min.js"></script>
   <script>
    $(document).ready( function () {
    	$('.forwarder_filter').hide();
	    $('.forwarder_link').click(function(){
	    	$('.forwarder_filter').show();
	    	$('.forwarder_link').hide();
		});

		
	} );


    /* Carrier */
    function moreCarrierItems() {

      $(".carrier-hidden-item").show();
      $(".more_linkC").hide();
      $(".less_linkC").show();
    }

    function lessCarrierItems() {
      $(".carrier-hidden-item").hide();
      $(".more_linkC").show();
      $(".less_linkC").hide();
    }
    /* Carrier */
    
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
    /* Carrier */
  </script> 
<!--   Tooltip --> 
<script>
$(function () {
	  $('[data-toggle="tooltip"]').tooltip({
		    trigger : 'hover'
	  })
	})

</script> 
<!--   Tooltip --> 
</html>