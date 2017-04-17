<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ page import="java.net.*,java.util.Map.Entry,java.util.stream.Collectors,java.util.regex.Pattern,java.lang.*,java.text.DecimalFormat, java.math.*, controller.WordDetails, com.jaunt.*" %>
<%@ page import="java.sql.*,java.util.*,java.io.*,org.apache.commons.lang3.StringEscapeUtils" %>
<%
	Class.forName("com.mysql.jdbc.Driver");
	Connection c = DriverManager.getConnection("jdbc:mysql://localhost/newsbee","root","");
	Statement stmt = c.createStatement();
	String sql = "SELECT * FROM headlines JOIN news on headlines.id = news.headline_id WHERE category = 'business'";
	ResultSet r = stmt.executeQuery(sql);
	while(r.next()){
%>
	<p><%=r.getString("text") %></p>
	<br/><br/><hr/>
<% }%>