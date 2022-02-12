<%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="ISO-8859-1">
<title>Insert title here</title>
<!--Datatable Export-->
<link rel="stylesheet" href="static/css/buttons.dataTables.css">
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
	  getCarrierList();

	  $("#add-carrier").submit(function(event) {
		   $('#loader').show();
	      //Prevent default submission of form
	      event.preventDefault();

	      var form_data = {};	       
	      	      
	      form_data["userId"] = userInfo.id;  
	      form_data["carrier"] = $("#carrNameId").val(); 
	      form_data["carrierCode"] = $("#compCodeId").val(); 	      
	      form_data["website"] = $("#compWebsiteId").val();
	      form_data["logopath"] = $("#compLogoId").val(); 
	      form_data["scacCode"] = $("#scacCodeId").val();
	     
          $.post({
 	         url : server_url+'admin/addCarrier',
 	         contentType: "application/json",
 	         headers: authHeader,
 	         data : JSON.stringify(form_data), 
 	         success : function(response) {
 	        	if(response.respCode == 1){	        		
 	     	       swal(response.respData.msg);
 	     	       $('#addCarrierModal').modal('hide');
 	     	       getCarrierList();
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
	   
	  $("#update-carrier").submit(function(event) {
		   $('#loader').show();	
		        
	       event.preventDefault();	
	            
	       var form_data = {};
	       form_data["id"] = $("#carrierUpdId").val(); 
	       form_data["userId"] = userInfo.id;  	      
	       form_data["website"] = $("#compWebsiteUpdId").val();
	       form_data["logopath"] = $("#compLogoUpdId").val(); 
	       
	       $.ajax({
	   		type: 'PUT',
 	         url : server_url+'admin/updateCarrierById',
 	         contentType: "application/json",
 	         headers: authHeader,
 	         data : JSON.stringify(form_data), 
 	         success : function(response) {
 	        	if(response.respCode == 1){	        		
 	     	       swal(response.respData.msg);
 	     	       $('#updateCarrier').modal('hide');
 	     	       getCarrierList();
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

function getCarrierList(){
	 $('#loader').show();
	  var tableId = "carrierListTable";  

	  	$.ajax({
	  			
	  		     type: 'GET', 
	               url : server_url+'admin/getCarrierList',	     
	               enctype: 'multipart/form-data',
	               headers: authHeader,
	               processData: false,
	               contentType: false,
	               data : null,	      
	               success : function(response) {
	  	           console.log(response)	  	 	        	
	  	            if(response.respCode == 1){  		    
	  	            	$('#loader').hide();        
	  		          loadCarrierListTable(response.respData,tableId); 		            		             	       
	  	            }else{
	  		            errorBlock("#error_block",response.respData)
	  		            loadCarrierListTable(null,tableId);
	                  }
	  	             $('#loader').hide();
	               },
	               error: function (error) {
	  	                console.log(error)
	                      if( error.responseJSON != undefined){
	   	                   errorBlock("#error_block",error.responseJSON.respData);
	   	                   loadCarrierListTable(null,tableId);
	                      }else{
	   	                   errorBlock("#error_block","Server Error! Please contact administrator");
	                      }         
	  	              $('#loader').hide();
	               }
	      })
	  
}

function loadCarrierListTable(data,tableId){
  	
  	$('#'+tableId).dataTable().fnClearTable();
  	
  	var oTable = $('#'+tableId).DataTable({
  		/* 'responsive': true,  */
  	 	"destroy" : true,
  		"data" : data,     	
       "dom": 'lBfrtip',
       "lengthChange": true,
       "buttons": [{
           extend: 'pdfHtml5',
           filename: 'carrier_list_pdf',
           title: "",
           text: '<i class="fas fa-file-pdf"></i>',
           exportOptions: {
             columns: [0, 1, 2, 3, 4]
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
           filename: 'carrier_list_xsl',
           title: "",
           className: 'excel',
           text: '<i class="fas fa-file-excel"></i>',
           exportOptions: {
             columns: [0, 1, 2, 3, 4]
           }
           /* messageTop: "User Enquiry Data" */
         },
       ],
  		"columns": 	[
  			           {        
                          "data": null,
                            sortable: true,					    	          
                            render: function (data,type,row) {
	                            var carriername = data.carriername;
	                            var carriershortname = data.carriershortname;

		                        return carriername+" ("+carriershortname+")";
			                    		
	                         }
                   },
  			            {        
  			            	 "data": null,
			    	           sortable: true,					    	          
			    	           render: function (data,type,row) {
               				   var website = data.website;

               					return '<a href="'+website+'" target="_blank">'+website+'</a>';
               						               					
               				}
  			            },
  						{				    	        	  
			      	           "data": null,					      	       
			    	           sortable: true,					    	          
			    	           render: function (data,type,row) {
               				   var logopath = data.logopath;

               				   return logopath;
               					
               				}
						},						
  					    {          	
                   	     
                 	       "data": null,
                 	      className: 'dt-body-center',
                 	        sortable: true,	
              				render: function (data,type,row) {
              					 var logopath = data.logopath;
                     			return '<img src="'+logopath+'" width="70">';	                     					
              				}
				        },
				        {          	
                       	     
                     	       "data": null,
                     	      className: 'text-center',
                     	        sortable: true,	
                  				render: function (data,type,row) {
	                  				var id = data.id;
                  					var action = '<button type="button" class="update_btn" onclick="getCarrierDetailsById('+id+');"><i class="fas fa-pencil-alt"></i></button>'+
                  					'<button type="button" class="del_btn" onclick="deleteCarrier('+id+');"><i class="fas fa-trash"></i></button>';
                  					
                  					return action;
	                     				                     					
                  				}
					     }
              			
                  	]
      		                  
      		     });
}

function deleteCarrier(id){
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
		        url: server_url + 'admin/deleteCarrier/'+id+"/"+userInfo.id,
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
		            getCarrierList();

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

function getCarrierDetailsById(id){
	$('#loader').show();
    var userId = userInfo.id;
    $.ajax({
      type: 'GET',
      url: server_url + 'admin/getCarrierDetailsById',
      enctype: 'multipart/form-data',
      headers: authHeader,
      processData: false,
      contentType: false,

      data: "id=" + id,

      success: function (response) {

        console.log(response)

        if (response.respCode == 1) {
          $('#loader').hide();
          var carriername = response.respData.carriername;
          var carriershortname = response.respData.carriershortname;
          var website = response.respData.website;
          var logopath = response.respData.logopath;
          $("#carrierUpdId").val(response.respData.id);
          $("#carrNameUpdId").val(carriername);
          $("#compCodeUpdId").val(carriershortname);
          $("#compWebsiteUpdId").val(website);
          $("#compLogoUpdId").val(logopath);    
          $('#updateCarrier').modal('show');
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
            <h2 class="book_cargo_hd mt-4">Carrier List</h2>
            <p class="upload_subline mb-4">List of Carriers</p>
          </div>
           <div class="col-md-2 text-right">
            <button type="button" class="login_btn2" data-toggle="modal" data-target="#addCarrierModal">Add Carrier</button>
          </div> 
        </div>
        <div class="clearfix"></div>
        <!-- <div class="table-responsive"> --><!-- to remove unwanted scroll -->
        <div class="">
          <table class="table table-bordered table_fontsize" id="carrierListTable" style="width:100%">
            <thead class="thead-light">
              <tr>
                <th>Carrier</th>
                <th>Company URL</th>
                <th>Logo URL</th>
                <th>Company Logo</th>
                <th>Action</th>
              </tr>
            </thead>                    
          </table>
        </div>
      </div>
    </div>
  </div>
</div>

<!-- Add Carrier -->
<div class="modal fade" id="addCarrierModal" tabindex="-1" role="dialog" aria-labelledby="exampleModalLabel" aria-hidden="true">
  <div class="modal-dialog modal-lg" role="document">
    <div class="modal-content">
    <form method="post" id="add-carrier">
      <div class="modal-header modal-header-spl">
        <h5 class="modal-title" id="exampleModalLabel">Add Carrier</h5>
        <button type="button" class="close modal_close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
      </div>
      <div class="modal-body">
        <div class="row mt-2">
          <div class="col-md-2">
            <label for="" class="form-label-new">Name</label>
          </div>
          <div class="col-md-4 ">
            <input type="text" class="form-control font14" name="carrName" id="carrNameId" autocomplete="off" required>
          </div>
          <div class="col-md-2">
            <label for="" class="form-label-new">Code</label>
          </div>
          <div class="col-md-4 ">
            <input type="text" class="form-control font14" name="compCode" id="compCodeId" autocomplete="off" required>
          </div>
        </div>
        <div class="row mt-2">       
          <div class="col-md-2">
            <label for="" class="form-label-new">Website URL</label>
          </div>
          <div class="col-md-4 ">
            <input type="text" class="form-control font14" name="compWebsite" id="compWebsiteId" autocomplete="off" required>
          </div>
           <div class="col-md-2">
            <label for="" class="form-label-new">Logo URL</label>
          </div>
          <div class="col-md-4 ">
            <input type="text" class="form-control font14" name="compLogo" id="compLogoId" autocomplete="off" required>
          </div>
        </div>
        <div class="row mt-2">       
          <div class="col-md-2">
            <label for="" class="form-label-new">SCAC Code</label>
          </div>
          <div class="col-md-4 ">
            <input type="text" class="form-control font14" name="scacCode" id="scacCodeId" autocomplete="off" required>
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

<!-- Update Carrier -->
<div class="modal fade" id="updateCarrier" tabindex="-1" role="dialog" aria-labelledby="exampleModalLabel" aria-hidden="true">
  <div class="modal-dialog modal-lg" role="document">
    <div class="modal-content">
    <form method="post" id="update-carrier">
      <div class="modal-header modal-header-spl">
        <h5 class="modal-title" id="exampleModalLabel">Update Carrier</h5>
        <button type="button" class="close" data-dismiss="modal" aria-label="Close"> <span aria-hidden="true">&times;</span> </button>
      </div>
      <div class="modal-body">
      <input type="hidden" id="carrierUpdId" name="" value="">
        <div class="row mt-2">
          <div class="col-md-2">
            <label for="" class="form-label-new">Name</label>
          </div>
          <div class="col-md-4 ">
            <input type="text" class="form-control font14" name="carrNameUpd" id="carrNameUpdId" autocomplete="off" readonly>
          </div>
          <div class="col-md-2">
            <label for="" class="form-label-new">Code</label>
          </div>
          <div class="col-md-4 ">
            <input type="text" class="form-control font14" name="compCodeUpd" id="compCodeUpdId" autocomplete="off" readonly>
          </div>
        </div>
        <div class="row mt-2">        
          <div class="col-md-2">
            <label for="" class="form-label-new">Website URL</label>
          </div>
          <div class="col-md-4 ">
            <input type="text" class="form-control font14" name="compWebsiteUpd" id="compWebsiteUpdId" autocomplete="off" required>
          </div>
          <div class="col-md-2">
            <label for="" class="form-label-new">Logo URL </label>
          </div>
          <div class="col-md-4 ">
            <input type="text" class="form-control font14" name="compLogoUpd" id="compLogoUpdId" autocomplete="off" required>
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
<!-- Update Carrier -->

</body>
</html>