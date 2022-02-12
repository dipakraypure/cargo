<%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="ISO-8859-1">
<title>Insert title here</title>
<!--Datatable Export-->
<link rel="stylesheet" href="static/css/buttons.dataTables.css">
<script src="https://cdn.datatables.net/buttons/1.7.1/js/dataTables.buttons.min.js"></script> 
<script src="https://cdnjs.cloudflare.com/ajax/libs/jszip/3.1.3/jszip.min.js"></script><!-- excel--> 
<script src="https://cdnjs.cloudflare.com/ajax/libs/pdfmake/0.1.53/pdfmake.min.js"></script> 
<script src="https://cdnjs.cloudflare.com/ajax/libs/pdfmake/0.1.53/vfs_fonts.js"></script> 
<script src="https://cdn.datatables.net/buttons/1.7.1/js/buttons.html5.min.js"></script> 
<script src="https://cdn.datatables.net/buttons/1.7.1/js/buttons.print.min.js"></script> 
<!--Datatable Export--> 
<style type="text/css">
p {font-size:14px; padding:0 5px}
</style>
<script type="text/javascript">
   
  $(function() {
	  activeNavigationClass();
	  getUploadedAdsList();
	  
 /*  Submit form using Ajax */
	   $("#upload-ads").submit(function(event) {
		   $('#loader').show();
	      //Prevent default submission of form
	      event.preventDefault();
	      
	      var form_data = $(this).serializeJSON({useIntKeysAsArrayIndex: true});
	     
           $.post({
  	         url : server_url+'admin/uploadAds',
  	         contentType: "application/json",
  	         headers: authHeader,
  	         data : JSON.stringify(form_data), 
  	         success : function(response) {
  	        	if(response.respCode == 1){	        		
  	     	       swal(response.respData.msg);
  	     	       $('#AddAdvt').modal('hide');
  	     	       getUploadedAdsList();
  	       		}else if(response.respCode == 0){	  	       		
  	       		    errorBlock("#error_block",response.respData);          			
  	            }else{
  	                errorBlock("#error_block",response.respData);
  	  	        }
  	        	$('#loader').hide();
  	         },
  	         error: function (error) {  	        	        	 
  	        	 console.log(error.responseJSON ) 	             
  	             if( error.responseJSON != undefined){
  	            	 errorBlock("#error_block",error.responseJSON.respData);  	            	  	            	 
  	              }else{
  	            	  errorBlock("#error_block","Server Error! Please contact administrator"); 	            	
  	              }
  	        	$('#loader').hide();
  	     	}
  	      }) 
  	        
	   });

	   $("#update-ads").submit(function(event) {
		   $('#loader').show();	
		        
	      event.preventDefault();	
	            
	       var form_data = {};
	       form_data["id"] = $("#adsId").val(); 
	       form_data["userId"] = userInfo.id;  
	       form_data["companyName"] = $("#companyNameUpd").val();
	       form_data["email"] = $("#emailUpd").val();
	       form_data["startDate"] = $("#startDateUpd").val(); 
	       form_data["endDate"] = $("#endDateUpd").val();	       
	       form_data["content"] = $("#contentUpd").val();
	       form_data["priority"] = $("#priorityUpd").val();
	       form_data["status"] = $("#statusUpd").val();

	       $.ajax({
	   		 type: 'PUT',
  	         url : server_url+'admin/updateAdsById',
  	         contentType: "application/json",
  	         headers: authHeader,
  	         data : JSON.stringify(form_data), 
  	         success : function(response) {
  	        	if(response.respCode == 1){	        		
  	     	       swal(response.respData.msg);
  	     	       $('#UpdateAdvt').modal('hide');
  	     	       getUploadedAdsList();
  	       		}else if(response.respCode == 0){	  	       		
  	       		    errorBlock("#error_block",response.respData);          			
  	            }else{
  	                errorBlock("#error_block",response.respData);
  	  	        }
  	        	$('#loader').hide();
  	         },
  	         error: function (error) {  	        	        	 
  	        	 console.log(error.responseJSON ) 	             
  	             if( error.responseJSON != undefined){
  	            	 errorBlock("#error_block",error.responseJSON.respData);  	            	  	            	 
  	              }else{
  	            	  errorBlock("#error_block","Server Error! Please contact administrator"); 	            	
  	              }
  	        	$('#loader').hide();
  	     	}
  	      }) 
  	        
	   });

  });

  function getUploadedAdsList(){
	  $('#loader').show();
	  var tableId = "uloadAdsTableId";  

	  	$.ajax({
	  			
	  		     type: 'GET', 
	               url : server_url+'admin/getUploadedAdsList',	     
	               enctype: 'multipart/form-data',
	               headers: authHeader,
	               processData: false,
	               contentType: false,
	               data : null,	      
	               success : function(response) {
	  	           console.log(response)	  	 	        	
	  	            if(response.respCode == 1){  		    
	  	            	$('#loader').hide();        
	  		          loadUploadAdsListTable(response.respData,tableId); 		            		             	       
	  	            }else{
	  		            errorBlock("#error_block",response.respData)
	  		            loadUploadAdsListTable(null,tableId);
	                  }
	  	             $('#loader').hide();
	               },
	               error: function (error) {
	  	                console.log(error)
	                      if( error.responseJSON != undefined){
	   	                   errorBlock("#error_block",error.responseJSON.respData);
	   	                   loadUploadAdsListTable(null,tableId);
	                      }else{
	   	                   errorBlock("#error_block","Server Error! Please contact administrator");
	                      }         
	  	              $('#loader').hide();
	               }
	      })
	  
  }

  function loadUploadAdsListTable(data,tableId){
	  	
	  	$('#'+tableId).dataTable().fnClearTable();
	  	
	  	var oTable = $('#'+tableId).DataTable({
	  		/* 'responsive': true,  */
	  	 	"destroy" : true,
	  		"data" : data,     	
	       "dom": 'lBfrtip',
	       "lengthChange": true,
	       "buttons": [{
	           extend: 'excel',
	           filename: 'upload_ads_xsl',
	           title: '',
	           text: '<i class="far fa-file-excel-o"></i>',
	           titleAttr: 'Download Excel',
	           exportOptions: {
	             columns: [0, 1, 2, 3, 4, 5, 6]
	           }
	           /*messageTop: "User Enquiry Data" */
	         },
	       ],
	       "columnDefs": [
		    	    { "width": "10%",  "targets": 0 },
		    	    { "width": "50%",  "targets": 2 },
		    	    { "width": "4%",  "targets": 3 },
		    	    { "width": "8%",  "targets": 4 },
		    	    { "width": "8%",  "targets": 5 },
		    	    { "width": "6%",  "targets": 6 },
		    	    { "width": "6%",  "targets": 7 }
		    	    
		    	    
		    	  ],
	  		"columns": 	[
	  			           {        
	                          "data": null,
                                sortable: true,					    	          
                                render: function (data,type,row) {
		                            var companyname = data.companyname;

			                        return companyname;
				                    		
		                         }
                       },
	  			            {        
	  			            	 "data": null,
				    	           sortable: true,					    	          
				    	           render: function (data,type,row) {
	               				   var email = data.email;

	               					return email;
	               						               					
	               				}
	  			            },
	  						{				    	        	  
				      	           "data": null,					      	       
				    	           sortable: true,					    	          
				    	           render: function (data,type,row) {
	               				   var content = data.content;

	               				   return content;
	               					
	               				}
							},
							{				    	        	  
				      	           "data": null,
				      	         className: 'dt-body-right',					      	       
				    	           sortable: true,					    	          
				    	           render: function (data,type,row) {
	               				   var priority = data.priority;

	               				   return priority;
	               					
	               				}
							},
	  						 {
	  							      
								    "data": null,
								    className: 'dt-body-center',
                    	        sortable: true,	
                 				render: function (data,type,row) {
                 					var startdate = data.startdate;
                 					
                 					return startdate;
                 					
                 				}	
	                        },
	  	    	            {          	
	                        	     
	                        	       "data": null,
	                        	       className: 'dt-body-center',
	                        	        sortable: true,	
	                     				render: function (data,type,row) {
	                     					 var enddate = data.enddate;
	                     					
	                     					return enddate;
		                     				                     					
	                     				}
	  					    },
	  					    {          	
                       	     
                     	       "data": null,
                     	      className: 'dt-body-center',
                     	        sortable: true,	
                  				render: function (data,type,row) {
                  					 var status = data.status;
                  					
                  					return status;
	                     				                     					
                  				}
					        },
					        {          	
	                       	     
	                     	       "data": null,
	                     	      className: 'text-center',
	                     	        sortable: true,	
	                  				render: function (data,type,row) {
		                  				var id = data.id;
	                  					var action = '<button type="button" class="update_btn" onclick="getAdsDetailsById('+id+');"><i class="fas fa-pencil-alt"></i></button>'+
	                  	                  '<button type="button" class="del_btn" onclick="deleteAds('+id+');"><i class="fas fa-trash"></i></button>';
	                  					
	                  					return action;
		                     				                     					
	                  				}
						     }
	              			
	                  	]
	      		                  
	      		     });
}

  function deleteAds(id) {

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
	        url: server_url + 'admin/deleteAds/'+id+"/"+userInfo.id,
	        enctype: 'multipart/form-data',
	        headers: authHeader,
	        processData: false,
	        contentType: false,

	        data: null,

	        success: function (response) {

	          console.log(response)

	          if (response.respCode == 1) {
	            $('#loader').hide();
	            successBlock("#success_block", response.respData.msg);
	            getUploadedAdsList();

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

  function getAdsDetailsById(id){
	  $('#loader').show();
      var userId = userInfo.id;
      $.ajax({
        type: 'GET',
        url: server_url + 'admin/getAdsDetailsById',
        enctype: 'multipart/form-data',
        headers: authHeader,
        processData: false,
        contentType: false,

        data: "id=" + id + "&userId=" + userInfo.id,

        success: function (response) {

          console.log(response)

          if (response.respCode == 1) {
            $('#loader').hide();
            
            $('#adsId').val(response.respData.id); 
            $('#companyNameUpd').val(response.respData.companyname);
            $('#emailUpd').val(response.respData.email);
            $('#startDateUpd').val(response.respData.startdate);
            $('#endDateUpd').val(response.respData.enddate);
            $('#contentUpd').val(response.respData.content);
            $("#priorityUpd").val(response.respData.priority);
            $("#statusUpd").val(response.respData.status);
            
            $('#UpdateAdvt').modal('show');
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
  
 </script>

</head>
<body>
<div class="container-fluid">
  <div class="bg_white_main mb-4 mt-4">
    <div class="row">
      <div class="col-md-12 mb-4">
        <div class="row">
          <div class="col-md-10">
            <h2 class="book_cargo_hd mt-4">Scrolling Advertisement</h2>
            <p class="upload_subline mb-4">Registered Advertisements</p>
          </div>
          <div class="col-md-2 text-right">
            <button type="button" class="login_btn2" data-toggle="modal" data-target="#AddAdvt">Add Advertisment</button>
          </div>
        </div>
        <div class="clearfix"></div>
        <!-- <div class="table-responsive"> --><!-- to remove unwanted scroll -->
        <div class="">
          <table class="table table-bordered table_fontsize" id="uloadAdsTableId" style="width:100%">
            <thead class="thead-light">
              <tr>
                <th>Company Name</th>
                <th>Email Id</th>
                <th>Content</th>
                <th>Display Order</th>
                <th>Start Date</th>
                <th>End Date</th>
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

<!-- Add Advertisment -->
<div class="modal fade" id="AddAdvt" tabindex="-1" role="dialog" aria-labelledby="exampleModalLabel" aria-hidden="true">
  <div class="modal-dialog modal-lg" role="document">
    <div class="modal-content">
    <form method="post" id="upload-ads">
      <div class="modal-header modal-header-spl">
        <h5 class="modal-title" id="exampleModalLabel">Add Advertisment</h5>
        <button type="button" class="close modal_close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
      </div>
      <div class="modal-body">
        <div class="row mt-2">
          <div class="col-md-2">
            <label for="" class="form-label-new">Company Name</label>
          </div>
          <div class="col-md-4 ">
            <input type="text" class="form-control font14" name="companyName" id="CoName" autocomplete="off" required>
          </div>
          <div class="col-md-2">
            <label for="" class="form-label-new">Email Id</label>
          </div>
          <div class="col-md-4 ">
            <input type="email" class="form-control font14" name="email" id="CoEmail" autocomplete="off" required>
          </div>
        </div>
        <div class="row mt-2">
          <div class="col-md-2">
            <label for="" class="form-label-new">Start Date</label>
          </div>
          <div class="col-md-4 ">
            <input type="text" class="form-control font14" name="startDate" id="StDt" autocomplete="off" required>
          </div>
          <div class="col-md-2">
            <label for="" class="form-label-new">End Date</label>
          </div>
          <div class="col-md-4 ">
            <input type="text" class="form-control font14" name="endDate" id="EdDat" autocomplete="off" required>
          </div>
        </div>
        <div class="row mt-2">
          <div class="col-md-2">
            <label for="" class="form-label-new">Content</label>
          </div>
          <div class="col-md-10 ">
            <textarea  class="form-control font14" name="content" id="content" autocomplete="off" maxlength="140" placeholder="140 Charaters" required></textarea>
          </div>
          </div>
           <div class="row mt-2">
          <div class="col-md-2">
            <label for="" class="form-label-new">Display Order</label>
          </div>
          <div class="col-md-4 ">
            <select class="form-control font14" name="priority" id="priority" required>
              <option value="1">1</option>
              <option value="2">2</option>
              <option value="3">3</option>
              <option value="4">4</option>
              <option value="5">5</option>
              <option value="6">6</option>
              <option value="7">7</option>
              <option value="8">8</option>
              <option value="9">9</option>
              <option value="10">10</option>
            </select>
          </div>
           <div class="col-md-2">
            <label for="" class="form-label-new">Status</label>
          </div>
          <div class="col-md-4 ">
            <select class="form-control font14" name="status" id="status" required>
              <option value="Active">Active</option>
              <option value="Inactive">Inactive</option>              
            </select>
          </div>
          
        </div>
        
      </div>
      <div class="modal-footer">
        <button type="button" class="clear_btn" data-dismiss="modal">Close</button>
        <button type="submit" class="advt_btn">Submit</button>
      </div>
      </form>
    </div>
  </div>
</div>
<!-- Add Advertisment -->

<!-- Update Advertisment -->
<div class="modal fade" id="UpdateAdvt" tabindex="-1" role="dialog" aria-labelledby="exampleModalLabel" aria-hidden="true">
  <div class="modal-dialog modal-lg" role="document">
    <div class="modal-content">
    <form method="post" id="update-ads">
      <div class="modal-header modal-header-spl">
        <h5 class="modal-title" id="exampleModalLabel">Update Advertisment</h5>
        <button type="button" class="close" data-dismiss="modal" aria-label="Close"> <span aria-hidden="true">&times;</span> </button>
      </div>
      <div class="modal-body">
      <input type="hidden" id="adsId" name="" value="">
        <div class="row mt-2">
          <div class="col-md-2">
            <label for="" class="form-label-new">Company Name</label>
          </div>
          <div class="col-md-4 ">
            <input type="text" class="form-control font14" name="companyName" id="companyNameUpd" autocomplete="off" required>
          </div>
          <div class="col-md-2">
            <label for="" class="form-label-new">Email Id</label>
          </div>
          <div class="col-md-4 ">
            <input type="email" class="form-control font14" name="email" id="emailUpd" autocomplete="off" required>
          </div>
        </div>
        <div class="row mt-2">
          <div class="col-md-2">
            <label for="" class="form-label-new">Start Date</label>
          </div>
          <div class="col-md-4 ">
            <input type="text" class="form-control font14" name="startDate" id="startDateUpd" autocomplete="off" required>
          </div>
          <div class="col-md-2">
            <label for="" class="form-label-new">End Date</label>
          </div>
          <div class="col-md-4 ">
            <input type="text" class="form-control font14" name="endDate" id="endDateUpd" autocomplete="off" required>
          </div>
        </div>
        <div class="row mt-2">
          <div class="col-md-2">
            <label for="" class="form-label-new">Content</label>
          </div>
          <div class="col-md-10 ">
            <textarea  class="form-control font14" name="content" id="contentUpd" autocomplete="off" required></textarea>
          </div>
          </div>
           <div class="row mt-2">
          <div class="col-md-2">
            <label for="" class="form-label-new">Display Order</label>
          </div>
          <div class="col-md-4 ">
            <select class="form-control font14" name="priority" id="priorityUpd" required>
              <option value="1">1</option>
              <option value="2">2</option>
              <option value="3">3</option>
              <option value="4">4</option>
              <option value="5">5</option>
              <option value="6">6</option>
              <option value="7">7</option>
              <option value="8">8</option>
              <option value="9">9</option>
              <option value="10">10</option>
            </select>
          </div>
           <div class="col-md-2">
            <label for="" class="form-label-new">Status</label>
          </div>
          <div class="col-md-4 ">
            <select class="form-control font14" name="status" id="statusUpd" required>
              <option value="Active">Active</option>
              <option value="Inactive">Inactive</option>              
            </select>
          </div>
          
        </div>
        
      </div>
      <div class="modal-footer">
        <button type="button" class="clear_btn" data-dismiss="modal">Close</button>
        <button type="submit" class="advt_btn">Submit</button>
      </div>
      </form>
    </div>
  </div>
</div>
<!-- Update Advertisment -->

<script>
$(document).ready(function () {
	  $('#advtDetails').DataTable({
	    /* 'responsive': true */
		    "columnDefs": 	[
		    	{ targets: 3,
		    		className: 'text-center' },
		    		{ targets: 4,
			    		className: 'text-center' },
		    		{ targets: 5,
			    		className: 'text-center' },
			    		{ targets: 7,
				    		className: 'text-center' }
			    ]
	  });	
	});
</script> 	
<script type="text/javascript">
$(function () {
    $('#StDt, #startDateUpd').datetimepicker({
      format: 'DD-MMM-YYYY',
      minDate: moment()
    });
    $('#EdDat, #endDateUpd').datetimepicker({
      format: 'DD-MMM-YYYY',
      useCurrent: false //Important! See issue #1075
    });
    $("#StDt, #startDateUpd").on("dp.change", function (e) {
      $('#EdDat').data("DateTimePicker").minDate(e.date);
      $('#endDateUpd').data("DateTimePicker").minDate(e.date);
    });
    $("#EdDat, #endDateUpd").on("dp.change", function (e) {
      $('#StDt').data("DateTimePicker").maxDate(e.date);
      $('#startDateUpd').data("DateTimePicker").maxDate(e.date);
    });
  });
</script>
</body>
</html>