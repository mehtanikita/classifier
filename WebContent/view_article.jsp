<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ page import="java.sql.*,java.io.*" %>
<%@include file="header.jsp" %>
	<% 
		String a_id = request.getParameter("i");
		ResultSet r = stmt.executeQuery("SELECT * FROM articles WHERE id='"+a_id+"'");
		r.next();
		String title = r.getString("title");
		String a_name = r.getString("name");
		String s_tags = r.getString("s_tags");
		String path = System.getProperty("user.dir")+"/";
		
		String[] tags = s_tags.split(",");
		File file = new File(path+a_name);
		FileInputStream fis = new FileInputStream(file);
		byte[] data = new byte[(int) file.length()];
		fis.read(data);
		fis.close();
		
		a_name = a_name.replace(".txt","");
		String str = new String(data, "UTF-8");
		str = str.replaceAll("[^\\x00-\\x7F]", "");
		str = str.replaceAll("\\n","<br/>");
	%>
	<link href="css/view_article.css" rel="stylesheet" type="text/css"/>
	<script src="js/view_article.js" type="text/javascript"></script>
	<div id="main_div" class="col-md-12">
		
		<div id="article_div" class="col-md-offset-2 col-md-8">
			<div id="article">
				<div id="article_head">
					<p class="text-center"><a href=""><%=title %></a></p>
				</div>
				<div id="article_body">
					<p><%=str%></p>
				</div>
				<div id="tags_div">
				<% for(String t : tags){%>  
					<a href="explore_tags.jsp?t=<%=t%>" title="Explore">
						<span class="label label-primary"><%=t%></span>
					</a>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
				<%}%>
				</div>
			</div>
		</div>
		<input type="hidden" id="article_id" value="<%=a_id %>"/>
	</div>
<%@include file="footer.jsp" %>