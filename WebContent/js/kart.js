$(document).ready(function()
{
    var check_arr = new Array();
    var address = $("#address").val();
    var address2 = "";
    var cnt=0;

    $(".category").each(function()
    {
        var check_arr = new Array();
        $(this).find(".attr_select").each(function(index)
        {
            check_arr[index] = $(this).val();
        });
        var p = $(this).parents(".kart_item").find(".product_no").val();
        var quant = $(this).find(".quantity");
        $.ajax
        ({
            type: "POST",
            url: "product/get_available",
            data: {attribute: check_arr, product: p},
            success: function(data)
            {
                quant.attr('max',data);
            }
        });
    });

    $(document).on("change",".quantity",function()
    {
        var val = parseInt($(this).val());
        var max = $(this).prop('max');
        if(val>max)
        {
            $(this).val(max);
        }

        var quantity = $(this).val();
        var total_quant = 0;
        var grand_total = 0;
        quantity = parseInt(quantity);
        $(this).parents(".append_div").find(".quantity").each(function()
        {
            total_quant += parseInt($(this).val());
        });
        $(this).parents(".kart_item").find(".price_div").find(".total_quant").text(total_quant);

        var price = $(this).parents(".kart_item").find(".price_div").find(".item_price").text();
        price = parseInt(price);
        $(this).parents(".kart_item").find(".price_div").find(".total_price").text(price*total_quant);

        $("#kart_details").find(".total_price").each(function()
        {
            grand_total += parseInt($(this).text());
        });

        $("#grand_total").text(grand_total);
        $(this).parents(".price_div").find(".total_price").text(quantity*price);
    });

    $(document).on("change",".attr_select",function()
    {
        $(this).parents(".category").find(".attr_select").each(function(index)
        {
            check_arr[index] = $(this).val();
        });
        var p = $(this).parents(".kart_item").find(".product_no").val();
        var quant = $(this).parents(".category").find(".quantity");
        quant.val('1');
        $.ajax
        ({
            type: "POST",
            url: "product/get_available",
            data: {attribute: check_arr, product: p},
            success: function(data)
            {
                quant.attr('max',data);
            }
        })
    });

    $(document).on("click",".plus_one",function()
    {
        var attr, quant, name, new_name, split;
        var parent = $(this).parents(".append_div");
        var clone = $(this).parents(".append_row").clone();
        clone.hide();

        var array_cnt = $(this).parents(".append_div").find(".array_cnt").text();
        array_cnt = parseInt(array_cnt)+1;
        $(this).parents(".append_div").find(".array_cnt").text(array_cnt);

        clone.find(".attr_select").each(function()
        {
            name = $(this).attr('name');
            split = name.substring(name.indexOf("[")+1,name.indexOf("]"));
            new_name = name.replace(split,"row"+(array_cnt));
            $(this).attr('name',new_name);
        });

        quant = clone.find(".quantity");
        name = quant.attr('name');
        split = name.substring(name.indexOf("[")+1,name.indexOf("]"));
        new_name = name.replace(split,"row"+(array_cnt));
        quant.attr('name',new_name);

        clone.find(".minus_one").removeClass("hide");
        $(this).siblings(".minus_one").removeClass("hide");
        parent.find(".plus_one").remove();
        parent.append(clone);
        parent.find(".append_row:last-child").find(".attr_select").trigger('change');
        clone.slideDown("fast");
        clone.find(".quantity").trigger("change");
    });

    $(document).on("click",".minus_one",function()
    {
        var rem = $(this).parents(".append_row");
        var parent = $(this).parents(".append_div");
        rem.slideUp(200);

        setTimeout(function()
        {
            if(rem.is(":last-child"))
            {
                var plus_minus = rem.find(".plus_minus").html();
            }
            rem.remove();
            parent.find(".append_row").last().find(".plus_minus").html(plus_minus);
            if(parent.find(".append_row").length==1)
            {
                parent.find(".append_row").find(".minus_one").addClass("hide");
            }
            parent.find(".quantity").trigger('change');
        },210);
    });

	$(document).on("click",".add_to_kart",function()
    {
        var prod_id = $(this).attr('rel');
        var caller = $(this);

        /* Animation on click*/

     	var anim1 = $(this).parents(".kart_item");
        var anim = anim1.find(".product_img").clone();

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

        var anim1 = $(this).parents(".kart_item");
        var anim = anim1.find(".product_img").clone();

        anim.css('height','200px');
        anim.css('width','200px');

        anim1.before(anim);

        var pos = anim.offset();
        $("body").prepend(anim);
        var move = anim.css({
            "position": "absolute",
            "z-index": "9",
            "top": pos.top+30,
            "left": pos.left+30
        });
        var block1 = anim.offset();
        move.animate({
            "top": block1.top-50,
            "left": block1.left-50,
            "width": 100,
            "height": 100,
        }, 400
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
            },800);
            $("#lid, #lidcap").css(
            {
                transform: 'rotateZ(-20deg)',
                MozTransform: 'rotateZ(-20deg)',
                WebkitTransform: 'rotateZ(-20deg)',
                msTransform: 'rotateZ(-20deg)'
            });
        },450);

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

    $("#payment_btn").click(function(e)
    {
        if(cnt==0)
        {
            e.preventDefault();
            $("#address_div").slideDown("fast");
            cnt++;
        }
    });
    $("#address").keyup(function()
    {
        address2 = $("#address").val();
        if(address2!=address)
        {
            $("#use_default").prop('checked',false);
        }
    });
    $("#use_default").change(function()
    {
        if($(this).prop('checked'))
        {
            $("#address").val(address);
        }
        else
        {
            $("#address").val(address2);
        }
    });
});