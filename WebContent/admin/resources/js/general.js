var lat, lng, hr;
$(document).ready(function()
{
	$("#location_link").click(function(e)
	{
		hr = $(this).attr('href');
		e.preventDefault();
		
		if (navigator.geolocation) {
	        navigator.geolocation.getCurrentPosition(showPosition);
	    } else {
	    	$.get("http://ipinfo.io", function(response) {
	    	    loc = response.loc.split(",");
	    	    lat = loc[0];
	    	    lng = loc[1];
	    	    set_lat_long();
	    	}, "jsonp");
	    }
	});
	url = window.location.href;
	url = url.split("?")[0];
	tmp = url.split('/');
	controller = $.trim(tmp[tmp.length-2]);
	module = $.trim(tmp[tmp.length-1]);
	$('a[href="'+controller+'/'+module+'"]').parents('.treeview').addClass("active");
	$('a[href="'+controller+'/'+module+'"]').parent().addClass("active_sidelink");
	
	$(document).on("click",".confirm_friend", function(e)
	{
		e.stopPropagation();
		var rel = $(this).attr('rel');
		var par = $(this).parents(".confirm_friend_li");
		$.ajax
		({
			type: "POST",
			url: "friend/confirm_friend",
			data: { id:rel },
			success: function(response)
			{
				par.html('<h4 class="text-center text-success">Confirmed Friend <span class="glyphicon glyphicon-ok"></span></h4>');
			}
		});
	});
	$(document).on("click",".decline_friend", function(e)
	{
		e.stopPropagation();
		var rel = $(this).attr('rel');
		var par = $(this).parents(".confirm_friend_li");
		$.ajax
		({
			type: "POST",
			url: "friend/decline_friend",
			data: { id:rel },
			success: function(response)
			{
				par.html('<h4 class="text-center text-danger">Declined Friend <span class="glyphicon glyphicon-remove"></span></h4>');
			}
		});
	});
});
function showPosition(position) {
	lat = position.coords.latitude;
	lng = position.coords.longitude;
	set_lat_long();
}
function set_lat_long()
{	
	$.ajax
	({
		type: "GET",
		url: "stores/set_lat_long",
		data: { lat: lat, lng: lng },
		success: function(response)
		{
			window.location.href = hr;
		},
		error: function(response)
		{
			return false;
		}
	});
}