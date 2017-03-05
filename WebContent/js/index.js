$(document).ready(function()
{
	$(document).on("click",".add_to_kart",function()
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
        var block1 = $("#kart_div").offset();
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
            url: "kart/add_to_kart",
            data: {product: prod_id},
            success: function(data)
            {
                if(data=="true")
                {
                    caller.removeClass("btn-success add_to_kart");
                    caller.addClass("btn-danger remove_from_kart");
                    caller.find(".btn_text").text(" Remove");
                }
                else
                    alert("There was some problem adding the item! Please try again.");
            }
        });
    });
    $(document).on("click",".remove_from_kart",function()
    {
        var prod_id = $(this).attr('rel');
        var caller = $(this);
        
        /* Animation on click*/
        $('body').on('scroll touchmove mousewheel', function(e){
          e.preventDefault();
          e.stopPropagation();
          return false;
        })
        $("#trash").fadeIn("fast");

        var anim1 = $(this).parents(".flip-container");
        var anim = anim1.find(".main_thumbnail").clone();

        anim.css('height','100px');
        anim.css('width','100px');

        $("#kart_div").before(anim);

        var pos = anim.offset();
        $("body").prepend(anim);
        var move = anim.css({
            "position": "absolute",
            "z-index": "9",
            "top": pos.top,
            "left": pos.left
        });
        var block1 = $("#kart_div").offset();
        move.animate({
            "top": block1.top-50,
            "left": block1.left-50,
            "width": 50,
            "height": 50,
        }, 200
        );

        var trash = $("#trash").offset();
        setTimeout(function()
        {
            move.animate
            ({
                "top": trash.top+10,
                "left": trash.left+10,
                "width": 50,
                "height": 50,
            },1000);
            $("#lid, #lidcap").css(
            {
                transform: 'rotateZ(-20deg)',
                MozTransform: 'rotateZ(-20deg)',
                WebkitTransform: 'rotateZ(-20deg)',
                msTransform: 'rotateZ(-20deg)'
            });
        },250);

        setTimeout(function()
        {
            $("#lid, #lidcap").css(
            {
                transform: 'rotateZ(20deg)',
                MozTransform: 'rotateZ(20deg)',
                WebkitTransform: 'rotateZ(20deg)',
                msTransform: 'rotateZ(20deg)'
            });
        },1300);

        setTimeout(function()
        {
            $("#lid, #lidcap").css(
            {
                transform: 'rotateZ(-20deg)',
                MozTransform: 'rotateZ(-20deg)',
                WebkitTransform: 'rotateZ(-20deg)',
                msTransform: 'rotateZ(-20deg)'
            });
        },1500);

        setTimeout(function()
        {
            $("#lid, #lidcap").css(
            {
                transform: 'rotateZ(0deg)',
                MozTransform: 'rotateZ(0deg)',
                WebkitTransform: 'rotateZ(0deg)',
                msTransform: 'rotateZ(0deg)'
            });
        },1700);

        setTimeout(function()
        {
            anim.remove();  
            $("#trash").fadeOut("slow");
            $("body").css('overflow','auto');
            $("body").off("scroll touchmove mousewheel");
        },1800);
        /* End of Animation*/

        $.ajax
        ({
            type: "POST",
            url: "kart/remove_from_kart",
            data: {product: prod_id},
            success: function(data)
            {
                if(data=="true")
                {
                    caller.removeClass("btn-danger remove_from_kart");
                    caller.addClass("btn-success add_to_kart");
                    caller.find(".btn_text").text(" Add to Kart");
                }
                else
                    alert("There was some problem removing the item! Please try again.");
            }
        });
    });
});