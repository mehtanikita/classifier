<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ page import="java.util.*"%>
<%@include file="settings.jsp" %>
<%
	int limit = 5;
	HashSet<String> words = new HashSet<String>();  
	String q = request.getParameter("query");	
	q = q.trim();
	
	boolean sent = false;
	String init = "";
	if(q.indexOf(" ") > -1)
	{
		sent = true;
		init = q.substring(0,q.lastIndexOf(" ") + 1);
		q = q.substring(q.lastIndexOf(" ") + 1, q.length());
	}
	
	String query = "SELECT * FROM tags WHERE (name like '"+q+"%' OR name like '%"+q+"%' OR name like '"+q+"%') GROUP BY name ORDER BY CASE WHEN name LIKE '"+q+"%' THEN 1 WHEN name LIKE '%"+q+"%' THEN 2 WHEN name LIKE '%"+q+"' THEN 3 ELSE 5 END, name ASC, cnt DESC LIMIT "+limit;
	ResultSet r = stmt.executeQuery(query);
	
	while(r.next())
	{
		words.add(r.getString("name"));
		limit--;
	} 
	
	if(limit > 0)
	{
		query = "SELECT * FROM word_list WHERE (word like '"+q+"%' OR word like '%"+q+"%' OR word like '"+q+"%') GROUP BY word ORDER BY CASE WHEN word LIKE '"+q+"%' THEN 1 WHEN word LIKE '%"+q+"%' THEN 2 WHEN word LIKE '%"+q+"' THEN 3 ELSE 5 END, word ASC LIMIT "+limit;
		r = stmt.executeQuery(query);
	}
	while(r.next())
	{
		words.add(r.getString("word"));
	}
	
	Iterator<String> itr = words.iterator();
	while(itr.hasNext())
	{
		if(sent)
		{%>
			<p><%=init%><%= itr.next() %></p>
		<%}
		else
		{%>
			<p><%= itr.next() %></p>
		<%}
	} 	
	%>