<%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="ISO-8859-1">
<title>Feadback</title>
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
.switch {
    position: relative;
    display: inline-block;
    width: 50px;
    height: 23px;
}
.switch input {
    opacity: 0;
    width: 0;
    height: 0;
}
.slider {
    position: absolute;
    cursor: pointer;
    top: 0;
    left: 0;
    right: 0;
    bottom: 0;
    background-color: #ccc;
    -webkit-transition: .4s;
    transition: .4s;
}
.slider:before {
    position: absolute;
    content: "";
    height: 15px;
    width: 15px;
    left: 4px;
    bottom: 4px;
    background-color: white;
    -webkit-transition: .4s;
    transition: .4s;
}
input:checked + .slider {
    background-color: #161a47;
}
input:focus + .slider {
    box-shadow: 0 0 1px #2196F3;
}
input:checked + .slider:before {
    -webkit-transform: translateX(26px);
    -ms-transform: translateX(26px);
    transform: translateX(26px);
}
/* Rounded sliders */
.slider.round {
    border-radius: 34px;
}
.slider.round:before {
    border-radius: 50%;
}
</style>
<script>
$(document).ready(function () {
  activeNavigationClass();
  getFeedbackList();

});

function getFeedbackList() {
  $('#loader').show();
  var tableId = "feedbackTable";

  $.ajax({

    type: 'GET',
    url: server_url + 'admin/getFeedbackList',
    enctype: 'multipart/form-data',
    headers: authHeader,
    processData: false,
    contentType: false,
    data: null,
    success: function (response) {
      console.log(response)
      if (response.respCode == 1) {
        $('#loader').hide();
        loadFeedbackListTable(response.respData, tableId);
      } else {
        errorBlock("#error_block", response.respData)
        loadFeedbackListTable(null, tableId);
      }
      $('#loader').hide();
    },
    error: function (error) {
      console.log(error)
      if (error.responseJSON != undefined) {
        errorBlock("#error_block", error.responseJSON.respData);
        loadFeedbackListTable(null, tableId);
      } else {
        errorBlock("#error_block", "Server Error! Please contact administrator");
      }
      $('#loader').hide();
    }
  })
}

function loadFeedbackListTable(data, tableId) {

  $('#' + tableId).dataTable().fnClearTable();

  var oTable = $('#' + tableId).DataTable({
    /* 'responsive': true,  */
    "destroy": true,
    "data": data,
    "dom": 'lBfrtip',
    "buttons": [{
      extend: 'excel',
      /* title: "User Enquiry Data", */
      text: '<i class="fa fa-file-excel"></i>',
      titleAttr: 'Download Excel',
      exportOptions: {
        columns: [0, 1, 2, 3, 4, 5, 6, 7, 8]
      }
      /* messageTop: "User Enquiry Data" */
    }, ],
    "columnDefs": [
	    { "width": "5%",  "targets": 0 },
	    { "width": "10%",  "targets": 2 },
	    { "width": "10%",  "targets": 3 },
    	{ "width": "8%",  "targets": 4 },
    	{ "width": "20%",  "targets": 6 },
    	{ "width": "5%",  "targets": 7 },
	    { "width": "5%",  "targets": 8 },
	    { "width": "10%",  "targets": 9 }
	  ],
    "columns": [{
        "data": null,
        sortable: true,
        render: function (data, type, row) {
          var createddate = data.createddate;

          return createddate;

        }
      },
      {
        "data": null,
        sortable: true,
        render: function (data, type, row) {
          var name = data.name;

          return name;

        }
      },
      {
          "data": null,
          sortable: true,
          render: function (data, type, row) {
            var companyname = data.companyname;

            return companyname;

          }
        },
      {
        "data": null,
        sortable: true,
        render: function (data, type, row) {
          var email = data.email;

          return email;

        }
      },
      {
        "data": null,
        sortable: true,
        render: function (data, type, row) {
          var mobile = data.mobile;

          return mobile;

        }
      },
      {
          "data": null,
          sortable: true,
          render: function (data, type, row) {
            var location = data.location;

            return location;

          }
        },
      {
        "data": null,
        sortable: true,
        render: function (data, type, row) {
          var message = data.message;

          return message;

        }
      },
      {
        "data": null,
        sortable: true,
        render: function (data, type, row) {
          var replydate = data.replydate;
          if(replydate == null){
        	  replydate = "";
          }
          return replydate;

        }
      },
      {
        "data": null,
        sortable: true,
        render: function (data, type, row) {
          var status = data.status;

          if(status == "Closed"){
             status = "Closed";
          }
          
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

          var replyDisClass = ''; 
          if(status == 'Closed'){
        	  replyDisClass = 'disabled';
          }
          
          var action = '<button type="button" title="View" class="view_btn  actbtn" onclick="getFeedbackDetailsById(' + id + ');"><i class="fas fa-eye"></i></button>'
            + '<button type="button" title="Reply" class="reply_btn actbtn '+replyDisClass+'" onclick="getFeedbackDetailsForReplyById('+id+');" '+replyDisClass+'><i class="fa fa-reply"></i></button>'
            + '<button type="button" title="Delete" class="del_btn1 actbtn" onclick="deleteFeedbackById('+id+');"><i class="fas fa-trash"></i></button>';

          return action;

        }
      }

    ]

  });
}

