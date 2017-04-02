<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@include file="settings.jsp" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
	<meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <meta name="description" content="">
    <meta name="author" content="">

	<title>Classifier</title>
	<link rel="shortcut icon" type="image/png" href="favicon.png"/>
	<link href="css/bootstrap.css" rel="stylesheet" type="text/css"/>
	<link href="css/landing-page.css" rel="stylesheet">
    <link href="font-awesome/css/font-awesome.min.css" rel="stylesheet" type="text/css">
    <link href="https://fonts.googleapis.com/css?family=Lato:300,400,700,300italic,400italic,700italic" rel="stylesheet" type="text/css">
	<link href="css/stylesheet.css" rel="stylesheet" type="text/css"/>
	
	<script src="js/jquery.js" type="text/javascript"></script>
	<script src="js/bootstrap.js" type="text/javascript"></script>
	<script src="js/general.js" type="text/javascript"></script>
</head>
<%!
	public static int get_value(String name, HashMap<String,String> vars)
	{
		return Integer.parseInt(vars.get(name).split(":")[1]);
	}
%>
<%
	HashMap<String,String> vars=new HashMap<String,String>();
	
	try (BufferedReader br = new BufferedReader(new FileReader(System.getProperty("user.dir")+"/variables.txt"))) {
	    String line;
	    String[] arr = new String[2];
	    while ((line = br.readLine()) != null) {
	    	arr = line.split(",");
	    	vars.put(arr[0],arr[1]);
	    }
	}
%>
<body>
	<nav class="navbar navbar-default navbar-fixed-top topnav" role="navigation">
        <div class="container topnav">
            <!-- Brand and toggle get grouped for better mobile display -->
            <div class="navbar-header">
                <button type="button" class="navbar-toggle" data-toggle="collapse" data-target="#bs-example-navbar-collapse-1">
                    <span class="sr-only">Toggle navigation</span>
                    <span class="icon-bar"></span>
                    <span class="icon-bar"></span>
                    <span class="icon-bar"></span>
                </button>
                <a class="navbar-brand topnav" href="index.jsp">Classifier</a>
            </div>
            <!-- Collect the nav links, forms, and other content for toggling -->
            <div class="collapse navbar-collapse" id="bs-example-navbar-collapse-1">
                <ul class="nav navbar-nav navbar-right">
                	<li>
                        <a href="index.jsp#trending">Trending</a>
                    </li>
                    <li>
                        <a href="upload.jsp">Upload</a>
                    </li>
                    <li>
                        <a href="index.jsp#contact">Contact</a>
                    </li>
                </ul>
            </div>
            <!-- /.navbar-collapse -->
        </div>
        <!-- /.container -->
    </nav>
