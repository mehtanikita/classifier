var time = 0;
$(document).ready(function()
{
	knob();
	setInterval(function(){time++;},1000);
	$("#sort_select").change(function()
	{
		var a_id = $("#article_id").val();
		var on = $(this).val().split("_")[0];
		var sort = $(this).val().split("_")[1];
		window.location.href = window.location.href.split('?')[0]+"?i="+a_id + "&on="+on+"&sort="+sort+"#all_reviews";
	});
	$("#view_reviews").click(function()
	{
		$("#all_reviews").show();
		$(this).remove();
	});
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
function knob()
{
	$(".knob").knob({
        draw: function () {

          // "tron" case
          if (this.$.data('skin') == 'tron') {

            var a = this.angle(this.cv)  // Angle
                    , sa = this.startAngle          // Previous start angle
                    , sat = this.startAngle         // Start angle
                    , ea                            // Previous end angle
                    , eat = sat + a                 // End angle
                    , r = true;

            this.g.lineWidth = this.lineWidth;

            this.o.cursor
                    && (sat = eat - 0.3)
                    && (eat = eat + 0.3);

            if (this.o.displayPrevious) {
              ea = this.startAngle + this.angle(this.value);
              this.o.cursor
                      && (sa = ea - 0.3)
                      && (ea = ea + 0.3);
              this.g.beginPath();
              this.g.strokeStyle = this.previousColor;
              this.g.arc(this.xy, this.xy, this.radius - this.lineWidth, sa, ea, false);
              this.g.stroke();
            }

            this.g.beginPath();
            this.g.strokeStyle = r ? this.o.fgColor : this.fgColor;
            this.g.arc(this.xy, this.xy, this.radius - this.lineWidth, sat, eat, false);
            this.g.stroke();

            this.g.lineWidth = 2;
            this.g.beginPath();
            this.g.strokeStyle = this.o.fgColor;
            this.g.arc(this.xy, this.xy, this.radius - this.lineWidth + 1 + this.lineWidth * 2 / 3, 0, 2 * Math.PI, false);
            this.g.stroke();

            return false;
          }
        }
      });
}