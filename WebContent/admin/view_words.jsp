<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@include file="authenticate.jsp" %>
<%@include file="header.jsp" %>
<%@include file="sidebar.jsp" %>
<link rel="stylesheet" href="admin/resources/css/dataTables.bootstrap.css"/>
<script src="admin/resources/js/jquery.dataTables.js"></script>
<script src="admin/resources/js/dataTables.bootstrap.js"></script>
<%
	String query,word,category;
	int id,count, max_length = 70;
	ResultSet r;
	
	query = "SELECT * FROM word_list JOIN category ON word_list.category_id = category.id";
	r = stmt.executeQuery(query);
%>
<div class="row">
  <div class="col-md-12">
   <div class="box box-primary">
     <div class="box-header with-border">
       <h3 class="box-title">Words</h3>
     </div><!-- /.box-header -->
     <div class="box-body">
       <table id="dataTable" class="table table-bordered table-striped">
         <thead>
           <tr>
             <th>Word</th>
             <th>Category</th>
             <th>Count</th>
           </tr>
         </thead>
         <tbody>
         <%
         	while(r.next())
         	{
         		id = r.getInt("word_list.id");
         		word = r.getString("word");
         		category = r.getString("name");
         		count = r.getInt("count");
         %>	
           <tr>
             <td><%=word%></td>
             <td><%=category%></td>
             <td><%=count%></td>
           </tr>
         <%
         	}
         %>
         </tbody>
         <tfoot>
           <tr>
             <th>Word</th>
             <th>Category</th>
             <th>Count</th>
           </tr>
         </tfoot>
       </table>
     </div><!-- /.box-body -->
   </div><!-- /.box -->
  </div><!-- /.col -->
 </div><!-- /.row -->
<%@include file="footer.jsp" %>