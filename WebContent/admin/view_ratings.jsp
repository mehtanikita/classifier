<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@include file="authenticate.jsp" %>
<%@include file="header.jsp" %>
<%@include file="sidebar.jsp" %>
<link rel="stylesheet" href="admin/resources/css/dataTables.bootstrap.css"/>
<%
	boolean latest = false;
	String query,a_title,name,text,cls,score,time_when;
	String where_clause = "";
	int a_id,title_len = 70, review_len = 200;
	ResultSet r;
	
	if(request.getParameterMap().containsKey("latest"))
	{
		if(request.getParameter("latest").equals("true"))
		{
			latest = true;
			where_clause = "WHERE reviews.time_when > DATE_SUB(CURDATE(), INTERVAL "+get_value("record_days",vars)+" DAY)";
		}
	}
	
	query = "SELECT * FROM reviews JOIN articles ON reviews.article_id = articles.id "+where_clause+" ORDER BY reviews.time_when DESC, articles.title, reviews.name";
	r = stmt.executeQuery(query);
%>
<div class="row">
  <div class="col-md-12">
   <div class="box box-primary">
     <div class="box-header with-border">
       <h3 class="box-title">
       Search &nbsp;
       <%
       		if(latest)
       		{%>
       			<i class="text-muted"><small>(showing latest records only)</small></i>&nbsp;&nbsp;
       			<a href="admin/view_ratings.jsp">
       				<span class="label label-primary">Show ALL</span>
       			</a>
       		<%}
       %>
       </h3>
     </div><!-- /.box-header -->
     <div class="box-body">
       <table id="dataTable" class="table table-bordered table-striped">
         <thead>
           <tr>
             <th>Name</th>
             <th>Review</th>
             <th>Score</th>
             <th>Article</th>
             <th>When</th>
           </tr>
         </thead>
         <tbody>
         <%
         	while(r.next())
         	{
         		a_id = r.getInt("articles.id");
         		a_title = r.getString("articles.title");
         		if(a_title.length() > title_len)
         			a_title = a_title.substring(0,title_len)+"...";
         		name = r.getString("reviews.name");
         		text = r.getString("reviews.text");
         		if(text.length() > review_len)
         			text = text.substring(0,review_len)+"...";
         		text = decode(text);
         		text = text.replaceAll("\\n","<br/>");
         		if(r.getString("type").equals("positive"))
         			cls = "success";
         		else
         			cls = "danger";
         		score = r.getString("score");
         		time_when = get_time_diff(r.getString("reviews.time_when"));
         %>	
           <tr>
             <td><%=name%></td>
             <td><%=text%></td>
             <td class="text-<%=cls%>"><b><%=score%></b></td>
             <td><a href="view_article.jsp?i=<%= a_id%>" target="_blank"><%=a_title %></a></td>
             <td><%=time_when%></td>
           </tr>
         <%
         	}
         %>
         </tbody>
         <tfoot>
           <tr>
             <th>Name</th>
             <th>Review</th>
             <th>Score</th>
             <th>Article</th>
             <th>When</th>
           </tr>
         </tfoot>
       </table>
     </div><!-- /.box-body -->
   </div><!-- /.box -->
  </div><!-- /.col -->
 </div><!-- /.row -->
<%@include file="footer.jsp" %>