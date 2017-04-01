<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@include file="settings.jsp" %>
<%
	String q = request.getParameter("q");
	String a_id = request.getParameter("a_id");
	String return_url = request.getParameter("return_url");
	
	String chk_query = "SELECT * FROM search WHERE search_string = '"+q+"' AND article_id = "+a_id;
	ResultSet r = stmt.executeQuery(chk_query);
	if(r.next())
		stmt.executeUpdate("UPDATE search set click_cnt = click_cnt + 1 WHERE search_string = '"+q+"' AND article_id = "+a_id);
	else
		stmt.executeUpdate("INSERT INTO search(search_string, article_id, click_cnt) VALUES('"+q+"','"+a_id+"','1')");
	
	response.sendRedirect(return_url);
%>
