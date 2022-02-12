<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Admin Home</title>

 <link href="http://code.jquery.com/ui/1.10.2/themes/smoothness/jquery-ui.css" rel="Stylesheet"></link>
 <style>
 </style>
 
 
  <script type="text/javascript">
   
  $(function() {
	  activeNavigationClass();
	  getAllCarrier();

	     /*  Submit form using Ajax */
	    /* $('#carrier-rate-convert-form').submit(function(event) {  */
	    
	     $("#convertBtnId").click(function(){

		     var carrierName =  $("#carrierDropdownId").val();
		     var carrierSelectVal = $("#carrierDropdownId option:selected").text();

		     var carrierAPI = "";
		     
             if(carrierSelectVal.startsWith("Maxicon"))
		     {
            	 carrierAPI = "convertFileMaxiconToSys";          	
       		 }else if(carrierSelectVal.startsWith("RCL")){
       			 carrierAPI = "convertFileRCLToSys";
             }
		     
	    	 var formData = new FormData();
	            
             formData.append("userId", userInfo.id);
             formData.append("carrier",carrierName);

             //formData.append("origin", $("#originInputId").val());
             formData.append("validDateFrom", $("#validDateFromId").val());
             formData.append("validDateTo", $("#validDateToId").val());
  
             //get carrier rate file
             var carrierRateFileInput = document.getElementById('carrierRateFileId');
             var fileRate = carrierRateFileInput.files[0];
             formData.append("carrierRateFileToConvert", fileRate);

             $.post({
                 url : server_url+'admin/'+carrierAPI,	         
                 enctype: 'multipart/form-data',
                 headers: authHeader,
                 processData: false,
	             contentType: false,
                 data : formData,
	         
                 success : function(response) {

      	          console.log(response)
      	 	        	
      	          if(response.respCode == 1){
      		            //swal("Carrier File Convert Sucessfully");  
      		      
      		            $("#downloadDivId").show();
      		            $("#carrierDownNameId").val(response.respData.carriername);
      		            $("#templateNameLblDownId").val(response.respData.filename);
      		            
      		            successBlock("#success_block",response.respData.msg);    		       
     		          }else{
				        errorBlock("#error_block",response.respData)
                    }
                 },
                 error: function (error) {

      	          console.log(error)
      	 
      	          console.log(error.responseJSON )
            
                    if( error.responseJSON != undefined){
          	       errorBlock("#error_block",error.responseJSON.respData);
                    }else{
          	       errorBlock("#error_block","Server Error! Please contact administrator");
                    }
          
                   // $('.spinner-border').hide()
   	            }
             })
             
		 });

	     $("#downTemplateBtnId").click(function(){

	    	 var carrierName = $("#carrierDownNameId").val();
	    	 var templateName = $("#templateNameLblDownId").val();
	    	 var userId =  userInfo.id;
	    	 
	    	 var url = server_url+'download/downloadTemplate';
	    	 window.location.href = url+"?userId="+ userId + "&carrierName=" + carrierName +"&templateName="+templateName;
	    	 	    	 
	     });

	     $("#uploadTemplateDataBtnId").click(function(){

	    	 var carrierName = $("#carrierDownNameId").val();
	    	 var templateName = $("#templateNameLblDownId").val();
	    	 var userId =  userInfo.id;
	    	    	
             $.ajax({
     			
  			     type: 'GET', 
                 url : server_url+'admin/uploadTemplateData',	         
                 enctype: 'multipart/form-data',
                 headers: authHeader,
                 processData: false,
	             contentType: false,

                 data : "userId="+ userId + "&carrierName=" + carrierName +"&templateName="+templateName,
	         
                 success : function(response) {

      	          console.log(response)
      	 	        	
      	          if(response.respCode == 1){
      	        	swal("Template data uploaded Sucessfully");   
      		            window.location.href = contextPath+"/uploadRate"; 	
      		            successBlock("#success_block",response.respData.msg);   
      		             	       
     		          }else{
				        errorBlock("#error_block",response.respData)
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
            
	     });

	     $("#uploadTemplateDataBtnId").click(function(){

	    	 var formData = new FormData();
	            
             formData.append("userId", userInfo.id);
  
             //get carrier rate file
             var carrierRateFileInput = document.getElementById('carrierRateTempFileId');
             var fileRate = carrierRateFileInput.files[0];
             formData.append("carrierRateTempFileToUpload", fileRate);

             $.post({
                 url : server_url+'admin/uploadDirTemplateFile',	         
                 enctype: 'multipart/form-data',
                 headers: authHeader,
                 processData: false,
	             contentType: false,
                 data : formData,
	         
                 success : function(response) {

      	          console.log(response)
      	 	        	
      	          if(response.respCode == 1){
      		            //swal("Carrier File Convert Sucessfully");  
      		            
      		            successBlock("#success_block",response.respData.msg);    		       
     		          }else{
				        errorBlock("#error_block",response.respData)
                    }
                 },
                 error: function (error) {

      	          console.log(error)
      	 
      	          console.log(error.responseJSON )
            
                    if( error.responseJSON != undefined){
          	       errorBlock("#error_block",error.responseJSON.respData);
                    }else{
          	       errorBlock("#error_block","Server Error! Please contact administrator");
                    }
          
                   // $('.spinner-border').hide()
   	            }
             })
		 });
	     
	  
	});

  function getAllCarrier(){
		 
		$.ajax({
			
			   type: 'GET',  		     	
			   contentType: "application/json",
			   url : server_url+'admin/getCarriers',
			   headers: authHeader,
			   data: null
			})
			.done(function(response) {
				try{
					
					var ddl = document.getElementById("carrierDropdownId");
	                var option = document.createElement("OPTION");
	                
					if(response != null && response.respData.length !=0){
				        $('#carrierDropdownId').empty();	             
	                    option.innerHTML = 'Choose Carrier';
					    option.value = '0';
					    ddl.options.add(option);	
											
						for( i=0 ; i< response.respData.length ; i++){
									  
						       var option = document.createElement("OPTION");
						       option.innerHTML = response.respData[i].carriershortname+"("+response.respData[i].carriername+")";
						       option.value = response.respData[i].id;
						       ddl.options.add(option);			
						} 
											  		   
					}else{
						$('#carrierDropdownId').empty();
						option.innerHTML = 'No Carriers available';
					    option.value = '0';
					    ddl.options.add(option);
					}
					 
				}catch(err){				
					console.log(response.respData);
				}
			})
			.fail(function(err) {			
				    console.log("Failed");
		    });
}
	
  </script>
  
</head>



<div class="container-fluid">
  	<div class="bg_white_main">
        
        <div class="row">
        <div class="col-md-12 ">
          <h2 class="book_cargo_hd">Upload Carriers Rate!</h2>
        </div>
        
      	<div class="col-md-4">
      		<div class="bg_white3">
      		<!-- 
      		<form method="post" id="carrier-rate-convert-form" >
      		 -->
      		<label class="form-label mt-0">Select Carrier</label>
      		<select class="form-control font14" id="carrierDropdownId">
      			<!-- <option>- Choose Carrier -</option>  -->
      		</select>
      			
      	
      		<label class="form-label">Valid Date From</label>
      		<input type="datetime" class="form-control font14" autocomplete="off" name ="validDateFrom" id="validDateFromId" required>
      		
      		<label class="form-label">Valid Date To</label>
      		<input type="datetime" class="form-control font14" autocomplete="off" name ="validDateTo" id="validDateToId" required>
      		
      		
            <label class="form-label">Upload Carrier Rate File </label>
           
            <input type="file" class="form-control font14" name="carrierRateFile" id="carrierRateFileId" >
            <button type="submit" value="Submit" class="login_btn2" id="convertBtnId"><span>Convert</span></button>
            
            
           <!--  </form> -->
      		</div>
      	</div>
      	
      	<div class="col-md-4">
      	
      	    <div class="bg_white3" style="display:none;" id="downloadDivId">
      		    <label class="form-label">Template  </label>
      		    
      		    <label class="form-label">Carrier Name</label>
      		    <input type="text" class="form-control font14" name ="carrierDownName" id="carrierDownNameId" readonly>
      		
      		    <label class="form-label">Template Name</label>
                <input type="text" class="form-control font14" name="templateDownName" id="templateNameLblDownId" readonly>
                
                <button type="submit" value="Download" class="login_btn2" id="downTemplateBtnId"><span>Download</span></button>
                <button type="submit" value="Submit" class="login_btn2" id="uploadTemplateDataBtnId"><span>Upload Data</span></button>
                <div class="clear-fix"></div>
                 
      		</div>
      	    
      		<div class="bg_white3" style="display:none;">
      		    <label class="form-label">Upload Template Data </label>
      		    
                <input type="file" class="form-control font14" name="carrierRateFile" id="carrierRateFileId" >
                <button type="submit" value="Submit" class="login_btn2" id="submitBtnId"><span>Upload Data</span></button>
                
                <div class="clear-fix"></div>
                 
      		</div>
      		
      		<div class="bg_white3" >
      		    <label class="form-label">Upload Template  </label>
      		    
      		    <label class="form-label">Upload Carrier Rate Template File </label>
                 <input type="file" class="form-control font14" name="carrierRateTempFile" id="carrierRateTempFileId">
                <button type="submit" value="Submit" class="login_btn2" id="uploadDirTemplateBtnId"><span>Upload Data</span></button>
                
                <div class="clear-fix"></div>
                 
      		</div>
      		
      	</div>
      	
      	<!--  
      	<div class="col-md-6">
      	  <div class="bg_white3">
      	     <img src="static/images/place.jpg" alt="place" class="place_img">
      	  </div>
      	</div>
      	-->
      	
      	</div>
      	
      	
  	</div>
 </div>

<script src="http://code.jquery.com/ui/1.10.2/jquery-ui.js" ></script>
  <script>
	$(document).ready(function() {
		
		$(function() {
			$( "#validDateFromId" ).datepicker({ 
				dateFormat: 'dd-mm-yy',
				minDate: 0,
				beforeShow: function (textbox, instance) {
		            instance.dpDiv.css({
		                    marginTop: (-textbox.offsetHeight) + 'px',
		                    marginLeft: textbox.offsetWidth + 'px'
		            });
		          }
			});

			$( "#validDateToId" ).datepicker({ 
				dateFormat: 'dd-mm-yy',
				minDate: 0,
				beforeShow: function (textbox, instance) {
		            instance.dpDiv.css({
		                    marginTop: (-textbox.offsetHeight) + 'px',
		                    marginLeft: textbox.offsetWidth + 'px'
		            });
		          }
			});
			
		});
		
	});
	
  </script>

</html>