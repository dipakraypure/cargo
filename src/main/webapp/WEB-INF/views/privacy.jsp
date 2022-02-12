<%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="ISO-8859-1">
<title>Privacy Policy</title>
<link href="http://code.jquery.com/ui/1.10.2/themes/smoothness/jquery-ui.css" rel="stylesheet">
<link rel="shortcut icon" href="static/images/logo.png" type="image/x-icon">
<link href="static/css/bootstrap.css" type="text/css" rel="stylesheet">
<link href="static/css/style.css" type="text/css" rel="stylesheet">
<link href="static/css/font-awesome.min.css" type="text/css" rel="stylesheet">
<link href="static/css/jquery.transfer.css" type="text/css" rel="stylesheet">
<link href="static/css/icon_font.css" type="text/css" rel="stylesheet">
<script src="static/vendor/jquery/jquery.min.js"></script> 
<script src="https://momentjs.com/downloads/moment.min.js"></script> 
<script  src="static/js/bootstrap.min.js"></script> 
<script  src="static/js/jquery.transfer.js"></script> 
    <style>
        .transfer-demo {
            width: 640px;
            height: 400px;
            margin: 0 auto;
        }
    </style>
</head>
<body>
<span id="success_block"></span> <span id="error_block"></span>
<nav class="navbar navbar-expand-lg padd0">
  <div class="container-fluid"> <a class="navbar-brand" href="${pageContext.request.contextPath}/home"> <img src="static/images/logo.png" class="clogo" alt="Book My Cargo"> </a>
    <button class="navbar-toggler" type="button" data-toggle="collapse" data-target="#navbarSupportedContent" aria-controls="navbarSupportedContent" aria-expanded="false" aria-label="Toggle navigation"> <span class="navbar-toggler-icon"></span> </button>
    <div class="collapse navbar-collapse d-flex flex-column mtm5" id="navbarSupportedContent">
      <div class="ml-auto mb-2"> &nbsp;</div>
      <ul class="navbar-nav main_nav_bg">
        <!--  <li class="nav-item active" id="masters_home">
		        <a  id="menu1" class="nav-link" href="#">Home <span class="sr-only">(current)</span></a>
		      </li> -->
        
      </ul>
    </div>
  </div>
</nav>
  <div class="container-fluid">
    <div class="bg_white_main">
      <div class="row minht400 spl_padd">
        <div class="col-md-12 padd0">
          <h2 class="book_cargo_hd">Privacy Policy</h2>
        </div>
        <div class="col-md-12"> 
       <div id="transfer3" class="transfer-demo"></div>
        <div class="col-md-6 float-right"><input type="button" value="Submit" class="book_btn4"></div>
        </div>
      </div>
    </div>
  </div>
</form>

<!-- footer start-->
<footer class="footer mt-3">
  <div class="container-fluid">
    <div class="row">
      <div class="col-md-1">
        <h3 class="footer_hd">Sitemap</h3>
        <p><a href="#" class="footer_link">Home</a></p>
        <p><a class="footer_link">My Profile</a></p>
        <p><a href="#" class="footer_sublink">- My Company</a></p>
      </div>
      <div class="col-md-2">
        <h3 class="footer_hd">&nbsp;</h3>
        <p><a class="footer_link">My Preferences</a></p>
        <p><a href="#" class="footer_sublink">- My Booking</a></p>
        <p><a href="#" class="footer_sublink">- My Checklist</a></p>
        <p><a href="#" class="footer_sublink">- My Shipping Bills</a></p>
        <p><a href="#" class="footer_sublink">- My BLs</a></p>
        <p><a href="${pageContext.request.contextPath}/privacy" class="footer_sublink">- My Invoices</a></p>
      </div>
      <div class="col-md-2">
        <h3 class="footer_hd">Legal</h3>
        <p><a href="${pageContext.request.contextPath}/termscondition" class="footer_link">Terms & Conditions</a></p>
        <p><a href="${pageContext.request.contextPath}/privacypolicy" class="footer_link">Privacy Policy</a></p>
      </div>
      <div class="col-md-2">
        <h3 class="footer_hd">Social</h3>
        <p><a href="#" class="footer_link"><i class="fa fa-linkedin footer_icons" aria-hidden="true"></i> Linkedin</a></p>
        <p><a href="#" class="footer_link"><i class="fa fa-facebook footer_icons" aria-hidden="true"></i> Facebook</a></p>
      </div>
      <div class="col-md-2">
        <h3 class="footer_hd">Write to us</h3>
        <input type="text" class="form-control footer_input" placeholder="Enter your Name">
        <input type="text" class="form-control footer_input" placeholder="Enter your Email id">
        <input type="text" class="form-control footer_input" placeholder="Enter your Mobile no.">
      </div>
      <div class="col-md-3">
        <h3 class="footer_hd">&nbsp;</h3>
        <textarea class="form-control footer_input" rows="3" placeholder="Enter your Message"></textarea>
        <input type="submit" value="Submit" class="form_submit">
      </div>
      <div class="col-md-12">
        <p class="copy_line"> &copy; BookMyCargo 2021. All rights reserved. | <a href="#privacy_modal" data-toggle="modal" >Privacy Policy </a> </p>
      </div>
    </div>
  </div>
</footer>
<!-- footer end -->
<script src="http://code.jquery.com/ui/1.10.2/jquery-ui.js" ></script> 

<script>

    var selectedData = null;
    
    var groupDataArray1 = [
        {
            "groupName": "Afghanistan",
            "groupData": [
                {
                    "city": "Kabul",
                    "value": 101
                },
                {
                    "city": "Kandahar",
                    "value": 102
                },
                {
                    "city": "Herat",
                    "value": 103
                },
                {
                    "city": "Mazar-i-Sharif	",
                    "value": 104
                }
            ]
        },
        {
            "groupName": "Albania",
            "groupData": [
                {
                    "city": "Korce",
                    "value": 201
                },
                {
                    "city": "Kukes",
                    "value": 202
                },
                {
                    "city": "Lezhe ",
                    "value": 203
                }
            ]
        }
    ];

    var settings3 = {
        "groupDataArray":groupDataArray1,
        "groupItemName": "groupName",
        "groupArrayName": "groupData",
        "itemName": "city",
        "valueName": "value",
        "callable": function (items) {
            console.dir(items)
            selectedData = items;
        }
    };

    $("#transfer3").transfer(settings3);
</script>
</body>
</html>