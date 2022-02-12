<%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="ISO-8859-1">
<title>Upload Rate</title>
<link rel="stylesheet" href="static/css/bootstrap-datetimepicker.min.css">
<script src="static/js/bootstrap-datetimepicker.min.js"></script> 
<style>
.hide {
    display: none;
}
.imgT1 {
    max-height: 600px;
        min-height: 406px;
    box-shadow: 0 0px 5px rgb(0 0 0 / 10%);
}
.imgT2 img {
    max-height: 380px;
    margin: auto;
        width: 100%;
}
.imgT3 {
    max-height: 200px;
}
</style>

<script type="text/javascript">
$(function () {
	activeNavigationClass();
		
  $('#upload-offer-form').submit(function (event) {
    $('#loader').show()
    event.preventDefault();

    var formData = new FormData();
    formData.append("userId", userInfo.id);
    formData.append("tital", $("#fname").val());
    formData.append("origin", $("#forigin").val());
    formData.append("destination", $("#fdest").val());
    formData.append("fromDate", $("#fromDate").val());
    formData.append("toDate", $("#tillDate").val());
    var templateType = $('input[name="tab"]:checked').val();
    formData.append("templateType", templateType);
    
    var offerImage = document.getElementById('file');
    var offerImg = offerImage.files[0];
    formData.append("offerImage", offerImg);

    formData.append("description", $("#fname3").val());

    formData.append("footer", $("#fname4").val());
    
    var footerImage = document.getElementById('filef');
    var footerImg = footerImage.files[0];
    formData.append("footerImage", footerImg);
    
    $.post({
      url: server_url + 'admin/uploadOffer',
      enctype: 'multipart/form-data', 
      headers: authHeader,
      processData: false,
      contentType: false,
      data: formData,

      success: function (response) {
        console.log(response)

        if (response.respCode == 1) {
          successBlock("#success_block", response.respData.msg);
          $('#otp_modal').modal('hide');
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

        $('#loader').hide()
      }
    })

  });
});
</script>
	
</head>
<body>
<div class="container-fluid">
  <div class="bg_white_main mb-4 mt-4" style="max-height: 1020px;">
    <div class="row">
      <div class="col-md-12 mb-4">      
          <h2 class="book_cargo_hd mt-3">Upload Special Offer</h2>
          <div class="row">
            <div class="col-md-6 col-xs-12">
             <form method="post" id="upload-offer-form" >
              <div class="bg_white_main">
                <p class="upload_subline">Please fill the forms to upload your Offer</p>
                <div class="col-md-12"> 
                  
                  <!--------------- Common--------------->
                  <div id="temp" class=""> 
                    <!--<h3>Offer Template 1</h3>-->
                    <div class="col-md-12"> 
                      <!--Ttle-->
                      <div class="form-group row">
                        <label for="" class="col-sm-4 form-label">Title</label>
                        <div class="col-sm-8">
                          <input type="text"  class="form-control font14" id="fname" onkeyup="myFunction(this)" required>
                        </div>
                      </div>
                      <!--Title--> 
                      <!--Origin-->
                      <div class="form-group row">
                        <label for="" class="col-sm-4 form-label">Origin</label>
                        <div class="col-sm-8">
                          <input type="text"  class="form-control font14" id="forigin" onkeyup="myFunction(this)" required>
                        </div>
                      </div>
                      <!--Origin--> 
                      <!--Destination-->
                      <div class="form-group row">
                        <label for="" class="col-sm-4 form-label">Destination</label>
                        <div class="col-sm-8">
                          <input type="text"  class="form-control font14" id="fdest" onkeyup="myFunction(this)" required>
                        </div>
                      </div>
                      <!--Destination--> 
                      <!--Date-->
                      <div class="form-group row">
                        <label for="" class="col-sm-4 form-label">Date Valid From</label>
                        <div class="col-sm-8">
                          <input type="text"  class="form-control fromDate" id="fromDate" onfocusout="myFunction(this)" required>
                        </div>
                      </div>
                      <div class="form-group row">
                        <label for="" class="col-sm-4 form-label">Date Valid Till</label>
                        <div class="col-sm-8">
                          <input type="text"  class="form-control fromDate" id="tillDate" onfocusout="myFunction(this)" required>
                          <!--  <input type="text"  class="form-control font14" id="fname2" onkeyup="myFunction(this)"> --> 
                        </div>
                      </div>
                      <!--Date--> 
                      
                    </div>
                  </div>
                  <!--------------- Common--------------->
                  
                  <div class="">
                    <p class="upload_subline">Choose templates from below options</p>
                    <input type="radio" class="filter_checkbox" name="tab" value="template1" onclick="show1();" checked />
                    <span class="filter_label">Template 1</span>
                    <input type="radio" class="filter_checkbox" name="tab" value="template2" onclick="show2();" />
                    <span class="filter_label">Template 2</span>
                     </div>
                          
                  <!--------------- Temp Input 1--------------->
                  <div class="clearfix"></div>
                  <div class="mt-2">
                    <div class="col-md-12"> 
                      <!--Image-->
                      <div class="form-group row">
                        <label for="" class="col-sm-4 form-label">Image</label>
                        <div class="col-sm-8">
                          <input type="file" class="form-control-file file upload_file2" id="file" name= "filetype" required>
                          <small id="" class="form-text text-muted">(JPEG, PNG, TIFF, BMT | Size 1mb)</small> </div>
                      </div>
                      <!--Image--> 
                      
                    </div>
                  </div>
                  <!--------------- Temp Input 1---------------> 
                  <!--------------- Temp Input 2--------------->
                  <div > 
                    <!-- <h3>Offer Template 2</h3> -->
                    <div class="col-md-12">   
                    <div id="temp2" class="hide">                    
                      <!--Description-->
                      <div class="form-group row">
                        <label for="" class="col-sm-4 form-label">Description</label>
                        <div class="col-sm-8">
                          <textarea type="text"  class="form-control font14" id="fname3" maxlength="575" onkeyup="myFunction(this)" 
              autocomplete="off" rows="4" cols="8"  name="des" style="height:200px, white-space: normal" placeholder="Maximum charaters 575"></textarea>
                        </div>
                      </div>
                      <!--Description--> 
                      <!--Footer Text-->
                      <div class="form-group row">
                        <label for="" class="col-sm-4 form-label">Footer</label>
                        <div class="col-sm-8">
                          <input type="text"  class="form-control font14" id="fname4" onkeyup="myFunction(this)">
                        </div>
                      </div>
                      <!--Footer Text--> 
                      <!--Footer Image-->
                      <div class="form-group row">
                        <label for="" class="col-sm-4 form-label">Footer Sticker</label>
                        <div class="col-sm-8">
                          <input type="file" class="form-control-file file upload_file2" id="filef" name= "filetype1">
                          <small id="" class="form-text text-muted">(JPEG, PNG, TIFF, BMT | Size 1mb)</small> </div>
                      </div>
                      <!--Footer Image--> 
                      </div>
                    </div>
                  </div>
                  <!--------------- Temp Input 2---------------> 
                 
                </div>
              </div>
              <div class="row">
                <div class="col-md-12 text-left"> 
                   <button type="submit" value="Submit" class="search_btn" style="display: block;"><span>Save</span></button>
                </div>
              </div>
              </form>
            </div>
            <!------------------------------ Preview ------------------------------>
            <div class="col-md-4 col-xs-6">
              <div class=" bg_white_main">
                <p class="upload_subline text-center">Preview </p>                
                  <div class="previewcont" id="temppre2" >
                  <!--Image T2 -->
                  <div class="col-md-12 p-0 imgT2">
                    <p class="embed-responsive-item text-center"><img  id="pfile" src="" name= "pfiles" class="img-fluid " alt=""  /></p>
                  </div>
                  <!--Image T2-->  
                  <div id="temp2pre" style="display:none">                
                  <!--Title -->
                  <div class="col-md-12">
                    <p class="viewMoreHd ml-0" id="pfname"></p>
                  </div>
                  <!--Title--> 
                  <!--Origin Destination-->
                  <div class="col-md-12">
                    <h3 class="viewMoreHd ml-0">
                    <span id="pforigin"></span>&nbsp;&&nbsp;<span id="pfdest"></span>
                    </h3>
                  </div>
                  <!--Origin Destination --> 
                  <!--Date-->
                  <div class="col-md-12">
                    <p class="viewMoreSub ml-0">Special Promotional Rates from&nbsp;<span  class="" id="pfromDate"></span> to <span class="" id="ptillDate"></span></p>
                  </div>
                  <!--Date--> 
                  <!--Description-->
                  <div class="col-md-12">
                    <p class="description" id="pfname3"></p>
                  </div>
                  <!--Description--> 
                  <!--Footer Text-->
                  <div class="col-md-12">
                    <p class="viewMoreSub ml-0" id="pfname4"></p>
                  </div>
                  <!--Footer Text--> 
                  <!--Footer Image-->
                  <div class="col-md-12"  id="pre2">
                    <p class="footerimg embed-responsive-item text-center" ><img  id="pfilef" src="" name= "pfilesf" class="img-fluid"   /></p>
                  </div>
                  <!--Footer Image--> 
                  </div>
                   </div>
                </div>
                <div class="clearfix"></div>
              </div>
                <!------------------------------ Preview ------------------------------> 
            </div>
          </div>       
      </div>
    </div>
  </div>

 
<script>
	 function show1() {
	   $("#temp2, #temp2pre").hide();
	 }
	 function show2() {		  
		 $("#temp2, #temp2pre").show();
	 }
</script> 

<script>
$(document).ready(function () {
	activeNavigationClass();
  $("#temp1").on("click", function () {
    $('pre2').empty();
  });
});
</script> 
<script>
$("#title").change(function () {
  console.log("================title===========")
});

$("#date1").change(function () {
  console.log("================date===========")
});

$(".file").change(function () {
  console.log("===========================")
  readURL(this);
});

$(".fname3").change(function () {
  console.log("=============textarea==============")
  readURL(this);
});

function myFunction(arg) {
  var id = arg.getAttribute('id');
  var value = arg.value;
  value = value.replace(/\r?\n/g, '<br />');
  console.log("========myFunction===================", id)
  console.log("========myFunction=======value============", value)
  $("#p" + id).html(value)

}

function readURL(input) {

  console.log("========myFunction============input=======", input.getAttribute('id'))

  if (input.files && input.files[0]) {
    var reader = new FileReader();

    reader.onload = function (e) {
      $('#p' + input.getAttribute('id')).attr('src', e.target.result);
    }
    reader.readAsDataURL(input.files[0]); // convert to base64 string
  }
}
</script> 
<script type="text/javascript">
	 $(function () {
	   // Linked date and time picker 
	   // start date date and time picker 
	   $('#fromDate').datetimepicker({
	     format: 'DD-MMM-YYYY',
	     minDate: moment()
	   });

	   // End date date and time picker 
	   $('#tillDate').datetimepicker({
	     format: 'DD-MMM-YYYY',
	     useCurrent: false
	   });

	   // start date picke on chagne event [select minimun date for end date datepicker]
	   $("#fromDate").on("dp.change", function (e) {
	     $('#tillDate').data("DateTimePicker").minDate(e.date);
	   });
	   // Start date picke on chagne event [select maxmimum date for start date datepicker]
	   $("#tillDate").on("dp.change", function (e) {
	     $('#fromDate').data("DateTimePicker").maxDate(e.date);
	   });
	 });
</script>
</body>
</html>