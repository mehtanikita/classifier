<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/sql" prefix="sql"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<!DOCTYPE html>
<html>
<head>
	<meta charset="utf-8">
	<meta http-equiv="X-UA-Compatible" content="IE=edge">
	<title>El' Predicto</title>
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
	<script type="text/javascript">
		$(document).ready(function() {
			$('.dropdown-toggle').dropdown();
			$("#tips_btn").click(function(){ $(this).find(".label").fadeOut("slow");});
			$("#notif_btn").click(function(){ $(this).find(".label").fadeOut("slow");	});
			$("#friend_req_btn").click(function(){ $(this).find(".label").fadeOut("slow");	});
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
				class="logo-mini"><b>Cl</b></span> <span class="logo-lg"><b>Classifier</b></span>
			</a>
			<nav class="navbar navbar-static-top" role="navigation">
				<a href="#" class="sidebar-toggle" data-toggle="offcanvas"
					role="button"> <span class="sr-only">Toggle navigation</span>
				</a>
				<div class="navbar-custom-menu">
					<ul class="nav navbar-nav">
						<!-- Messages: style can be found in dropdown.less-->
						<li class="dropdown messages-menu">
								<a href="#" id="tips_btn"
									class="dropdown-toggle" data-toggle="dropdown"> <i
										class="fa fa-lightbulb-o"></i>
										<span class="label label-success">5</span>
								</a>
							<ul class="dropdown-menu">
								<li class="header">You have 5 new tips</li>
								<li>
									<!-- inner menu: contains the actual data -->
									<ul class="menu">
										<li>
											<!-- start message --> <a>
												<div class="pull-left">
													<i class="fa fa-lightbulb-o"></i>
												</div>
												<h4>
													Temp
												</h4>
										</a>
										</li>
										<!-- end message -->
									</ul>
								</li>
								<li class="footer"><a href="tips/view">See All tips.</a></li>
							</ul></li>
						<!-- Notifications: style can be found in dropdown.less -->
						<li class="dropdown notifications-menu">
								<a href="#" id="notif_btn"
									class="dropdown-toggle" data-toggle="dropdown"> <i
										class="fa fa-bell-o"></i>
										<span class="label label-warning">3</span>
								</a>
							<ul class="dropdown-menu">
								<li class="header">You have 8 new notification(s).</li>
								<li>
									<!-- inner menu: contains the actual data -->
									<ul class="menu">
										<li>
											<a href="user/daily_data?id=1"> <i class="fa fa-users text-aqua"></i>
												Update your daily progress!
											</a>
										</li>
									</ul>
								</li>
							</ul></li>
						<!-- Tasks: style can be found in dropdown.less -->
						<li class="dropdown tasks-menu"><a href="#" id="friend_req_btn"
							class="dropdown-toggle" data-toggle="dropdown"> <i
								class="fa fa-user-plus"></i> 
								<span class="label label-danger">3</span>
						</a>
							<ul class="dropdown-menu">
								<li class="header">You have 3 new friend request(s).</li>
								<li>
									<!-- inner menu: contains the actual data -->
									<ul class="menu">
										<div class="confirm_friend_li">
											<div class="col-sm-12">
												<p><strong>Vortex</strong> sent you a friend request.</p>
											</div>
											<div class="col-sm-12">
												<div class="col-sm-5">
													<button class="btn btn-primary confirm_friend">
														<i class="fa fa-check"></i> Accept
													</button>
												</div>
												<div class="col-sm-2"></div>
												<div class="col-sm-5">
													<button class="btn btn-danger decline_friend">
														<i class="fa fa-times"></i> Reject
													</button>
												</div>
											</div>
										</div>
									</ul>
								</li>
							</ul></li>
						<!-- User Account: style can be found in dropdown.less -->
						<li class="dropdown user user-menu"><a href="#"
							class="dropdown-toggle" data-toggle="dropdown"> <img
								src="admin/resources/others/dist/img/user2-160x160.jpg"
								class="user-image" alt="User Image"> <span
								class="hidden-xs">Vortex</span>
						</a>
							<ul class="dropdown-menu">
								<!-- User image -->
								<li class="user-header"><img
									src="admin/resources/others/dist/img/user2-160x160.jpg"
									class="img-circle" alt="User Image">
									<p>
										Vortex
									</p>
								</li>
								<!-- Menu Footer-->
								<li class="user-footer">
									<div class="pull-left">
										<a href="#" class="btn btn-default btn-flat">Profile</a>
									</div>
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