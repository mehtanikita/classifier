$(document).ready(function()
{
    $('[data-toggle="tooltip"]').tooltip(); 
    var tgl_cnt = 0;
    $(document).on("click",".add_to_wishlist",function()
    {
        var prod_id = $(this).attr('rel');
        var caller = $(this);

        /* Animation on click*/
        var anim1 = $(this).parents(".flip-container");
        var anim = anim1.find(".main_thumbnail").clone();
 
        anim.css('height','250px');
        anim.css('width','250px');
        anim1.before(anim);
        var pos = anim.offset();
        $("body").prepend(anim);
        var move = anim.css({
            "position": "absolute",
            "z-index": "9999",
            "top": pos.top,
            "left": pos.left
        });
        var block1 = $("#user_actions_div").offset();
        move.animate({
            "top": block1.top+50,
            "left": block1.left+50,
            "width": 50,
            "height": 50,
        }, 1000
        );

        setTimeout(
            function()
            {
                move.animate
                ({
                    "top": block1.top+10,
                    "left": block1.left+10,
                    "width": 0,
                    "height": 0,
                    "opacity": 0
                },200);
            }
            ,1050, 
            function()
            {
                anim.remove();
            }
        );
        /* End of Animation*/
        
        $.ajax
        ({
            type: "POST",
            url: "product/add_to_wishlist",
            data: {product: prod_id},
            success: function(data)
            {
                if(data=="true")
                {
                    caller.removeClass("btn-info add_to_wishlist");
                    caller.addClass("btn-warning remove_from_wishlist");
                    caller.find(".btn_text").text(" Remove");
                }
                else
                    alert("There was some problem adding the item! Please try again.");
            }
        });
    });
    $(document).on("click",".remove_from_wishlist",function()
    {
        var prod_id = $(this).attr('rel');
        var parent = $(this).parents(".wishlist_item");
        $.ajax
        ({
            type: "POST",
            url: "product/remove_from_wishlist",
            data: {product: prod_id},
            success: function(data)
            {
                if(data=="true")
                {
                    parent.fadeOut("slow");
                    setTimeout(
                        function()
                        {
                            parent.remove();
                        }, 1000);
                }
                else
                    alert("There was some problem removing the item! Please try again.");
            }
        });
    });
    $("#edit").click(function()
    {
        $("#edit_div").hide("fast");
        $("#save_div").slideDown("fast");
        $(".disable_toggle").removeAttr('disabled');
    });
    $("#cancel").click(function()
    {
        $("#update_form")[0].reset();
        $("#save_div").hide("fast");
        $("#edit_div").slideDown("fast");
        $(".disable_toggle").attr('disabled',true);
    });
    $("#failed_orders_toggle").click(function()
    {
        if(tgl_cnt%2==0)
        {
            $("#failed_orders").slideDown("fast");
            $(this).find("span").removeClass("glyphicon-menu-down");
            $(this).find("span").addClass("glyphicon-menu-up");
            tgl_cnt++;
        }
        else
        {
            $("#failed_orders").slideUp("fast");
            $(this).find("span").removeClass("glyphicon-menu-up");
            $(this).find("span").addClass("glyphicon-menu-down");
            tgl_cnt++;   
        }
    });
});