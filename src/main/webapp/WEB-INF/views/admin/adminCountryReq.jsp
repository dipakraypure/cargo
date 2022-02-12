<%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="ISO-8859-1">
<title>Country Requirement</title>
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

<script>
$(document).ready(function () {
	activeNavigationClass();
	
	getCountrySpecificationList();
	getAllCountryList();
  
});

function getCountrySpecificationList(){

	  $('#loader').show();
	  var tableId = "countryTable";

	  $.ajax({
	    type: 'GET',
	    url: server_url + 'admin/getCountrySpecificationList',
	    enctype: 'multipart/form-data',
	    headers: authHeader,
	    processData: false,
	    contentType: false,
	    data: null,
	    success: function (response) {
	      console.log(response)
	      if (response.respCode == 1) {
	        $('#loader').hide();
	        loadSpecificationListTable(response.respData, tableId);
	      } else {
	        errorBlock("#error_block", response.respData)
	        loadSpecificationListTable(null, tableId);
	      }
	      $('#loader').hide();
	    },
	    error: function (error) {
	      console.log(error)
	      if (error.responseJSON != undefined) {
	        errorBlock("#error_block", error.responseJSON.respData);
	        loadSpecificationListTable(null, tableId);
	      } else {
	        errorBlock("#error_block", "Server Error! Please contact administrator");
	      }
	      $('#loader').hide();
	    }
	  })
}

function loadSpecificationListTable(data,tableId){

	$('#' + tableId).dataTable().fnClearTable();

	  var oTable = $('#' + tableId).DataTable({
	    /* 'responsive': true,  */
	    "destroy": true,
	    "data": data,
	    "dom": 'lBfrtip',
	    "buttons": [{
	           extend: 'excel',
	           filename: 'country_requirement_xsl',
	           title: '',
	           text: '<i class="far fa-file-excel-o"></i>',
	           titleAttr: 'Download Excel',
	           exportOptions: {
	             columns: [0, 1, 2, 3]
	           }
	           /*messageTop: "User Enquiry Data" */
	         },
	       ],
	    "columnDefs": [
		    { "width": "15%",  "targets": 0 },
	    	{ "width": "10%",  "targets": 2 },
	    	{ "width": "5%",  "targets": 3 },
    	    { "width": "8%",  "targets": 4 }
    	  ],
	    "columns": [{
	        "data": null,
	        sortable: true,
	        render: function (data, type, row) {
	          var countryname = data.countryname;

	          return countryname;

	        }
	      },	      
	      {
	        "data": null,
	        sortable: true,
	        render: function (data, type, row) {
	          var specification = data.specification;

	          return specification;

	        }
	      },	     
	      {
	        "data": null,
	        sortable: true,
	        render: function (data, type, row) {
	          var updateddate = data.updateddate;
	          if(updateddate == null){
	        	  updateddate = "";
	          }
	          return updateddate;

	        }
	      },
	      {
	        "data": null,
	        className: 'text-center',
	        sortable: true,
	        render: function (data, type, row) {
	          var status = data.status;

	          return status;

	        }
	      },
	      {

	        "data": null,
	        className: 'text-center',
	        sortable: true,
	        render: function (data, type, row) {
	          var id = data.id;
	          var status = data.status;
	          
	          var action = '<button type="button" title="View" class="view_btn  actbtn" onclick="getCountrySpecificationDetailsById('+id+');"><i class="fas fa-eye"></i></button>'+
	                '<button type="button" title="Edit" class="update_btn actbtn" onclick="getCountrySpecificationDetailsForUpdateById('+id+');"><i class="fas fa-pencil-alt"></i></button>'+
	                '<button type="button" title="Delete" class="del_btn1 actbtn" onclick="deleteCountrySpecificationById('+id+');"><i class="fas fa-trash"></i></button>';

	          return action;

	        }
	      }

	    ]

	  });
}

