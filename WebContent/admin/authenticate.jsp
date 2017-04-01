<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%
	int admin_id = 0;
	if(session.getAttribute("admin_id") != null)
	{
		admin_id = (int) session.getAttribute("admin_id");
	}
	if(admin_id != 13)
		response.sendRedirect("index.jsp");
%>