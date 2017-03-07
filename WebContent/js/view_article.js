var time = 0;
$(document).ready(function()
{
	setInterval(function(){time++;},1000);
});
window.onbeforeunload = function()
{
	update_details();
    return undefined;
}
function update_details()
{
	var a_id = $("#article_id").val();
    $.ajax
    ({
        type: "POST",
        url: "update_details.jsp",
        data: { a_id: a_id, time: time },
        success: function(response)
        {
        	
        }
    });  
}