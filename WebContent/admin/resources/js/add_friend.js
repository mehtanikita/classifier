$(document).ready(function()
{
	$("#search_friends").click(function()
	{
		var q = $("#user_search").val();
		$.ajax
		({
			type: "POST",
			url: "friend/get_friends",
			data: { q:q },
			success: function(response)
			{
				$("#friend_div").html(response);
			}
		});
	});
	$(document).on("click",".add_friend",function()
	{
		var rel = $(this).attr('rel');
		var par = $(this).parent();
		$.ajax
		({
			type: "POST",
			url: "friend/add_friend",
			data: { id:rel },
			success: function(response)
			{
				par.html('<h5>Request Sent <span class="glyphicon glyphicon-ok"></span></h5>');
			}
		});
	});
});