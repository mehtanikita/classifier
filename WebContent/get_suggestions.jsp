<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%
	int limit = 4;	
	String q = request.getParameter("query");	
	
	for(int i=1; i <= 4; i++)
	{ 
%>
	<p><%= q %></p>
<% 	} %>