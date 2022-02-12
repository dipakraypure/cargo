/**
 * Navigation active using below function
 */
function activeNavigationClass(){
	// Store original location in loc like: http://test.com/one/ (ending slash)
	let locationLastPart = window.location.pathname
    if (locationLastPart.substring(locationLastPart.length-1) == "/") {
       locationLastPart = locationLastPart.substring(0, locationLastPart.length-1);
    }
    locationLastPart = locationLastPart.substr(locationLastPart.lastIndexOf('/') + 1);
	
	$(".navbar-nav li").removeClass("active");
    $('#masters_'+locationLastPart).addClass("active");
}