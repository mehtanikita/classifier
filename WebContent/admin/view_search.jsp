<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@include file="authenticate.jsp" %>
<%@include file="header.jsp" %>
<%@include file="sidebar.jsp" %>
<link rel="stylesheet" href="admin/resources/css/dataTables.bootstrap.css"/>
<%
	boolean latest = false;
	String query,search_string,time_when;
	String where_clause = "";
	int id,count;
	ResultSet r;
	
	if(request.getParameterMap().containsKey("latest"))
	{
		if(request.getParameter("latest").equals("true"))
		{
			latest = true;
			where_clause = "WHERE time_when > DATE_SUB(CURDATE(), INTERVAL "+get_value("record_days",vars)+" DAY)";
		}
	}
	
	query = "SELECT id,search_string, SUM(click_cnt) AS count, time_when FROM search "+where_clause+" GROUP BY search_string";
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
       			<a href="admin/view_search.jsp">
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
             <th>Search Query</th>
             <th>Click count</th>
             <th>When</th>
           </tr>
         </thead>
         <tbody>
         <%
         	while(r.next())
         	{
         		id = r.getInt("id");
         		search_string = r.getString("search_string");
         		count = r.getInt("count");
         		time_when = r.getString("time_when");
         		time_when = get_time_diff(time_when);
         %>	
           <tr>
             <td><%=search_string%></td>
             <td><%=count%></td>
             <td><%=time_when%></td>
           </tr>
         <%
         	}
         %>
         </tbody>
         <tfoot>
           <tr>
             <th>Search Query</th>
             <th>Click count</th>
             <th>When</th>
           </tr>
         </tfoot>
       </table>
     </div><!-- /.box-body -->
   </div><!-- /.box -->
  </div><!-- /.col -->
 </div><!-- /.row -->
<%@include file="footer.jsp" %>