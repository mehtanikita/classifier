<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>

	<aside class="main-sidebar" style="position: fixed">
	    <section class="sidebar">
	        <div class="user-panel">
	            <div class="pull-left image">
	                <img src="admin/resources/others/dist/img/user2-160x160.jpg" class="img-circle" alt="User Image">
	            </div>
	            <div class="pull-left info">
	                <p></p>
	                <p>Admin Panel</p>
	            </div>
	        </div>
	
	        <ul class="sidebar-menu">
	            <li class="active">&nbsp</li>
	            <li class="treeview">
	                <a ref=""><i class="fa fa-dashcube"></i><span> Dashboard</span> <i class="fa fa-angle-left pull-right"></i></a>
	                <ul class="treeview-menu">
	                    <li><a href="admin/dashboard.jsp"><i class="fa fa-home"></i> Home </a></li>
	                    <li><a href="admin/view_articles.jsp"><i class="fa fa-file-text"></i> Articles </a></li>
	                    <li><a href="admin/view_words.jsp"><i class="fa fa-file-word-o"></i> Words </a></li>
	                    <li><a href="admin/view_search.jsp"><i class="fa fa-search"></i> Search </a></li>
	                    <li><a href="admin/view_ratings.jsp"><i class="fa fa-star"></i> Reviews </a></li>
	                    <li><a href="admin/view_categories.jsp"><i class="fa fa-book"></i> Categories </a></li>
	                    <li><a href="admin/add_words.jsp"><i class="fa fa-plus"></i> Add Words </a></li>
	                </ul>
	            </li>
	        </ul>
	    </section>
	</aside>
	<div class="content-wrapper">
    	<div class="content" id="content_div" style="padding-top: 100px; min-height: 600px;">