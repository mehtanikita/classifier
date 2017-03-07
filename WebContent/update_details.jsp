<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@include file="settings.jsp" %>
<%
	String a_id = request.getParameter("a_id");
	String time = request.getParameter("time");
	String query = "UPDATE articles SET view_count = view_count + 1, time_count = time_count + "+time+" WHERE id='"+a_id+"'";
	stmt.executeUpdate(query);
%>