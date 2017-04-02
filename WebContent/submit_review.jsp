<%@page import="javax.net.ssl.HttpsURLConnection"%>
<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ page import="java.net.*,java.io.*, java.text.DecimalFormat, java.math.*, org.json.*" %>
<%@include file="settings.jsp" %>
<% 
	String a_id = request.getParameter("article_id");
	String name = request.getParameter("name");
	if(name.equals("") || name == null)
		name = "Anonymous";
	String text = request.getParameter("review_text");
	
	String USER_AGENT = "Mozilla/5.0";
	
	DecimalFormat df = new DecimalFormat("#.##");
	df.setRoundingMode(RoundingMode.CEILING);
	Double percent;
	try{
		String txt = URLEncoder.encode(text, "UTF-8");
		String url = "http://sentiment.vivekn.com/api/text/?txt="+txt;
		
		
		URL obj = new URL(url);
		HttpURLConnection  con = (HttpURLConnection ) obj.openConnection();

		//add reuqest header
		con.setRequestMethod("POST");
		con.setRequestProperty("User-Agent", USER_AGENT);
		con.setRequestProperty("Accept-Language", "en-US,en;q=0.5");

		String urlParameters = "txt="+txt;

		// Send post request
		con.setDoOutput(true);
		DataOutputStream wr = new DataOutputStream(con.getOutputStream());
		wr.writeBytes(urlParameters);
		wr.flush();
		wr.close();

		BufferedReader in = new BufferedReader(
		        new InputStreamReader(con.getInputStream()));
		String inputLine;
		StringBuffer resp = new StringBuffer();

		while ((inputLine = in.readLine()) != null) {
			resp.append(inputLine);
		}
		in.close();

		//print result
		//out.println(resp.toString()+"<br/><br/>");
		
		JSONObject json = new JSONObject(resp.toString());
		JSONObject data = (JSONObject)json.get("result");
		
		String type = (String) data.get("sentiment");
		double tmp_score = Double.parseDouble((String)data.get("confidence"));
		String score;
		
		if(!type.equals("Positive"))
			tmp_score = 100 - tmp_score;
		score = df.format(tmp_score);
		
		String query = "INSERT INTO reviews(article_id,name,text,type,score,time_when) VALUES ("+a_id+",'"+name+"','"+text+"','"+type+"',"+score+",'')";
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
		response.sendRedirect("view_article.jsp?i="+a_id);
	}
	catch(Exception e){}
	
	
%>