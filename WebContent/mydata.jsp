<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ page import="java.net.*,java.util.Map.Entry,java.util.stream.Collectors,java.util.regex.Pattern,java.lang.*,java.text.DecimalFormat, java.math.*, controller.WordDetails, com.jaunt.*" %>
<%@ page import="java.sql.*,controller.Sentiment,java.util.*,java.io.*,org.apache.commons.lang3.StringEscapeUtils" %>
<%!
	public int r(int min, int max)
	{
		return min + (int) (Math.random() * ((max - min) + 1));
	}
	public static String encode(String s)
	{
		return StringEscapeUtils.escapeJava(s);
	}
%>
<%
	Class.forName("com.mysql.jdbc.Driver");
	Connection c = DriverManager.getConnection("jdbc:mysql://localhost/classifier","root","");
	Statement stmt = c.createStatement();
	Statement st = c.createStatement();
	Statement ta = c.createStatement();
	String sql = "SELECT * FROM reviews";
	String[] names = {"Anonymous","John Doe","Nikita","Charmy","Vortex","William","Smith","Kohli"};
	String name;
	HashMap<String,String> re = new HashMap<String,String>();
	ResultSet r = stmt.executeQuery(sql);
	ArrayList<String> reviews = new ArrayList<String>();
	while(r.next()){
			reviews.add(r.getString("text"));
			re.put(r.getString("text"), r.getString("score"));
	}
	int len = reviews.size();
	String str,sc,type;

	r = stmt.executeQuery("SELECT * FROM articles WHERE id < 80");
	while(r.next())
	{
		int a_id = r.getInt("id");
		int no = r(2,7);
		for(int i = 1; i <= no; i++)
		{
			name = names[r(0,names.length-1)];
			str = reviews.get(r(0,len-3));
			sc = re.get(str);
			double sco = Double.parseDouble(sc);
			if(sco > 50)
				type = "positive";
			else
				type = "negative";
			String query = "INSERT INTO reviews(article_id,name,text,type,score) VALUES ("+a_id+",'"+name+"','"+StringEscapeUtils.escapeEcmaScript(encode(str))+"','"+type+"',"+sc+")";
			//st.executeUpdate(query);
		}
		out.println("<br/><br/>");
	}	
%>
	<br/><br/><hr/>
