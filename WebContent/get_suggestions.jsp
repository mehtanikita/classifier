<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ page import="java.util.*"%>
<%@include file="settings.jsp" %>
<%
	int limit = 5;
	LinkedHashSet<String> words = new LinkedHashSet<String>();  
	String q = request.getParameter("query");
	q = q.trim();
	
	boolean sent = false;
	boolean cat = false;
	int cat_id = 0;
	String cat_str = "";
	String init = "";
	String query;
	ResultSet r;
	if(q.indexOf(":") > -1)
	{
		query = "SELECT * FROM category WHERE name = '"+q.substring(0,q.indexOf(':'))+"'";
		r = stmt.executeQuery(query);
		if(r.next())
		{
			cat = true;
			cat_id = r.getInt("id");
		}
	}
	if(q.indexOf(" ") > -1)
	{
		sent = true;
		init = q.substring(0,q.lastIndexOf(" ") + 1);
		q = q.substring(q.lastIndexOf(" ") + 1, q.length());
	}
	else
	{
		query = "SELECT * FROM category WHERE name LIKE '"+q+"%' ORDER BY name LIMIT "+limit;
		r = stmt.executeQuery(query);
		
		while(r.next())
		{
			words.add(r.getString("name")+": ");
			limit--;
		} 
	}
	if(limit > 0)
	{
		query = "SELECT * FROM tags WHERE (name = '"+q+"' OR name like '"+q+"%' OR name like '%"+q+"%' OR name like '"+q+"%') GROUP BY name ORDER BY CASE WHEN name = '"+q+"' THEN 1 WHEN name LIKE '"+q+"%' THEN 2 WHEN name LIKE '%"+q+"%' THEN 3 WHEN name LIKE '%"+q+"' THEN 4 ELSE 5 END, name ASC, cnt DESC LIMIT "+limit;
		r = stmt.executeQuery(query);
		
		while(r.next())
		{
			words.add(r.getString("name"));
			limit--;
		} 
		if(limit > 0)
		{
			if(cat)
				cat_str = " AND category_id = '"+cat_id+"'";
			query = "SELECT * FROM word_list WHERE (word = '"+q+"' OR word like '"+q+"%' OR word like '%"+q+"%' OR word like '"+q+"%') "+cat_str+" GROUP BY word ORDER BY CASE WHEN word = '"+q+"' THEN 1 WHEN word LIKE '"+q+"%' THEN 2 WHEN word LIKE '%"+q+"%' THEN 3 WHEN word LIKE '%"+q+"' THEN 4 ELSE 5 END, word ASC LIMIT "+limit;
			r = stmt.executeQuery(query);
			
			while(r.next())
			{
				words.add(r.getString("word"));
			}
		}
		
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