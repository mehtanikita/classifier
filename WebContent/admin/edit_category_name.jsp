<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@include file="authenticate.jsp" %>
<%@include file="settings.jsp" %>
<%
	String id = request.getParameter("id");
	String name = request.getParameter("name");
	
	String sql = "UPDATE category SET name = '"+name+"' WHERE id = "+id;
	stmt.executeUpdate(sql);
%>