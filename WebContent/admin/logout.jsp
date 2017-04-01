<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%
	session.removeAttribute("admin_id");
	response.sendRedirect("index.jsp");
%>