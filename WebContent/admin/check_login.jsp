<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%
	String uname = (String) request.getParameter("username");
	String pword = (String) request.getParameter("password");
	
	if(uname.equals("admin") && pword.equals("admin"))
	{
		session.setAttribute("admin_id",13);
		response.sendRedirect("dashboard.jsp");
	}
	else
		response.sendRedirect("index.jsp");

%>