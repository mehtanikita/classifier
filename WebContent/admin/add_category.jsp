<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@include file="authenticate.jsp" %>
<%@include file="settings.jsp" %>
<%
	String name = request.getParameter("name");
	
	String sql = "INSERT into category(name) VALUES ('"+name+"')";
	stmt.executeUpdate(sql);
	response.sendRedirect("view_categories.jsp");
%>