<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@include file="header.jsp" %>
	<link href="css/upload.css" rel="stylesheet" type="text/css"/>
	<div id="main_div">
		<div class="col-md-offset-1 col-md-10">
			<div class="row">
				<div class="box box-primary">
			       <div class="box-header with-border">
			         <h3 class="box-title">Insert Article</h3>
			       </div>
			       <div class="box-body">
						<form action="save_file.jsp" method="POST">
							<input type="text" name="title" id="title_text" class="form-control" placeholder="Article Title"/>
							<textarea rows="10" cols="100" id="text_area" class="form-control" name="file_text" placeholder="Paste text here.." required oninvalid='this.setCustomValidity("Please enter some text")' oninput='this.setCustomValidity("")' ></textarea><br/>
							<input type="hidden" name="type" value="text"/>
							<div class="col-md-offset-10 col-md-2">
								<button class="btn btn-primary form-control">
									<span class="glyphicon glyphicon-file"></span>
									Insert Article
								</button>
							</div>
						</form>
					</div>
				</div>
			</div>
			<br/><br/><br/>
			<div class="row">
				<div class="box box-success">
			       <div class="box-header with-border">
			         <h3 class="box-title">Upload Article</h3>
			       </div>
			       <div class="box-body">
						<form action="save_file.jsp" method="POST" enctype="multipart/form-data">
							<div id="upload_file_div">
								<h2 id="file_name">Drop files here.</h2>
								<input type="text" style="display: none" name="type" value="file"/>
								<input type="file" id="file_upload" name="file" accept="application/msword,text/plain" required/>
							</div><br/>
							<div class="col-md-offset-10 col-md-2">
								<button class="btn btn-success form-control">
									<span class="glyphicon glyphicon-cloud-upload"></span>
									Upload Article
								</button>
							</div>
						</form>
					</div>
				</div>
			</div>
		</div>
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