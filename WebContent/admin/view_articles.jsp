<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@include file="authenticate.jsp" %>
<%@include file="header.jsp" %>
<%@include file="sidebar.jsp" %>
<link rel="stylesheet" href="admin/resources/css/dataTables.bootstrap.css"/>
<%
	boolean latest = false;
	String query,title,score,rating,time,time_when;
	String where_clause = "";
	int id,views,hours, max_length = 70;
	ResultSet r;
	
	if(request.getParameterMap().containsKey("latest"))
	{
		if(request.getParameter("latest").equals("true"))
		{
			latest = true;
			where_clause = "WHERE time_when > DATE_SUB(CURDATE(), INTERVAL "+get_value("record_days",vars)+" DAY)";
		}
	}
	
	query = "SELECT * FROM articles "+where_clause;
	r = stmt.executeQuery(query);
%>
<div class="row">
  <div class="col-md-12">
   <div class="box box-primary">
     <div class="box-header with-border">
       <h3 class="box-title">
       Articles &nbsp;
       <%
       		if(latest)
       		{%>
       			<i class="text-muted"><small>(showing latest records only)</small></i>&nbsp;&nbsp;
       			<a href="admin/view_articles.jsp">
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
             <th>Title</th>
             <th>Score</th>
             <th>Total views</th>
             <th>Read time</th>
             <th>User rating</th>
             <th>When</th>
             <th>View</th>
           </tr>
         </thead>
         <tbody>
         <%
         	while(r.next())
         	{
         		id = r.getInt("id");
         		title = r.getString("title");
         		if(title.length() > max_length)
         			title = title.substring(0,max_length+1) + "...";
         		score = r.getString("score");
         		views = r.getInt("view_count");
         		time = r.getInt("time_count")/3600 + "h " + (r.getInt("time_count")/60)%60 + "m";
         		rating = r.getString("review_score");
         		time_when = get_time_diff(r.getString("time_when"));
         %>	
           <tr>
             <td><%=title%></td>
             <td><%=score%></td>
             <td><%=views%></td>
             <td><%=time%></td>
             <td><%=rating%></td>
             <td><%=time_when%></td>
             <td>
             	<a href="view_article.jsp?i=<%=id%>" target="_blank" class="text-center">
             		<button class="btn btn-primary">
             			<span class="glyphicon glyphicon-share"></span>
             		</button>
             	</a>
             </td>
           </tr>
         <%
         	}
         %>
         </tbody>
         <tfoot>
           <tr>
             <th>Title</th>
             <th>Score</th>
             <th>Total views</th>
             <th>Read time</th>
             <th>User rating</th>
             <th>When</th>
             <th>View</th>
           </tr>
         </tfoot>
       </table>
     </div><!-- /.box-body -->
   </div><!-- /.box -->
  </div><!-- /.col -->
 </div><!-- /.row -->
<%@include file="footer.jsp" %>