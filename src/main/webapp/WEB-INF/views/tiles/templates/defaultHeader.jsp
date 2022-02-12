<script type="text/javascript">
$(function(){

	    $('.navbar-nav li').click(function(){
            $('.navbar-nav li').removeClass('active');
            $(this).addClass('activeM');
        })

});  

</script>

<header>
  <nav class="navbar navbar-expand-lg padd0 navbar-dark bg-light">
    <div class="container-fluid"> <a class="navbar-brand" href="#"> <img src="static/images/logo.png" class="clogo"> </a>
      <button class="navbar-toggler mr-3" type="button" data-toggle="collapse" data-target="#navbarSupportedContent" aria-controls="navbarSupportedContent" aria-expanded="false" aria-label="Toggle navigation"> <span class="navbar-toggler-icon"></span> </button>
      <div class="collapse navbar-collapse " id="navbarSupportedContent">
        <ul class="navbar-nav main_nav_bg mt-4" id="navbarHeaderId" style="display:none;">
          <li class="nav-item active" id="masters_userHome"> <a  id="menu1" class="nav-link" href="${pageContext.request.contextPath}/userHome">Home <span class="sr-only">(current)</span></a> </li>
          <li class="nav-item" id="masters_userDashboard"> <a  id="menu1" class="nav-link" href="${pageContext.request.contextPath}/userDashboard">My Dashboard </a> </li>
          <li class="nav-item" id="masters_userProfile"> <a  id="menu1" class="nav-link" href="${pageContext.request.contextPath}/userProfile">My Profile</a> </li>
          <li class="nav-item" id="masters_userCompany"> <a  id="menu1" class="nav-link" href="${pageContext.request.contextPath}/userCompany">My Company</a> </li>
          
          <!-- admin pages mapping -->
          
          <li class="nav-item" id="masters_uploadRate"> <a  id="menu1" class="nav-link" href="${pageContext.request.contextPath}/uploadRate">Home</a> </li>
          <li class="nav-item" id="masters_adminDashboard"> <a  id="menu1" class="nav-link" href="${pageContext.request.contextPath}/adminDashboard">Dashboard</a> </li>
          <li class="nav-item" id="masters_adminProfile"> <a  id="menu1" class="nav-link" href="${pageContext.request.contextPath}/adminProfile">My Profile</a> </li>
          <li class="nav-item" id="masters_uploadOffer"> <a  id="menu1" class="nav-link" href="${pageContext.request.contextPath}/uploadOffer">Special Offers</a> </li>          
          <li class="nav-item" id="masters_adminFeedback"> <a  id="menu1" class="nav-link" href="${pageContext.request.contextPath}/adminFeedback">Feedback</a> </li>         
          <li class="nav-item dropdown" id="masters_adminSetup"> <a class="nav-link dropdown-toggle" href="#" id="navbarDropdown" role="button" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false"> Setup </a>
            <div class="dropdown-menu" aria-labelledby="navbarDropdown">
              <a class="dropdown-item"  id="masters_carrierSetup" href="${pageContext.request.contextPath}/carrierSetup">Carrier Setup</a>
              <div class="dropdown-divider"></div>
              <a class="dropdown-item"  id="masters_forwarderSetup" href="${pageContext.request.contextPath}/forwarderSetup">Forwarder Setup</a>
              <div class="dropdown-divider"></div>
              <a class="dropdown-item"  id="masters_countryRequirement" href="${pageContext.request.contextPath}/countryRequirement">Country Requirements</a>
              <div class="dropdown-divider"></div>
              <a class="dropdown-item"  id="masters_uploadAds" href="${pageContext.request.contextPath}/uploadAds">Upload Ads</a> 
              </div>
          </li>
          <li class="nav-item" id="masters_loginLog"> <a  id="menu1" class="nav-link" href="${pageContext.request.contextPath}/loginLog">Login History</a> </li>
          <!-- end admin pages login --> 
          
          <!-- forwarder tabs -->
          
          <li class="nav-item" id="masters_forwarderHome"> <a  id="menu1" class="nav-link" href="${pageContext.request.contextPath}/forwarderHome">Home</a> </li>
          <li class="nav-item" id="masters_forwarderProfile"> <a  id="menu1" class="nav-link" href="${pageContext.request.contextPath}/forwarderProfile">My Profile</a> </li>
          <li class="nav-item " id="masters_forwarderDashboard"> <a  id="menu1" class="nav-link" href="${pageContext.request.contextPath}/forwarderDashboard">My Dashboard</a> </li>
          <li class="nav-item " id="masters_forwarderCompany"> <a id="menu1" class="nav-link" href="${pageContext.request.contextPath}/forwarderCompany">My Company</a> </li>
          <li class="nav-item " id="masters_forwarderAlerts"> <a  id="menu1" class="nav-link" href="${pageContext.request.contextPath}/forwarderAlerts">My Alerts</a> </li>
          <!-- forwarder tabs -->
          
          <li class="nav-item dropdown ml-auto"> <a class="nav-link dropdown-toggle" href="#" id="navbarDropdown" role="button" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false" > Welcome <span id="user_name" class="user_name"> </span> </a>
            <div class="dropdown-menu" aria-labelledby="navbarDropdown"> <a class="dropdown-item" onClick=logout()>Logout</a> </div>
          </li>
        </ul>
      </div>
    </div>
  </nav>
</header>
<script>
  $("#user_name").html(userInfo.username); 
 </script> 