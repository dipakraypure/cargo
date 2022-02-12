<%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="ISO-8859-1">
<title>Insert title here</title>
<script type="text/javascript">
$(function () {
  activeNavigationClass();
  var userId = userInfo.id;
  getUserProfileDetailsById(userId);

  /*  Submit form using Ajax */
  $('#user-profile-details-form').submit(function (e) {
    e.preventDefault();
    $('#loader').show();
    var formData = new FormData();
    formData.append("userid", userInfo.id);
    formData.append("mobilenumber", $("#mobileNumInputId").val());

    $.ajax({
	  type: 'PUT',
      url: server_url + 'user/updateUserMyProfile',
      enctype: 'multipart/form-data',
      headers: authHeader,
      processData: false,
      contentType: false,
      data: formData,

      success: function (response) {
        console.log(response)
        if (response.respCode == 1) {
          successBlock("#success_block", response.respData.msg);
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
      url: server_url + 'user/updateMyProfileResetPass',
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

  //forwarder-verify-mobile-otp-form
  $('#forwarder-verify-mobile-otp-form').submit(function (e) {
    e.preventDefault();
    $('#loader').show();
    var formData = new FormData();
    formData.append("userid", userInfo.id);
    formData.append("mobileverifyotp", $("#mobileOtpId").val());

    $.post({
      url: server_url + 'user/verifyMobileOtp',

      enctype: 'multipart/form-data',
      headers: authHeader,
      processData: false,
      contentType: false,
      data: formData,

      success: function (response) {
        console.log(response)
        if (response.respCode == 1) {
          successBlock("#success_block", response.respData.msg);
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

        var mobNum = response.respData.mobilenumber;

        var input = document.querySelector('#mobileNumInputId');
        var iti = window.intlTelInputGlobals.getInstance(input);
        var cCode = '';
        var mob = mobNum.substring(1);
        for (var i = 0; i < iti.countries.length; i++) {
          var dCode = iti.countries[i].dialCode;
          if (mob.startsWith(dCode)) {
            cCode = iti.countries[i].iso2;
            break;
          }
        }
        iti.setCountry(cCode);

        $("#emailInputId").val(response.respData.email);
        $("#mobileNumInputId").val(response.respData.mobilenumber);

        $("#roleInputId").val(response.respData.role);
        $("#userStatusInputId").val(response.respData.status);

        var isemailverify = response.respData.isemailverify;

        if (isemailverify == "Y") {
          $("#veriSpanIdEmail").show();
          $("#emailVerifyDateId").text(response.respData.emailverifydate);
        } else {
          $("#verifyEmailOtpId").show();
          $("#notVeriSpanIdEmail").show();
        }

        var ismobileverify = response.respData.ismobileverify;

        if (ismobileverify == "Y") {
          $("#veriSpanIdMobile").show();
          $("#mobileVerifyDateId").text(response.respData.mobileverifydate);
        } else {
          $("#verifyMobileOtpId").show();
          $("#notVeriSpanIdMobile").show();
          $("#mobileVerifyDateId").hide();
        }

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

function sendVerifyMobileOtp() {
  $('#loader').show();
  var formData = new FormData();
  formData.append("userid", userInfo.id);
  formData.append("email", $("#emailInputId").val());
  formData.append("mobilenumber", $("#mobileNumInputId").val());

  $.post({
    url: server_url + 'user/sendVerifyMobileOtp',
    enctype: 'multipart/form-data',
    headers: authHeader,
    processData: false,
    contentType: false,
    data: formData,

    success: function (response) {
      if (response.respCode == 1) {
        successBlock("#success_block", response.respData.msg);
        $('#loader').hide();
        $('#otp_modal').modal('show');
      } else {
        errorBlock("#error_block", response.respData)
      }
      $('#loader').hide();
    },
    error: function (error) {
      if (error.responseJSON != undefined) {
        errorBlock("#error_block", error.responseJSON.respData);
      } else {
        errorBlock("#error_block", "Server Error! Please contact administrator");
      }
      $('#loader').hide();
    }
  })

}

function resentVerifyMobileOtp() {
  $('#loader').show();
  var formData = new FormData();
  formData.append("userid", userInfo.id);
  formData.append("email", $("#emailInputId").val());
  formData.append("mobilenumber", $("#mobileNumInputId").val());

  $.post({
    url: server_url + 'user/resendVerifyMobileOtp',
    enctype: 'multipart/form-data',
    headers: authHeader,
    processData: false,
    contentType: false,
    data: formData,

    success: function (response) {
      if (response.respCode == 1) {
        successBlock("#success_block", response.respData.msg);
      } else {
        errorBlock("#error_block", response.respData)
      }
      $('#loader').hide();
    },
    error: function (error) {
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

  var input = document.querySelector("#mobileNumInputId");
  window.intlTelInput(input, {
    nationalMode: false,
    utilsScript: "static/js/utils.js",
  });

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
                <div class="col-md-4"> <span class="verified mt-1" id="veriSpanIdEmail" style="display: none;"><i class="fa fa-check" aria-hidden="true"></i> Verified</span>
                  <label class="form-label-new marleft" id="emailVerifyDateId"></label>
                  <span class="notverified mt-1" id="notVeriSpanIdEmail" style="display: none;"><i class="fa fa-times" aria-hidden="true"></i> Not Verified</span> </div>
              </div>
              <div class="row mt-4">
                <div class="col-md-8">
                  <div class="row">
                    <div class="col-md-4">
                      <label for="" class="form-label-new">Mobile Number</label>
                    </div>
                    <div class="col-md-8 padd0">
                      <input type="input" class="form-control font14" name="mobilenumber"  id='mobileNumInputId' onkeypress="return numberKey(event)" required>
                    </div>
                  </div>
                </div>
                <div class="col-md-4"> <span class="verified mt-1" id="veriSpanIdMobile" style="display: none;"><i class="fa fa-check" aria-hidden="true"></i> Verified</span>
                  <label class="form-label-new marleft" id="mobileVerifyDateId"></label>
                  <span class="notverified mt-1" id="notVeriSpanIdMobile" style="display: none;"><i class="fa fa-times" aria-hidden="true"></i> Not Verified</span><a href="#" class="form-label-new marleft"  style="display: none;" id="verifyMobileOtpId" onclick="sendVerifyMobileOtp();">Verify Mobile</a> </div>
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
                      <input type="password" class="form-control font14" name="" id='currPasswordInputId' required>
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
                      <input type="password" class="form-control font14 pr-password" name="" id='newPasswordInputId' required>
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
                      <input type="password" class="form-control font14" name="" id='confirmPasswordInputId' oninput="checkRePass(this)" required>
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
        <div class="col-md-12 col-xs-12">
          <div class="bg_white3">
              <h3 class="book_cargo_hd2">Account Action</h3>
              <div class="row mt-4">
                <div class="col-md-12">
                  <div class="row">
                    <div class="col-md-10 ">
                      <label for="" class="form-label-new">Once you deactivate your account, you will not be able to use the application anymore. You will have to do a fresh registration if you want to access again. Do you want to proceed? </label>
                    </div>
                    <div class="col-md-1 pul-right">
                      <button type="button" value="Submit" class="comp_sub_btn" style="display: block;" onClick="deactivateAccount();"><span>Deactivate</span></button>
                    </div>
                  </div>
                </div>
              </div>          
          </div>
        </div>
      </div>
    </div>
  </div>
</div>
<div id="otp_modal" class="modal fade" tabindex="-1" role="dialog" aria-labelledby="myLargeModalLabel" aria-hidden="true">
  <div class="modal-dialog modal-dialog-centered">
    <div class="modal-content">
      <div class="modal-header modal-header-spl">
        <h5 class="modal-title">OTP Verification</h5>
        <button type="button" class="close btn_close" data-dismiss="modal" aria-label="Close"> <span aria-hidden="true">&times;</span> </button>
      </div>
      <div class="modal-body">
        <form method="post" id="forwarder-verify-mobile-otp-form" >
          <h3 class="viewMoreHd2 mb-3">Enter your OTP for Mobile Number verification send to number</h3>
          <div class="row m-0">
            <div class="col-md-8">
              <input type="text" class="form-control mb-3" placeholder="Enter your Mobile OTP" name="mobileotp" id='mobileOtpId' required>
            </div>
            <div class="col-md-4">
              <p class="float-right m-0"><a href="#" id="" onclick="resentVerifyMobileOtp();">Resend OTP</a></p>
            </div>
          </div>
          <input type="submit" class="btn btn-theme" value="Submit">
        </form>
      </div>
    </div>
  </div>
</div>
</body>
</html>