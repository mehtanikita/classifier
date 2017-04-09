<%@page import="javax.net.ssl.HttpsURLConnection"%>
<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ page import="java.net.*,java.io.*, java.text.DecimalFormat, java.math.*, org.json.*,controller.Sentiment" %>
<%@include file="settings.jsp" %>
<% 
	String a_id = request.getParameter("article_id");
	String name = request.getParameter("name");
	if(name.equals("") || name == null)
		name = "Anonymous";
	String text = (String) request.getParameter("review_text");

	String USER_AGENT = "Mozilla/5.0";
	
	DecimalFormat df = new DecimalFormat("#.##");
	df.setRoundingMode(RoundingMode.CEILING);
	Double percent;
	try{
		Sentiment s = new Sentiment(text);
		
		String type = s.type;
		double tmp_score = Double.parseDouble(s.score);
		String score;
		
		tmp_score /= 2;
		tmp_score += 0.5;
		tmp_score *= 100;
		
		score = df.format(tmp_score);
		
		String query = "INSERT INTO reviews(article_id,name,text,type,score) VALUES ("+a_id+",'"+name+"','"+StringEscapeUtils.escapeEcmaScript(encode(text))+"','"+type+"',"+score+")";

		stmt.executeUpdate(query);
		
		query = "SELECT COUNT(score) AS cnt, ROUND(SUM(score),2) AS total_score FROM reviews";
		ResultSet r = stmt.executeQuery(query);
		r.next();
		int cnt = r.getInt("cnt");
		
		double total_score = r.getDouble("total_score");
		String avg = df.format(total_score/cnt);
		out.println(avg);
		
		query = "UPDATE articles SET review_score="+avg+" WHERE id="+a_id;
		stmt.executeUpdate(query);
		response.sendRedirect("view_article.jsp?i="+a_id+"&on=id&sort=desc#all_reviews");
	}
	catch(Exception e){}
	
	
%>