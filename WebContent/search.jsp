<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ page import="org.apache.commons.lang3.*" %>
<%@include file="header.jsp" %>
	<% String s = request.getParameter("q");%>
	<link href="css/search.css" rel="stylesheet" type="text/css"/>
	<div id="main_div" class="col-md-12">
		
		<div id="search_results_div" class="col-md-offset-2 col-md-8">
			<div id="search_header">
				<form action="search.jsp">
					<div class="col-md-10">
						<div class="form-group">
							<input type="text" name="q" class="form-control" value="<%=s%>" placeholder="Search Here.." required oninvalid="this.setCustomValidity('Please enter something')" onkeyup="this.setCustomValidity('')"/>
						</div>
					</div>
					<div class="col-md-2">
						<button class="btn btn-primary">
							Search
							<i class="fa fa-search fa-fw"></i>
						</button>
					</div>
				</form>
			</div>
			<div class="clearfix"></div><br/>
			<div id="search_results">
			<div style="background: #fff">
				<%
					s = s.replaceAll("[^\\w\\s]+", "");
					s = s.trim();
					int spaces = s.length() - s.replace(" ", "").length();
					int n_splits = 1;
					int ind,e_ind,start = 0,end = s.length();
					while((n_splits <= spaces+1) && (true))
					{
						out.println("<h1>------"+n_splits+"--------</h1>");
						if(n_splits == 1)
						{
							out.println(s+ "<br/>");
						}
						else
						{
							for(int i = 1; i <= n_splits ; i++)
							{
								if(i == 1)
								{
									ind = StringUtils.ordinalIndexOf(s, " ",spaces+2-n_splits);
									out.println(s.substring(start,ind)+ "<br/>");
								}
								else if(i == n_splits)
								{
									ind = StringUtils.ordinalIndexOf(s, " ",n_splits-1);
									out.println(s.substring(ind,end)+"<br/>");
								}
								else
								{
									ind = StringUtils.ordinalIndexOf(s," ", i-1);
									e_ind = StringUtils.ordinalIndexOf(s," ", (spaces+i+1)-n_splits);
									out.println(s.substring(ind,e_ind)+"<br/>");
								}
							}
						}
						n_splits++;
					}
				%>
			</div>
			<% for(int i=1; i<=7; i++){ %>
				<div class="result">
					<div class="result_head">
						<a href="">Article about sports</a>
					</div>
					<div class="result_desc">
						<p>Here is the abstract from the article and pasted here. Here is the abstract from the article and pasted here. Here is the abstract from the article and pasted here. Here is the abstract from the article and pasted here. And also....</p>
					</div>
				</div>
			<%} %>
			</div>
		</div>
	</div>
<%@include file="footer.jsp" %>
    