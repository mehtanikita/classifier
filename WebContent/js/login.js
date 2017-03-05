$(document).ready(function()
{
	$('[data-toggle="tooltip"]').tooltip();
	var name,inv_name,email,inv_email,contact,inv_contact,pword,cpword,pSpan,cSpan,re,inv_pword_check,inv_pword,pword_pristine;
	var orig_color = $("#name").parent().find("span").css('background-color');
	pword_pristine = cpword_pristine = 0;
	inv_name = inv_email = inv_contact = inv_pword_check = inv_pword = 1;

	$("#name").keyup(function()
	{
		name = $("#name").val();
		if(name=="")
		{
			inv_name=1;
		}
		else
		{
			$("#name").parent().find("span").css({'background-color':orig_color});
			$("#name").css({'border-color': orig_color});
			$("#name").attr('data-original-title','');
			$("#Name").siblings(".tooltip").hide();
			inv_name=0;
		}
	});
	$("#name").on("change",function()
	{
		if(inv_name==1)
		{
			$("#name").parent().find("span").css({'background-color':'red'});
			$("#name").css({'border-color': 'red'});
			$("#name").attr('data-original-title','Name can not be blank.');
		}
	});
	$("#name").on("focus",function()
	{
		if(inv_name!=1)
		{
			$("#name").css({'border-color': orig_color});
		}
	});
	$("#name").on("blur",function()
	{
		if(inv_name!=1)
		{
			$("#name").css({'border-color': '#cccccc'});
		}
	});

	$("#email").keyup(function()
	{
		email = $("#email").val();
    	re = /^(([^<>()\[\]\\.,;:\s@"]+(\.[^<>()\[\]\\.,;:\s@"]+)*)|(".+"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$/;
		if(!(re.test(email)))
		{
			inv_email=1;
		}
		else
		{
			$("#email").parent().find("span").css({'background-color':orig_color});
			$("#email").css({'border-color': orig_color});
			$("#email").attr('data-original-title','');
			$("#email").siblings(".tooltip").hide();
			inv_email=0;
		}
	});
	$("#email").on("change",function()
	{
		if(inv_email==1)
		{
			$("#email").parent().find("span").css({'background-color':'red'});
			$("#email").css({'border-color': 'red'});
			$("#email").attr('data-original-title','Invalid Email Id.');
		}
	});
	$("#email").on("focus",function()
	{
		if(inv_email!=1)
		{
			$("#email").css({'border-color': orig_color});
		}
	});
	$("#email").on("blur",function()
	{
		if(inv_email!=1)
		{
			$("#email").css({'border-color': '#cccccc'});
		}
	});

	$("#contact").keyup(function()
	{
		contact = $("#contact").val();
		if(isNaN(contact) || $("#contact").val()=="" || contact.length!=10)
		{
			inv_contact=1;
		}
		else
		{
			$("#contact").parent().find("span").css({'background-color':orig_color});
			$("#contact").css({'border-color': orig_color});
			$("#contact").attr('data-original-title','');
			$("#contact").siblings(".tooltip").hide();
			inv_contact=0;
		}
	});
	$("#contact").on("change",function()
	{
		if(inv_contact==1)
		{
			$("#contact").parent().find("span").css({'background-color':'red'});
			$("#contact").css({'border-color': 'red'});
			$("#contact").attr('data-original-title','Invalid Contact.');
		}
	});
	$("#contact").on("focus",function()
	{
		if(inv_contact!=1)
		{
			$("#contact").css({'border-color': orig_color});
		}
	});
	$("#contact").on("blur",function()
	{
		if(inv_contact!=1)
		{
			$("#contact").css({'border-color': '#cccccc'});
		}
	});
	$("#pword").keypress(function()
	{
		pword_pristine = 1;
	});
	$("#cpword").keypress(function()
	{
		cpword_pristine = 1;
	});

	$("#pword, #cpword").keyup(function()
	{
		if(pword_pristine==1 && cpword_pristine==1)
		{
			pword = $("#pword").val();
			cpword = $("#cpword").val();
			pSpan = $("#pword").parent().find("span");
			cSpan = $("#cpword").parent().find("span");

			if(pword==cpword)
			{
				inv_pword_check = 0;
				pSpan.css({'background-color': orig_color});
				cSpan.css({'background-color': orig_color});
				$("#pword").css({'border-color': '#ccc'});
				$("#cpword").css({'border-color': '#ccc'});
				$("#pword").attr('data-original-title','');
				$("#cpword").attr('data-original-title','');
				$(this).css({'border-color': orig_color});
				$(this).siblings(".tooltip").hide();
			}
			else
			{
				inv_pword_check = 1;
				pSpan.css({'background-color':'red'});
				cSpan.css({'background-color':'red'});
				$("#pword").css({'border-color': 'red'});
				$("#cpword").css({'border-color': 'red'});
				$("#pword").attr('data-original-title','Passwords do not match!');
				$("#cpword").attr('data-original-title','Passwords do not match!');
			}
		}
	});
	$("#pword, #cpword").focus(function()
	{
		if(pword==cpword)
		{
			$(this).css({'border-color': orig_color});
		}
	});
	$("#pword, #cpword").blur(function()
	{
		if(pword==cpword)
		{
			$("#pword").css({'border-color': '#ccc'});
			$("#cpword").css({'border-color': '#ccc'});
		}
	});
	$("#submit").click(function()
	{
		if($("#name").val()=="")
		{
			$("#name").trigger("change");
			$("#name").focus();
			return false;
		}
		else if(inv_email==1)
		{
			$("#email").trigger("change");
			$("#email").focus();
			return false;
		}
		else if(inv_contact==1)
		{
			$("#contact").trigger("change");
			$("#contact").focus();
			return false;
		}
		else if(inv_pword_check==1)
		{
			$("#cpword").trigger("keyup");
			$("#cpword").focus();
			return false;
		}
		else
		{
			$("#submit").prop('disabled',false);
			return true;
		}
	});
	$("#signup").on("keyup blur", function()
	{
		if(inv_email==0 && inv_contact==0 && inv_pword_check==0)
		{
			$("#submit").prop('disabled',false);
		}
	});
});