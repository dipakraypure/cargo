
function logout() {
    localStorage.removeItem("user");
    //currentUserSubject.next(null);
   	//window.location.href ="login";
    window.location.href ="home";
  }

  function getCurrentUser() {
	  
	  var token = JSON.parse(localStorage.getItem('user'))
	  
	  
/*	  	var base64Url = token.accessToken.split('.')[1];
	    var base64 = base64Url.replace(/-/g, '+').replace(/_/g, '/');
	    var jsonPayload = decodeURIComponent(atob(base64).split('').map(function(c) {
	        return '%' + ('00' + c.charCodeAt(0).toString(16)).slice(-2);
	    }).join(''));

	    JSON.parse(jsonPayload);
*/	  
	  
	  if(token == null)
		  window.location.href ="home";
			//window.location.href ="login";
	  
    return token;
  }