function getFeedbackDetailsById(id) {
  $('#loader').show();
  var userId = userInfo.id;
  $.ajax({
    type: 'GET',
    url: server_url + 'admin/getFeedbackDetailsById',
    enctype: 'multipart/form-data',
    headers: authHeader,
    processData: false,
    contentType: false,
    data: "id=" + id,

    success: function (response) {

      if (response.respCode == 1) {
        $('#loader').hide();
        $('#fdId').val(response.respData.id);
        $('#fdName').text(response.respData.name);
        $('#fdEmail').text(response.respData.email);
        $('#fdMobile').text(response.respData.mobile);
        $('#fdMessage').text(response.respData.message);
        $('#fdActionMessage').text(response.respData.actionmessage);
        $("#fdStatus").val(response.respData.status);

        $('#view_feedback_details').modal('show');
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

function getFeedbackDetailsForReplyById(id) {
	  $('#loader').show();
	  var userId = userInfo.id;
	  $.ajax({
	    type: 'GET',
	    url: server_url + 'admin/getFeedbackDetailsById',
	    enctype: 'multipart/form-data',
	    headers: authHeader,
	    processData: false,
	    contentType: false,
	    data: "id=" + id,

	    success: function (response) {
		    
	      if (response.respCode == 1) {
	        $('#loader').hide();
	        $('#fdReplyId').val(response.respData.id);
	        $('#fdReplyName').text(response.respData.name);
	        $('#fdReplyEmail').text(response.respData.email);
	        $('#fdReplyMobile').text(response.respData.mobile);
	        $('#fdReplyMessage').text(response.respData.message);
	       
	        $('#reply_feedback_details').modal('show');
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

function deleteFeedbackById(id){
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
		        url: server_url + 'admin/deleteFeedback/'+id+"/"+userInfo.id,
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
		            getFeedbackList();

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

function updateFeedbackStatus(){
	  $('#loader').show();	
	  var id = $('#fdId').val();
	  var userId = userInfo.id;
	  var status = $('#fdStatus').val();
	  var obj = {'id':id,'userid':userId,'status':status};
  	 
	  $.ajax({
		type: 'PUT',
  	    url: server_url + 'admin/updateFeedbackStatus',
  	    contentType: "application/json; charset=utf-8",
  	    headers: authHeader,
  	    processData: false,
  	    data: JSON.stringify(obj),
  	    success: function (response) {
  	      $('#loader').hide();
  	      console.log(response)

  	      if (response.respCode == 1) {     	        
  	        successBlock("#success_block", response.respData.msg);  
  	        getFeedbackList();
  	        $('#view_feedback_details').modal('hide'); 	        
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

function replyFeedbackWithActionTaken(){
	  $('#loader').show();	
	  var id = $('#fdReplyId').val();
	  var userId = userInfo.id;
	  var actionMessage = $('#fdReplyActionTaken').val();
	  var obj = {'id':id,'userid':userId,'actionmessage':actionMessage};
  	 
  	  $.post({
  	    url: server_url + 'admin/replyToFeedback',
  	    contentType: "application/json; charset=utf-8",
  	    headers: authHeader,
  	    processData: false,
  	    data: JSON.stringify(obj),
  	    success: function (response) {
  	      $('#loader').hide();
  	      console.log(response)

  	      if (response.respCode == 1) {     	        
  	        successBlock("#success_block", response.respData.msg);  
  	        getFeedbackList();
  	        $('#reply_feedback_details').modal('hide'); 	        
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
    <div class="spl_padd">
      <div class="col-md-12 padd0">
        <h2 class="book_cargo_hd">User Feedback</h2>
      </div>
      <div class="row">
        <div class="col-md-12 col-xs-12">
          <p class="upload_subline">Feedbacks / Suggestions received from user.</p>
          <div class="">
            <!-- <div class="table-responsive"> --><!-- to remove unwanted scroll -->
        <div class="">
              <table class="table table-bordered" id="feedbackTable">
                <thead class="thead-light">
                  <tr>
                    <th>Created Date</th>                    
                    <th>Name</th>
                    <th>Company Name</th>
                    <th>Email Id</th>
                    <th>Mobile No.</th>
                    <th>Location</th>
                    <th>Message</th>
                    <th>Reply Date</th>
                    <th>Status</th>
                    <th>Actions</th>
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

<!-- View Feedback Modal -->
<div class="modal fade" id="view_feedback_details" tabindex="-1" role="dialog" aria-labelledby="exampleModalLabel" aria-hidden="true">
  <div class="modal-dialog modal-dialog-centered modal-lg" role="document">
    <div class="modal-content">
      <div class="modal-header modal_hd_sec">
        <p class="h5 modal-title modal_hd" id="ModalTitle">View Feedback </p>
        <button type="button" class="close modal_close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
      </div>
      <div class="modal-body">
        <input type="hidden" id="fdId" name="fdId" value="">                
        <div class="row">
          <div class="col-lg-6 col-sm-12 mt-2">
            <div class="row">
              <div class="col-md-3">
                <label for="" class="form-label-new">Name:</label>
              </div>
              <div class="col-md-7">
                <p class="para" id="fdName"></p>
              </div>
            </div>
          </div>
          <div class="col-lg-6 col-sm-12 mt-2">
            <div class="row">
              <div class="col-md-3">
                <label for="" class="form-label-new">Email Id:</label>
              </div>
              <div class="col-md-7">
                <p class="para" id="fdEmail"></p>
              </div>
            </div>
          </div>
          <div class="col-lg-6 col-sm-12 mt-2">
            <div class="row">
              <div class="col-md-3">
                <label for="" class="form-label-new">Mobile No.:</label>
              </div>
              <div class="col-md-7">
                <p class="para" id="fdMobile"></p>
              </div>
            </div>
          </div>
          <div class="col-lg-6 col-sm-12 mt-2">
            <div class="row">
              <div class="col-md-3">
                <label for="" class="form-label-new">Status:</label>
              </div>
              <div class="col-md-4">
                <select class="form-control font14" name="status" id="fdStatus" required>
                  <option value="Open">Open</option>
                  <option value="Closed">Closed</option>
                </select>
              </div>
            </div>
          </div>
          <div class="col-lg-12 col-sm-12 mt-2">
            <div class="row">
              <div class="col-md-1 mr-5">
                <label for="" class="form-label-new">Feedback:</label>
              </div>
              <div class="col-md-10">
                <p class="para" id="fdMessage"  style="margin-left: -8px;"></p>
              </div>
            </div>
          </div>
          <div class="col-lg-6 col-sm-12 mt-2">
            <div class="row">
              <div class="col-md-3">
                <label for="" class="form-label-new">Action Taken:</label>
              </div>
              <div class="col-md-7">
                <p class="para" id="fdActionMessage"></p>
              </div>
            </div>
          </div>
        </div>
      </div>
      <div class="modal-footer">
        <button type="button" class="clear_btn" data-dismiss="modal">Close</button>
        <button type="submit" class="advt_btn" onclick="updateFeedbackStatus();">Save</button>
      </div>
    </div>
  </div>
</div>
<!-- View Feedback Modal --> 

<!-- Reply Feedback Modal -->
<div class="modal fade" id="reply_feedback_details" tabindex="-1" role="dialog" aria-labelledby="exampleModalLabel" aria-hidden="true">
  <div class="modal-dialog modal-dialog-centered modal-lg" role="document">
    <div class="modal-content">
      <div class="modal-header modal_hd_sec">
        <p class="h5 modal-title modal_hd" id="">Reply to Feedback</p>
        <button type="button" class="close modal_close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
      </div>
      <div class="modal-body">
      <input type="hidden" id="fdReplyId" name="fdReplyId" value=""> 
        <div class="row">
          <div class="col-lg-4 col-sm-12 mt-2">
            <div class="row">
              <div class="col-md-3">
                <label for="" class="form-label-new">Name:</label>
              </div>
              <div class="col-md-7">
                <p class="para" id="fdReplyName"></p>
              </div>
            </div>
          </div>
          <div class="col-lg-4 col-sm-12 mt-2">
            <div class="row">
              <div class="col-md-3">
                <label for="" class="form-label-new">Email Id:</label>
              </div>
              <div class="col-md-7">
                <p class="para" id="fdReplyEmail"></p>
              </div>
            </div>
          </div>
          <div class="col-lg-4 col-sm-12 mt-2">
            <div class="row">
              <div class="col-md-4">
                <label for="" class="form-label-new">Mobile No.:</label>
              </div>
              <div class="col-md-7">
                <p class="para" id="fdReplyMobile"></p>
              </div>
            </div>
          </div>
          <div class="col-lg-12 col-sm-12 mt-2">
            <div class="row">
              <div class="col-md-1">
                <label for="" class="form-label-new">Feedback:</label>
              </div>
              <div class="col-md-11">
                <p class="para" id="fdReplyMessage"></p>
              </div>
            </div>
          </div>
          <div class="col-lg-12 col-sm-12 mt-2">
            <div class="row">
              <div class="col-md-1">
                <label for="" class="form-label-new">Action Taken:</label>
              </div>
              <div class="col-md-11">
                <textarea class="form-control font14" maxlength="300" placeholder="300 characters only" name="" id="fdReplyActionTaken"></textarea>
              </div>
            </div>
          </div>
        </div>
      </div>
      <div class="modal-footer">
        <button type="button" class="clear_btn" data-dismiss="modal">Close</button>
        <button type="button" class="advt_btn" onclick="replyFeedbackWithActionTaken();">Send</button>
      </div>
    </div>
  </div>
</div>
<!-- Reply Feedback Modal -->
<script>
$(document).ready(function(){
	  $('#menu1').click(function(){
	    $(this).addClass("activeM");
	});
	});
</script>
</body>
</html>