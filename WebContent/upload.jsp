<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@include file="header.jsp" %>
	<link href="css/upload.css" rel="stylesheet" type="text/css"/>
	<div id="main_div">
		<form action="save_file.jsp" method="POST">
			<input type="text" name="title" id="title_text" class="form-control" placeholder="Article Title"/>
			<textarea rows="10" cols="100" id="text_area" class="form-control" name="file_text" placeholder="Paste text here.." required oninvalid='this.setCustomValidity("Please enter some text")' oninput='this.setCustomValidity("")' ></textarea><br/>
			<input type="hidden" name="type" value="text"/>
			<button class="btn btn-primary form-control">
				<span class="glyphicon glyphicon-file"></span>
				Insert Article
			</button>
		</form>
		<br/><hr/>
		<h3 class="text-center" style="margin-top: -28px; margin-bottom: 20px;">OR</h3>
		<form action="save_file.jsp" method="POST" enctype="multipart/form-data">
			<div id="upload_file_div">
				<h1 id="file_name">Drop files here.</h1>
				<input type="text" style="display: none" name="type" value="file"/>
				<input type="file" id="file_upload" name="file" accept="application/msword,text/plain" required/>
			</div><br/>
			<button class="btn btn-success form-control">
				<span class="glyphicon glyphicon-cloud-upload"></span>
				Upload Article
			</button>
		</form>
	</div>
	<script type="text/javascript">
		$(document).ready(function()
		{
			$("#upload_file_div").click(function(e)
			{
				$("#file_upload").trigger('click');
			});
			$("#file_upload").click(function(e) {
				e.stopPropagation();
		   	});
			$("#file_upload").change(function()
			{
				$("#file_name").text($("#file_upload").val().split('\\')[2]);
			});
		});
	</script>
	<script type="text/javascript">
		
		upload_file_div.ondragover = upload_file_div.ondragenter = function(evt)
		{
			$("#upload_file_div").css('color','#4286f4');
			$("#upload_file_div").css('boxShadow','-5px 5px 5px #ccc');
		  	evt.preventDefault();
		};
		upload_file_div.ondragleave = function()
		{
			$("#upload_file_div").css('color','black');
			$("#upload_file_div").css('boxShadow','none');
		};
		upload_file_div.ondrop = function(evt)
		{
			file_upload.files = evt.dataTransfer.files;
			evt.preventDefault();
		};
	</script>
<%@include file="footer.jsp" %>