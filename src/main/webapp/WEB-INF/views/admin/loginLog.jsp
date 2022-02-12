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
<style>

</style>
<script type="text/javascript">
   
  $(function() {
	  activeNavigationClass();
	  getUserLoginLogData();
	  
  });

  function getUserLoginLogData(){

	  var tableId = "loginLogTableId";  

	  	$.ajax({
	  			
	  		     type: 'GET', 
	               url : server_url+'admin/getUseLoginLog',	     
	               enctype: 'multipart/form-data',
	               headers: authHeader,
	               processData: false,
	               contentType: false,

	               data : null,
	      
	               success : function(response) {

	  	           console.log(response)
	  	 	        	
	  	            if(response.respCode == 1){  		            
	  		          loadUserLoginLogDataTable(response.respData,tableId); 		            		             	       
	  	            }else{
	  		            errorBlock("#error_block",response.respData)
	  		            loadUserLoginLogDataTable(null,tableId);
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


  function loadUserLoginLogDataTable(data,tableId){
	  	
	  	$('#'+tableId).dataTable().fnClearTable();
	  	
	  	var oTable = $('#'+tableId).DataTable({
	  		 'responsive': true, 
	  	 	"destroy" : true,
	  		"data" : data,     	
	       "dom": 'lBfrtip',
	      
	      "buttons": [{
	           extend: 'excel',
	           filename: 'login_log_xsl',
	           title: '',
	           text: '<i class="far fa-file-excel-o"></i>',
	           titleAttr: 'Download Excel',
	           exportOptions: {
	             columns: [0, 1, 2, 3, 4, 5]
	           }
	           /*messageTop: "User Enquiry Data" */
	         },
	       ],
	       "columnDefs": [
      {  "targets": 0, "className": "text-center", "width": "5%", },
       { "targets": 4, "className": "dt-body-center", "width": "10%",  },
       { "targets": 5, "className": "dt-body-center", "width": "10%", },
       ],
	  		"columns": 	[
	  			           {        
  	                          "data": null,
                                  sortable: true,					    	          
                                  render: function (data,type,row) {
		                            var serialnumber = data.srno;

			                        return serialnumber;
				                    		
		                         }
                         },
	  			            {        
	  			            	 "data": null,
				    	           sortable: true,					    	          
				    	           render: function (data,type,row) {
	               				   var username = data.username;

	               					return username;
	               						               					
	               				}
	  			            },
	  						{				    	        	  
				      	           "data": null,					      	       
				    	           sortable: true,					    	          
				    	           render: function (data,type,row) {
	               				   var userrole = data.userrole;

	               				   return userrole;
	               					
	               				}
							},
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
                   					var logindatetime = data.logindatetime;
                   					if(logindatetime == null){
                   						logindatetime = "NA";
                           			}
                   					return logindatetime;
                   					
                   				}	
	                        },
	  	    	            {          	
	                        	     
	                        	       "data": null,
	                        	        sortable: true,	
	                     				render: function (data,type,row) {
	                     					 var ipaddress = data.ipaddress;
	                     					 if(ipaddress == null){
	                     						ipaddress = "NA";
	     		                     		 }
	                     					return ipaddress;
		                     				                     					
	                     				}
	  					    }
	              			
	                  	],
	                  	"order": [[ 4, 'desc' ]],
	      		                  
	      		     });
}

  function deleteAllLoginLog(){
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
		        url: server_url + 'admin/deleteAllLoginLog/'+userInfo.id,
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
		            getUserLoginLogData();

		          } else {
		            errorBlock("#error_block", response.respData);
		            getUserLoginLogData();
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
  
  </script>
</head>
<body>
<div class="container-fluid">
  <div class="bg_white_main mb-4 mt-4">
    <div class="row">
          <div class="col-md-10">
        <h2 class="book_cargo_hd mt-4">User Login History</h2>
        <p class="upload_subline mb-4">Below is the full list of User Login logs</p>
         </div>
          <div class="col-md-2 text-right">
            <button type="button" class="login_btn2G" onclick="deleteAllLoginLog();">Clear All</button>
          </div>
        </div>
        <div class="clearfix"></div>
        <!-- <div class="table-responsive"> --><!-- to remove unwanted scroll -->
        <div class="">
          <table class="table table-bordered table_fontsize " id="loginLogTableId" style="width:100%">
            <thead class="thead-light">
              <tr>
                <th>Sr. no.</th>
                <th>Email Id</th>
                <th>User Role</th>
                <th>User Company</th>
                <th>Date & Time</th>
                <th>IP Address</th>
              </tr>
            </thead>
          </table>
        </div>
      </div>
    </div>
  </div>
</div>

<script>
	
	$(document).ready( function () {
	    $('#loginLogTableId').DataTable();
	} );
  </script>
</body>
</html>