<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@include file="authenticate.jsp" %>
<%@include file="settings.jsp" %>
<%
	String id = request.getParameter("id");

	String sql = "DELETE FROM category WHERE id = "+id;
	stmt.executeUpdate(sql);
	
	sql = "DELETE FROM word_list WHERE category_id = "+id;
	stmt.executeUpdate(sql);
	
	sql = "DELETE FROM articles WHERE category_id = "+id;
	stmt.executeUpdate(sql);
%>