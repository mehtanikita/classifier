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
	
	query = "SELECT category.id AS c_id, name, COUNT(word_list.id) AS cnt FROM word_list JOIN category ON word_list.category_id = category.id GROUP BY category_id";
	r = stmt.executeQuery(query);
%>
<div class="row">
  <div class="col-md-12">
   <div class="box box-primary">
     <div class="box-header with-border">
       <h3 class="box-title">Categories</h3>
     </div><!-- /.box-header -->
     <div class="box-body">
       <table id="dataTable" class="table table-bordered table-striped">
         <thead>
           <tr>
             <th>Category</th>
             <th>Total words</th>
             <th class="text-center">Edit</th>
             <th class="text-center">Delete</th>
           </tr>
         </thead>
         <tbody>
         <%
         	while(r.next())
         	{
         		id = r.getInt("c_id");
         		category = r.getString("name");
         		count = r.getInt("cnt");
         %>	
           <tr>
             <td><%=category%></td>
             <td><%=count%></td>
             <td class="text-center">
             	<button class="btn btn-primary edit_category" rel="<%=id%>" cat_name="<%=category%>">
             		<i class="fa fa-pencil-square-o"></i>
             	</button>
             </td>
             <td class="text-center">
             	<button class="btn btn-danger delete_category" rel="<%=id%>">
             		<span class="glyphicon glyphicon-trash"></span>
             	</button>
             </td>
           </tr>
         <%
         	}
         %>
         </tbody>
         <tfoot>
           <tr>
             <th>Category</th>
             <th>Total words</th>
             <th class="text-center">Edit</th>
             <th class="text-center">Delete</th>
           </tr>
         </tfoot>
       </table>
     </div><!-- /.box-body -->
   </div><!-- /.box -->
  </div><!-- /.col -->
 </div><!-- /.row -->
 <div class="row">
  <div class="col-md-12">
   <div class="box box-primary">
     <div class="box-header with-border">
       <h3 class="box-title">Add Category</h3>
     </div><!-- /.box-header -->
     <div class="box-body">
	     <form action="admin/add_category.jsp" method="POST">
	     	<div class="input-group input-group-sm">
	           <input type="text" class="form-control" name="name" placeholder="Category name">
	           <span class="input-group-btn">
	             <button class="btn btn-primary btn-flat" type="submit">Add <span class="glyphicon glyphicon-plus"></span></button>
	           </span>
	         </div>
	      </form>
     </div>
    </div>
   </div>
  </div>
  <script type="text/javascript">
  	$(document).ready(function()
  	{
  		$(document).on("click",".edit_category",function()
  		{
  			var el = $(this).parents("tr").find("td:first-child");
  			var id = $(this).attr('rel');
  			var name = $(this).attr('cat_name');
  			$.confirm({
  			    title: 'Edit name:',
  			    content: '<input value="'+name+'" autofocus="true" type="text" id="category_name" placeholder="Category name..." class="form-control">',
  			  	type: 'dark',
  			  	theme: 'material',
  			  	backgroundDismiss: true,
  			    buttons: {
  			        formSubmit: {
  			            text: 'Save',
  			            btnClass: 'btn-blue',
  			            action: function () {
  			            	var cat_name = $("#category_name").val().trim(); 
  			            	if(cat_name != "")
  		                    {
  		                        $.ajax
  		                        ({
  		                            type: "POST",
  		                            url: "admin/edit_category_name.jsp",
  		                            data: { id: id, name: cat_name },
  		                            success: function(response)
  		                            {
  		                                el.text(cat_name);
  		                            }
  		                        });
  		                    }
  		                    else
  		                    {
  		                        $.alert
  		                        ({
  		                            title: 'Oops!',
  		                            content: 'Category name <b>cannot</b> be empty!',
  		                          	type: 'red',
  		                          	theme: 'material',
  		                            icon: 'fa fa-exclamation-triangle',
  		                          	backgroundDismiss: true,
  		                            animation: 'zoom',
  		                            closeAnimation: 'zoom',
  		                            btn: 'Okay',
  		                            btnClass: 'btn-primary'
  		                        });
  		                    }
  			            }
  			        },
  			        cancel: {
  			        	text: 'Cancel',
  			            btnClass: 'btn-red'
  			        },
  			    }
  			});
  		});
  		$(document).on("click",".delete_category",function()
  		{
  			var el = $(this).parents("tr");
  			var id = $(this).attr('rel');
  			$.confirm({
  			    title: 'Are you sure?',
  			    content: 'All the words and related articles will be <b>deleted</b>!',
  			  	type: 'red',
              	theme: 'material',
  			    buttons: {
  			        confirm: {
  			        	text: 'Delete',
  			            btnClass: 'btn-red',
  			            action: function () {
  			            	$.ajax
	                        ({
	                            type: "POST",
	                            url: "admin/delete_category.jsp",
	                            data: { id: id },
	                            success: function(response)
	                            {
	                                el.fadeOut("slow");
	                            }
	                        });
  			            }
  			        },
  			      	cancel: {
			        	text: 'Cancel',
			        },
  			    }
  			});
  		});
  	});
  </script>
<%@include file="footer.jsp" %>