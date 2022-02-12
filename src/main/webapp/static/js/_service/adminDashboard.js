/*********************************************/
/*******Start Customer/User functions *******/	
/* Start Load User role on popup */
	function loadUserRoleDropdown(){
	$.ajax({
		
		   type: 'GET',  		     	
		   contentType: "application/json",
		   url : server_url+'auth/getAllRole',
		   data: null
		})
		.done(function(response) {
			try{
				
				var ddl = document.getElementById("userTypeId");
                var option = document.createElement("OPTION");
                
				if(response != null && response.respData.length !=0){
			        $('#userTypeId').empty();	             
                    option.innerHTML = 'Choose Profile';
				    option.value = '0';
				    ddl.options.add(option);	
										
					for( i=0 ; i< response.respData.length ; i++){
								  
					       var option = document.createElement("OPTION");
					       option.innerHTML = response.respData[i].name;
					       option.value = response.respData[i].code;
					       ddl.options.add(option);			
					} 
										  		   
				}else{
					$('#userTypeId').empty();
					option.innerHTML = 'No Profile available';
				    option.value = '0';
				    ddl.options.add(option);
				}
				 
			}catch(err){				
				errorBlock("#error_block",response.respData);
			}
		})
		.fail(function(err) {			
			    errorBlock("#error_block",response.respData);
	    });
    }
    /* end Load User role on popup */

