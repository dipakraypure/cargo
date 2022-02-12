function makeRegexDateString(minDate,maxDate){
      var min = new Date( minDate );
      var max = new Date( maxDate );
      
     var sortedDates = [];
     
     for (var i=0;i<createdAt.length;i++){
    	 var date = new Date( createdAt[i] );
    	 if (
                 ( min === null && max === null ) ||
                 ( min === null && date <= max ) ||
                 ( min <= date   && max === null ) ||
                 ( min <= date   && date <= max )
             ) {
    		    sortedDates.push(createdAt[i]);
             }  
     } 

     if(sortedDates.length == 0){
        var date = moment().format('DD-MMM-YYYY');
        return '^(' + date + ')\$';
     }
     return sortedDates.map(function myFunction(d){     
        return '^(' + d + ')\$';                 
         }).join("|");    
  }

function filterme() {
	  //build a regex filter string with an or(|) condition
	  var origin = $('input:checkbox[name="typeorigin"]:checked').map(function() {
		  var val = this.value.trim().replace('(', '\\(');
		  var val1 = val.replace(')', '\\)');
		  return '^(' + val1 + ')\$'    
	  }).get().join('|');
	  
	  //filter in column 0, with an regex, no smart filtering, no inputbox,not case sensitive
	  enqUserTable.fnFilter(origin, 0, true, false,true,false);
	  bkUserTable.fnFilter(origin, 0, true, false,true,false);
	  enqForwarderTable.fnFilter(origin, 0, true, false,true,false);
	  bkForwarderTable.fnFilter(origin, 0, true, false,true,false);
	  //build a filter string with an or(|) condition
	  var destination = $('input:checkbox[name="typedestination"]:checked').map(function() {
		  var val = this.value.trim().replace('(', '\\(');
		  var val1 = val.replace(')', '\\)');
		  return '^(' + val1 + ')\$';		 
	  }).get().join('|');
	 
	  //now filter in column 2, with no regex, no smart filtering, no inputbox,not case sensitive
	  enqUserTable.fnFilter(destination, 1, true, false,false,false); 
	  bkUserTable.fnFilter(destination, 1, true, false,false,false); 
	  enqForwarderTable.fnFilter(destination, 1, true, false,false,false); 
	  bkForwarderTable.fnFilter(destination, 1, true, false,false,false);   
	//build a filter string with an or(|) condition
	  var forwarder = $('input:checkbox[name="typecustomer"]:checked').map(function() {
		  var val = this.value.trim().replace('(', '\\(');
		  var val1 = val.replace(')', '\\)');
		  return '^(' + val1 + ')\$';		 
	  }).get().join('|');
	 
	  //now filter in column 2, with no regex, no smart filtering, no inputbox,not case sensitive
	  enqUserTable.fnFilter(forwarder, 2, true, false,false,false); 
	  bkUserTable.fnFilter(forwarder, 2, true, false,false,false); 
	  enqForwarderTable.fnFilter(forwarder, 2, true, false,false,false); 
	  bkForwarderTable.fnFilter(forwarder, 2, true, false,false,false); 
	  
	  var period = $('input[name=period_input]:checked').val();

	  if( period != undefined){		  	  

		  var dateRange = '';
		  var cur = moment().format('DD-MMM-YYYY');
		  
		  if(period == "DAY"){
			  //var dt = moment().set({'hour': 01, 'minute': 00, 'second': 00});
			  //minDate = dt.format('DD-MMM-YYYY hh:mm:ss');
	          minDate = moment().format('DD-MMM-YYYY');
			  maxDate = moment().format('DD-MMM-YYYY');
	          dateRange = makeRegexDateString(minDate,maxDate);
		  }else if(period == "WEEK"){
            minDate = moment().subtract(7,'d').format('DD-MMM-YYYY');
	          maxDate = moment().format('DD-MMM-YYYY');
	          dateRange = makeRegexDateString(minDate,maxDate);
		  }else if(period == "MONTH"){
			  minDate = moment().subtract(30,'d').format('DD-MMM-YYYY');
	          maxDate = moment().format('DD-MMM-YYYY');
	          dateRange = makeRegexDateString(minDate,maxDate);
		  }else if(period == "RANGE"){
			  //minDate = $('#fdaterange1').val();
			  //maxDate = $('#fdaterange1').val();
			  dateRange	= makeRegexDateString(minDate,maxDate);
		  }
		  enqUserTable.fnFilter(dateRange, 3, true, false,false,false); 
		  bkUserTable.fnFilter(dateRange, 3, true, false,false,false); 
		  enqForwarderTable.fnFilter(dateRange, 3, true, false,false,false); 
		  bkForwarderTable.fnFilter(dateRange, 3, true, false,false,false); 
		  
	  }
	 	 
	}

  function resetFilter(){
  	 $(":checkbox").prop('checked',false);
  	 $(":radio").prop('checked',false);
  	 filterme();
  }
  
  function generateCreatedAtArrayListFromBooking(data){
		createdAt = [];
		forwarderFilterArray = [];
		originFilterArray = [];
		destinationFilterArray = [];
		
    for(var i=0;i<data.length;i++){
  	 var date = data[i].bookingdate.split(" ");
       createdAt.push(date[0]);
       forwarderFilterArray.push(data[i].forwarder);
       originFilterArray.push(data[i].originwithcode);
       destinationFilterArray.push(data[i].destinationwithcode);
    }
}
  
  function generateFilterDataArrayListFromBooking(data){
		createdAt = [];
		customerFilterArray = [];
		originFilterArray = [];
		destinationFilterArray = [];
		
    for(var i=0;i<data.length;i++){
      var date = data[i].bookingdate.split(" ");
       createdAt.push(date[0]);
       customerFilterArray.push(data[i].forwarder);
       originFilterArray.push(data[i].originwithcode);
       destinationFilterArray.push(data[i].destinationwithcode);      
    }
}
  
  function generateCreatedAtArrayListFromEnquiry(data){
		createdAt = [];
		forwarderFilterArray = [];
		originFilterArray = [];
		destinationFilterArray = [];
    for(var i=0;i<data.length;i++){
  	 var date = data[i].searchdate.split(" ");
       createdAt.push(date[0]);
       originFilterArray.push(data[i].origin);
       destinationFilterArray.push(data[i].destination);
    }
  }
  
  function prepareForwarderFilter(forwarderFilterArray){
	  forwarderFilterArray = removeDuplicates(forwarderFilterArray);
	  forwarderFilterArray.sort();
	  var forwarderFilterSection = '';
	  var count = 1;
	  var disable = '';
	  var className = '';
	  
	  if(forwarderFilterArray.length != 0){
		  $('#forwarderFilterMainDiv').show();
		  $("#forwarderFilterMoreLessSectionId").hide();
		  for(var i=0;i<forwarderFilterArray.length;i++){
			  if(count > 5){
				  className = 'forwarder-hidden-item';
				  disable = 'display: none;';
			  }	  
			  var div = '<div class="widthSpl100 '+className+'" style="'+disable+'"><input type="checkbox" class="filter_checkbox" value="'+forwarderFilterArray[i]+'" onchange="filterme()" name="typeforwarder"><label class="filter_label">'+forwarderFilterArray[i]+'</label></div>';
			  forwarderFilterSection = forwarderFilterSection + div;		  
			  count++;
		  }
		  
		  $("#forwarderFilterSectionId").empty();
		  $("#forwarderFilterSectionId").append(forwarderFilterSection);
		  if(count > 5 ){            	         	         	  
	       	   $("#forwarderFilterMoreLessSectionId").show();
		  }
		  
	  }else{
		  $('#forwarderFilterMainDiv').hide();
	  }	  
  }
  
  function generateFilterDataArrayListFromEnquiry(data){
		createdAt = [];
		customerFilterArray = [];
		originFilterArray = [];
		destinationFilterArray = [];
		
    for(var i=0;i<data.length;i++){
       var date = data[i].searchdate.split(" ");
       createdAt.push(date[0]);
       customerFilterArray.push(data[i].customer);
       originFilterArray.push(data[i].origin);
       destinationFilterArray.push(data[i].destination);
    }
}
  
  function prepareCustomerFilter(customerFilterArray){
	  customerFilterArray = removeDuplicates(customerFilterArray);
	  customerFilterArray.sort();
	  var customerFilterSection = '';
	  var count = 1;
	  var disable = '';
	  var className = '';
	  if(customerFilterArray.length != 0){
		  $('#customerFilterMainDiv').show();
		  $("#customerFilterMoreLessSectionId").hide();
		  for(var i=0;i<customerFilterArray.length;i++){
			  if(count > 5){
				  className = 'customer-hidden-item';
				  disable = 'display: none;';
			  }	  
			  var div = '<div class="widthSpl100 '+className+'" style="'+disable+'"><input type="checkbox" class="filter_checkbox" value="'+customerFilterArray[i]+'" onchange="filterme()" name="typecustomer"><label class="filter_label">'+customerFilterArray[i]+'</label></div>';
			  customerFilterSection = customerFilterSection + div;		  
			  count++;
		  }
		  
		  $("#customerFilterSectionId").empty();
		  $("#customerFilterSectionId").append(customerFilterSection);
		  if(count > 5 ){            	         	         	  
	       	   $("#customerFilterMoreLessSectionId").show();
		  }
	  }else{
		  $('#customerFilterMainDiv').hide();
	  }
	  
  }
  
  function prepareOriginFilter(originFilterArray){
	  originFilterArray = removeDuplicates(originFilterArray);
	  originFilterArray.sort();
	  var originFilterSection = '';
	  var count = 1;
	  var disable = '';
	  var className = '';
	  if(originFilterArray.length != 0){
		  $('#originFilterMainDiv').show();
		  $("#originFilterMoreLessSectionId").hide();
		  for(var i=0;i<originFilterArray.length;i++){
			  if(count > 5){
				  className = 'origin-hidden-item';
				  disable = 'display: none;';
			  }	  
			  var div = '<div class="widthSpl100 '+className+'" style="'+disable+'"><input type="checkbox" class="filter_checkbox" value="'+originFilterArray[i]+'" onchange="filterme()" name="typeorigin"><label class="filter_label">'+originFilterArray[i]+'</label></div>';
			  originFilterSection = originFilterSection + div;		  
			  count++;
		  }
		  $("#originFilterSectionId").empty();		 
		  $("#originFilterSectionId").append(originFilterSection);
          if(count > 5 ){            	         	         	  
        	  $("#originFilterMoreLessSectionId").show();
		  }
	  }else{
		  $('#originFilterMainDiv').hide();
	  }
	  
  }
  
  function prepareDestinationFilter(destinationFilterArray){
	  destinationFilterArray = removeDuplicates(destinationFilterArray);
	  destinationFilterArray.sort();
      var destinationFilterSection = '';
   	  var count = 1;
   	  var disable = '';
   	  var className = '';
   	  if(destinationFilterArray.length != 0){
   		$('#destinationFilterMainDiv').show();
   		$("#destinationFilterMoreLessSectionId").hide();
   		for(var i=0;i<destinationFilterArray.length;i++){
     		  if(count > 5){
     			  className = 'destination-hidden-item';
     			  disable = 'display: none;';
     		  }	  
     		  var div = '<div class="widthSpl100 '+className+'" style="'+disable+'"><input type="checkbox" class="filter_checkbox" value="'+destinationFilterArray[i]+'" onchange="filterme()" name="typedestination"><label class="filter_label">'+destinationFilterArray[i]+'</label></div>';
     		destinationFilterSection = destinationFilterSection + div;  		  
     		  count++;
     	  }
     	  
     	  $("#destinationFilterSectionId").empty();
     	  $("#destinationFilterSectionId").append(destinationFilterSection);
     	 if(count > 5 ){            	         	         	  
       	     $("#destinationFilterMoreLessSectionId").show();
		  }
   	  }else{
   		$('#destinationFilterMainDiv').hide();
   	  }
   	  
    }
  
  function removeDuplicates(data){
	  var unique = [];
	  data.forEach(element =>{
		  if(!unique.includes(element)){
			  unique.push(element);
		  }
	  });
	  return unique;
  }