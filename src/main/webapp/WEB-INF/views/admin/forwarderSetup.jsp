<%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="ISO-8859-1">
<title>Insert title here</title>
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
	  getForwarderSetupList();
	  loadForwarderCompany();

	  /*  Submit form using Ajax */
	   $("#add-popular-forwarder").submit(function(event) {
		   $('#loader').show();
	      //Prevent default submission of form
	      event.preventDefault();
	      
	      var form_data = {};
	      form_data["forwarderId"] = $("#forwarderAddId").val();
	      form_data["status"] = $("#statusId").val();
	      form_data["startDate"] = $("#startDateId").val(); 
	      form_data["endDate"] = $("#endDateId").val();  	     	   	     
	      form_data["priority"] = $("#priorityId").val();
	     
          $.post({
 	         url : server_url+'admin/addForwarderSetup',
 	         contentType: "application/json",
 	         headers: authHeader,
 	         data : JSON.stringify(form_data), 
 	         success : function(response) {
 	        	if(response.respCode == 1){	        		
 	     	       swal(response.respData.msg);
 	     	       $('#addPopForwarder').modal('hide');
 	     	       getForwarderSetupList();
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

	   $("#update-pop-forwarder").submit(function(event) {
		   $('#loader').show();	
		        
	      event.preventDefault();	
	            
	       var form_data = {};
	       form_data["id"] = $("#setupId").val(); 
	       form_data["userid"] = userInfo.id;  
		   form_data["status"] = $("#statusUpdId").val();
		   form_data["startDate"] = $("#startDateUpdId").val(); 
		   form_data["endDate"] = $("#endDateUpdId").val();  	     	   	     
		   form_data["priority"] = $("#priorityUpdId").val();

		   $.ajax({
			 type: 'PUT',
  	         url : server_url+'admin/updateForwSetupById',
  	         contentType: "application/json",
  	         headers: authHeader,
  	         data : JSON.stringify(form_data), 
  	         success : function(response) {
  	        	if(response.respCode == 1){	        		
  	     	       swal(response.respData.msg);
  	     	       $('#updatePopForwarder').modal('hide');
  	     	       getForwarderSetupList();
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

/* Start Load User role on popup */
function loadForwarderCompany() {
 
	$('#loader').show();
  	$.ajax({
  			
  		     type: 'GET', 
               url : server_url+'admin/getCompanyNameList',	     
               enctype: 'multipart/form-data',
               headers: authHeader,
               processData: false,
               contentType: false,

               data : null,
      
               success : function(response) {

  	           console.log(response)
  	 	       var ddl = document.getElementById("forwarderAddId");
               var option = document.createElement("OPTION"); 	
  	 	        	
  	            if(response.respCode == 1){  		            
  	            	$('#forwarderAddId').empty();	             
	                 option.innerHTML = 'Choose Company';
					 option.value = '0';
					 ddl.options.add(option);
					 
	            	 for(var i=0; i<response.respData.length; i++){										  
	            	    var option = document.createElement("OPTION");
	            	    option.innerHTML = response.respData[i].forwarder;
	            	    option.value = response.respData[i].id;
	            	    ddl.options.add(option);			
	            	 }             		             	       
  	            }else{
  	            	$('#forwarderAddId').empty();
					option.innerHTML = 'No Company available';
				    option.value = '0';
				    ddl.options.add(option);		  	            
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
/* end Load User role on popup */

function getForwarderSetupList(){
	 $('#loader').show();
	  var tableId = "popForwarderTableId";  

	  	$.ajax({
	  			
	  		     type: 'GET', 
	               url : server_url+'admin/getForwarderSetupList',	     
	               enctype: 'multipart/form-data',
	               headers: authHeader,
	               processData: false,
	               contentType: false,
	               data : null,	      
	               success : function(response) {
	  	           console.log(response)	  	 	        	
	  	            if(response.respCode == 1){  		    
	  	            	$('#loader').hide();        
	  		          loadForwarderSetupListTable(response.respData,tableId); 		            		             	       
	  	            }else{
	  		            errorBlock("#error_block",response.respData)
	  		            loadForwarderSetupListTable(null,tableId);
	                  }
	  	             $('#loader').hide();
	               },
	               error: function (error) {
	  	                console.log(error)
	                      if( error.responseJSON != undefined){
	   	                   errorBlock("#error_block",error.responseJSON.respData);
	   	                loadForwarderSetupListTable(null,tableId);
	                      }else{
	   	                   errorBlock("#error_block","Server Error! Please contact administrator");
	                      }         
	  	              $('#loader').hide();
	               }
	      })
	  
}

function loadForwarderSetupListTable(data,tableId){
	$('#'+tableId).dataTable().fnClearTable();
  	
  	var oTable = $('#'+tableId).DataTable({
  		/* 'responsive': true,  */
  	 	"destroy" : true,
  		"data" : data,     	
       "dom": 'lBfrtip',
       "lengthChange": true,
       "buttons": [{
           extend: 'pdfHtml5',
           filename: 'forwader_list_pdf',
           title: "",
           text: '<i class="fas fa-file-pdf"></i>',
           exportOptions: {
             columns: [0, 1, 2, 3, 4, 5]
           },
           customize: function (doc) {
          	 doc.defaultStyle.alignment = 'left';
          	  doc.styles.tableHeader.alignment = 'left';
            doc.content.splice(1, 0, {
              margin: [1, 1, 7, 1],
              alignment: 'left',
              image: 'data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAGQAAAAvCAYAAAAVfW/7AAAAGXRFWHRTb2Z0d2FyZQBBZG9iZSBJbWFnZVJlYWR5ccllPAAAAyRpVFh0WE1MOmNvbS5hZG9iZS54bXAAAAAAADw/eHBhY2tldCBiZWdpbj0i77u/IiBpZD0iVzVNME1wQ2VoaUh6cmVTek5UY3prYzlkIj8+IDx4OnhtcG1ldGEgeG1sbnM6eD0iYWRvYmU6bnM6bWV0YS8iIHg6eG1wdGs9IkFkb2JlIFhNUCBDb3JlIDcuMC1jMDAwIDc5LmRhYmFjYmIsIDIwMjEvMDQvMTQtMDA6Mzk6NDQgICAgICAgICI+IDxyZGY6UkRGIHhtbG5zOnJkZj0iaHR0cDovL3d3dy53My5vcmcvMTk5OS8wMi8yMi1yZGYtc3ludGF4LW5zIyI+IDxyZGY6RGVzY3JpcHRpb24gcmRmOmFib3V0PSIiIHhtbG5zOnhtcD0iaHR0cDovL25zLmFkb2JlLmNvbS94YXAvMS4wLyIgeG1sbnM6eG1wTU09Imh0dHA6Ly9ucy5hZG9iZS5jb20veGFwLzEuMC9tbS8iIHhtbG5zOnN0UmVmPSJodHRwOi8vbnMuYWRvYmUuY29tL3hhcC8xLjAvc1R5cGUvUmVzb3VyY2VSZWYjIiB4bXA6Q3JlYXRvclRvb2w9IkFkb2JlIFBob3Rvc2hvcCAyMi41IChXaW5kb3dzKSIgeG1wTU06SW5zdGFuY2VJRD0ieG1wLmlpZDpGMkUwMTY2QTBGOUExMUVDQjgzOUQ0MUYxMjE5QzNCMCIgeG1wTU06RG9jdW1lbnRJRD0ieG1wLmRpZDpGMkUwMTY2QjBGOUExMUVDQjgzOUQ0MUYxMjE5QzNCMCI+IDx4bXBNTTpEZXJpdmVkRnJvbSBzdFJlZjppbnN0YW5jZUlEPSJ4bXAuaWlkOkYyRTAxNjY4MEY5QTExRUNCODM5RDQxRjEyMTlDM0IwIiBzdFJlZjpkb2N1bWVudElEPSJ4bXAuZGlkOkYyRTAxNjY5MEY5QTExRUNCODM5RDQxRjEyMTlDM0IwIi8+IDwvcmRmOkRlc2NyaXB0aW9uPiA8L3JkZjpSREY+IDwveDp4bXBtZXRhPiA8P3hwYWNrZXQgZW5kPSJyIj8+wLlEcwAAFk1JREFUeNrsW3d8FWXWPjO35qaRhBCkIyhkAQVhRVDARlEXUAQplk9lBeVbrLi6n66iroLY1rUB6ioqYi9gAV0JoAi4gAJKF5YmpCc3ye0zs+e9eSa8eZ0bwM8//IP39zvcYeo7pzznOeedaPmthtBvbWgaUSRhUU3Uou3TCqhzSw+Vlxuk67/+s3KyXDTu1XJ689sQ5We7juXSk1kuYDmPpTtLNkuIZSvLcpaPWb491vm46fg41uFnuZ/lBpYM5VguSxuW81keYHmb5TaWfUd7c/24fo9ptGVZynK7gzGcxhiWZSz9jxvk1x+tWFaz9Etx3Eyx/0SWf7Gcftwgv+54EUY5nOuI9nK+u686YvYrrUwUxk3qY1o0jQ9tVK5NY1nAknncIL/OGMcyrJHidPooFLdOK6k0pg/s4Fs9e0zudp+L1tVGzceCMbMnG+oph0i583hS//8P4bRTGu3QaE0wZA43eHv+FXl0UaGfspmhndneSyHDov/9oMpauyd2Y8scV4Zh0jXSpRNZZrLUHI+QXz66spwp/T8ajls3edkqb43PpQn90ilNp5EVZYlHuhd4Jp9+op/evyqPuhR4qKLGvJEjpVi6tgAM7Dhk/YJhFyXdFD2tDUatNc+OyqGRvTOovDRxS13M+oAVP60ybM4uK0/MadPCQ5NOTyfLpNqESR8o9+153CDHNlqyvMDSQqK68ljNyZw65bC94mYBG+KBRlbUaVJtpXH2xD7p1K21h4tbc51yfWdp+28sZx83SNNF3+fA+mCKPBux+B+fS0sW+izp6k0si/Ky/Rp5+BzejiiH5fNHgBK3lZN6VxQugpKJZ1WzfMOyJcWk/8hyGrY3szyd4rwWqGbb4uXEi37q4C0dWYpYEtJ+D3PKcSzLGar38u+FyX1ES4RCmlBoX+G8LAtx73bYdhoDWFkaubUVQnHJNyeagTbIVmk+Zcp13XhOtGhbhHq282716rQwZtAITWswxq7MZnrRsi1h2l+RoDS3dpJyfYW0vZ+lB8tctGGSETINHPsxlidZnmX5juVxB+8RVerzMKAokAS1W4mWgaqYnSzT0fMZxfIJyyzlvKtYBMY2U3pZC8igV6wqI1ZeY+Syaj7mfR+g8k01AixfCOIjlA1H+BBeqA7xvBVMXc8KhUwBK6S7ko4xRYKpfGyrjnmW10UtZq+pow17Y5Th1a/0uLWn2aBbOGcsyM1xD1q6PVJxwbxyYvpLAa92sXL95sNlDLXH9jA72QuDZMF7A1C68Ox7WW6BwuzxBMs5LIOQmHqx/B7GmavA4NuINHGvgSwd0G4QMl4Of1BAQ9o3npV/aV2NMaywredQbrY7JxYxq+CBg5owyEgUYLUsrVkWsZSyTHU4988cEJFm2a7ZizaFaeH3YcrLdIkmoVeCld7YFkXeDuna5pk+/cEEV4CnP1dCDy6rCWbmuKbm5Li657b0TCjaEt4/6uVy4qihrIA+mU/rIaOZhBJdJIPY8JVUngjNOEtMUDqWOnDlcpbhUqV5PcurwrNkxoGIulRKgkPgYROhEHs8iv/fLO1L4JkI+GQ0vc7c/V4tbi25bWAmdWrttWqilpjTuyznqtEkGxJQu1KqiG+E56mJeQq/+DxWVkUpR4hlJCfQQTlnNH7Fs/+pwrbJzuVza3R/UZBGzS2lCa+Um1fOK6Pxb1YQF4yUn66PThj0jHKdiNgfsH2ukk9OtA1iAZ/VsVva3wnKW+5w3r8kZRIiIgTYU8cStB+8kseIOYTxf+E9O0qDxv39u6fRlUwdq0riBmO2Fy/TnKWPw3196LI+hnvZ816EiJkmnXsZS3a6T5ux62CcHvuqljIzdTERtRd1oeRkQrF7lLbJLIajNzJ8et/3N4W1BetD9NqqOqqNWd3yMvTH2dhvS9TZdr47lSKRlOMNLEtzeMkCslNd/baIop8czjsk4bJNG4XXlzicuxlekSM9NwYl3gsvEfhPuQGdvJwxzXo1ZcD732G53OG+5wFCvwT2xyXvfkWptP8kHItffA/XCFTHOI91lh3KPUVevBvbAlb/52fdRIvGMh9YnZ/lWpuf7fosP8f1dcCjreMIv8VhjmIO27B9uUSM7LHVNoiwYqVy8BSE+UppcpYCQaSwkCwpuabqfNbCez2SZ+8E0xAEYDQrqTg33UV3DMgki0MfucOPnLQefSV1DMILhTBXOSc9DjZpJ3dh8Dut+haITU0JeTSo3Heq1KUV6HBlivcSyh0MouNzOD4dZMjOT7McznnLNkg1Hnof1S+8vAxDPA7ct3OI7XHqqFPO8UqRpY4oHMAtRVcf5KLpyBOiuKK8wM9KpHbIX5aUcO1xHYq5GgeF/IjIuRKQIVbx1ghjxA2LqiINESLm8meHOb/HcgK2XwPkHcu4D2Lre6HaNQYpWk8SfrcBS7kYiTxDoXtuwIvh8EBDaTU01bBUr48jAQsjVkmFFbOUn9k0D4xHGPVqaf/JgMBlTcDvzUjSM5BnrHg9C6JeJ3goHm84bw6ovzwEY3tDcjiRG8YepTHuh6ORZNBzlXP+LRMdHYnrE1DZU4DB1yLEbpIUZypJSu35JJTfpvpDJPH9L6Csv8u4qqXuTK+nxotEU0BA1klkQR3rkYOCWJfg3GFR25Yemvz7dKqrbLRefzPYpDwGIjq7a4fhZaSUq5zG3ciLdkX/pkL5k20YkIew2jqRvVoo/iWWz1Bp29Wl5tQmkPbZFXQshZfaOcOQjBaHUd4FrLwu4KoyZNCMFTWkNUYtS2I83RHVdlH1o5S/Uo2NqIxNFJ+U4IIwN10nriEowgYyLbLlKkCgzKoEtN4TTlhUWp6gcNxayLA3JgU8C2M8KP3/WgeoW4PqvEy8M7Oz5H1t2usEMytAM0lK5vkO59nn2Akx1ESPLFOqeWwIsxmXqGW68ItPN9hc+6v50OGEK49lMGxPQGtzOBA1kbtsx2k0r2DQpIt6BmhwVz9VVxjJL11sKQuZ15XWmc8Lw7HyqbTG2FxaZzzEVJeeuCyH2jdzUXFV4sO4aQ3j6AphnUR8KXNzaa35IAtVi/ykNdQfRdKjhfNdxNdVCQMfKk5QjwI3PTk2t8EQVgp4MSWDeCSvVLujBHJAoMZ+7D+knPs7JN5qCZkSYGjiGY+IMM/N0Oet2xff/dq6EI3vnUbBGlPtBS1De8ZCbll4FHiuqZErlB2sMuiv52TS1DPSyc0O4NYpWWXPXF5DB2uMSWs3R1yeNG3g6H4Z59zeN71ENBVP6eyj0T0C9OZ3IZr2YdVnWWn62EBA/2dZ0HiubbbryY7N69X6E997a1mCCjL1nUzfzwesihw4mA0VrQlbyRkNPTWNnhnRjDp19DUk65jDC/ST6PB+GGSgRN/sMVTp0Qjr34W2yiLlXBGiuzApp9wiWM5Yn0efX1ES67+3LE4ufzpZ7MlaYxAsAgHx4CVrjzLJ/szx4uyhhfkecnkaH32/TS4Zlkb3fF498dyT/DTkrAw3lSZOYCpeXl6SiLVmQnDbkCzS2Vdufa/io2CN1rfjCZ7dH1/bnApb1LP6/dUJuuDFcvp+X4x0n2Y28+vneFxkVUWsaJThUlT688fl0qWcxxJ1BlVwoWobRHh0NqaUCSYwTKJrcRjCppd2xS7o8mRQw3LsE3z+IJK0SKTFgMQpqBGmKn0vFd7GmBqt8Qf0SbNX1s4d1Svg7pzt0mpijXS5CH2xbmjpyFGgp8hhmlNHQkBKkJWjugg7QIZlWRfPvCLvMopbv6vZFW2ZqI/mYr5md1XYXOyKmJ/c1D9j+4ATfTR7Ve3u6/tnUCGztnKGP+FArTJd9OXk5vTOhjA9taaWNhYnqqjOpFYcQWPPyKRJ/dKpa46bqioSScWLa9zI8CKc/gOIsju3r7M8pFDHroCLlYCaQaBtkxRSIIqwxbjnF6jAC1kexn3lDm2eYpRveHYvudP0OfuqjSWxqBV0+3SyYkaSQXElTNGE9S0n3hLcd6li4OacdwIC6318bpgNGakvMLOkfHekMZXvIaLVV7kvJhwqZJl0gEnGyXBc8Ts0btLDwZj5Qp+23n/MaZWzLVlhVxqD+FlpLIsrGWpzOJL+yIq/oleAnlxVS7tK4nTzwEwqbO1NsodKzjWW5EFafqshXaDoDKlNsN8uVBzGBESQC9DxShPrIROA9SJiPlKUR1gL6QCYS0iu7ImZdEl12Fgfmtlmp7+19wI6FF/HTyypYO/LZGXXRKyerKA8GLyBGhsGDcgO6Ltqo+aePYzfJxV4KD1Dp7JKoxezmQw8q6kxGO+3GPmwGJBukx/BCm9FLWRHXBVHzaOGSY8CWt9FnrzNzqMiErM5Ykg4VNCgUMxyimOP9pv8thdhVsa4+vDwHGrLtDTEL+Hm93nxmxD9dXAWDe7mp1htfZXt9koBxsYK8f7hL5XR6u1hGnZqgK7vl0GDO/spHqvPRUIZoo+lOZPzy9C7a482Sy6mI5zqKzjqCkT3PUqTcDWg+VusMV2CBbxlDs5IUo1SiMKz+DdpkIaynp2ogplKkvuCPwpr5bKnvXdVHnVlvC5l/J3BjEjweK+rHqZ2cWSs2hNNnlch6DMn7hfG59LwHszY2FjZfp04ucqU2o8OxWSsU1RBqQdBQDxQnECSs1g2AKpnoKXzCJDAHk+hqO6NmqQnWKQOohSGkasRheJ+20XzUTXICCx9aii2PnVgRORQbbeFd6RqKrbGOX5AnYEe2A65ZeKQcHVW2jDW20mowssZdlZWhMxtGR6dsrmoi3F+OFCZOMyQLMZ3j9a/ZaZewBASYhttYmMtEwVfi0yd6wmTVt2QTz3a+6iCjclRooHAXIDicWGKTrVc3J6CxTsRPe/wHFfzXe7QDnc2CCRnOljgLhhnKGq5GrSmihCNHQDpP9kGORNNxc4o8Cwkr73AyqImJrgOLY8/UP0n+E7jDfR/DMloMRSRS1HJhpRrhqDpZq+qVcJLDX7xuVHDmmIAdvzuBuz5Gyi3fL44Z1PcoCvihrWxlou1cQxj8zliTLZSdcjS9PpcVHYs0SuWBTL9mubNdF1CYStWFTI/apatn86GeaS62hhoNIZEkbe+h2FKwGR7w6AngbkKiAsKg7TCyWLyZ0gLS/1giHIopS7FRwWrkZDfb6ITugRLvefhxQNYPxmDVb23lIadcIxNgIqRwOA4rhMd2zvw+7B0zUzsfwnHqhBVF6KPJBhfL/a0qrLyBF3aO0BzxuSSn5UWZbgTuUgUfWkcReK7EmE4jUM0naNQAI3J+3RxMsNfcoUx20UH98do6eYwnVmY5uvQ0eda9FUtm9eiEV3TLq6JmBM5eHtqzsW03V0WzvggG26z+M4ibtazLNFz+T9g40qHLukTUv2hjufRml6ITmlzqR5Rly77ALrU8Sx6ZgKL90lrA2PgRU5sbwNgIwA8bocVvR/Q51LHpVjcup3f+9Hkwk5xgt7jGuGSvky8auvbNHs599z1eZBGd/fT+YVpFAmZNOvLGiYXHFWncFRtCFEPZm1dmrvo3c0R2s7nf72R93VJo4FcvT+znOvTsEn3jsimv56bRcGIWYC80xpQJRDigGiGcnB+J/JYlmBebORw1KI0ZoNuVN/V8HR1fIcc0tbhmAc4OhHd4jno2s5JUSF7AIPVDu3nG9CW2QdqeQ4mnop6P4sE7IVB7E89n0tx/heI4ossrPGkM3O7e0kw2X73p7to7pdBev6bOtpfbtDiHRFqXVRDBivq+0Px5JWfbI/QIT7mTdOSpKC0JEEuVmDLdr4HdpUnajftiT7cPNf9p0RA73/f+1VXndHWlxg2ML2YKo1im4xEmFBwDZXURo6IRN63dGuENnNtsu5AnK7uE2j4LmtzirWOrwFdBxyODYNC1qO/dAARNecYyZTdXAxLq5M56DanGnOU59hfA25rYqVyLyKpfk3YxzhRHKcxCypIrI1sYFaWluGiFrkuEg2/LWwIjbEkj40lCF4te3ALNqKAFdF8bFHgTrI0NtpYLkKDgVx3Ej59HnL5clza41/VUNHeKEWiZvI8cd0tXMl3zHMlo3H5zig9vbKW3tkcSfqr6KO9vLYuaZAsB68lKfGm+ju5W+HRmyVYmoJ8s8ehVxVO8ZxrkR92SR1hFwqyox3ZSseZHD4gKEarJcnyBOtq2cxFG6H4ls3dJBKxCGVBEiSiUL8cynQ6WRmKukdv1IXeK3XBnub7Pp3DeeeLXVH6nPNLA13nA8t4n4gukZN2M9yVcC7Lz3MnaZ4lrYN4qemvAZ1GMyTpFxWvnYIk/A+HpdssLO7XAftPBJPyoDIOSrSSUjQ8Uw3PEQxiH8ugw99uJQ2QVBC2QUuz0ZtLSEvSMWk9Pkthky4VXcS98gJ6GgV0O+ovZKVX7q40ViWMRIOBC9gJ2E5Drfo5CdqbcB9hDSHV+AMm+ozDAtDlDgapgxEfwLYPSa4Z1u2/Ugp1tTPbFUytAJH2E/LCjcpCW1OrlQnc22ntJw1MrD2c8x7Q/bUgFg/hI4oeaAndBuPFpf6dGNPAVEcj8gfDETryy3TO8mnzeQr2J0kt2BiL8Z4GdDNUP4p1cKcxBnj9g7L/7+gAt3OAlEOIhAHISx3x0tOo8ZePlsMqbhWakoLSzsP9L3e4Rj9CR4ZSFK/iQ7izEbF98bx50rPPRnvjQij5NKlrbSlFcg8JFUYivw6AgW6UCMirmNP5YLjCmT9zS2F5LEl4OBSZJRnThEfZ/aBHHdpTB5R16HloQF6LVkNY8nK3wtn/ojQlT3X4eCJwhBXDWAp47oM2SLG0Tr8InWgbdq6DtwdBofs4GKSOGn8WtVv6gOFT5NauWJYYAsey15yuEK0aNyaY1gQ2d8dF/5EqaA1rJX+RjJmQPHSkYhCb9gYcEvsO3NOuKUI4P6sJ5WYqnl4nKSFVdORDWWpuyoI3b1UcwAuPr3XIaX6HzoIaibkONZlNblxwzFthNBNM0XLjotYpbt4RxeIb8GJ7Va8UHu2XVvs0vLAdluIBOxWjOOUrNToroeDCo4Afe9gFZaqqOAPv+GOK/OFRDGxiXmnk/Hcirib6dnLO8qaoyQwYZiRaKV4483NuwMzFSJgq1eyMSe2XMFLgp/h2aUGKiVShJXCZssCVsqmrvLDddOwF73ViTlGHApYApa87nN8Jecyp+A3DW3VFaVGgh5bCCX7pMEFqslAANyp+dVS9hITpVz5eeB6Ttc8ZL1HcVKMIiWzCUU4wKnmxPewe1WvKnGzD+RV4+jdweRwSrzzkr1LmpKDDaUrLpSUMsEd6vpUi2g3lmCn9Wg7RocPpLCXniY7vJh1r4Heh/bwb3j8Pk2kFTz+EpHg3QmzLEZT8Ooqws6UXbEHOX9nbSV7+W4k3QQOHI3cJRYrvYecDBgeB+srMaQJY38dY858F9nQQ6xGT6fAf9A+Dse2W0Arkw15ItC/hnSukJW2fwhrtj8tPkArTAB3+VCqXfv6HTM0Bqxbe8Qkk+U5o+3SxYeIhwMzVoKRRJOVXpHaEB8b6+Ci8fiYUZnv/LBjX6euQV6XWizzuQbSNAqNxA1LfA8yuVDzwRzCva0ASzgeBeAg5cIsSAWdI3n8NcPxD5FQN+E5Sn0/udn8rsa/V0vY2yTjbHZaLi+AghP7d23imTYja/FeAAQAxUqGe13wFtQAAAABJRU5ErkJggg=='
            });
           },
           title: " ",
           orientation: 'landscape',
           pageSize: 'LEGAL'
           /* messageTop: "User Enquiry Data" */
         },
         {
           extend: 'excel',
           filename: 'forwader_list_xsl',
           title: "",
           className: 'excel',
           text: '<i class="fas fa-file-excel"></i>',
           exportOptions: {
             columns: [0, 1, 2, 3, 4, 5]
           }
           /* messageTop: "User Enquiry Data" */
         },
       ],
  		"columns": 	[
  			           {        
                          "data": null,
                            sortable: true,					    	          
                            render: function (data,type,row) {
	                            var companyname = data.companyname;

		                        return companyname;
			                    		
	                         }
                        },
  			            {        
  			            	 "data": null,
			    	           sortable: true,					    	          
			    	           render: function (data,type,row) {
               				   var location = data.location;

               					return location;
               						               					
               				}
  			            },
  						{				    	        	  
			      	           "data": null,					      	       
			    	           sortable: true,					    	          
			    	           render: function (data,type,row) {
               				   var startdate = data.startdate;

               				   return startdate;
               					
               				}
						},
						{				    	        	  
			      	           "data": null,			      	        				      	       
			    	           sortable: true,					    	          
			    	           render: function (data,type,row) {
               				   var enddate = data.enddate;

               				   return enddate;
               					
               				}
						},
  						 {
  							      
							    "data": null,							  
                	        sortable: true,	
             				render: function (data,type,row) {
             					var priority = data.priority;
             					
             					return priority;
             					
             				}	
                        },
  	    	            {          	
                        	     
                        	       "data": null,
                        	        sortable: true,	
                     				render: function (data,type,row) {
                     					 var status = data.status;
                     					
                     					return status;
	                     				                     					
                     				}
  					    }, 					   
				        {          	
                       	     
                     	       "data": null,
                     	        sortable: true,	
                  				render: function (data,type,row) {
	                  				var id = data.id;
                  					var action = '<button type="button" class="update_btn" onclick="getForwarderSetupDetailsById('+id+');"><i class="fas fa-pencil-alt"></i></button>'+
                  	                  '<button type="button" class="del_btn" onclick="deleteForwarderSetup('+id+');"><i class="fas fa-trash"></i></button>';
                  					
                  					return action;
	                     				                     					
                  				}
					     }
              			
                  	]
      		                  
      		     });
}

function deleteForwarderSetup(id){
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
		        url: server_url + 'admin/deleteForwarderSetup/'+id+"/"+userInfo.id,
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
		            getForwarderSetupList();

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

function getForwarderSetupDetailsById(id){
	 $('#loader').show();
     var userId = userInfo.id;
     $.ajax({
       type: 'GET',
       url: server_url + 'admin/getForwarderSetupDetailsById',
       enctype: 'multipart/form-data',
       headers: authHeader,
       processData: false,
       contentType: false,

       data: "id=" + id + "&userId=" + userInfo.id,

       success: function (response) {

         console.log(response)

         if (response.respCode == 1) {
           $('#loader').hide();
           
           $('#setupId').val(response.respData.id); 
           $('#companyNameUpd').val(response.respData.companyname);
           $('#locationUpd').val(response.respData.location);
           $('#startDateUpdId').val(response.respData.startdate);
           $('#endDateUpdId').val(response.respData.enddate);
           $('#priorityUpdId').val(response.respData.priority);        
           $("#statusUpdId").val(response.respData.status);
           
           $('#updatePopForwarder').modal('show');
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
            <h2 class="book_cargo_hd mt-4">Popular Forwader(s)</h2>
            <p class="upload_subline mb-4">Popular Forwader(s)</p>
          </div>
          <div class="col-md-2 text-right">
            <button type="button" class="login_btn2" data-toggle="modal" data-target="#addPopForwarder">Add Forwader</button>
          </div>
        </div>
        <div class="clearfix"></div>
        <!-- <div class="table-responsive"> --><!-- to remove unwanted scroll -->
        <div class="">
          <table class="table table-bordered table_fontsize" id="popForwarderTableId" style="width:100%">
            <thead class="thead-light">
              <tr>
                <th>Forwader /CHA</th>
                <th>Location</th>               
                <th>Start Date</th>
                <th>End Date</th>
                <th>Display Order</th>
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

<!-- Add popular forwarder -->
<div class="modal fade" id="addPopForwarder" tabindex="-1" role="dialog" aria-labelledby="exampleModalLabel" aria-hidden="true">
  <div class="modal-dialog modal-lg" role="document">
    <div class="modal-content">
    <form method="post" id="add-popular-forwarder">
      <div class="modal-header modal-header-spl">
        <h5 class="modal-title" id="exampleModalLabel">Forwader /CHA</h5>
        <button type="button" class="close modal_close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
      </div>
      <div class="modal-body">
        <div class="row mt-2">
          <div class="col-md-2">
            <label for="" class="form-label-new">Company Name</label>
          </div>
          <div class="col-md-4 ">
            <select class="form-control font14" name="forwarderAdd" id="forwarderAddId" required>              
            </select>
          </div>
         <div class="col-md-2">
            <label for="" class="form-label-new">Status</label>
        </div>
         <div class="col-md-4 ">
           <select class="form-control font14" name="status" id="statusId" required>
              <option value="Active">Active</option>
              <option value="Inactive">Inactive</option>              
            </select>
         </div>
        </div>
        <div class="row mt-2">
          <div class="col-md-2">
            <label for="" class="form-label-new">Start Date</label>
          </div>
          <div class="col-md-4 ">
            <input type="text" class="form-control font14" name="startDate" id="startDateId" autocomplete="off" required>
          </div>
          <div class="col-md-2">
            <label for="" class="form-label-new">End Date</label>
          </div>
          <div class="col-md-4 ">
            <input type="text" class="form-control font14" name="endDate" id="endDateId" autocomplete="off" required>
          </div>
        </div>
           <div class="row mt-2">
          <div class="col-md-2">
            <label for="" class="form-label-new">Display Order</label>
          </div>
          <div class="col-md-4 ">
            <select class="form-control font14" name="priority" id="priorityId" required>
              <option value="1">1</option>
              <option value="2">2</option>
              <option value="3">3</option>
              <option value="4">4</option>
              <option value="5">5</option>
              <option value="6">6</option>
              <option value="7">7</option>
              <option value="8">8</option>
              <option value="9">9</option>
              <option value="10">10</option>
            </select>
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
<!-- Add Popular Forwader -->

<!-- Update Popular Forwader -->
<div class="modal fade" id="updatePopForwarder" tabindex="-1" role="dialog" aria-labelledby="exampleModalLabel" aria-hidden="true">
  <div class="modal-dialog modal-lg" role="document">
    <div class="modal-content">
    <form method="post" id="update-pop-forwarder">
      <div class="modal-header modal-header-spl">
        <h5 class="modal-title" id="exampleModalLabel">Update Popular Forwader</h5>
        <button type="button" class="close" data-dismiss="modal" aria-label="Close"> <span aria-hidden="true">&times;</span> </button>
      </div>
      <div class="modal-body">
      <input type="hidden" id="setupId" name="" value="">
        <div class="row mt-2">
          <div class="col-md-2">
            <label for="" class="form-label-new">Company Name</label>
          </div>
          <div class="col-md-4 ">
            <input type="text" class="form-control font14" name="companyNameUpd" id="companyNameUpd" autocomplete="off" readonly>            
          </div>
         <div class="col-md-2">
            <label for="" class="form-label-new">Location</label>
        </div>
         <div class="col-md-4 ">
          <input type="text" class="form-control font14" name="locationUpd" id="locationUpd" autocomplete="off" readonly>            
         </div>
        </div>
        <div class="row mt-2">
          <div class="col-md-2">
            <label for="" class="form-label-new">Start Date</label>
          </div>
          <div class="col-md-4 ">
            <input type="text" class="form-control font14" name="startDateUpd" id="startDateUpdId" autocomplete="off" required>
          </div>
          <div class="col-md-2">
            <label for="" class="form-label-new">End Date</label>
          </div>
          <div class="col-md-4 ">
            <input type="text" class="form-control font14" name="endDateUpd" id="endDateUpdId" autocomplete="off" required>
          </div>
        </div>
           <div class="row mt-2">
          <div class="col-md-2">
            <label for="" class="form-label-new">Display Order</label>
          </div>
          <div class="col-md-4 ">
            <select class="form-control font14" name="priority" id="priorityUpdId" required>
              <option value="1">1</option>
              <option value="2">2</option>
              <option value="3">3</option>
              <option value="4">4</option>
              <option value="5">5</option>
              <option value="6">6</option>
              <option value="7">7</option>
              <option value="8">8</option>
              <option value="9">9</option>
              <option value="10">10</option>
            </select>
          </div>
          <div class="col-md-2">
            <label for="" class="form-label-new">Status</label>
          </div>
          <div class="col-md-4 ">           
           <select class="form-control font14" name="status" id="statusUpdId" required>
              <option value="Active">Active</option>
              <option value="Inactive">Inactive</option>              
            </select>
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
<!-- Update Advertisment -->

<script>
</script> 	
<script type="text/javascript">
$(function () {
    $('#startDateId, #startDateUpdId').datetimepicker({
      format: 'DD-MMM-YYYY',
      minDate: moment()
    });
    $('#endDateId, #endDateUpdId').datetimepicker({
      format: 'DD-MMM-YYYY',
      useCurrent: false //Important! See issue #1075
    });
    $("#startDateId, #startDateUpdId").on("dp.change", function (e) {
      $('#endDateId').data("DateTimePicker").minDate(e.date);
      $('#endDateUpdId').data("DateTimePicker").minDate(e.date);
    });
    $("#endDateId, #endDateUpdId").on("dp.change", function (e) {
      $('#startDateId').data("DateTimePicker").maxDate(e.date);
      $('#startDateUpdId').data("DateTimePicker").maxDate(e.date);
    });
  });
</script>
</body>
</html>