function getUserEnquiryCountByStatus(userId,shipmentType){

		$('#loader').show();
	  	$.ajax({
	  			
	  		     type: 'GET', 
	               url : server_url+'user/getUserEnquiryCountByStatus',	     
	               enctype: 'multipart/form-data',
	               headers: authHeader,
	               processData: false,
	               contentType: false,

	               data: "userId=" + userId + "&shipmentType=" + shipmentType,
	      
	               success : function(response) {

	  	           console.log(response)
	  	 	        	
	  	            if(response.respCode == 1){  		            

	  	            	$("#eqRequestCount").text(response.respData.requestCount);
	  	            	$("#eqAcceptedCount").text(response.respData.acceptedCount);
	  	            	$("#eqCancelledCount").text(response.respData.cancelledCount);
	  	            	$("#eqRejectedCount").text(response.respData.rejectedCount);
	  	            	 	            		             	       
	  	            }else{
	  		            errorBlock("#error_block",response.respData)
	  		            
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

	 function getUserBookingCountByStatus(userId,shipmentType){
	    $('#loader').show();
	  	$.ajax({
	  			
	  		     type: 'GET', 
	               url : server_url+'user/getUserBookingCountByStatus',	     
	               enctype: 'multipart/form-data',
	               headers: authHeader,
	               processData: false,
	               contentType: false,

	               data: "userId=" + userId + "&shipmentType=" + shipmentType,
	      
	               success : function(response) {

	  	           console.log(response)
	  	 	        	
	  	            if(response.respCode == 1){  		            

	  	            	$("#bkRequestCount").text(response.respData.requestCount);
	  	            	$("#bkAcceptedCount").text(response.respData.acceptedCount);
	  	            	$("#bkCancelledCount").text(response.respData.cancelledCount);
	  	            	$("#bkRejectedCount").text(response.respData.rejectedCount);
	  	            	 	            		             	       
	  	            }else{
	  		            errorBlock("#error_block",response.respData)
	  		            
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
	 
/*----------------------- Get All User Enquiry List-------------------*/
	 
	 function getEnquiryDetailsListByStatus(enquiryStatus){
		    var userType = $('#userTypeId :selected').val();
		    var userEntityId =  $('#userEntityId :selected').val();
		    var shipmentType = $('#shipmenttypefilter').val();
		    
		    if(userType != "" && userEntityId != ""){
		    	if(userType == "CS"){
			    	//Customer
					getUserEnquiryDetailsAllList(userEntityId,shipmentType,enquiryStatus);
			    }else if(userType == "FF"){
			    	//forwarder
					getForwarderEnquiryDetailsAllList(userEntityId,shipmentType,enquiryStatus);
			    }
		    }
		    	
		}
	 
	 function getBookingDetailsListByStatus(bookingStatus){
		  var userType = $('#userTypeId :selected').val();
		  var userEntityId =  $('#userEntityId :selected').val();
		  var shipmentType = $('#shipmenttypefilter').val();
		  
		  if(userType != "" && userEntityId != ""){
			  if(userType == "CS"){
				  //Customer
				  getUserBookingDetailsAllList(userEntityId,shipmentType,bookingStatus);
			  }else if(userType == "FF"){
				  //forwarder
				  getForwarderBookingDetailsAllList(userEntityId,shipmentType,bookingStatus);
			  } 
		  }
		 
	 }
	 
	 function getUserEnquiryDetailsAllList(userId,shipmentType,enquiryStatus){

			$("#enquiryForwarderTableContId").hide();
			$("#bookingForwarderTableContId").hide();
			$("#bookingUserTableContId").hide();
			$("#enquiryUserTableContId").show();

			$('#loader').show();
			
			var tableId = "Enquiry_User_table";  

		  	$.ajax({
		  			
		  		     type: 'GET', 
		               url : server_url+'user/getUserEnquiryList',	     
		               enctype: 'multipart/form-data',
		               headers: authHeader,
		               processData: false,
		               contentType: false,
		               
		               data: "userId=" + userId + "&shipmentType="+ shipmentType+"&enquiryStatus=" + enquiryStatus,

		               success : function(response) {

		  	           console.log(response)
		  	 	        	
		  	            if(response.respCode == 1){  		            
		  	            	loadUserEnquiryListTable(response.respData,tableId);
		  	            	generateCreatedAtArrayListFromEnquiry(response.respData);
		  	            	prepareCustomerFilter(customerFilterArray);
		  	            	prepareForwarderFilter(forwarderFilterArray);   	  
			  		        prepareOriginFilter(originFilterArray);
			  		        prepareDestinationFilter(destinationFilterArray);
			  		          	            		             	       
		  	            }else{
		  		            errorBlock("#error_block",response.respData)
		  		            loadUserEnquiryListTable(null,tableId);
		                  }
		  	             $('#loader').hide();
		               },
		               error: function (error) {
		  	                console.log(error)
		                      if( error.responseJSON != undefined){
		                    	  loadUserEnquiryListTable(null,tableId);
		   	                   errorBlock("#error_block",error.responseJSON.respData);
		                      }else{
		                    	  loadUserEnquiryListTable(null,tableId);
		   	                   errorBlock("#error_block","Server Error! Please contact administrator");
		                      }         
		  	              $('#loader').hide();
		               }
		      })
		  }
	 
	 function loadUserEnquiryListTable(data, tableId) {

		  $('#' + tableId).dataTable().fnClearTable();
		  var shipType = "";
		  var oTable = $('#' + tableId).DataTable({
		    "destroy": true,
		    "data": data,
		    "dom": 'lBfrtip',
		    "scrollX": true,
		    "autoWidth": true,
		    "lengthChange": true,
		    "buttons": [{
		        extend: 'pdf',
		        filename: "user_enquiry_data_pdf",
		        title: "user_enquiry_data_pdf",
		        text: '<i class="fa fa-file-pdf-o"></i>',
		        titleAttr: 'Download PDF',
		        exportOptions: {
		          columns: [0, 1, 2, 3, 4, 5, 6, 7, 8]
		        },
		        customize: function (doc) {
		        	 doc.defaultStyle.alignment = 'left';
		        	  doc.styles.tableHeader.alignment = 'left';
		          doc.content.splice(1, 0, {
		            margin: [1, 1, 7, 1],
		            alignment: 'left',
		            image: 'data:image/png;base64,/9j/4QAYRXhpZgAASUkqAAgAAAAAAAAAAAAAAP/sABFEdWNreQABAAQAAAA8AAD/4QMtaHR0cDovL25zLmFkb2JlLmNvbS94YXAvMS4wLwA8P3hwYWNrZXQgYmVnaW49Iu+7vyIgaWQ9Ilc1TTBNcENlaGlIenJlU3pOVGN6a2M5ZCI/PiA8eDp4bXBtZXRhIHhtbG5zOng9ImFkb2JlOm5zOm1ldGEvIiB4OnhtcHRrPSJBZG9iZSBYTVAgQ29yZSA3LjAtYzAwMCA3OS5kYWJhY2JiLCAyMDIxLzA0LzE0LTAwOjM5OjQ0ICAgICAgICAiPiA8cmRmOlJERiB4bWxuczpyZGY9Imh0dHA6Ly93d3cudzMub3JnLzE5OTkvMDIvMjItcmRmLXN5bnRheC1ucyMiPiA8cmRmOkRlc2NyaXB0aW9uIHJkZjphYm91dD0iIiB4bWxuczp4bXA9Imh0dHA6Ly9ucy5hZG9iZS5jb20veGFwLzEuMC8iIHhtbG5zOnhtcE1NPSJodHRwOi8vbnMuYWRvYmUuY29tL3hhcC8xLjAvbW0vIiB4bWxuczpzdFJlZj0iaHR0cDovL25zLmFkb2JlLmNvbS94YXAvMS4wL3NUeXBlL1Jlc291cmNlUmVmIyIgeG1wOkNyZWF0b3JUb29sPSJBZG9iZSBQaG90b3Nob3AgMjIuNCAoV2luZG93cykiIHhtcE1NOkluc3RhbmNlSUQ9InhtcC5paWQ6RERGRkJCOEFGNjg3MTFFQjg5NDE4NjM4MjhGODZFODAiIHhtcE1NOkRvY3VtZW50SUQ9InhtcC5kaWQ6RERGRkJCOEJGNjg3MTFFQjg5NDE4NjM4MjhGODZFODAiPiA8eG1wTU06RGVyaXZlZEZyb20gc3RSZWY6aW5zdGFuY2VJRD0ieG1wLmlpZDpEREZGQkI4OEY2ODcxMUVCODk0MTg2MzgyOEY4NkU4MCIgc3RSZWY6ZG9jdW1lbnRJRD0ieG1wLmRpZDpEREZGQkI4OUY2ODcxMUVCODk0MTg2MzgyOEY4NkU4MCIvPiA8L3JkZjpEZXNjcmlwdGlvbj4gPC9yZGY6UkRGPiA8L3g6eG1wbWV0YT4gPD94cGFja2V0IGVuZD0iciI/Pv/uAA5BZG9iZQBkwAAAAAH/2wCEAAYEBAQFBAYFBQYJBgUGCQsIBgYICwwKCgsKCgwQDAwMDAwMEAwODxAPDgwTExQUExMcGxsbHB8fHx8fHx8fHx8BBwcHDQwNGBAQGBoVERUaHx8fHx8fHx8fHx8fHx8fHx8fHx8fHx8fHx8fHx8fHx8fHx8fHx8fHx8fHx8fHx8fH//AABEIAC8AZAMBEQACEQEDEQH/xACWAAACAgMBAQAAAAAAAAAAAAAFBgAEAwcIAgEBAAMBAQEAAAAAAAAAAAAAAAABAgMEBRAAAQQBAwIEAwYFAwUAAAAAAgEDBAUGABESIRMxIhQHQVEWYXEyQiMVkaFSMySBYghyorJEFxEAAgIBAgMGBQQDAAAAAAAAAAERAgMhEjFBBFFhcYHRIpHBMhMF8KGxcvFCgv/aAAwDAQACEQMRAD8A6p0ATQBNAE0ATQBNAE0ATQB8MwACM1QQFFUiXwRE6qugDl20z33W94Mxm0WAyyp8ZgKqHNAyY5N7qIuvvAiufqKiqDbfw8ddyx0x1m2rIlvgVr2n9/8A2haayJu/W/omzFJzZvOyWU5Lx2ebf3MBJenNtei+OnW2PJpEMGmjozAsyr8yxOvyKAKttTAXuMEqKTToKouNkqf0mipv8fHXHko6uCk5GDUDNcyvc3JI8W6uRx9mRjtFMkxJjzcxUmduIaC68LBNcC2TcuPc3XbWyxLRTqxSFLPM7+TkLtFilZHnvw4rMywmTXzjMNpJ5dhkODbpk4YgpeCIKbfPUqiiWElUvdJXcXgWEOpcO/sp5UzNG66IK3PaIxfF15EJO20jRmpoK7j4J10/taxOgSZ4Oc3Meda0+Q1rMW4r64raN6R9Xo0mMKkJcTMGzAwNEEkIfiipodFo1wCTNCz9Z/0zFhQVetL+I1ZSY6H5YUIwQjedPbr5i4Npt5y+5dJ44nuCQ5SXSWaSkVrsnGdVvjvy5D+U/wDXZdcmDNvnSIZ1dT0/241mUVZWTG1MnsNRVdCA2LpmhdSRFTuoKbfkFdZ26mLWSX0/pmtOjmtW3G9x6fEIvWQDIhMMj3SmbkiovQWhHkp/zRE+/W1suqS1n+DnrhcWb02/z2GoA9zLHJfd3Lfb8HUjwmaiTCrGtkRXJwiiuukXjuiHsKb+Cb67vt7aK3ec86iT/wAXbitZrMmwiVJSsyKW+px+75DLg2jLjY77bk0YLuPjsuj8hiteuj4o06XIqXVmph8B59zZlfhPtNkFddzWnp12y5Gra8SUlJx0OHIRLzbD+Ml22T79cH4vpL4+L5nZ+S6umaydVGhrjG81vvbP/j9TW0dzhOtbwpUOM6KKj0FB/VFUXrxMWlXdPmipr1b0V8jXceanCOm/qGL9LfUfAvSeh/ce3+ft9nvbffx1xbdYNDTthUZRKwzOZMS0bGjYt7V6fS9hAckx2XecllJnJSa7oCSIqN9P566E1uWmsIkd8AksSc4zGQyPBqQ3TvMAvijJwfIn8UXWWRe1eY0J9Wu2XVDir+gWc3aAvw3WC8P/AJoWtXwf9UIZ8yIVz98UVOQ4lZqafHir7KJ/NNZ0+n/pDYK9gyGuhFUW3myOZCh2bE4v/brCZEI6N/0pF/tECeC+b8+qz66rgKo5Vb4QHY8s12YkhKad/wCtl03Q/wC3nrx8VtjVuT3fs2/U9jNV5E6rjXa/ikn8jNRRyCxZR9EVyRBN99F67k+/zJF3+XLbVYK+5TzrPxZHVXmjjleF5Vgz41CJqRNJw+56U1gxf9jDfnRPv8/X7k1fTUhueXtXgZ9ZklVj/Zbn4vT5Gkvfn2ryOpyUPdLB+fr4pjItIrScnBNpNvUNgn4wIPK6Hy6/PXr4Mqa2WPNsuYOz/wBo7L3DxGJ7kUtM5S5bKaSRZ0RKgrK49EfZ6ooOkich5bKSePm8ax5dj2tyganUWPZP2JtM0mpkOVhJHHYpKIR5BH6iaba7K0ncXkDIkmxL03XonxXV5s6rouIlWQwOG5n7ze4ziXNc5jeH40foRgkPDsttqn+O0O3EnXUQeZJ5RHbb4bzvrjrpq2ESzqP9vhft/wC3dkfRdr0/p/y9rjw4fdx6a4Z5mhqjJ6729rZ9rS2+XWDEGwfcsbihjohtIEoubiSHGGDdZZc268nB6fHbW9XZw0iXA3TcNr7mVHyPGrt+nkSYjcZZ1YrDrMmIO5MooPA80vDmvAxTdN9vDWavGjUjgo0uKYDf4WxU4/YOPRaqabrFvGdVZbVm04Ruvq6SLydI3CU+QqJISptx03eytLCAQzae29NaXjd/lj1nkL7K1VlPljxWMzxUuwCMMhHaT9TmvzXquqizShaCGGRT4TCxvHbo7UY1bizTTlfeI82glGRpGSbcc24G2+GyEKeK7bdUTUp2bajiM81OSe3+SIGPwLMjlblMZjuA7GfMUJSImxfBtXA8+yqKL0XXNfo/ZD4SdVOssr71ExBavM6wWivybsbRG7NqMgvRWgdfVpki5obosg4raL8z2TWlenbtuXZBi8r27e+Q5RP1MuD+5VUoJsGxNZTUloxcbLmiD5CHpt5dTXHsb72O+R2juUFa1C6mL24jZssJ4n3UZI/9UFw0T+GufKr20Wi8YOnA8VNbOX4T6IDHS5JFXvQpMmO6nXi6/wCrYL7CQkRwf4LrmeDLXWra89y9TtXU4baWVWu5bX6HtvNZMZwY9tHSFMFNiBxVFh3/AHNu7EifcvT7dNda6uLrbb9n4Ml/ja2U43ur3cV4oKMZZBeURENjPog9xot1+ziRKv8ADW9erq/0jlt0Fl/h+ga3Phvt5tt+P266ji5mvvZhtt2syea4KFJm5JbepcVNyNGZJMNoS/FBbbQU1tlfDwJRnyGHGwP2xfp8cRxHi5QKRoyVw/VWL6i2gr4qgG8pInwFNFXvtLDggfhlTHwjPSxVheNXc1TEuBvuiLLrkGNKRE/qcbJtwlXxXfVXe6s9jEtAdjOUzKaz9wBjY9ZXZJevuCkEGSAl9Ix+mquOAW/TrsK6dqyq6xoCYBqoMX6O9p6onWZsCZdnNcBndWEMfUyga2NBVUZcLiqKniPhq2/dZ9wuw2JkN5iUjLqCvuYE5qyjWBJRTjYcCOUr07nJAeTykJNct0Xousa1cNoop+zDYOQMnsjRFmT8jtFkOr+IkjyFjtCq/IW2kRNGbl4IET2faaiOZnWxxRuJDyOb6dtOggLwtvEIp4IKEa7Imnm5PuBBiD7k0Mx0OLMtqLJbkO1051rixLGIik72F5KX4RUh5iPJE3HdNS8bQSCb33KYl4layahuZAmFTvWtPLksIAvNAA/qtISn1AnA3ExTxRdlTVVx6qe0JLbuXUsNyU1YFLs3np8evbgpHB1AlPQhkC0yiIPkIRUlI16Eq9UTUWxblqkVW7q5Tgyxc1xlmNFOvq5C2M1+RFCpYjtjLF2Iv+QjnmFsUb6bkrnHqmyrumpr06rwSRV81rfU2wp9a0X0x9R83PQfg7fbLv8Ae7nZ7Ha/F3e75OPz1WxzBnIlY8OW42/kEbFq6HlNPPs5k2FLZnss+llPnvJiy0JC/tv8uobl8FFF1pbbaJ0EVbLDpAQcRge4FzFl0kByTLuJ02V2Qk2j6l6SM13FAlBnumrfm38qdNNX1e1ahB4scWwELnH53t/MqxyaBPB8Yrc8SOTCUVbmtIKuOEv6JqSbJ4omhWtD3cAhDd7fVrkKyzFw34z6TLx2QAx3hdJtFjsDweQf7bnl3UF67bL8dZ5HKXgNCNVYtLa9tsQZr7OrK/prh+bTIssDiz1STIJyK28G/mNpwkXiJcSHqnjrV29zmYaFGgYu3Mrvsrwxy2p4+Ox620KShTLGM45JP0jzfZjNNbq4fnUvFOieGpUJOHIz3j6ZPjc+/bxqvjZVQWFnJmRnYs5hlyJKdL/LiyEc3HYHkVdxVSTfZR0Wi0ToxF/29rrCprpjUlyPaWdxbTZWSPQH2yYrn3h59heSoZdpBANtuXXdU20sjTfgtBoW4EOyepMXqnmmGI9NGnIzaFKjLGnF6N1lj0aiZEaG2aumpIPFE+OrbUt9oi1f08lzEapgX4qE3h06KpFJZEFM2oaIYmpIJNJwXdxPKnTdeqaVXq/7AXmKqQmV9/vRuP1FFf4pIaU+I0ZNKPDly58uqB4qPm8NKdPL5gDZ9PwyCPOdH1qN2lzygQJzbM0mpCNL3G9nmOXaIERwFPpyRVTTT08kAW9JD/8Al3b9HA5eq7n7f69e33/Wcu163ub+q+3n/d6eGpn3j5H/2Q=='
		          });
		        },
		        title: " ",
		        orientation: 'landscape',
		        pageSize: 'LEGAL'
		        /* messageTop: "User Enquiry Data" */
		      },
		      {
		        extend: 'excel',
		        filename: "user_equiry_data_xsl",
		        title: "",
		        text: '<i class="fa fa-file-excel"></i>',
		        titleAttr: 'Download Excel',
		        exportOptions: {
		          columns: [0, 1, 2, 3, 4, 5, 6, 7, 8]
		        }

		        /* messageTop: "User Enquiry Data" */
		      },
		    ],
		    "columnDefs": [
		      /* origin */
		      {
		        "targets": 0,
		        "className": "dt-body-left",
		        "width": "10%",
		      },
		      /* destination */
		      {
		        "targets": 1,
		        "className": "dt-body-left",
		        "width": "10%",
		      },
		      /* ref */
		      {
		        "targets": 2,
		        "className": "dt-body-center",
		        "width": "10%",
		      }, /* date */
		      {
		        "targets": 3,
		        "className": "dt-body-center",
		        "width": "9%",
		      },
		      /* category */
		      {
		        "targets": 4,
		        "className": "dt-body-center",
		        "width": "8%",
		      },
		      /* FCL LCL */
		      {
		        "targets": 5,
		        "className": "dt-body-center",
		        "width": "6%",
		      },
		      /* container */
		      {
		        "targets": 6,
		        "className": "dt-body-left",
		      },
		      /* weight */
		      {
		        "targets": 7,
		        "className": "dt-body-right",
		        "width": "5%",
		      },
		      /* volume */
		      {
		        "targets": 8,
		        "className": "dt-body-right",
		      },
		      /* ready date */
		      {
		        "targets": 9,
		        "className": "dt-body-center",
		        "width": "9%",
		      },
		      /* status */
		      {
		        "targets": 10,
		        "className": "dt-body-center",
		        "width": "8%",
		      },
		      /* action */
		      {
		        "targets": 11,
		        "className": "text-center",
		      }
		    ],
		    "columns": [

		      {
		        "data": null,
		        sortable: true,
		        render: function (data, type, row) {
		          var originwithcode = data.origin;

		          return originwithcode;

		        }
		      },
		      {
		        "data": null,
		        sortable: true,
		        render: function (data, type, row) {
		          var destinationwithcode = data.destination;

		          return destinationwithcode;

		        }
		      },
		      {

		        "data": null,
		        sortable: true,
		        render: function (data, type, row) {
		          var enquiryreference = data.enquiryreference;

		          return '<u><a href="#" onclick="getForwarderEnquiryStatusByReference(\'' + enquiryreference + '\');" class="book_link">' + enquiryreference + '</a></u>';


		        }
		      },
		      {

		        "data": null,
		        sortable: true,
		        render: function (data, type, row) {
		          var searchdate = data.searchdate.split(" ");

		          return searchdate[0];

		        }
		      },
		      {

		        "data": null,
		        sortable: true,
		        render: function (data, type, row) {
		          var cargocategory = data.cargocategory;

		          return cargocategory;

		        }
		      },
		      {

		        "data": null,
		        sortable: true,
		        render: function (data, type, row) {
		          var shipmenttype = data.shipmenttype;
		          shipType = data.shipmenttype;
		          return shipmenttype;

		        }
		      },
		      {

		        "data": null,
		        sortable: true,
		        render: function (data, type, row) {
		          var selectedfcl = data.selectedfcl;
		          return selectedfcl;

		        }
		      },
		      {

		        "data": null,
		        sortable: true,
		        render: function (data, type, row) {
		          var lcltotalweight = data.lcltotalweight;		    		       
		          return lcltotalweight;

		        }
		      },
		      {

		        "data": null,
		        sortable: true,
		        render: function (data, type, row) {
		          var lclvolume = data.lclvolume;
		          return lclvolume;

		        }
		      },
		      {

		        "data": null,
		        sortable: true,
		        render: function (data, type, row) {
		          var cargoreadydate = data.cargoreadydate;

		          return cargoreadydate;

		        }
		      },
		      {

		        "data": null,
		        sortable: true,
		        render: function (data, type, row) {
		          var status = data.status;
		          return status;
		        }
		      },
		      {

		        "data": null,
		        sortable: true,
		        render: function (data, type, row) {

		          var id = data.id;
		          var status = data.status;

		          var optionsDisClass = '';
		          var cancelDisClass = '';

		          if (status == 'Requested') {
		            optionsDisClass = 'disabled';
		            cancelDisClass = '';

		          }
		          if (status == 'Accepted') {
		            optionsDisClass = '';
		            cancelDisClass = '';

		          }
		          if (status == 'Cancelled') {
		            optionsDisClass = 'disabled';
		            cancelDisClass = 'disabled';

		          }
		          if (status == 'Rejected') {
		            optionsDisClass = 'disabled';
		            cancelDisClass = 'disabled';

		          }

		          cancelDisClass = 'disabled';

		          var accept = "Accepted";
		          var cancel = "Cancelled";

		          return '<span class="m-1"  title="Options" ><button type="button" onclick="enquiryAcceptedList(\'' + id + '\');"  class="list_btn actbtn ' + optionsDisClass + '" ' + optionsDisClass + '><i class="fas fa-list"></i></button></span>'
		          + '<button type="button" value="V" class="view_btn actbtn"  title="View" onclick="viewEnquiryDetailsById(\'' + id + '\');" ><i class="fas fa-eye"></i></button>'  
		          + '<span title="Cancel"><button type="button"  onclick="updateEnquiryStatus(\'' + id + '\',\'' + cancel + '\');" class="can_btn actbtn ' + cancelDisClass + '" ' + cancelDisClass + '><i class="fas fa-times"></i></button></span>';


		        }
		      }
		    ],
		    "order": [
		      [3, "desc"]
		    ],

		  });
		  if (shipType == "FCL" && shipType != "") {
		    oTable.column(7).visible(false);
		    oTable.column(8).visible(false);
		  } else if (shipType == "LCL" && shipType != "") {
		    oTable.column(6).visible(false);
		  }

		} 	 
	

	 function viewEnquiryDetailsById(enquiryId){
	 	$('#loader').show();
	 	  $.ajax({
	 		    type: 'GET',
	 		    url: server_url + 'user/getUserEnquiryDetailsById',
	 		    enctype: 'multipart/form-data',
	 		    headers: authHeader,
	 		    processData: false,
	 		    contentType: false,

	 		    data: "enquiryId=" + enquiryId,

	 		    success: function (response) {
	 		      console.log(response)
	 		      if (response.respCode == 1) {
	 			      $("#enqReffDetLbl").text(response.respData.enquiryreference);
	 			      $("#enqOrgDetLbl").text(response.respData.origin);
	 			      $("#enqDestDetLbl").text(response.respData.destination);
	 			      $("#enqFclLclDetLbl").text(response.respData.shipmenttype);
	 			      $("#enqCRDDetLbl").text(response.respData.cargoreadydate);

	 			      $("#enqCargoCatDetLbl").text(response.respData.cargocategory);
	 			      $("#enqCommodityDetLbl").text(response.respData.commodity);
	 			      $("#enqImcoDetLbl").text(response.respData.imco);
	 			      $("#enqTempRangeDetLbl").text(response.respData.temprange);
	 			      
	 			      if(response.respData.shipmenttype == "FCL"){
	 			    	 $("#fclContainerDiv").show();
	 			    	 $("#lclContainerDiv").hide(); 
	 			         $("#enqServiceDetLbl").text(response.respData.shipmenttype);
	 			         $("#enqTwentyCountDetLbl").text(response.respData.twentyFtCount);
	 			         $("#enqFourtyCountDetLbl").text(response.respData.fourtyFtCount);
	 			         $("#enqFourtyHCCountDetLbl").text(response.respData.fourtyFtHcCount);
	 			         $("#enqFourtyFiveHcCountDetLbl").text(response.respData.fourtyFiveFtCount);
	 			      }else if(response.respData.shipmenttype == "LCL"){
	 			    	 $("#lclContainerDiv").show();
	 			    	 $("#fclContainerDiv").hide();				     
	 			         $("#enqServiceDetLclLbl").text(response.respData.shipmenttype);
	 			         $("#enqWtLclDetLbl").text(response.respData.lcltotalweight);
	 			         $("#enqVolLclDetLbl").text(response.respData.lclvolume);
	 			         $("#enqNoPckLclDetLbl").text(response.respData.lclnumberpackage);
	 			      }
	 			      
	 		    	  $('#view_enquiry_modal').modal('show');
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

	 function getForwarderEnquiryStatusByReference(enquiryReference){
	 	 $('#loader').show();
	 	  var tableId = "forwarder_enquiry_refstatus_table";
	 	  var userId = userInfo.id;

	 	  $.ajax({

	 	    type: 'GET',
	 	    url: server_url + 'user/getForwarderEnquiryStatusByReference',
	 	    enctype: 'multipart/form-data',
	 	    headers: authHeader,
	 	    processData: false,
	 	    contentType: false,
	 	    data: "userId=" + userId + "&enquiryReference=" + enquiryReference,
	 	    success: function (response) {

	 	      console.log(response)

	 	      if (response.respCode == 1) {

	 	        loadTableForwarderEnquiryStatusList(response.respData, tableId);

	 	        $("#forwarder_ref_enq_stat_modal").modal('show');
	 	      } else {
	 	    	  loadTableForwarderEnquiryStatusList(null, tableId);
	 	        errorBlock("#error_block", response.respData)
	 	      }
	 	      $('#loader').hide();
	 	    },
	 	    error: function (error) {
	 	      console.log(error)
	 	      if (error.responseJSON != undefined) {
	 	    	  loadTableForwarderEnquiryStatusList(null, tableId);
	 	        errorBlock("#error_block", error.responseJSON.respData);
	 	      } else {
	 	        loadTableEnquiryAcceptedList(null, tableId);
	 	        errorBlock("#error_block", "Server Error! Please contact administrator");
	 	      }
	 	      $('#loader').hide();
	 	    }
	 	  })
	 }

	 function loadTableForwarderEnquiryStatusList(data, tableId) {
		  $('#' + tableId).dataTable().fnClearTable();
		  var oTable = $('#' + tableId).DataTable({
		    'responsive': true,
		    "destroy": true,
		    "data": data,
		    "dom": 'lBfrtip',
		    "autoWidth": true,
		    "lengthChange": true,
		    "buttons": [{
		        extend: 'pdf',
		        filename: "forwader_enquiry_data_pdf",
		        title: "",
		        text: '<i class="fa fa-file-pdf-o"></i>',
		        titleAttr: 'Download PDF',
		        exportOptions: {
		          columns: [0, 1, 2]
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
		        filename: "forwader_enquiry_data_xsl",
		        title: "",
		        text: '<i class="fa fa-file-excel"></i>',
		        titleAttr: 'Download Excel',
		        exportOptions: {
		          columns: [0, 1, 2]
		        }
		        /* messageTop: "User Enquiry Data" */
		      },
		    ],
		    /*  "scrollX": true, */
		    "columnDefs": [
		      /* origin */
		      {
		        "targets": 0,
		        "className": "dt-body-left",
		        "width": "20%",
		      },
		      /* destination */
		      {
		        "targets": 1,
		        "className": "dt-body-left",
		        "width": "40%",
		      },
		      /* imp exp */
		      {
		        "targets": 2,
		        "className": "dt-body-left",
		      },
		      
		    ],
		    "columns": [

		      {
		        "data": null,
		        sortable: true,
		        render: function (data, type, row) {
		          var enquiryreference = data.enquiryreference;
		          return enquiryreference;
		        }

		      },
		      {
		        "data": null,
		        sortable: true,
		        render: function (data, type, row) {
		          var forwarder = data.forwarder;

		          return forwarder;
		        }
		      },
		      {
		        "data": null,
		        sortable: true,
		        render: function (data, type, row) {
		          var status = data.status;
		          var updateddate = data.updateddate;
		          var statusAndDate = status + " (" + updateddate + ")";

		          return statusAndDate;
		        }
		      }

		    ]

		  });

		}
 
	 
	 function getUserBookingDetailsAllList(userId,shipmentType,bookingStatus){

		    $("#enquiryForwarderTableContId").hide();
			$("#bookingForwarderTableContId").hide();
			$("#enquiryUserTableContId").hide();
			$("#bookingUserTableContId").show();
			
			$('#loader').show();
			var tableId = "Booking_User_table";  

		  	$.ajax({
		  			
		  		     type: 'GET', 
		               url : server_url+'user/getUserBookingList',	     
		               enctype: 'multipart/form-data',
		               headers: authHeader,
		               processData: false,
		               contentType: false,

		               data: "userId=" + userId + "&shipmentType="+ shipmentType +"&bookingStatus=" + bookingStatus,
		      
		               success : function(response) {

		  	           console.log(response)
		  	 	        	
		  	            if(response.respCode == 1){  		            
		  		          loadUserBookingListTable(response.respData,tableId); 	
		  		          generateCreatedAtArrayListFromBooking(response.respData);
		  		          prepareCustomerFilter(customerFilterArray);
		  		          prepareForwarderFilter(forwarderFilterArray);   	  
		  		          prepareOriginFilter(originFilterArray);
		  		          prepareDestinationFilter(destinationFilterArray);
		  	            }else{
		  		            errorBlock("#error_block",response.respData)
		  		            loadUserBookingListTable(null,tableId);
		                  }
		  	              $('#loader').hide();
		               },
		               error: function (error) {
		  	                console.log(error)
		                      if( error.responseJSON != undefined){
		                    	  loadUserBookingListTable(null,tableId);
		   	                   errorBlock("#error_block",error.responseJSON.respData);
		                      }else{
		                    	  loadUserBookingListTable(null,tableId);
		   	                   errorBlock("#error_block","Server Error! Please contact administrator");
		                      }         
		  	                 $('#loader').hide();
		               }
		      })
		  }
	 
	 function loadUserBookingListTable(data,tableId){
		  	
		  	$('#'+tableId).dataTable().fnClearTable();
		  	
		  	var oTable = $('#'+tableId).DataTable({
		  		/*'responsive': true,*/
		  	 	"destroy" : true,
		  		"data" : data,     	
		       "dom": 'lBfrtip',
		       "autoWidth": true,
		       "lengthChange": true,
		       "buttons": [
		       	{
		               extend: 'pdf',
		               title: "user_booking_data_pdf",
		               text:      '<i class="fa fa-file-pdf-o"></i>',
		               titleAttr: 'Download PDF',
		               exportOptions: {
		                   columns: [0,1,2,3,4,5,6,7,8]
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
		               title: "user_booking_data_xsl",
		               text:      '<i class="fa fa-file-excel"></i>',
		               titleAttr: 'Download Excel',
		               exportOptions: {
		                   columns: [0,1,2,3,4,5,6,7,8]
		               }
		               /* messageTop: "User Enquiry Data" */
		           },
		       ],
		       /*"columnDefs": [
		    	    { "width": "10%", "targets": 8 }
		    	  ],*/
		  		"columns": 	[
		  			           
		  			            {        
		  			            	 "data": null,
					    	           sortable: true,					    	          
					    	           render: function (data,type,row) {
		               				   var originwithcode = data.originwithcode;

		               					return originwithcode;
		               					
		               				}
		  			            },
		  						{				    	        	  
					      	           "data": null,					      	       
					    	           sortable: true,					    	          
					    	           render: function (data,type,row) {
		               				   var destinationwithcode = data.destinationwithcode;

		               					return destinationwithcode;
		               					
		               				}
								},
		  						{
		  							      
									    "data": null,
	                      	        sortable: true,	
	                   				render: function (data,type,row) {
	                       				var id = data.id;
	                   					var bookingreff = data.bookingreff;
	                   					return '<u><a href="#" onclick="getUserBookingDetailsById(\''+bookingreff+'\');" class="book_link">'+bookingreff+'</a></u>';
	                   					
	                   				}	
		                        },
		  	    	            {          
		                        	     
		                        	       "data": null,
		                        	       className: 'text-center',
		                        	        sortable: true,	
		                     				render: function (data,type,row) {
		                     					 var bookingdate = data.bookingdate.split(" ");
		                     					return bookingdate[0];
		                     					
		                     				}
				    	                   
		  					    },
		  					    {        
	  	                          "data": null,
	  	                        "className": "text-left",
	                                  sortable: true,					    	          
	                                  render: function (data,type,row) {
			                            var forwarder = data.forwarder;
				                        return forwarder;
				
			                         }
	                            },
							    {
		                  		      
		                  		       "data": null,
	                        	       className: 'text-center',
		                  		        sortable: true,
	              				    render: function (data,type,row) {
	              				    	 var cutoffdate = data.cutoffdate;
	              					    return cutoffdate;
	              					
	              				    }
		    	                        
							    },	
							    {
		                  		      
		                  		       "data": null,
	                        	       className: 'text-right',
		                  		        sortable: true,
	           				          render: function (data,type,row) {
	               				            var status = data.bookingstatus;
	                                        var statBTN = '';
	               				    
	           					            return status;
	           					
	           				         }
		    	                        
							    },					  
							    {
		                  		      
		                  		       "data": null,
	                        	       className: 'text-center',
		                  		        sortable: true,
	              				    render: function (data,type,row) {
	                  				    var id = data.id;

	                  				  var status = data.bookingstatus;

	            				    	var cancelDisClass = '';
		                    			var rejectDisClass = '';	                    			
		                    			
		                    			if(status == 'Requested'){
		                    				cancelDisClass = '';
		                    				rejectDisClass = 'disabled';	                    					                    				
	     			                    }
		                    		    if(status == 'Accepted'){
		                    		    	cancelDisClass = 'disabled';
		                    		    	rejectDisClass = 'disabled';	                    				                    				
				                        }  			                        
		                    		    if(status == 'Cancelled'){
		                    		    	cancelDisClass = 'disabled';
		                    		    	rejectDisClass = 'disabled';	                    				                    				
				                        }    
		                    		    if(status == 'Rejected'){
		                    		    	cancelDisClass = 'disabled';
		                    		    	rejectDisClass = 'disabled';	                    					                    				
				                        }
	                  				                    		
		                    		    cancelDisClass = 'disabled';
	                    		    	rejectDisClass = 'disabled';
	                    		    	
	                  				    var accept = "Accepted";	                  				    
	                                    var cancel = "Cancelled";
	                                    var reject = "Rejected";
	                  				                 					   
	              					    return ' <button title="Cancel" type="button" value="C" onclick="updateBookingStatus(\''+id+'\',\''+cancel+'\');" class="can_btn actbtn '+cancelDisClass+'"  '+cancelDisClass+'><i class="fas fa-times"></i></button>'+
	              					 		   ' <button title="Reject"  type="button"  value="R"  onclick="updateBookingStatus(\''+id+'\',\''+reject+'\');" class="rej_btn actbtn '+rejectDisClass+'" '+rejectDisClass+'><i class="fas fa-times-circle"></i></button>';
	            					
	              				    }
		    	                        
							    }
		                  		
		              			
		                  	],
		  	                "order": [[ 3, "desc" ]],	
		      		                  
		      		     });

	}  
	 
	 function enquiryAcceptedList(enquiryId){

		 
		 $('#loader').show();
		 var tableId = "enquiryAcceptedListTableId";	
		 var userId = $('#userEntityId :selected').val();
		 
		  	$.ajax({
		  			
		  		     type: 'GET', 
		               url : server_url+'user/getEnquiryAcceptedList',	     
		               enctype: 'multipart/form-data',
		               headers: authHeader,
		               processData: false,
		               contentType: false,
		               data : "userId="+userId+"&enquiryId="+enquiryId,	     	      
		               success : function(response) {

		  	           console.log(response)
		  	 	        	
		  	            if(response.respCode == 1){ 
		  	         
			  	            loadTableEnquiryAcceptedList(response.respData,tableId,enquiryId);   	
		  	            
		  	            	$("#enquiry_accepted_list").modal('show');		  		          	            		             	       
		  	            }else{
		  	            	loadTableEnquiryAcceptedList(null,tableId,enquiryId); 
		  		            errorBlock("#error_block",response.respData)	  		            
		                  }
		  	             $('#loader').hide();
		               },
		               error: function (error) {
		  	                console.log(error)
		                      if( error.responseJSON != undefined){	
		                    	  loadTableEnquiryAcceptedList(null,tableId,enquiryId);                     	 
		   	                   errorBlock("#error_block",error.responseJSON.respData);
		                      }else{	                    	 
		                    	  loadTableEnquiryAcceptedList(null,tableId,enquiryId); 
		   	                   errorBlock("#error_block","Server Error! Please contact administrator");
		                      }         
		  	              $('#loader').hide();
		               }
		      })
		 
	 }
	 

	 function loadTableEnquiryAcceptedList(data, tableId, enquiryId) {

	   $('#' + tableId).dataTable().fnClearTable();

	   var oTable = $('#' + tableId).DataTable({
	     'responsive': true,
	     "destroy": true,
	     "data": data,
	     "autoWidth": true,
	     "dom": 'lBfrtip',
	     "lengthChange": true,
	     "buttons": [
	     	{
	             extend: 'pdf',
	             title: "user_accepted_enquiry_data_pdf",
	             text:      '<i class="fa fa-file-pdf-o"></i>',
	             titleAttr: 'Download Excel',
	             exportOptions: {
	                 columns: [0,1,2,3,4,5,6,7,8]
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
	             /* title: "User Accepted Enquiry Data", */
	             text:      '<i class="fa fa-file-excel"></i>',
	             titleAttr: 'Download Excel',
	             exportOptions: {
	                 columns: [0,1,2,3,4,5,6,7,8]
	             }
	             /* messageTop: "User Enquiry Data" */
	         },
	     ],
	     "columns": [

	       {
	         "data": null,
	         sortable: true,
	         render: function (data, type, row) {
	           var enquiryreference = data.enquiryreference;

	           return enquiryreference;

	         }
	       },
	       {
	         "data": null,
	         sortable: true,
	         render: function (data, type, row) {
	           var forwarder = data.forwarder;

	           return forwarder;

	         }
	       },
	       {

	         "data": null,
	         className: 'dt-body-right',
	         sortable: true,
	         render: function (data, type, row) {
	           var ftcharges = data.freightcharges;
	           var ftchargescurrency = data.ftchargescurrency;

	           var freightcharges = "";
	           
	           if(ftcharges == 0){
	         	  freightcharges = ftcharges;
	           }else{
	         	  freightcharges =  ftchargescurrency+ " " +parseFloat(ftcharges).toFixed(2);
	           }
	   			
	           return freightcharges;

	         }
	       },
	       {

	         "data": null,
	         className: 'dt-body-right',
	         sortable: true,
	         render: function (data, type, row) {
	           var orgcharges = data.origincharges;
	           var orgchargescurrency = data.orgchargescurrency;			

	 		  var origincharges = "";

	 		  if(orgcharges == 0){
	 			  origincharges = orgcharges;
	           }else{
	         	  origincharges =  orgchargescurrency+ " " +parseFloat(orgcharges).toFixed(2);
	           }
	           	
	           return origincharges;

	         }

	       },
	       {
	         "data": null,
	         className: 'dt-body-right',
	         sortable: true,
	         render: function (data, type, row) {
	           var destcharges = data.destinationcharges;
	           var destchargescurrency = data.destchargescurrency;

	           var destinationcharges = "";

	           if(destcharges == 0){
	         	  destinationcharges = destcharges;
	           }else{
	         	  destinationcharges =  destchargescurrency+ " " +parseFloat(destcharges).toFixed(2);
	           }
	           
	           return destinationcharges;

	         }
	       },
	       {

	         "data": null,
	         className: 'dt-body-right',
	         sortable: true,
	         render: function (data, type, row) {
	         var othcharges = data.othercharges;
	         var otherchargescurrency = data.otherchargescurrency;
	                 
	         var othercharges = "";

	         if(othcharges == 0){
	         	othercharges = othcharges;
	         }else{
	         	othercharges =  otherchargescurrency+ " " +parseFloat(othcharges).toFixed(2);
	         }
	           return othercharges;

	         }

	       },
	       {

	         "data": null,
	         className: 'dt-body-right',
	         sortable: true,
	         render: function (data, type, row) {
	           var usdtotalcharges = parseFloat(data.usdtotalcharges);
	           return usdtotalcharges.toFixed(2);

	         }

	       },
	       {

	           "data": null,
	           className: 'dt-body-right',
	           sortable: true,
	           render: function (data, type, row) {
	             var inrtotalcharges = parseFloat(data.inrtotalcharges);
	             return inrtotalcharges.toFixed(2);

	           }

	       },
	       {

	         "data": null,
	         className: 'text-center',
	         sortable: true,
	         render: function (data, type, row) {

	           var forwarderid = data.forwarderid;
	           var enquiryreference = data.enquiryreference;
	           
	           var disabledClass = 'disabled';
	        	            
	            return '<button type="button" value="Submit" class="green_sub actbtn '+disabledClass+'" onclick="bookSchedule(\'' + forwarderid + '\',\'' + enquiryreference + '\');" title="Book" '+disabledClass+'> <i class="fas fa-check-circle"></i></button>';
	            
	            }
	       }
	     ]
	   });
	 }
	 
	//onclick function for get booking details after click on booking reff
	function getUserBookingDetailsById(bookingreff){
	   getUserBookingDetailsByBookingReff(bookingreff);
	}
	 
	function getUserBookingDetailsByBookingReff(bookingReff){
		$('#loader').show();
		  	$.ajax({
		  			
		  		     type: 'GET', 
		               url : server_url+'user/getUserBookingDetailsById?bookingReff='+bookingReff,	     
		               enctype: 'multipart/form-data',
		               headers: authHeader,
		               processData: false,
		               contentType: false,

		               data : null,
		      
		               success : function(response) {
		            	   $('#loader').hide();
		  	           console.log(response)
		  	 	        	
		  	            if(response.respCode == 1){  		            

		  	            	//booking reff
		  	            	$("#bkBookingReffLbl").text(response.respData.bookingreff);
		  	            	
		  	            	$("#bkBookByLbl").text(response.respData.bookedby);
		  	            	$("#bkCargoReadyDateLbl").text(response.respData.cargoreadydate);
		  	            	$("#bkDateOfBookingLbl").text(response.respData.dateofbooking);
		  	            	$("#bkBookingStatusLbl").text(response.respData.bookingstatus);

		  	            	//booking party
		  	            	$("#bkBookingPartyLbl").text(response.respData.bookingparty);

		  	            	//schedule details
		  	            	$("#bkBookingDateLbl").text(response.respData.bookingdate);
		  	            	$("#bkOriginLbl").text(response.respData.origin);
		  	            	$("#bkDestinationLbl").text(response.respData.destination);
		  	            	$("#bkCutOffDateLbl").text(response.respData.cutoffdate);
		  	            	$("#bkIncotermLbl").text(response.respData.incoterm);
		  	            	$('#tbodyBookingDetailsPopUpId').empty();
		  	            	$('#tbodyBookingChargesPopUpId').empty();
		  	            	
		  	            	var tRows = '';
		  	            	for(var i = 0 ;i<response.respData.scheduleLegsResponse.length ;i++){
			  	            	var org = response.respData.scheduleLegsResponse[i].origin;
			  	            	var dest = response.respData.scheduleLegsResponse[i].destination;
			  	            	var mode = response.respData.scheduleLegsResponse[i].mode;
			  	            	var carrier = response.respData.scheduleLegsResponse[i].carrier;
			  	            	var vessel = response.respData.scheduleLegsResponse[i].vessel;
			  	            	var voyage = response.respData.scheduleLegsResponse[i].voyage;
			  	            	var etddate = response.respData.scheduleLegsResponse[i].etddate;
				  	            var etadate = response.respData.scheduleLegsResponse[i].etadate;
					  	        var transittime = response.respData.scheduleLegsResponse[i].transittime;
					  	        
					  	        var daysLable = ""
					  	        if(transittime > 1){
					  	            daysLable = "Days";
						  	    }else{
						  	        daysLable = "Day";
							  	}

				  	            transittime = transittime+" "+daysLable;
			  	            	
		  	            		tRows = tRows + '<tr><td>'+org+'</td><td>'+dest+'</td><td>'+mode+'</td><td>'+carrier+'</td><td>'+vessel+'</td><td>'+voyage+'</td><td>'+transittime+'</td><td>'+etddate+'</td><td>'+etadate+'</td></tr>';		  	            	
			  	            }
		  	            	
		  	            	$('#tbodyBookingDetailsPopUpId').append(tRows);

		  	            	var tRowsCharges = '';
		  	            	var json = [];
		  	                var totalCharges = [];
		  	            	if(response.respData.chargesRateResponseList != null){
		  	            	    for(var i = 0 ;i<response.respData.chargesRateResponseList.length ;i++){
			  	            	    var chargesgrouping = response.respData.chargesRateResponseList[i].chargesgrouping;
			  	            	    var chargestype = response.respData.chargesRateResponseList[i].chargestype;
			  	            	    var currency = response.respData.chargesRateResponseList[i].currency;
			  	            	    var rate = response.respData.chargesRateResponseList[i].rate;
			  	            	    var basis = response.respData.chargesRateResponseList[i].basis;
			  	            	    var quantity = response.respData.chargesRateResponseList[i].quantity;			  	            	   
			  	            	    var totalAmount = rate * quantity;
			  	            	    var totalChargesUsd = 0;
			  	                    var totalChargesInr = 0;
			  	                
			  	            	    if(currency == "USD"){
			  	            		   totalChargesUsd = totalAmount;
			  	                    }else if(currency == "INR"){
			  	                       totalChargesInr = totalAmount;
			  	    	            }	
			  	                    
			  	            	    if (json.some(e => e.ChargeGroup == chargesgrouping)) {
				  	            		/*totalCharges = json.map(item => {
						                    if (item.ChargeGroup == chargesgrouping) {
						                      	 return {
						                      	    ...item,
						                         USD:  item.USD + totalChargesUsd,
						                     	 INR:  item.INR + totalChargesInr
						                      	};
						                     }
						                     return item;
						               });*/
			  	            	    	totalCharges = totalChargesSummary(json,chargesgrouping,totalChargesUsd,totalChargesInr);
				  	            		json = totalCharges;
				  	            	}else{
				  	            		/* vendors contains the element we're looking for */
					  	            	    var itemObject = {};
					  	            	    itemObject["ChargeGroup"] = chargesgrouping;
					  	            	    itemObject["USD"] = totalChargesUsd;
					  	            	    itemObject["INR"] = totalChargesInr;
					  	            	    json.push(itemObject);		
					  	            	    
					  	            }
			  	          	      
			  	            	    totalAmount = parseFloat(totalAmount.toFixed(2));
			  	            	     	
					  	            tRowsCharges = tRowsCharges + '<tr><td>'+chargesgrouping+'</td><td>'+chargestype+'</td><td>'+currency+'</td><td>'+rate+'</td><td>'+basis+'</td><td>'+quantity+'</td><td>'+totalAmount.toFixed(2)+'</td></tr>';		  	            	
			  	                 }
			  	            }
		  	            	
		  	            	$('#tbodyBookingChargesPopUpId').append(tRowsCharges);
		  	            	var chargeSummary = '';
		  	      	        if(json != null){
		  	      		    var totalUsd = 0;
		  	      		    var totalInr = 0;
		  	              	for(var i=0; i< json.length ; i++){
		  	                      var chargesGrouping = json[i].ChargeGroup;
		  	                      var usdAmount = json[i].USD;
		  	                      var inrAmount = json[i].INR;
		  	                      totalUsd = totalUsd + usdAmount;
		  	                      totalInr = totalInr + inrAmount;
		  	                      chargeSummary = chargeSummary + '<tr><td class="text-left">'+chargesGrouping+'</td>'
		  	                                                    + '<td class="text-right">'+usdAmount.toFixed(2)+'</td>'
		  	                                                    + '<td class="text-right">'+inrAmount.toFixed(2)+'</td></tr>';
		  	                  }
		  	              	chargeSummary = chargeSummary + '<tr><td class="text-left"><b>Total Amount</b></td>'
		  	                  + '<td class="text-right"><b>'+totalUsd.toFixed(2)+'</b></td>'
		  	                  + '<td class="text-right"><b>'+totalInr.toFixed(2)+'</b></td></tr>';
		  	              }
		  	      	    $('#tbodyBkSummaryChargesPopUpId').empty();
		  	      	    $('#tbodyBkSummaryChargesPopUpId').append(chargeSummary);
		  	            	$("#bkDestReqInfoLbl").text(response.respData.origincode+" "+response.respData.destinationcode);
		  	            	
	    				    $("#user_booking_details").modal('show'); 	
	    				    $('#loader').hide();           		             	       
		  	            }else{
		  		            errorBlock("#error_block",response.respData)
		  		            
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

/*-----------------User Enquiry Accepted---------------------------------*/	

/******************************************************************************/	
/******************************************************************************/
/******************************************************************************/
	
/*****************Start Forwarder functions ***********************************/
	
	 function getForwarderEnquiryCountByStatus(userId,shipmentType){
		    $('#loader').show();
		  	$.ajax({
		  			
		  		     type: 'GET', 
		               url : server_url+'forwarder/getForwarderEnquiryCountByStatus',	     
		               enctype: 'multipart/form-data',
		               headers: authHeader,
		               processData: false,
		               contentType: false,
		               "scrollX": true,

		               data: "userId=" + userId + "&shipmentType=" + shipmentType,
		      
		               success : function(response) {

		  	           console.log(response)
		  	 	        	
		  	            if(response.respCode == 1){  		            

		  	            	$("#eqRequestCount").text(response.respData.requestCount);
		  	            	$("#eqAcceptedCount").text(response.respData.acceptedCount);
		  	            	$("#eqCancelledCount").text(response.respData.cancelledCount);
		  	            	$("#eqRejectedCount").text(response.respData.rejectedCount);
		  	            	 	            		             	       
		  	            }else{
		  		            errorBlock("#error_block",response.respData)
		  		            
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
		  	              $('#loader').show();
		               }
		      })
		  }  
	 
     function getForwarderBookingCountByStatus(userId,shipmentType){
	    $('#loader').show();
	  	$.ajax({
	  			
	  		     type: 'GET', 
	               url : server_url+'forwarder/getForwarderBookingCountByStatus',	     
	               enctype: 'multipart/form-data',
	               headers: authHeader,
	               processData: false,
	               contentType: false,

	               data: "userId=" + userId + "&shipmentType=" + shipmentType,
	      
	               success : function(response) {

	  	           console.log(response)
	  	 	        	
	  	            if(response.respCode == 1){  		            

	  	            	$("#bkRequestCount").text(response.respData.requestCount);
	  	            	$("#bkAcceptedCount").text(response.respData.acceptedCount);
	  	            	$("#bkCancelledCount").text(response.respData.cancelledCount);
	  	            	$("#bkRejectedCount").text(response.respData.rejectedCount);
	  	            	 	            		             	       
	  	            }else{
	  		            errorBlock("#error_block",response.respData)
	  		            
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
     
/*------------------------Get All Forwarder Enquiry List-------------------------------*/
     
     function getForwarderEnquiryDetailsAllList(userId,shipmentType,enquiryStatus){
 		
 		$("#enquiryUserTableContId").hide();
		$("#bookingUserTableContId").hide();
		$("#bookingForwarderTableContId").hide();
		$("#enquiryForwarderTableContId").show();

 		$('#loader').show();
 		
 		var tableId = "Enquiry_Forwarder_table";  

 	  	$.ajax({
 	  			
 	  		     type: 'GET', 
 	               url : server_url+'forwarder/getForwarderEnquiryList',	     
 	               enctype: 'multipart/form-data',
 	               headers: authHeader,
 	               processData: false,
 	               contentType: false,
 	               
 	               data : "userId="+userId+"&shipmentType="+shipmentType+"&enquiryStatus="+enquiryStatus,
 	     	      
 	               success : function(response) {

 	  	           console.log(response)
 	  	 	        	
 	  	            if(response.respCode == 1){  
 		  	            		            
 	  	            	loadForwarderEnquiryListTable(response.respData,tableId);
 	  	            	generateFilterDataArrayListFromEnquiry(response.respData);  
 	  	            	prepareCustomerFilter(customerFilterArray); 	
 	  	            	prepareForwarderFilter(forwarderFilterArray);
 	  	            	prepareOriginFilter(originFilterArray);
 		  		        prepareDestinationFilter(destinationFilterArray);      
 		  		              		             	       
 	  	            }else{
 	  		            errorBlock("#error_block",response.respData)
 	  		            loadForwarderEnquiryListTable(null,tableId);
 	                  }
 	  	             $('#loader').hide();
 	               },
 	               error: function (error) {
 	  	                console.log(error)
 	                      if( error.responseJSON != undefined){
 	                    	  loadForwarderEnquiryListTable(null,tableId);
 	   	                   errorBlock("#error_block",error.responseJSON.respData);
 	                      }else{
 	                    	  loadForwarderEnquiryListTable(null,tableId);
 	   	                   errorBlock("#error_block","Server Error! Please contact administrator");
 	                      }         
 	  	               $('#loader').hide();
 	               }
 	      })
 	  }
     
     function loadForwarderEnquiryListTable(data, tableId) {

    	  $('#' + tableId).dataTable().fnClearTable();
    	  var shipType = "";
    	  var oTable = $('#' + tableId).DataTable({
    	    /* 'responsive': true, */
    	    "destroy": true,
    	    "data": data,
    	    "dom": 'lBfrtip',
    	    "scrollX": true,
    	    "autoWidth": true,
    	    "lengthChange": true,
    	    "buttons": [{
    	        extend: 'pdf',
    	        filename: 'forwader_enquiry_data_pdf',
    	        title: "",
    	        text: '<i class="fa fa-file-pdf-o"></i>',
    	        titleAttr: 'Download PDF',
    	        exportOptions: {
    	          columns: [0, 1, 2, 3, 4, 5, 6, 7, 8]
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
    	        filename: 'forwader_enquiry_data_xsl',
    	        title: "",
    	        text: '<i class="fa fa-file-excel"></i>',
    	        titleAttr: 'Download Excel',
    	        exportOptions: {
    	          columns: [0, 1, 2, 3, 4, 5, 6, 7, 8]
    	        }
    	        /* messageTop: "User Enquiry Data" */
    	      },
    	    ],
    	    "columnDefs": [
    	      /* origin */
    	      {
    	        "targets": 0,
    	        "className": "dt-body-left",
    	        "width": "10%",
    	      },
    	      /* destination */
    	      {
    	        "targets": 1,
    	        "className": "dt-body-left",
    	        "width": "10%",
    	      },
    	      /* imp exp */
    	      {
    	        "targets": 2,
    	        "className": "dt-body-left",
    	        render: function (data, type, row) {
    	          return data.substr(0, 2);
    	        }
    	      },
    	      /* date */
    	      {
    	        "targets": 3,
    	        "className": "dt-body-center",
    	        "width": "9%",
    	      },
    	      /* category */
    	      {
    	        "targets": 4,
    	        "className": "dt-body-center",
    	        "width": "8%",
    	      },
    	      /* FCL LCL */
    	      {
    	        "targets": 5,
    	        "className": "dt-body-center",
    	        "width": "6%",
    	      },
    	      /* container */
    	      {
    	        "targets": 6,
    	        "className": "text-left",
    	      },
    	      /* weight */
    	      {
    	        "targets": 7,
    	        "className": "dt-body-right",
    	        "width": "5%",
    	      },
    	      /* volume */
    	      {
    	        "targets": 8,
    	        "className": "dt-body-right",
    	      },
    	      /* ready date */
    	      {
    	        "targets": 9,
    	        "className": "dt-body-center",
    	        "width": "9%",
    	      },
    	      /* status */
    	      {
    	        "targets": 10,
    	        "className": "dt-body-center",
    	        "width": "8%",
    	      },
    	      /* action */
    	      {
    	        "targets": 11,
    	        "className": "text-center",
    	        "width": "15%",
    	      }
    	    ],
    	    "columns": [

    	      {
    	        "data": null,
    	        sortable: true,
    	        render: function (data, type, row) {
    	          var originwithcode = data.origin;

    	          return originwithcode;
    	        }

    	      },
    	      {
    	        "data": null,
    	        sortable: true,
    	        render: function (data, type, row) {
    	          var destinationwithcode = data.destination;

    	          return destinationwithcode;
    	        }
    	      },
    	      {

    	        "data": null,
    	        sortable: true,
    	        render: function (data, type, row) {
    	          //var enquiryreference = data.enquiryreference;
    	          var customer = data.customer;
    	          return customer;
    	        }
    	      },
    	      {
    	        "data": null,
    	        sortable: true,
    	        render: function (data, type, row) {
    	          var searchdate = data.searchdate.split(" ");

    	          return searchdate[0];
    	        }
    	      },

    	      {
    	        "data": null,
    	        sortable: true,
    	        render: function (data, type, row) {
    	          var cargocategory = data.cargocategory;

    	          return cargocategory;
    	        }
    	      },
    	      {
    	        "data": null,
    	        sortable: true,
    	        render: function (data, type, row) {
    	          var shipmentType = data.shipmenttype;
    	          shipType = data.shipmenttype;
    	          return shipmentType;

    	        }
    	      },
    	      {
    	        "data": null,
    	        sortable: true,
    	        render: function (data, type, row) {
    	          var selectedfcl = data.selectedfcl;
    	          return selectedfcl;
    	        }
    	      },
    	      {
    	        "data": null,
    	        sortable: true,
    	        render: function (data, type, row) {
    	          var lcltotalweight = data.lcltotalweight;   	         
    	          return lcltotalweight;
    	        }
    	      },
    	      {
    	        "data": null,
    	        sortable: true,
    	        render: function (data, type, row) {
    	          var lclvolume = data.lclvolume;    	         
    	          return lclvolume;
    	        }
    	      },
    	      {
    	        "data": null,
    	        sortable: true,
    	        render: function (data, type, row) {
    	          var cargoreadydate = data.cargoreadydate;
    	          return cargoreadydate;
    	        }

    	      },
    	      {

    	        "data": null,
    	        sortable: true,
    	        render: function (data, type, row) {
    	          var status = data.status;
    	          return status;

    	        }

    	      },
    	      {

    	        "data": null,
    	        sortable: true,
    	        render: function (data, type, row) {
    	          var id = data.id;

    	          //Status 
    	          var status = data.status;
    	          var isscheduleupload = data.isscheduleupload;
    	          var ischargesupload = data.ischargesupload;

    	          var scheduleDisClass = '';
    	          var chargeDisClass = '';

    	          var viewDisClass = '';
    	          var submitDisClass = '';

    	          var cancelDisClass = '';

    	          if (status == 'Requested') {
    	            scheduleDisClass = '';
    	            chargeDisClass = '';

    	            viewDisClass = '';

    	            if (isscheduleupload == "Y" && ischargesupload == "Y") {
    	              submitDisClass = '';
    	            } else {
    	              submitDisClass = 'disabled';
    	            }

    	            cancelDisClass = '';
    	          }
    	          if (status == 'Accepted') {
    	            scheduleDisClass = 'disabled';
    	            chargeDisClass = 'disabled';

    	            viewDisClass = '';
    	            submitDisClass = 'disabled';

    	            cancelDisClass = 'disabled';
    	          }
    	          if (status == 'Cancelled') {
    	            scheduleDisClass = 'disabled';
    	            chargeDisClass = 'disabled';

    	            viewDisClass = '';
    	            submitDisClass = 'disabled';

    	            cancelDisClass = 'disabled';
    	          }
    	          if (status == 'Rejected') {
    	            scheduleDisClass = 'disabled';
    	            chargeDisClass = 'disabled';

    	            viewDisClass = '';
    	            submitDisClass = 'disabled';

    	            cancelDisClass = 'disabled';
    	          }

    	          scheduleDisClass = 'disabled';
    	          chargeDisClass = 'disabled';
    	          submitDisClass = 'disabled';
    	          cancelDisClass = 'disabled';

    	          var accept = "Accepted";
    	          var cancel = "Cancelled";

    	          return '<button type="button" value="Update" class="update_btn actbtn ' + scheduleDisClass + '" data-title-placement="right" data-title="Update Schedule" onclick="updateEnquirySchedule(\'' + id + '\');" ' + scheduleDisClass + '><i class="fas fa-pencil-alt"></i></button>'
    	            + '<button type="button" value="Update" class="chrg_btn actbtn ' + chargeDisClass + '" data-placement="right" data-title="Update Charges" onclick="updateEnquiryCharges(\'' + id + '\');" ' + chargeDisClass + '><i class="fas fa-pencil-alt"></i></button>'
    	            + '<button type="button" value="V" class="view_btn actbtn ' + viewDisClass + '" data-placement="right" data-title="View" onclick="viewEnquiryScheduleChargesDetailsById(\'' + id + '\');" ' + viewDisClass + '><i class="fas fa-eye"></i></button>'
    	            + '<button type="button" value="Submit" class="green_sub actbtn ' + submitDisClass + '"  data-placement="right"data-title="Submit" onclick="updateEnquiryStatus(\'' + id + '\',\'' + accept + '\');" ' + submitDisClass + '> <i class="fas fa-check-circle"></i></button>'
    	            + '<button type="button"  value="C" data-placement="right" data-title="Cancel"  onclick="updateEnquiryStatus(\'' + id + '\',\'' + cancel + '\');" class="can_btn actbtn ' + cancelDisClass + '" ' + cancelDisClass + '><i class="fas fa-times"></i></button>';

    	        }

    	      }

    	    ],
    	    "order": [
    	      [3, "desc"]
    	    ],

    	  });
    	  if (shipType == "FCL" && shipType != "") {
    	    oTable.column(7).visible(false);
    	    oTable.column(8).visible(false);
    	  } else if (shipType == "LCL" && shipType != "") {
    	    oTable.column(6).visible(false);
    	  }
    	}
     
     function getForwarderBookingDetailsAllList(userId,shipmentType,bookingStatus){

 		    $("#enquiryUserTableContId").hide();
		    $("#bookingUserTableContId").hide();		   
		    $("#enquiryForwarderTableContId").hide();
			$("#bookingForwarderTableContId").show();
			
			$('#loader').show();
			var tableId = "Booking_Forwarder_table";  

		  	$.ajax({
		  			
		  		     type: 'GET', 
		               url : server_url+'forwarder/getForwarderBookingList',	     
		               enctype: 'multipart/form-data',
		               headers: authHeader,
		               processData: false,
		               contentType: false,
		               "scrollX": true,

		               data : "userId="+userId+"&shipmentType="+shipmentType+"&bookingStatus="+bookingStatus,
		      
		               success : function(response) {

		  	           console.log(response)
		  	 	        	
		  	            if(response.respCode == 1){  		    
			  	                    
		  		          loadForwarderBookingListTable(response.respData,tableId); 	
		  		          generateFilterDataArrayListFromBooking(response.respData); 
		  		          prepareCustomerFilter(customerFilterArray);   
		  		          prepareForwarderFilter(forwarderFilterArray);
		  		          prepareOriginFilter(originFilterArray);
		  		          prepareDestinationFilter(destinationFilterArray);      
		  		              		             	       
		  	            }else{
		  		            errorBlock("#error_block",response.respData)
		  		            loadForwarderBookingListTable(null,tableId);
		                  }
		  	            $('#loader').hide();
		               },
		               error: function (error) {
		  	                console.log(error)
		                      if( error.responseJSON != undefined){
		                    	  loadForwarderBookingListTable(null,tableId);
		   	                   errorBlock("#error_block",error.responseJSON.respData);
		                      }else{
		                    	  loadForwarderBookingListTable(null,tableId);
		   	                   errorBlock("#error_block","Server Error! Please contact administrator");
		                      }         
		  	                $('#loader').hide();
		               }
		      })
		  }
     
     function loadForwarderBookingListTable(data, tableId) {

    	  $('#' + tableId).dataTable().fnClearTable();

    	  var oTable = $('#' + tableId).DataTable({
    	    /* 'responsive': true, */
    	    "destroy": true,
    	    "data": data,
    	    "dom": 'lBfrtip',
    	    "scrollX": true,
    	    "autoWidth": true,
    	    "lengthChange": true,
    	    "buttons": [{
    	        extend: 'pdf',
    	        filename: "forwader_booking_data_pdf",
    	        title: "",
    	        text: '<i class="fa fa-file-pdf-o"></i>',
    	        titleAttr: 'Download PDF',
    	        exportOptions: {
    	          columns: [0, 1, 2, 3, 4, 5, 6, 7, 8]
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
    	        orientation: 'landscape',
    	        pageSize: 'LEGAL'
    	        /* messageTop: "User Enquiry Data" */
    	      },
    	      {
    	        extend: 'excel',
    	        filename: "forwader_booking_data_xsl",
    	        title: "",
    	        text: '<i class="fa fa-file-excel"></i>',
    	        titleAttr: 'Download Excel',
    	        exportOptions: {
    	          columns: [0, 1, 2, 3, 4, 5, 6, 7, 8]
    	        }
    	        /* messageTop: "User Enquiry Data" */
    	      },
    	    ],
    	    "columnDefs": [
    	      /* origin */
    	      {
    	        "targets": 0,
    	        "className": "dt-body-left",
    	        "width": "10%",
    	      },
    	      /* destination */
    	      {
    	        "targets": 1,
    	        "className": "dt-body-left",
    	        "width": "10%",
    	      },
    	      /* imp exp */
    	      {
    	        "targets": 2,
    	        "className": "dt-body-left",
    	        "width": "15%",
    	      },
    	      /* book date */
    	      {
    	        "targets": 3,
    	        "className": "dt-body-center",
    	        "width": "8%",
    	      },
    	      /* ref */
    	      {
    	        "targets": 4,
    	        "className": "dt-body-center",
    	        "width": "10%",
    	      },
    	      /* cut date */
    	      {
    	        "targets": 5,
    	        "className": "dt-body-center",
    	        "width": "8%",
    	      },
    	      /* status */
    	      {
    	        "targets": 6,
    	        "className": "dt-body-center",
    	        "width": "8%",
    	      },
    	      /*action*/
    	      {
    	        "targets": 7,
    	        "className": "text-center",
    	        "width": "10%",
    	      }
    	    ],
    	    "columns": [

    	      {
    	        "data": null,
    	        sortable: true,
    	        render: function (data, type, row) {
    	          var originwithcode = data.originwithcode;

    	          return originwithcode;

    	        }
    	      },
    	      {
    	        "data": null,
    	        sortable: true,
    	        render: function (data, type, row) {
    	          var destinationwithcode = data.destinationwithcode;

    	          return destinationwithcode;

    	        }
    	      },
    	      {
    	        "data": null,
    	        sortable: true,
    	        render: function (data, type, row) {
    	          var forwarder = data.forwarder;
    	          return forwarder;

    	        }
    	      },
    	      {

    	        "data": null,
    	        sortable: true,
    	        render: function (data, type, row) {
    	          var bookingdate = data.bookingdate.split(" ");
    	          return bookingdate[0];

    	        }

    	      },
    	      {

    	        "data": null,
    	        sortable: true,
    	        render: function (data, type, row) {
    	          var id = data.id;
    	          var bookingreff = data.bookingreff;
    	          return '<u><a href="#" onclick="getForwarderBookingDetailsById(\'' + bookingreff + '\');" class="book_link">' + bookingreff + '</a></u>';

    	        }
    	      },
    	      {

    	        "data": null,
    	        sortable: true,
    	        render: function (data, type, row) {
    	          var cutoffdate = data.cutoffdate;
    	          return cutoffdate;

    	        }

    	      },
    	      {

    	        "data": null,
    	        sortable: true,
    	        render: function (data, type, row) {
    	          var status = data.bookingstatus;
    	          return status;

    	        }

    	      },
    	      {

    	        "data": null,
    	        sortable: true,
    	        render: function (data, type, row) {
    	          var id = data.id;
    	          var status = data.bookingstatus;

    	          var submitDisClass = '';
    	          var cancelDisClass = '';
    	          var rejectDisClass = '';

    	          if (status == 'Requested') {
    	            submitDisClass = '';
    	            cancelDisClass = '';
    	            rejectDisClass = '';
    	          }
    	          if (status == 'Accepted') {
    	            submitDisClass = 'disabled';
    	            cancelDisClass = 'disabled';
    	            rejectDisClass = 'disabled';
    	          }
    	          if (status == 'Cancelled') {
    	            submitDisClass = 'disabled';
    	            cancelDisClass = 'disabled';
    	            rejectDisClass = 'disabled';
    	          }
    	          if (status == 'Rejected') {
    	            submitDisClass = 'disabled';
    	            cancelDisClass = 'disabled';
    	            rejectDisClass = 'disabled';
    	          }

    	          submitDisClass = 'disabled';
    	          cancelDisClass = 'disabled';
    	          rejectDisClass = 'disabled';

    	          var pending = "Pending";
    	          var accept = "Accepted";
    	          var reject = "Rejected";
    	          var cancel = "Cancelled";

    	          return '<button title="Accept" type="button" value="A" onclick="updateBookingStatus(\'' + id + '\',\'' + accept + '\');"class="green_sub ' + submitDisClass + '" ' + submitDisClass + '><i class="fas fa-check-circle"></i></button>'
    	            + '<button title="Cancel" type="button"  value="C"  onclick="updateBookingStatus(\'' + id + '\',\'' + cancel + '\');" class="can_btn ' + cancelDisClass + '" ' + cancelDisClass + '><i class="fas fa-times"></i></button>'
    	            + '<button title="Reject" type="button"  value="R" onclick="updateBookingStatus(\'' + id + '\',\'' + reject + '\');" class="rej_btn ' + rejectDisClass + '" ' + rejectDisClass + '><i class="fas fa-times-circle"></i></button>';


    	        }

    	      }


    	    ],
    	    "order": [
    	      [3, "desc"]
    	    ],

    	  });

    	}
     
     function viewEnquiryScheduleChargesDetailsById(id){
    	 var userEntityId =  $('#userEntityId :selected').val();
		   $('#loader').show();
	       $.ajax({
				
			   type: 'GET', 
	           url : server_url+'forwarder/getForwEnqScheduleChargeDetailsById',	     
	           enctype: 'multipart/form-data',
	           headers: authHeader,
	           processData: false,
	           contentType: false,
	           data : "id="+id+"&userId="+userEntityId,
	                     	      
	           success : function(response) {
		           console.log(response)
		 	        	$('#loader').hide();
		            if(response.respCode == 1){  
			            		  
		            	 $("#enqReffLbl").text(response.respData.enquiryreference);
		            	 $("#enqOriginLbl").text(response.respData.origin);
		            	 $("#enqDestinationLbl").text(response.respData.destination);
		            	 $("#enqScheduleTypeLbl").text(response.respData.scheduletype);
		            	
		            	 var numberLegs = response.respData.numberoflegs;
		            	 var legs = "";
		                 if(numberLegs == 0){
		                     legs = "Direct";
		                 }else{
		                	 legs = numberLegs; 
		         	     }
		            	 $("#enqNoOfLegsLbl").text(legs);
		            	 
		            	 $("#enqCargoCatLbl").text(response.respData.cargocategory);
		            	 $("#enqFclLclLbl").text(response.respData.shipmenttype);
		            	 $("#enqEnquiryStatusLbl").text(response.respData.status);
		            	 $("#enqIncotermLbl").text(response.respData.incoterm);
		            	 $('#tbodyEnquiryDetailsPopUpId').empty();
		  	             $('#tbodyEnquiryChargesPopUpId').empty();
		  	            	
		            	 var trBody = '';
		            	 
		            	if(response.respData.scheduleLegsResponseList != null){		            		
			            	for(var i=0; i< response.respData.scheduleLegsResponseList.length ; i++){
			            		var transittime = response.respData.scheduleLegsResponseList[i].transittime;
				            	var daysLable = ""
						  	    if(transittime > 1){
						  	        daysLable = "Days";
							  	}else{
							  	    daysLable = "Day";
								}
					  	        transittime = transittime+" "+daysLable;
					  	            
			            		trBody = trBody + '<tr><td>'+response.respData.scheduleLegsResponseList[i].origin+'</td>'+
			                    '<td>'+response.respData.scheduleLegsResponseList[i].destination+'</td>'+
			            	    '<td>'+response.respData.scheduleLegsResponseList[i].mode+'</td>'+
			                    '<td>'+response.respData.scheduleLegsResponseList[i].carrier+'</td>'+
			                    '<td>'+response.respData.scheduleLegsResponseList[i].vessel+'</td>'+
			                    '<td>'+response.respData.scheduleLegsResponseList[i].voyage+'</td>'+
			                    '<td>'+transittime+'</td>'+
			                    '<td>'+response.respData.scheduleLegsResponseList[i].etddate+'</td>'+
			                    '<td>'+response.respData.scheduleLegsResponseList[i].etadate+'</td></tr>';
				            }	            		
			            }
			            $('#tbodyEnquiryDetailsPopUpId').append(trBody);	        	 

                      var tRowsCharges = '';
                      var json = [];
	  	                var totalCharges = [];
	  	            	if(response.respData.chargesRateResponseList != null){
	  	            	   for(var i = 0 ;i<response.respData.chargesRateResponseList.length ;i++){
		  	            	  var chargesgrouping = response.respData.chargesRateResponseList[i].chargesgrouping;
		  	            	  var chargestype = response.respData.chargesRateResponseList[i].chargestype;
		  	            	  var currency = response.respData.chargesRateResponseList[i].currency;
		  	            	  var rate = response.respData.chargesRateResponseList[i].rate;
		  	            	  var basis = response.respData.chargesRateResponseList[i].basis;
		  	            	  var quantity = response.respData.chargesRateResponseList[i].quantity;
		  	            	  var totalAmount = rate * quantity;
		  	            	var totalChargesUsd = 0;
	  	                    var totalChargesInr = 0;
	  	                
	  	            	    if(currency == "USD"){
	  	            		   totalChargesUsd = totalAmount;
	  	                    }else if(currency == "INR"){
	  	                       totalChargesInr = totalAmount;
	  	    	            }	
	  	                    
	  	            	    if (json.some(e => e.ChargeGroup == chargesgrouping)) {
		  	            		/*totalCharges = json.map(item => {
				                    if (item.ChargeGroup == chargesgrouping) {
				                      	 return {
				                      	    ...item,
				                         USD:  item.USD + totalChargesUsd,
				                     	 INR:  item.INR + totalChargesInr
				                      	};
				                     }
				                     return item;
				               });*/
	  	            	    	totalCharges = totalChargesSummary(json,chargesgrouping,totalChargesUsd,totalChargesInr);
		  	            		json = totalCharges;
		  	            	}else{
		  	            		/* vendors contains the element we're looking for */
			  	            	    var itemObject = {};
			  	            	    itemObject["ChargeGroup"] = chargesgrouping;
			  	            	    itemObject["USD"] = totalChargesUsd;
			  	            	    itemObject["INR"] = totalChargesInr;
			  	            	    json.push(itemObject);	
			  	            	    
			  	            }
		  	            	  totalAmount = parseFloat(totalAmount.toFixed(2));  
		  	            	  
				  	          tRowsCharges = tRowsCharges + '<tr><td>'+chargesgrouping+'</td><td>'+chargestype+'</td><td>'+currency+'</td><td>'+rate+'</td><td>'+basis+'</td><td>'+quantity+'</td><td>'+totalAmount.toFixed(2)+'</td></tr>';		  	            	
		  	               }
	  	            	}
	  	            	
	  	            	$('#tbodyEnquiryChargesPopUpId').append(tRowsCharges);
	  	            	var chargeSummary = '';
	  	      	        if(json != null){
	  	      		    var totalUsd = 0;
	  	      		    var totalInr = 0;
	  	              	for(var i=0; i< json.length ; i++){
	  	                      var chargesGrouping = json[i].ChargeGroup;
	  	                      var usdAmount = json[i].USD;
	  	                      var inrAmount = json[i].INR;
	  	                      totalUsd = totalUsd + usdAmount;
	  	                      totalInr = totalInr + inrAmount;
	  	                      chargeSummary = chargeSummary + '<tr><td class="text-left">'+chargesGrouping+'</td>'
	  	                                                    + '<td class="text-right">'+usdAmount.toFixed(2)+'</td>'
	  	                                                    + '<td class="text-right">'+inrAmount.toFixed(2)+'</td></tr>';
	  	                  }
	  	              	chargeSummary = chargeSummary + '<tr><td class="text-left"><b>Total Amount</b></td>'
	  	                  + '<td class="text-right"><b>'+totalUsd.toFixed(2)+'</b></td>'
	  	                  + '<td class="text-right"><b>'+totalInr.toFixed(2)+'</b></td></tr>';
	  	              }
	  	      	      $('#tbodyEnqSummaryChargesPopUpId').empty();
	  	      	      $('#tbodyEnqSummaryChargesPopUpId').append(chargeSummary);
	  	            	$("#bkDestReqInfoLbl").text(response.respData.origincode+" "+response.respData.destinationcode);	            
		            	$("#view_enq_schedule_charges_details").modal('show');	  	
		            		          	            		             	       
		            }else{
			            errorBlock("#error_block",response.respData)		            
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
     
     function getForwarderBookingDetailsById(bookingreff){
		 getForwarderBookingDetailsByBookingReff(bookingreff);
     }

	 function getForwarderBookingDetailsByBookingReff(bookingReff){
			$('#loader').show();
		  	$.ajax({
		  			
		  		     type: 'GET', 
		               url : server_url+'forwarder/getForwarderBookingDetailsById?bookingReff='+bookingReff,	     
		               enctype: 'multipart/form-data',
		               headers: authHeader,
		               processData: false,
		               contentType: false,
		               "scrollX": true,

		               data : null,
		      
		               success : function(response) {

		  	           console.log(response)
		  	           $('#loader').hide();
		  	 	        	
		  	            if(response.respCode == 1){  		            

		  	            	//booking reff
		  	            	$("#bkBookingReffLbl_FF").text(response.respData.bookingreff);
		  	            	
		  	            	$("#bkBookByLbl_FF").text(response.respData.bookedby);
		  	            	$("#bkCargoReadyDateLbl_FF").text(response.respData.cargoreadydate);
		  	            	$("#bkDateOfBookingLbl_FF").text(response.respData.dateofbooking);
		  	            	$("#bkBookingStatusLbl_FF").text(response.respData.bookingstatus);

		  	                //booking party
		  	            	$("#bkBookingPartyLbl_FF").text(response.respData.bookingparty);

		  	                //schedule details
		  	            	$("#bkBookingDateLbl_FF").text(response.respData.bookingdate);
	  	            	    $("#bkOriginLbl_FF").text(response.respData.origin);
	  	            	    $("#bkDestinationLbl_FF").text(response.respData.destination);
	  	            	    $("#bkCutOffDateLbl_FF").text(response.respData.cutoffdate);
	  	            	    $("#bkIncotermLbl_FF").text(response.respData.incoterm);
	  	            	    $('#tbodyBookingDetailsPopUpId_FF').empty();
		  	            	$('#tbodyBookingChargesPopUpId_FF').empty();
	  	            	    
	  	            	  var tRows = '';
	  	            	  if(response.respData.scheduleLegsResponse != null){
		  	            	 
		  	            	for(var i = 0 ;i<response.respData.scheduleLegsResponse.length ;i++){
			  	            	var org = response.respData.scheduleLegsResponse[i].origin;
			  	            	var dest = response.respData.scheduleLegsResponse[i].destination;
			  	            	var mode = response.respData.scheduleLegsResponse[i].mode;
			  	            	var carrier = response.respData.scheduleLegsResponse[i].carrier;
			  	            	var vessel = response.respData.scheduleLegsResponse[i].vessel;
			  	            	var voyage = response.respData.scheduleLegsResponse[i].voyage;
			  	            	var etddate = response.respData.scheduleLegsResponse[i].etddate;
				  	            var etadate = response.respData.scheduleLegsResponse[i].etadate;
					  	        var transittime = response.respData.scheduleLegsResponse[i].transittime;
			  	            	
					  	        var daysLable = ""
						  	    if(transittime > 1){
						  	        daysLable = "Days";
							  	}else{
							  	    daysLable = "Day";
								}
					  	        transittime = transittime+" "+daysLable;
					  	        
		  	            		tRows = tRows + '<tr><td>'+org+'</td><td>'+dest+'</td><td>'+mode+'</td><td>'+carrier+'</td><td>'+vessel+'</td><td>'+voyage+'</td><td>'+transittime+'</td><td>'+etddate+'</td><td>'+etadate+'</td></tr>';		  	            	
			  	            }
	  	            	 }
		  	            	$('#tbodyBookingDetailsPopUpId_FF').append(tRows);

		  	            	var tRowsCharges = '';
		  	            	var json = [];
		  	                var totalCharges = [];
		  	            	if(response.respData.chargesRateResponseList != null){
		  	            	    for(var i = 0 ;i<response.respData.chargesRateResponseList.length ;i++){
			  	            	    var chargesgrouping = response.respData.chargesRateResponseList[i].chargesgrouping;
			  	            	    var chargestype = response.respData.chargesRateResponseList[i].chargestype;
			  	            	    var currency = response.respData.chargesRateResponseList[i].currency;
			  	            	    var rate = response.respData.chargesRateResponseList[i].rate;
			  	            	    var basis = response.respData.chargesRateResponseList[i].basis;
			  	            	    var quantity = response.respData.chargesRateResponseList[i].quantity;
			  	            	    var totalAmount = rate * quantity;
			  	            	    var totalChargesUsd = 0;
			  	                    var totalChargesInr = 0;
			  	                
			  	            	    if(currency == "USD"){
			  	            		   totalChargesUsd =  totalAmount;
			  	                    }else if(currency == "INR"){
			  	                       totalChargesInr =  totalAmount;
			  	    	            }	
			  	                    
			  	            	    if (json.some(e => e.ChargeGroup == chargesgrouping)) {
				  	            		/*totalCharges = json.map(item => {
						                    if (item.ChargeGroup == chargesgrouping) {
						                      	 return {
						                      	    ...item,
						                         USD:  item.USD + totalChargesUsd,
						                     	 INR:  item.INR + totalChargesInr
						                      	};
						                     }
						                     return item;
						               });*/
			  	            	    	totalCharges = totalChargesSummary(json,chargesgrouping,totalChargesUsd,totalChargesInr);
				  	            		json = totalCharges;
				  	            	}else{
				  	            		/* vendors contains the element we're looking for */
					  	            	    var itemObject = {};
					  	            	    itemObject["ChargeGroup"] = chargesgrouping;
					  	            	    itemObject["USD"] = totalChargesUsd;
					  	            	    itemObject["INR"] = totalChargesInr;
					  	            	    json.push(itemObject);	
					  	            	    
					  	            }
			  	            	    totalAmount = parseFloat(totalAmount.toFixed(2));
					  	            
			  	            	    tRowsCharges = tRowsCharges + '<tr><td>'+chargesgrouping+'</td><td>'+chargestype+'</td><td>'+currency+'</td><td>'+rate+'</td><td>'+basis+'</td><td>'+quantity+'</td><td>'+totalAmount.toFixed(2)+'</td></tr>';		  	            	
			  	                }
		  	            	} 
		  	            	$('#tbodyBookingChargesPopUpId_FF').append(tRowsCharges);
		  	            	var chargeSummary = '';
		  	      	        if(json != null){
		  	      		    var totalUsd = 0;
		  	      		    var totalInr = 0;
		  	              	for(var i=0; i< json.length ; i++){
		  	                      var chargesGrouping = json[i].ChargeGroup;
		  	                      var usdAmount = json[i].USD;
		  	                      var inrAmount = json[i].INR;
		  	                      totalUsd = totalUsd + usdAmount;
		  	                      totalInr = totalInr + inrAmount;
		  	                      chargeSummary = chargeSummary + '<tr><td class="text-left">'+chargesGrouping+'</td>'
		  	                                                    + '<td class="text-right">'+usdAmount.toFixed(2)+'</td>'
		  	                                                    + '<td class="text-right">'+inrAmount.toFixed(2)+'</td></tr>';
		  	                  }
		  	              	chargeSummary = chargeSummary + '<tr><td class="text-left"><b>Total Amount</b></td>'
		  	                  + '<td class="text-right"><b>'+totalUsd.toFixed(2)+'</b></td>'
		  	                  + '<td class="text-right"><b>'+totalInr.toFixed(2)+'</b></td></tr>';
		  	              }
		  	      	      $('#tbodyBkSummaryChargesPopUpId_FF').empty();
		  	      	      $('#tbodyBkSummaryChargesPopUpId_FF').append(chargeSummary);
		  	            	$("#bkDestReqInfoLbl_FF").text(response.respData.origincode+" "+response.respData.destinationcode);
		  	            	
	    				    $("#forwarder_booking_details").modal('show'); 	
	    				             		             	       
		  	            }else{
		  		            errorBlock("#error_block",response.respData)
		  		            
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
