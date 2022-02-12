function errorBlock(err, msg){
	$(err).empty();
	$(err).show();
	$(err).append(msg);
	setTimeout(function(){  $(err).hide(); }, 3000);
}


function successBlock(success, msg){
	$(success).empty();
	$(success).show();
	$(success).append(msg);
	setTimeout(function(){  $(success).hide(); }, 3000);
}

