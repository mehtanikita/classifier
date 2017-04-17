<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@include file="settings.jsp" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/sql" prefix="sql"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<!DOCTYPE html>
<html>
<head>
	<meta charset="utf-8">
	<meta http-equiv="X-UA-Compatible" content="IE=edge">
	<title>Admin Panel</title>
	<meta
		content="width=device-width, initial-scale=1, maximum-scale=1, user-scalable=no"
		name="viewport">
	<base href="${pageContext.request.contextPath}/"></base>
	<link rel="shortcut icon" type="image/png" href="admin/resources/img/favicon.png"/>
	<link rel="stylesheet" type="text/css" href="admin/resources/others/bootstrap/css/bootstrap.min.css">
	<link rel="stylesheet" type="text/css" href="admin/resources/css/font-awesome.css">
	<link rel="stylesheet" type="text/css" href="admin/resources/css/ionicons.css">
	<link rel="stylesheet" type="text/css" href="admin/resources/others/dist/css/AdminLTE.min.css">
	<link rel="stylesheet" type="text/css" href="admin/resources/others/dist/css/skins/_all-skins.min.css">
	<link rel="stylesheet" type="text/css" href="admin/resources/css/stylesheet.css">
	<link rel="stylesheet" type="text/css" href="admin/resources/css/select2.css">
	<link rel="stylesheet" type="text/css" href="admin/resources/css/jquery-confirm.css">
	<link rel="stylesheet" type="text/css" href="admin/resources/css/dropzone.css">
	<link rel="stylesheet" type="text/css" href="admin/resources/js/square/purple.css">
	
	<script type="text/javascript" src="admin/resources/others/plugins/jQuery/jQuery-2.1.4.min.js"></script>
	<script type="text/javascript" src="admin/resources/others/bootstrap/js/bootstrap.min.js"></script>
	<script type="text/javascript" src="admin/resources/js/jquery-confirm.js"></script>
	<script type="text/javascript" src="admin/resources/js/icheck.js"></script>
	<script type="text/javascript" src="admin/resources/js/jquery.validate.js"></script>
	<script type="text/javascript" src="admin/resources/js/dropzone.js"></script>
	<script src="admin/resources/js/jquery.dataTables.js"></script>
	<script src="admin/resources/js/dataTables.bootstrap.js"></script>
	<script type="text/javascript">
		$(document).ready(function() {
			$('.dropdown-toggle').dropdown();
			$("#tips_btn").click(function(){ $(this).find(".label").fadeOut("slow");});
			$("#notif_btn").click(function(){ $(this).find(".label").fadeOut("slow");	});
			$("#friend_req_btn").click(function(){ $(this).find(".label").fadeOut("slow");	});
			
			$("#dataTable").show();
	    	$("#dataTable").DataTable();
		});
	</script>
	<script type="text/javascript" src="admin/resources/js/select2.js"></script>
	<script type="text/javascript" src="admin/resources/js/general.js"></script>
	<script type="text/javascript" src="admin/resources/others/plugins/slimScroll/jquery.slimscroll.min.js"></script>
	<script type="text/javascript" src="admin/resources/others/dist/js/app.min.js"></script>
</head>
<body class="skin-blue sidebar-mini">
	<div id="wrapper">
		<header class="main-header"  style="position: fixed; width: 100%">
			<a href="javascript:void(0)" class="logo"> <span
				class="logo-mini"><b>C</b></span> <span class="logo-lg"><b>Classifier</b></span>
			</a>
			<nav class="navbar navbar-static-top" role="navigation">
				<a href="#" class="sidebar-toggle" data-toggle="offcanvas"
					role="button"> <span class="sr-only">Toggle navigation</span>
				</a>
				<div class="navbar-custom-menu">
					<ul class="nav navbar-nav">
						
						<!-- User Account: style can be found in dropdown.less -->
						<li class="dropdown user user-menu"><a href="#"
							class="dropdown-toggle" data-toggle="dropdown"> <img
								src="admin.png"
								class="user-image" alt="User Image"> <span
								class="hidden-xs">Classifier</span>
						</a>
							<ul class="dropdown-menu">
								<!-- User image -->
								<li class="user-header"><img
									src="admin.png"
									class="img-circle" alt="User Image">
									<p>
										Classifier
									</p>
								</li>
								<!-- Menu Footer-->
								<li class="user-footer">
									<div class="pull-right">
										<a href="admin/logout.jsp" class="btn btn-default btn-flat">Sign out</a>
									</div>
								</li>
							</ul>
						</li>
					</ul>
				</div>
			</nav>
		</header>