function addCountrySpecification(){
	  $('#loader').show();
	  	
	  var userId = userInfo.id;
	  var countryname = $('#countryAddId option:selected').text();	  
	  var countrycode = $('#countryAddId').val();
      var specification = $('#specificationId').val();
	  var status = $('#statusAddId').val();

	  var obj = {'userid':userId,'countryname':countryname,'countrycode':countrycode,'specification':specification,'status':status};
	 
	  $.post({
	    url: server_url + 'admin/addCountrySpecification',
	    contentType: "application/json; charset=utf-8",
	    headers: authHeader,
	    processData: false,
	    data: JSON.stringify(obj),
	    success: function (response) {
	      $('#loader').hide();
	      console.log(response)

	      if (response.respCode == 1) {     	        
	        successBlock("#success_block", response.respData.msg);  
	        getCountrySpecificationList();
	        $('#add_specification').modal('hide'); 	        
	      } else if (response.respCode == 0) {
	        errorBlock("#error_block", response.respData.msg);    	       
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

function getAllCountryList(){
    
  	$.ajax({	  			
  		     type: 'GET', 
               url : server_url+'utility/getAllCountry',	     
               enctype: 'multipart/form-data',
               headers: authHeader,
               processData: false,
               contentType: false,
               data : null,	      
               success : function(response) {

            	try{       				
       			    var ddl = document.getElementById("countryAddId");
                    var option = document.createElement("OPTION");
                       
       				if(response != null && response.respData.length !=0){
       			        $('#countryAddId').empty();	             
                        option.innerHTML = 'Choose Country';
       				    option.value = '0';
       				    ddl.options.add(option);	
       										
       					for( i=0 ; i< response.respData.length ; i++){         					
       						   var countryname = response.respData[i].countryname;
    	  	            	   var countrycode = response.respData[i].countrycode;    	  	            	   
       					       var option = document.createElement("OPTION");
       					       option.innerHTML = countryname;
       					       option.value = countrycode;
       					       ddl.options.add(option);			
       					}        										  		   
       				}else{
       					$('#countryAddId').empty();
       					option.innerHTML = 'No Country available';
       				    option.value = '0';
       				    ddl.options.add(option);
       				}      				 
       			}catch(err){				
       				errorBlock("#error_block",response.respData);
       			}	                	 	        	  	             	      
               },
               error: function (error) {           	
  	               console.log(error)
                   if( error.responseJSON != undefined){
   	                   errorBlock("#error_block",error.responseJSON.respData);	   	                  
                   }else{
   	                   errorBlock("#error_block","Server Error! Please contact administrator");
                   }         
               }
      })
  
}

function deleteCountrySpecificationById(id){
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
		        url: server_url + 'admin/deleteCountrySpecification/'+id+"/"+userInfo.id,
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
		            getCountrySpecificationList();

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

function getCountrySpecificationDetailsById(id) {
	  $('#loader').show();
	  var userId = userInfo.id;
	  $.ajax({
	    type: 'GET',
	    url: server_url + 'admin/getCountySpecDetailsById',
	    enctype: 'multipart/form-data',
	    headers: authHeader,
	    processData: false,
	    contentType: false,
	    data: "id=" + id,

	    success: function (response) {

	      if (response.respCode == 1) {
	        $('#loader').hide();	       
	        
	        $('#viewCountrynameId').text(response.respData.countryname);	        
	        $("#viewCSStatusId").text(response.respData.status);
	        $("#viewSpecificationId").text(response.respData.specification);
	        
	        $('#view_specification').modal('show');
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

function getCountrySpecificationDetailsForUpdateById(id) {
	  $('#loader').show();
	  var userId = userInfo.id;
	  $.ajax({
	    type: 'GET',
	    url: server_url + 'admin/getCountySpecDetailsById',
	    enctype: 'multipart/form-data',
	    headers: authHeader,
	    processData: false,
	    contentType: false,
	    data: "id=" + id,

	    success: function (response) {

	      if (response.respCode == 1) {
	        $('#loader').hide();	       
	        $("#csUpdateId").val(response.respData.id);
	        $('#editCountrynameId').text(response.respData.countryname);	        
	        $("#editCSStatusId").val(response.respData.status);
	        $("#editSpecificationId").val(response.respData.specification);
	        
	        $('#edit_specification').modal('show');
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

function updateCountrySpecification(){
	 $('#loader').show();
	var id = $('#csUpdateId').val();
	var userId = userInfo.id;
	var status = $('#editCSStatusId').val();
	var specification = $('#editSpecificationId').val();
	
	var obj = {'id':id,'userid':userId,'specification':specification,'status':status};
	
	$.ajax({
		type: 'PUT',
  	    url: server_url + 'admin/updateCountrySpecification',
  	    contentType: "application/json; charset=utf-8",
  	    headers: authHeader,
  	    processData: false,
  	    data: JSON.stringify(obj),
  	    success: function (response) {
  	      $('#loader').hide();
  	      console.log(response)

  	      if (response.respCode == 1) {     	        
  	        successBlock("#success_block", response.respData.msg);  
  	        getCountrySpecificationList();
  	        $('#edit_specification').modal('hide'); 	        
  	      } else if (response.respCode == 0) {
  	        errorBlock("#error_block", response.respData.msg);    	       
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
            <h2 class="book_cargo_hd mt-4">Country Specific Requirement</h2>
            <p class="upload_subline mb-4">List of countries specific information</p>
          </div>
          <div class="col-md-2 text-right">
            <button type="button" class="login_btn2" data-toggle="modal" data-target="#add_specification">Add Details</button>
          </div>
        </div>
        <div class="clearfix"></div>
        <!-- <div class="table-responsive"> --><!-- to remove unwanted scroll -->
        <div class="">
          <table class="table table-bordered table_fontsize" id="countryTable" style="width:100%">
            <thead class="thead-light">
              <tr>              
                <th>Country</th>
                <th>Specific Requirements</th>
                <th>Updated Date</th>
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

<!-- Add Specification -->
<div class="modal fade" id="add_specification" tabindex="-1" role="dialog" aria-labelledby="exampleModalLabel" aria-hidden="true">
  <div class="modal-dialog modal-lg" role="document">
    <div class="modal-content">      
        <div class="modal-header modal-header-spl">
          <h5 class="modal-title" id="exampleModalLabel">Add Country specific requirements</h5>
          <button type="button" class="close modal_close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
        </div>
        <div class="modal-body">
          <div class="row mt-2">
            <div class="col-md-2">
              <label for="" class="form-label-new">Select Country</label>
            </div>
            <div class="col-md-4 ">
              <select class="form-control font14" name="country" id="countryAddId">              
              </select>
            </div>
            <div class="col-md-2">
              <label for="" class="form-label-new">Status</label>
            </div>
            <div class="col-md-4 ">
              <select class="form-control font14" name="status" id="statusAddId" required>
                <option value="Active">Active</option>
                <option value="Inactive">Inactive</option>
              </select>
            </div>
          </div>
          <div class="row mt-2">
            <div class="col-md-2">
              <label for="" class="form-label-new">Content</label>
            </div>
            <div class="col-md-10 ">
              <textarea  class="form-control font14" name="content" id="specificationId" autocomplete="off" required></textarea>
            </div>
          </div>
        </div>
        <div class="modal-footer">
          <button type="button" class="clear_btn" data-dismiss="modal">Close</button>
          <button type="submit" class="advt_btn" onclick="addCountrySpecification();">Submit</button>
        </div>      
    </div>
  </div>
</div>
<!-- Add Specification --> 

<!-- Edit Specification -->
<div class="modal fade" id="edit_specification" tabindex="-1" role="dialog" aria-labelledby="exampleModalLabel" aria-hidden="true">
  <div class="modal-dialog modal-lg" role="document">
    <div class="modal-content">
        <div class="modal-header modal-header-spl">
          <h5 class="modal-title" id="exampleModalLabel">Update Details</h5>
          <button type="button" class="close modal_close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
        </div>
        <div class="modal-body">
        <input type="hidden" id="csUpdateId" name="csUpdateId" value="">
          <div class="row mt-2">
            <div class="col-md-2">
              <label for="" class="form-label-new">Country Name</label>
            </div>
            <div class="col-md-4 ">
              <p class="para" id="editCountrynameId"></p>
            </div>
            <div class="col-md-2">
              <label for="" class="form-label-new">Status</label>
            </div>
            <div class="col-md-4 ">
              <select class="form-control font14" name="status" id="editCSStatusId" required>
                <option value="Active">Active</option>
                <option value="Inactive">Inactive</option>
              </select>
            </div>
          </div>
          <div class="row mt-2">
            <div class="col-md-2">
              <label for="" class="form-label-new">Content</label>
            </div>
            <div class="col-md-10 ">
              <textarea  class="form-control font14" name="content" id="editSpecificationId" autocomplete="off" required></textarea>
            </div>
          </div>
        </div>
        <div class="modal-footer">
          <button type="button" class="clear_btn" data-dismiss="modal">Close</button>
          <button type="submit" class="advt_btn"  onclick="updateCountrySpecification();">Submit</button>
        </div>
    </div>
  </div>
</div>
<!-- Edit Specification -->

<!-- View Specification -->
<div class="modal fade" id="view_specification" tabindex="-1" role="dialog" aria-labelledby="exampleModalLabel" aria-hidden="true">
  <div class="modal-dialog modal-lg" role="document">
    <div class="modal-content">
      <form method="post" id="upload-ads">
        <div class="modal-header modal-header-spl">
          <h5 class="modal-title" id="exampleModalLabel">View Details</h5>
          <button type="button" class="close modal_close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
        </div>
        <div class="modal-body">
          <div class="row mt-2">
            <div class="col-md-2">
              <label for="" class="form-label-new">Country Name</label>
            </div>
            <div class="col-md-4 ">
                <p class="para" id="viewCountrynameId"></p>
            </div>
            <div class="col-md-2">
              <label for="" class="form-label-new">Status</label>
            </div>
            <div class="col-md-4 ">
                <p class="para" id="viewCSStatusId"></p>
              </select>
            </div>
          </div>
          <div class="row mt-2">
            <div class="col-md-2">
              <label for="" class="form-label-new">Content</label>
            </div>
            <div class="col-md-10 ">
              <p class="para" id="viewSpecificationId"></p>
            </div>
          </div>
        </div>
        <div class="modal-footer">
          <button type="button" class="clear_btn" data-dismiss="modal">Close</button>
        </div>
      </form>
    </div>
  </div>
</div>
<!-- Edit Specification -->  
</body>
</html>