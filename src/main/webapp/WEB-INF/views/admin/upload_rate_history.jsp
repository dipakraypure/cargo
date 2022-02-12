<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="ISO-8859-1">
<title>Insert title here</title>
<link href="https://cdn.datatables.net/1.10.22/css/jquery.dataTables.min.css" type="text/css" rel="stylesheet">
</head>
<body>
	<div class="container-fluid">
	  	<div class="bg_white_main mb-4 mt-4">
	        <div class="row">
				<div class="col-md-12">
		      		 <h2 class="book_cargo_hd mt-2 mb-3">Carriers Rate History</h2>
		      		<table class="table table-bordered" id="upload_rate_history">
			     		<thead class="thead-light">
			     			<tr>
		               		   <th>Sr. no.</th>
		               		   <th>Carrier</th>
		               		   <th>Charge Type</th>
		               		   <th>Valid Date From</th>
		               		   <th>Valid Date To</th>
		               		   <th>Uploaded Date</th>
		                	</tr>
			     		</thead>
			     		<tbody>
				            <tr>
				                <td>1</td>
				                <td>ACL</td>
				                <td>Type 1</td>
				                <td>22-Dec-2020</td>
				                <td>24-Dec-2020</td>
				                <td>20-Dec-2020</td>
				            </tr>
				            <tr>
				                <td>2</td>
				                <td>ARC</td>
				                <td>Type 2</td>
				                <td>23-Dec-2020</td>
				                <td>24-Dec-2020</td>
				                 <td>20-Dec-2020</td>
				            </tr>
				             <tr>
				                <td>3</td>
				                <td>ACL</td>
				                <td>Type 1</td>
				                <td>22-Dec-2020</td>
				                <td>24-Dec-2020</td>
				                 <td>20-Dec-2020</td>
				            </tr>
				            <tr>
				                <td>4</td>
				                <td>BGK</td>
				                <td>Type 2</td>
				                <td>23-Dec-2020</td>
				                <td>24-Dec-2020</td>
				                 <td>21-Dec-2020</td>
				            </tr>
				             <tr>
				                <td>5</td>
				                <td>ACL</td>
				                <td>Type 1</td>
				                <td>22-Dec-2020</td>
				                <td>24-Dec-2020</td>
				                 <td>20-Dec-2020</td>
				            </tr>
				            <tr>
				                <td>6</td>
				                <td>ARC</td>
				                <td>Type 2</td>
				                <td>23-Dec-2020</td>
				                <td>24-Dec-2020</td>
				                 <td>20-Dec-2020</td>
				            </tr>
				        </tbody>
			     	</table>
		      	</div>
		    </div>
		 </div>
	</div>
	 <script src="http://cdn.datatables.net/1.10.1/js/jquery.dataTables.min.js"></script>
  <script src="https://cdn.datatables.net/responsive/1.0.7/js/dataTables.responsive.min.js"></script>
	<script>
	
	$(document).ready( function () {
		activeNavigationClass();
	    $('#upload_rate_history').DataTable();
	} );
	</script>
</body>
</html>