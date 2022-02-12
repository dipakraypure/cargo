<%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="ISO-8859-1">
<title>Admin Home</title>
<script type="text/javascript">
$(function () {
  activeNavigationClass();
  var userId = userInfo.id;
  getUserProfileDetailsById(userId);

  //reset password form 
  $('#user-profile-reset-password-form').submit(function (e) {
    e.preventDefault();

    $('#loader').show();
    var formData = new FormData();
    formData.append("userid", userInfo.id);
    formData.append("password", $("#currPasswordInputId").val());
    formData.append("newpassword", $("#newPasswordInputId").val());

    $.ajax({
	  type: 'PUT',
      url: server_url + 'admin/updateMyProfileResetPass',
      enctype: 'multipart/form-data',
      headers: authHeader,
      processData: false,
      contentType: false,
      data: formData,

      success: function (response) {
        console.log(response)
        if (response.respCode == 1) {
          successBlock("#success_block", response.respData.msg);
          $("#currPasswordInputId").val('');
          $("#newPasswordInputId").val('');
          $("#confirmPasswordInputId").val('');
          $('#loader').hide();
        } else {
          errorBlock("#error_block", response.respData)
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

  });

});

function getUserProfileDetailsById(userId) {
  $('#loader').show();
  $.ajax({

    type: 'GET',
    url: server_url + 'user/getUserProfileDetailsById/' + userId,
    enctype: 'multipart/form-data',
    headers: authHeader,
    processData: false,
    contentType: false,

    data: null,

    success: function (response) {

      console.log(response)

      if (response.respCode == 1) {
        $("#emailInputId").val(response.respData.email);
        $("#roleInputId").val(response.respData.role);
        $("#userStatusInputId").val(response.respData.status);

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

$(document).ready(function () {
  $(".pr-password").passwordRequirements({
  });
});

</script>
</head>
<body>
<div class="container-fluid">
  <div class="bg_white_main mb-4 mt-4">
    <div class="spl_padd">
      <div class="col-md-12 padd0">
        <h2 class="book_cargo_hd">My Profile</h2>
      </div>
      <div class="row">
        <div class="col-md-6 col-xs-12">
          <div class="bg_white3 minht350">
            <form method="post" id="user-profile-details-form" >
              <h3 class="book_cargo_hd2">General Details</h3>
              <div class="row mt-4">
                <div class="col-md-8">
                  <div class="row">
                    <div class="col-md-4">
                      <label for="" class="form-label-new">Email</label>
                    </div>
                    <div class="col-md-8 padd0">
                      <input type="input" class="form-control font14" name="email" id='emailInputId'  readonly>
                    </div>
                  </div>
                </div>                
              </div>              
              <div class="row mt-4">
                <div class="col-md-8">
                  <div class="row">
                    <div class="col-md-4">
                      <label for="" class="form-label-new">Role</label>
                    </div>
                    <div class="col-md-8 padd0">
                      <input type="input" class="form-control font14" name="role" id='roleInputId'  readonly>
                    </div>
                  </div>
                </div>
              </div>
              <div class="row mt-4">
                <div class="col-md-8">
                  <div class="row">
                    <div class="col-md-4">
                      <label for="" class="form-label-new">Status</label>
                    </div>
                    <div class="col-md-8 padd0">
                      <input type="input" class="form-control font14" name="userstatus" id='userStatusInputId'  readonly>
                    </div>
                  </div>
                </div>
              </div>
              
            </form>
          </div>
        </div>
        <div class="col-md-6 col-xs-12">
          <div class="bg_white3 minht350">
            <form method="post" id="user-profile-reset-password-form" >
              <h3 class="book_cargo_hd2">Password Details</h3>
              <div class="row mt-4">
                <div class="col-md-8">
                  <div class="row">
                    <div class="col-md-4">
                      <label for="" class="form-label-new">Current Password</label>
                    </div>
                    <div class="col-md-8 padd0">
                      <input type="password" class="form-control font14 " name="" id='currPasswordInputId' autocomplete="off" required>
                    </div>
                  </div>
                </div>
              </div>
              <div class="row mt-4">
                <div class="col-md-8">
                  <div class="row">
                    <div class="col-md-4">
                      <label for="" class="form-label-new">New Password</label>
                    </div>
                    <div class="col-md-8 padd0">
                      <input type="password" class="form-control font14 pr-password" name="" id='newPasswordInputId' autocomplete="off" required>
                    </div>
                  </div>
                </div>
              </div>
              <div class="row mt-4">
                <div class="col-md-8">
                  <div class="row">
                    <div class="col-md-4">
                      <label for="" class="form-label-new">Confirm Password</label>
                    </div>
                    <div class="col-md-8 padd0">
                      <input type="password" class="form-control font14" name="" id='confirmPasswordInputId' oninput="checkRePass(this)" autocomplete="off" required>
                      <script language='javascript' type='text/javascript'>
                                       function checkRePass(input) {
                                          if (input.value != document.getElementById('newPasswordInputId').value) {
                                                input.setCustomValidity('Password Must be Matching.');
                                          } else {
                                                // input is valid -- reset the error message
                                                input.setCustomValidity('');
                                          }
                                        }
                                    </script> 
                    </div>
                  </div>
                </div>
              </div>
              <div class="row mt-4">
                <div class="col-md-8">
                  <div class="row">
                    <div class="col-md-6 offset-md-4 padd0">
                      <button type="submit" value="Submit" class="comp_sub_btn" style="display: block;"><span>Update</span></button>
                    </div>
                  </div>
                </div>
              </div>
            </form>
          </div>
        </div>
       
      </div>
    </div>
  </div>
</div>

</body>
</html>