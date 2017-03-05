var list_ind;
var list_max;
var search_allow = 0;
$(document).ready(function()
{
	$(document).mouseup(function(e)
	{
	    var container = $("#search_div");

	    if (!container.is(e.target) // if the target of the click isn't the container...
	        && container.has(e.target).length === 0) // ... nor a descendant of the container
	    {
	        $("#search_list").hide();
	    }
	});
	$("#search_box").keyup(function(event)
	{
		if(event.which <= 45 && event.which != 8)
			return;
		
		search_allow = 0;
		var query = $("#search_box").val();
		if(query.trim()!="")
		{
			$.ajax
			({
				type: "GET",
				url: "get_suggestions.jsp",
				data: { query: query },
				success: function(response)
				{
					if(response.trim() == "")
					{
						$("#search_list").hide();
					}
					else
					{
						var regex = new RegExp(query,"gi");
						$("#search_list").html(response);
						$("#search_list p").each(function()
						{
							tmp_txt = $(this).html().replace(regex, '<strong>$&</strong>');
							$(this).html(tmp_txt);
						});
						$("#search_list").show();
					}
					list_max = $("#search_list p").length;
					list_ind = null;
				}
			});
		}
		else
		{
			$("#search_list").hide();
			$("#search_list").html('');
		}
	});
	$("#search_box").keydown(function(event)
	{
		if(event.which == "40")
		{
			if(list_ind == null)
				list_ind = 0;

			list_ind++;
			
			if(list_ind > list_max)
			{
				list_ind = 1;
			}
			
			goto_select(list_ind);
		}
		else if(event.which == "38")
		{
			event.preventDefault();
			if(list_ind == null)
				list_ind = list_max+1;

			list_ind--;

			if(list_ind <= 0)
			{
				list_ind = list_max;
			}
			
			goto_select(list_ind);
		}
		else if(event.which == "13")
		{
			event.preventDefault();
			if(search_allow == 1)
				$("#search_button").trigger('click');
			select_suggestion(list_ind);
		}
	});
	$(document).on("mouseenter","#search_list p",function()
	{
		list_ind = $(this).index()+1
		goto_select(list_ind);
	});
	$(document).on("click","#search_list p",function()
	{
		select_suggestion($(this).index()+1);	
	});
});
function goto_select(index)
{
	$("#search_list p").removeClass("list_hover");
	$("#search_list p:nth-child("+index+")").addClass("list_hover");
}

function select_suggestion(index)
{
	tmp = $("#search_list p:nth-child("+index+")").text();

	if(tmp.trim() == "")
		return;

	$("#search_box").val(tmp);
	search_allow = 1;
	$("#search_list").html('');
	$("#search_list").hide();
}