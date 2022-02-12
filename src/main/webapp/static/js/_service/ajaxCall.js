

function ajaxGetCall(url){
	
	$.ajax({
        url: server_url+url,
        type: 'GET',
        dataType: 'json',
        headers: authHeader,
        async: false,
        contentType: 'application/json; charset=utf-8',
        success: function (result) {
           // CallBack(result);

            console.log(result)
            
            return result.respData
        },
        error: function (error) {
        	console.log(error)

        	return error;
        }
    });
}