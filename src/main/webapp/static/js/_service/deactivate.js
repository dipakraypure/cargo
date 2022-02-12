//Deactivate user account
function deactivateAccount(){
	var userId = userInfo.id;
		 swal({
	         text: "Are you sure, please confirm?",
	         buttons: [
	           'Cancel',
	           'Ok'
	         ],
	       }).then(function(isConfirm) {
	         if (isConfirm) {
	       	  $('#loader').show();
	       	  var userid =  userInfo.id;  
	          var form_data = {};
	          form_data["userid"] = userid;
	          
					$.ajax({
						
					     type: 'PUT', 
			            url : server_url+'user/deactivateAccount/',	     
			            contentType: "application/json",
			            headers: authHeader,
			            data: JSON.stringify(form_data),
			   
			            success : function(response) {
				           console.log(response)
				 	        	
				            if(response.respCode == 1){  		            
				            	$('#loader').hide();
					           successBlock("#success_block",response.respData.msg);
					           logout();
	         	            		             	       
				            }else{
					            errorBlock("#error_block",response.respData);
			               }
				           $('#loader').hide();
			            },
			            error: function (error) {
				                console.log(error)
			                   if( error.responseJSON != undefined){
				                   errorBlock("#error_block",error.responseJSON.respData);
			                   }else{
				                   errorBlock("#error_block","Server Error! Please contact administrator");
			                   }         
				                $('#loader').hide();
			            }
			   })
	         } 
	       });
	 }	