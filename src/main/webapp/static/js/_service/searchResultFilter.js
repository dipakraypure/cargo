
function filterme() {
	 
	//build a filter string with an or(|) condition
	  var forwarder = $('input:checkbox[name="typeforwarder"]:checked').map(function() {
		  var val = this.value.trim().replace('(', '\\(');
		  var val1 = val.replace(')', '\\)');
		  return '^(' + val1 + ')\$';		 
	  }).get().join('|');
	 
	  //now filter in column 2, with no regex, no smart filtering, no inputbox,not case sensitive
	  searchTable.fnFilter(forwarder, 3, true, false,false,false); 
	  
	  var sort = $('input[name=sorting_input]:checked').val();
	  if( sort != undefined){		  	   
		  if(sort == "ASC"){
			  searchTable.fnSort([[5,'asc']]);
		  }else if(sort == "DESC"){
			  searchTable.fnSort([[5,'desc']]);
		  }
	  }	 	 
	}

  function resetFilter(){
  	 $(":checkbox").prop('checked',false);
  	 $(":radio").prop('checked',false);
  	 filterme();
  }
  
  function generateFilterArrayListFromSearchResult(data){
	  forwarderFilterArray = [];
	 		
      for(var i=0;i<data.length;i++){  	 
         forwarderFilterArray.push(data[i].forwarder);               
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
	  }else{
		  $('#forwarderFilterMainDiv').hide();
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