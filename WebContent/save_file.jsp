<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ page import="java.io.File, java.io.IOException, java.sql.*" %>
<% 
	Class.forName("com.mysql.jdbc.Driver");
	
	Connection c=DriverManager.getConnection("jdbc:mysql://localhost/niki","root","");
	Statement s=c.createStatement();
	ResultSet r=s.executeQuery("Select * from student");

	String txt = (String)request.getParameter("file_text");
	String path = System.getProperty("user.dir");
	String name = "newfile.txt";
	out.println(txt+"<br/>");
	try {
	     File file = new File(path + "/" + name);
         boolean fvar = file.createNewFile();
	     if (fvar)
	     {
			
	     }
	     else
	     {
	          out.println("Error creating file!");
	     }
   	}
	catch (IOException e)
	{
   		out.println("Exception Occurred:");
	    e.printStackTrace();
	}
%>