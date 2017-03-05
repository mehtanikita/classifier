<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@include file="header.jsp" %>
	<%
		String s = request.getParameter("q");
		out.println(s);
	%>

<%@include file="footer.jsp" %>
    