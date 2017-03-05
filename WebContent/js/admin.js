$(document).on('ready', function()
{
	$('[data-toggle="tooltip"]').tooltip();
	var plusOne;
	var plusOne_html;
	var cplusOne;
	var eplusOne;
	$("#image_trigger").click(function()
	{
		$("#image").trigger('click');
	});
	$("#ex_image_trigger").click(function()
	{
		$("#ex_image").trigger('click');
	});
	$("#category").change(function()
	{
		$("#info_option").remove();
		var c = $("#category").val();
		$.ajax
		({
			type: "POST",
			url: "admin/get_attributes",
			data:{category: c},
			success: function(data)
			{
				$("#append_div").html(data);
				plusOne = $("#append_div .iAppend").first();
				plusOne_html = plusOne[0].outerHTML;
				plus_minus = $(plusOne).find(".plus_minus").html();
				$("#append_div").find(".iAppend").first().find("select").first().addClass("focus");
				$("#append_div").find(".focus").focus();
			}
		})
	});
	$(document).on("click",".plus_one",function()
	{
		$(this).parents(".cAppend_div").find("select").removeClass("focus");
		$(this).parents("#append_div").find(".plus_one").remove();
		$("#append_div").append(plusOne_html);
		$("#append_div").find(".iAppend").last().find("select").first().addClass("focus");
		$("#append_div").find(".focus").focus();
	});
	$(document).on("click",".minus_one",function()
	{
		var check = $(this).parents(".iAppend").is(".iAppend:last-child");
		var empty = $(this).parents("#append_div");
		$(this).parent().parent().remove();
		if(check)
		{
			var temp = $("#append_div").find(".iAppend:last-child").find(".plus_minus");
			temp.html(plus_minus);
		}
		var trim = $.trim(empty.html());
		if(trim=="")
		{
			$(empty).siblings("#categ_select").find("#category").val('');
		}
		else
		{
			empty.find("iAppend").last().find("select").first().addClass("focus");
			empty.find(".focus").focus();
		}
	});

	$("#cSide").click(function()
	{
		setTimeout(function()
		{
			$("#cName").focus();
		},400);
	});
	$("#aSide").click(function()
	{
		setTimeout(function()
		{
			$("#aName").focus();
		},400);
	});
	$("#eSide").click(function()
	{
		setTimeout(function()
		{
			$("#edit_select").focus();
		},400);
	
	});
	$(".categ_check").change(function()
	{
		var c = $(this).prop('checked');
		if(c==true)
		{
			var a = $(this).parents(".attribute_div").find(".cAppend_div");
			a.hide();
			cplusOne = $(this).parents(".attribute_div").find(".cAppend_hidden");
			a.html(cplusOne.html());
			a.slideDown("fast");
			setTimeout(function()
			{
				$(a).find(".focus").focus();
			},200);
		}
		else
		{
			$(this).parents(".attribute_div").find(".cAppend_div").slideUp("fast");
		}
	});
	$(document).on("click",".cplus_one",function()
	{
		cplusOne = $(this).parents(".attribute_div").find(".cAppend_hidden");
		var c = $(this).parents(".attribute_div").find(".cAppend_div");
		$(this).parents(".cAppend_div").find("input").removeClass("focus");
		$(this).parents(".cAppend_div").find(".cplus_one").remove();
		c.append(cplusOne.html());
		$(c).find(".focus").focus();
	});
	$(document).on("click",".cminus_one",function()
	{
		var check = $(this).parents(".cClass").is(".cClass:last-child");
		var empty = $(this).parents(".cAppend_div");
		$(this).parent().parent().remove();
		if(check)
		{
			var x = $(cplusOne).find(".plus_minus").html();
			var temp = $(".cAppend_div").find(".cClass:last-child").find(".plus_minus");
			temp.html(x);
		}
		var trim = $.trim(empty.html());
		if(trim=="")
		{
			$(empty).siblings(".checkbox").find(".categ_check").prop('checked',false);
		}
		else
		{
			empty.find(".cClass").last().find("input").addClass("focus");
			empty.find(".focus").focus();
		}
	});
	$("#cBtn").click(function()
	{
		var val = $.trim($("#cName").val());
		if(val!="")
		{
			$(".cAppend_hidden").remove();
			$("#cAppend").find(":hidden" ).remove();
		}
	});

	$("#edit_select").change(function()
	{
		$("#eInfo_option").remove();
		var c = $(this).val();
		$(".edit_check").prop('checked',false);
		$(".eAppend_div .form-group").remove();
		$.ajax
		({
			type: "POST",
			url: "admin/get_categ_attributes",
			data:{category: c},
			success: function(data)
			{
				var obj = JSON.parse(data);
				var array = Object.keys(obj);
				for(var i=0;i<array.length;i++)
				{
					var a = $("#edit_check"+array[i]).parents(".attribute_div").find(".eAppend_div");
					eplusOne = $("#edit_check"+array[i]).parents(".attribute_div").find(".eAppend_hidden");
					$("#edit_check"+array[i]).prop('checked',true);
					for(var j=0;j<obj[array[i]].length;j++)
					{
						a.append(eplusOne.html());
						var temp = $("#edit_check"+array[i]).parents(".attribute_div").find(".eAppend_div").find(".form-group").last().find(".form-control");
						temp.val(obj[array[i]][j]);
						if(j<(obj[array[i]].length)-1)
						{
							$("#edit_check"+array[i]).parents(".attribute_div").find(".eAppend_div").find(".eplus_one").remove();
						}
					}
					setTimeout(function()
					{
						$(a).find(".focus").focus();
					},200);
					a.fadeIn("fast");
				}
			}
		})
	});
	$(".edit_check").change(function()
	{
		var e = $(this).prop('checked');
		if(e==true)
		{
			var a = $(this).parents(".attribute_div").find(".eAppend_div");
			a.hide();
			eplusOne = $(this).parents(".attribute_div").find(".eAppend_hidden");
			a.html(eplusOne.html());
			a.slideDown("fast");
			setTimeout(function()
			{
				$(a).find(".focus").focus();
			},200);
		}
		else
		{
			$(this).parents(".attribute_div").find(".eAppend_div").slideUp("fast");
			$(this).parents(".attribute_div").find(".eAppend_div").empty();
		}
	});
	$(document).on("click",".eplus_one",function()
	{
		eplusOne = $(this).parents(".attribute_div").find(".eAppend_hidden");
		var e = $(this).parents(".attribute_div").find(".eAppend_div");
		$(this).parents(".eAppend_div").find("input").removeClass("focus");
		$(this).parents(".eAppend_div").find(".eplus_one").remove();
		e.append(eplusOne.html());
		$(e).find(".focus").focus();
	});
	$(document).on("click",".eminus_one",function()
	{
		var check = $(this).parents(".eClass").is(".eClass:last-child");
		var empty = $(this).parents(".eAppend_div");
		$(this).parent().parent().remove();
		if(check)
		{
			var x = $(eplusOne).find(".plus_minus").html();
			var temp = $(".eAppend_div").find(".eClass:last-child").find(".plus_minus");
			temp.html(x);
		}
		var trim = $.trim(empty.html());
		if(trim=="")
		{
			$(empty).siblings(".checkbox").find(".edit_check").prop('checked',false);
		}
		else
		{
			empty.find(".eClass").last().find("input").addClass("focus");
			empty.find(".focus").focus();
		}
	});
	$("#eBtn").click(function()
	{
		var val = $.trim($("#edit_select").val());
		if(val!="")
		{
			$(".eAppend_hidden").remove();
			$("#eAppend").find(":hidden" ).remove();
		}
	});
	$(".update_order").click(function()
	{
		$(this).prop('disabled',true);
		var caller = $(this);
		var id = $(this).parents(".order_row").find(".order_id").text();
		id = id.trim();
		var status = $(this).parents(".order_row").find(".track_status").val();
		$.ajax
		({
			type: "POST",
			url: "admin/update_order",
			data: { order_id: id, status: status},
			success: function(data)
			{
				if(data)
				{
					caller.after('<span class="text-info h3">&#10004 Saved!</span>');
					setTimeout(function()
						{
							caller.next().fadeOut(800);
						},1500);
					setTimeout(function()
						{
							caller.next().remove();
							caller.prop('disabled',false);
						},2301);
				}
				else
				{
					caller.after('<span class="text-danger h3">&#10007 Error!</span>');
					setTimeout(function()
						{
							caller.next().fadeOut(800);
						},1500);
					setTimeout(function()
						{
							caller.next().remove();
							caller.prop('disabled',false);
						},2301);
				}
			}
		});
		
	});
});