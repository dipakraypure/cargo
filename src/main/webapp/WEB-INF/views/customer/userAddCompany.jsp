<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>My Company</title>
<style>
input[type=file] {
    width: 90px;
    color: transparent;
}
.filetype_label {
    display: inline-block !important;
    margin-left: 15px;
}
.filetype_label2 {
    display: inline-block !important;
    font-size: 14px;
}
</style>
<script type="text/javascript">

  $(function() {
	     activeNavigationClass();
		 loadExistingCompanyDetailsByUserId(userInfo.id);
	   
		 $('#company-update-form').submit(function(event) {

			 $('#loader').show();
			 //Prevent default submission of form
			 event.preventDefault();
			      
			 //Remove all errors
			 $('input').next().remove();

			 var formData = new FormData();

             formData.append("userId", userInfo.id);
             formData.append("userPanNumber", $("#userPanNumberId").val());
             formData.append("userIECCode", $("#userIECCodeId").val());
             formData.append("aliasName", $("#aliasNameId").val());
   
             formData.append("website", $("#website").val());
  
             //get user pan file
             var panFileInput = document.getElementById('userPanFileId');
             var filePan = panFileInput.files[0];
             formData.append("userPanFile", filePan);

             //get IEC file	
             var iecFileInput = document.getElementById('userIECFileId');
             var fileIEC = iecFileInput.files[0];
             formData.append("userIECFile", fileIEC);

           //get LOGO file
             var logoFileInput = document.getElementById('logoFileId');
             var logo = logoFileInput.files[0];
             formData.append("logo", logo);
  	      
            $.post({
                url : server_url+'user/updateCompany',	         
                enctype: 'multipart/form-data',
                headers: authHeader,
                processData: false,
	               contentType: false,
                data : formData,
                success : function(response) {

     	          console.log(response)
     	 	        	
     	          if(response.respCode == 1){
     	        	 $('#loader').hide();
     	        	 swal("Company Updated Sucessfully");
     		        window.location.href = contextPath+"/userCompany";
    		          }else{
				        errorBlock("#error_block",response.respData)
                   }
     	         $('#loader').hide();
                },
                error: function (error) {
           
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

  function  loadExistingCompanyDetailsByUserId(userId){
	  $('#loader').show();
	  $.ajax({
			
		   type: 'GET',  		     	
		   contentType: "application/json",
		   url : server_url+'user/companyDetailsByUserId?userId='+userId,
		   headers: authHeader,
		   data: null
		})
		.done(function(response) {
			try{
				
				$('#gstinNumberId').val(response.respData.gstinnumber);
				$('#gstinLastUpdatedId').text(response.respData.lastupdatedate);
				
				$('#legalNameId').val(response.respData.legalname);	
				$('#tradeNameId').val(response.respData.tradename);

				var buildingnumber = response.respData.buildingnumber;
				var floornumber = response.respData.floornumber;
				var buildingname = response.respData.buildingname;
				var street = response.respData.street;
				
				
				var companyAddress = buildingnumber +", "+floornumber+", "+buildingname+", "+street;
				$('#companyAddressId').val(companyAddress);
				
				$('#cityId').val(response.respData.destination);
				
				$('#pincodeId').val(response.respData.pincode);
				$('#stateId').val(response.respData.statecode);
				var statecode = response.respData.gstinnumber.substring(0, 2);
				$('#stateCodeId').val(statecode);

				$('#gstinStatusId').val(response.respData.gstinstatus);
				$('#taxPayerTypeId').val(response.respData.taxpayertype);


				$('#userPanNumberId').val(response.respData.userpanno);
				$('#userPanFileToShow').text(response.respData.userpanfilename);
				
				$('#userIECCodeId').val(response.respData.userieccode);
				$('#userIECFileToShow').text(response.respData.useriecfilename);
				
				$('#aliasNameId').val(response.respData.alias);
				$('#logoFileToShow').text(response.respData.aliasfilename);
				
				$('#website').val(response.respData.website);
							
			}catch(err){
				console.log("No Data Found");
			}
			 $('#loader').hide();
		})
		.fail(function(err) {
			 $('#loader').hide();	
			console.log("Failed");
	    });
  }

	window.pressedPAN = function(){
	    var file = document.getElementById('userPanFileId');
	    fileValidation(file);        
	    var fileLabel = document.getElementById('userPanFileToShow');
	    if(file.value == "")
	    {
	    	fileLabel.innerHTML = "No file chosen";
	    }
	    else
	    {
	        var theSplit = file.value.split('\\');
	        fileLabel.innerHTML = theSplit[theSplit.length-1];
	    }
	};

	window.pressedIEC = function(){
	    var file = document.getElementById('userIECFileId');
	    fileValidation(file);
	    var fileLabel = document.getElementById('userIECFileToShow');
	    if(file.value == "")
	    {
	    	fileLabel.innerHTML = "No file chosen";
	    }
	    else
	    {
	        var theSplit = file.value.split('\\');
	        fileLabel.innerHTML = theSplit[theSplit.length-1];
	    }
	};

	window.pressedLOGO = function(){
	    var file = document.getElementById('logoFileId');
	    fileValidation(file);
	    var fileLabel = document.getElementById('logoFileToShow');
	    if(file.value == "")
	    {
	    	fileLabel.innerHTML = "No file chosen";
	    }
	    else
	    {
	        var theSplit = file.value.split('\\');
	        fileLabel.innerHTML = theSplit[theSplit.length-1];
	    }
	};

	function fileValidation(file){
		/**file validation**/
        var file_name = file.value;
        var extension = file_name.split('.').pop().toLowerCase();
        var size      = file.files[0].size;
        var allowedFormats = ["jpg", "png", "bmp", "pdf"];

         if(!(allowedFormats.indexOf(extension) > -1)){
          swal("Choose jpg/png/bmp/pdf file");
          document.getElementById("submit").disabled = true;
          return false;              
         } else if( size > (50 * 1024)){
            swal("Your file should be less than 50 KB");
            return false;
         } else {
          document.getElementById("submit").disabled = false;   
         }
         /**file validation**/
    }
  </script>
</head>

<div class="container-fluid">
  <div class="bg_white_main mb-4"> 
    <!-- code for company details start -->
    <form method="post" id="company-update-form" >
      <div class="spl_padd">
        <div class="col-md-12 padd0">
          <h2 class="book_cargo_hd">Company Details</h2>
        </div>

        <div class="row">
          <div class="col-md-6 col-xs-12">
            <div class="bg_white3">
              <h3 class="book_cargo_hd2">GST Details</h3>
              <div class="row">
                <div class="col-md-6">
                  <div class="row">
                    <div class="col-md-6">
                      <label for="userGSTINNumber" class="form-label-new">GSTIN <span class="mandatory">*</span></label>
                    </div>
                    <div class="col-md-6 padd0">
                      <input type="input" class="form-control font14" name="userGSTINNumber" id='gstinNumberId' readonly>
                    </div>
                  </div>
                </div>
                <div class="col-md-6">
                  <label for="userGSTINNumber" class="form-label-new">Details last updated on <span id="gstinLastUpdatedId"></span></label>
                </div>
              </div>
              <div class="row mt-3">
                <div class="col-md-3">
                  <label for="legalEntity" class="form-label-new">Legal Entity <span class="mandatory">*</span></label>
                </div>
                <div class="col-md-9 paddl0">
                  <input type="input" class="form-control font14" name="legalEntity" id='legalNameId' readonly>
                </div>
              </div>
              <div class="row mt-3">
                <div class="col-md-3">
                  <label for="tradeName" class="form-label-new">Trade Name <span class="mandatory">*</span></label>
                </div>
                <div class="col-md-9 paddl0">
                  <input type="input" class="form-control font14" name="tradeName" id='tradeNameId' readonly>
                </div>
              </div>
              <div class="row mt-3">
                <div class="col-md-3">
                  <label for="userAddress1" class="form-label-new">Company Address <span class="mandatory">*</span></label>
                </div>
                <div class="col-md-9 paddl0">
                  <textarea class="form-control font14" name="companyAddress" id='companyAddressId' readonly></textarea>
                </div>
              </div>
              <div class="row mt-3">
                <div class="col-md-6">
                  <div class="row">
                    <div class="col-md-6">
                      <label for="city" class="form-label-new">City <span class="mandatory">*</span></label>
                    </div>
                    <div class="col-md-6 padd0">
                      <input type="input" class="form-control font14" name="city" id='cityId' readonly>
                    </div>
                  </div>
                </div>
                <div class="col-md-6">
                  <div class="row">
                    <div class="col-md-5 offset-md-1">
                      <label for="pincode" class="form-label-new">Pincode <span class="mandatory">*</span></label>
                    </div>
                    <div class="col-md-6 paddl0">
                      <input type="input" class="form-control font14" name="pincode" id='pincodeId' readonly>
                    </div>
                  </div>
                </div>
              </div>
              <div class="row mt-3">
                <div class="col-md-6">
                  <div class="row">
                    <div class="col-md-6">
                      <label for="stateDropdownId" class="form-label-new">State <span class="mandatory">*</span></label>
                    </div>
                    <div class="col-md-6 padd0">
                      <input type="input" class="form-control font14" name="state" id="stateId" readonly>
                    </div>
                  </div>
                </div>
                <div class="col-md-6">
                  <div class="row">
                    <div class="col-md-5 offset-md-1">
                      <label for="stateCode" class="form-label-new">State Code <span class="mandatory">*</span></label>
                    </div>
                    <div class="col-md-6 paddl0">
                      <input type="input" class="form-control font14" name="stateCode" id='stateCodeId' readonly>
                    </div>
                  </div>
                </div>
              </div>
              <div class="row mt-3">
                <div class="col-md-6">
                  <div class="row">
                    <div class="col-md-6">
                      <label for="status" class="form-label-new">Status <span class="mandatory">*</span></label>
                    </div>
                    <div class="col-md-6 padd0">
                      <input type="input" class="form-control font14" name="status" id='gstinStatusId' readonly>
                    </div>
                  </div>
                </div>
                <div class="col-md-6">
                  <div class="row">
                    <div class="col-md-5 offset-md-1">
                      <label for="type" class="form-label-new">Type <span class="mandatory">*</span></label>
                    </div>
                    <div class="col-md-6 paddl0">
                      <input type="input" class="form-control font14" name="type" id='taxPayerTypeId' readonly>
                    </div>
                  </div>
                </div>
              </div>
            </div>
          </div>
          <div class="col-md-6 col-xs-12">
            <div class="bg_white3">
              <h3 class="book_cargo_hd2">Other Details</h3>
              <div class="row  ">
                <div class="col-md-3">
                  <label for="userPanNumber" class="form-label-new">PAN</label>
                </div>
                <div class="col-md-4 padd0">
                  <input type="input" class="form-control font14" name="userPanNumber" id='userPanNumberId'>
                </div>
              </div>
              <div class="row mt-2">
                <div class="col-md-3">
                  <label for="pan" class="form-label-new">Upload PAN</label>
                </div>
                <div class="col-md-9 paddl0">
                  <input type="file" class="upload_file2" name="userPanFile" id="userPanFileId" onchange="pressedPAN()" data-max-size="50000" accept="image/*,application/pdf" >
                  <label id="userPanFileToShow" class="filetype_label2" >No file chosen</label>
                  <span class="verified" id="veriSpanIdPan" style="display: none;"><i class="fa fa-check" aria-hidden="true"></i> Verified</span> <span class="notverified" id="notVeriSpanIdPan" style="display: none;"><i class="fa fa-times" aria-hidden="true"></i> Not Verified</span> </div>
              </div>
              <div class="row  mt-1">
                <div class="col-md-3">
                  <label for="userPanNumber" class="form-label-new">IEC Code </label>
                </div>
                <div class="col-md-4 padd0">
                  <input type="input" class="form-control font14" name="userIESCode" id='userIECCodeId' >
                </div>
              </div>
              <div class="row mt-2">
                <div class="col-md-3">
                  <label for="pan" class="form-label-new">Upload IEC </label>
                </div>
                <div class="col-md-9 paddl0">
                  <input type="file" class="upload_file2" name="userIECFile" id="userIECFileId" onchange="pressedIEC()" data-max-size="50000"  accept="image/*,application/pdf" >
                  <label id="userIECFileToShow" class="filetype_label2" >No file chosen</label>
                  <span class="verified" id="veriSpanIdIec" style="display: none;"><i class="fa fa-check" aria-hidden="true"></i> Verified</span> <span class="notverified" id="notVeriSpanIdIec" style="display: none;"><i class="fa fa-times" aria-hidden="true"></i> Not Verified</span> </div>
              </div>
            </div>
            <div class="bg_white3">
              <h3 class="book_cargo_hd2">Other Information</h3>
              <div class="row mt-2">
                    <div class="col-md-3">
                      <label for="alias" class="form-label-new">Alias </label>
                    </div>
                    <div class="col-md-4 padd0">
                      <input type="input" class="form-control font14" name="alias" id='aliasNameId' >
                    </div>
                  </div>
                  <div class="row mt-2">
                    <div class="col-md-3">
                      <label for="website" class="form-label-new">Website</label>
                    </div>
                    <div class="col-md-4 padd0">
                      <input type="input" class="form-control font14" name="website" id='website' >
                    </div>
                  </div>
                
                  <div class="row mt-2">
                    <div class="col-md-3">
                      <label for="logo" class="form-label-new">Logo </label>
                    </div>
                    <div class="col-md-9 paddl0">
                      <input type="file" class="upload_file2" name="logo" id="logoFileId" onchange="pressedLOGO()" data-max-size="50000"  accept="image/*,application/pdf" >
                      <label id="logoFileToShow" class="filetype_label2" >No file chosen</label>
                    </div>
                  </div>
                  
                  </div>
              </div>
            </div>
           
         
         		 <div class="col-md-12">
         			<button type="submit" value="Submit" class="comp_sub_btn float-right" style="display: block;" id="submit"><span>Update</span></button>
         		</div>  
         		<br>
        </div>
    </form>
    <!-- code for company details end --> 
  </div>
</div>

</html>