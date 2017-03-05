$(document).ready(function()
{
    $("#loader").remove();
    $("#header").fadeIn();
    $("#body").fadeIn();
    $("#footer").fadeIn();
    
    $('[data-toggle="tooltip"]').tooltip();
    var progress_class,old_class, width;
    $(window).scroll(function(){
        if ($(this).scrollTop() > 400) {
            $('#scrollToTop').fadeIn();
        } else {
            $('#scrollToTop').fadeOut();
        }
    });
    
    $('#scrollToTop').click(function(){
        $('html, body').animate({scrollTop : 0},800);
        
    });

    $("#search_bar").keyup(function(e)
    {
        $("#search_list").show();
        var s = $(this).val();
        if(s!="")
        {
           $.ajax
            ({
                type: "POST",
                url: "home/get_search_listing",
                data: {search: s},
                success: function(data)
                {
                    $("#search_list").html(data);
                }
            });
        }
        else
        {
            $("#search_list").html('');
        }
        if (e.keyCode == 40)
        {      
            $("#search_list a").first().focus();
        }
    });

    $("#search_list a").focus(function()
    {
        alert("check");
        $(this).parent().css('background','#cfe3e8');
    });
    $("#user_dropdown a").hover(function()
    {
    	$(this).addClass("active");
    }, function()
    {
    	$(this).removeClass("active");
    });

    $("#track_btn").click(function()
    {
        var invoice_id = $("#invoice_id").val();
        var parent = $(this).parents("#track_order");
        $.ajax
        ({
            type: "POST",
            url: "home/track_order",
            data: { invoice_id: invoice_id },
            success: function(response)
            {
                if(response == ""|| response == "null" || response == null)
                {
                    parent.find("#track_status_div img").show();
                    setTimeout(function()
                    {
                        parent.find("#track_status_div img").hide();
                        parent.find("#progress_bar").hide();
                        parent.find("#track_status").show();
                        parent.find("#track_status").removeClass("text-"+old_class);
                        parent.find("#track_status").text('No match found!');
                        return;
                    },500);
                    
                }
                else
                {
                    myArray = JSON.parse(response);
                    data = myArray['track'];
                    progress_class = myArray['class'];
                    width = myArray['percent'];
                    
                    parent.find("#track_status").hide();
                    parent.find("#progress_bar").hide();
                    parent.find("#track_status_div img").show();
                    parent.find("#progress_bar div").removeClass("progress-bar-"+old_class);
                    parent.find("#progress_bar div").css('width','0%');
                    parent.find("#track_status").removeClass("text-"+old_class);
                    setTimeout(function()
                    {
                        parent.find("#track_status_div img").hide();
                        parent.find("#progress_bar").show();
                        parent.find("#progress_bar div").addClass("progress-bar-"+progress_class);
                        parent.find("#progress_bar div").animate({width : width+'%'},150);
                        setTimeout(function()
                        {
                            parent.find("#track_status").addClass("text-"+progress_class);
                            parent.find("#track_status").text(data);
                            parent.find("#track_status").fadeIn("slow");
                        },1000);
                    },500);
                    old_class = progress_class;
                }
            }
        });
    });

    $(".categ_head").click(function()
    {
        var id = $(this).parent().attr('id');
        $("#sidemenu li").removeClass("active");
        $("#sidemenu").find("#"+id).addClass("active");
    });

    $(".category").click(function()
    {
        $("#listing").hide();
    	var id = $(this).parent().attr('id');
        $.ajax
        ({
            type: "POST",
            url: "home/get_category_listing",
            data: {cat_id: id},
            success: function(data)
            {
                $("#listing").html(data);
                $("#listing").fadeIn(100);
            }
        });
    });
    $("#payment_btn").click(function()
    {
        $("#pay_btn").trigger('click');
    });
});