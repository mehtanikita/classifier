<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@include file="settings.jsp" %>
<%
	int limit = 5;	
	String q = request.getParameter("query");	
	
	String query = "SELECT * FROM tags WHERE (name like '"+q+"%' OR name like '%"+q+"%' OR name like '"+q+"%') GROUP BY name ORDER BY CASE WHEN name LIKE '"+q+"%' THEN 1 WHEN name LIKE '%"+q+"%' THEN 2 WHEN name LIKE '%"+q+"' THEN 3 ELSE 5 END, name ASC, cnt DESC LIMIT "+limit;
	ResultSet r = stmt.executeQuery(query);
	
	while(r.next()){
%>
	<p><%= r.getString("name")%></p>
<% 	
	limit--;
	} 
	
	if(limit > 0)
	{
		query = "SELECT * FROM word_list WHERE (word like '"+q+"%' OR word like '%"+q+"%' OR word like '"+q+"%') GROUP BY word ORDER BY CASE WHEN word LIKE '"+q+"%' THEN 1 WHEN word LIKE '%"+q+"%' THEN 2 WHEN word LIKE '%"+q+"' THEN 3 ELSE 5 END, word ASC LIMIT "+limit;
		r = stmt.executeQuery(query);
	}
	while(r.next()){%>
		<p><%= r.getString("word")%></p>
	<%}
	%>