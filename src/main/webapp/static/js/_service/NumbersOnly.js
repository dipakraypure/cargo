function numberOnly(id) {
	    var element = document.getElementById(id);
	    var regex = /[^0-9]/gi;
	    element.value = element.value.replace(regex, "");
}

function numberOnlyWithDecimal(id){

	var element = document.getElementById(id);
	//var regex= /[^0-9]/gi;
	var regexp = /^[0-9][0-9]\.[0-9][0-9][0-9]$/;
	//var regex=/\d{0,2}(\.\d{1,})?/gi;
	
	//console.log( regexp.test(element));
	//console.log("match: "+element.match(regexp));
	
	//var element = document.getElementById(id);
	//element.value = element.value.replace(regex, "");

}

//onkeypress="return isNumberKey(event)"
function numberKey(evt) {
    var charCode = (evt.which) ? evt.which : event.keyCode;
    if (charCode != 46 && charCode > 31
    && (charCode < 48 || charCode > 57))
        return false;

    return true;
}

function isNumberKey(evt, element) {
	  var charCode = (evt.which) ? evt.which : event.keyCode
	  if (charCode > 31 && (charCode < 48 || charCode > 57) && !(charCode == 46 || charCode == 8)){
		  return false;
	  }else {
		  
		  var len = $(element).val().length;
		  if(charCode == 46){
			  if(len < 2 || len > 3){
					
					return false;
				}
		  }
		  
		  if(len == 2){
			  if(charCode != 46){
				  return false;
			  }
		  }
  	    	    
	    var index = $(element).val().indexOf('.');
	    if (index > 0 && charCode == 46) {
	      return false;
	    }
	    if (index > 0) {
	      var CharAfterdot = (len + 1) - index;
	      if (CharAfterdot > 4) {
	        return false;
	      }
	    }

	  }
	  return true;
	}

function isNotAllowKey(evt, element){
	return false;
}

function isAlphaNumericKey(evt){
	 var charCode = (evt.which) ? evt.which : event.keyCode
	 if ((charCode > 47 && charCode<58) || (charCode > 64 && charCode<91) || (charCode > 96 && charCode<123)){
		 return true;
	 }else {
		 return false;		  
	 }	 
}