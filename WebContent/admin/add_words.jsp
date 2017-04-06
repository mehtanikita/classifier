<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@include file="authenticate.jsp" %>
<%@include file="header.jsp" %>
<%@include file="sidebar.jsp" %>
	<div class="col-md-10 col-md-offset-1">
	    <div class="box box-info">
	       <div class="box-header with-border">
	         <h3 class="box-title">Add Words</h3>
	       </div>
	       <div class="box-body">
	       <form action="admin/save_words.jsp">
	       	<div class="col-md-10 col-md-offset-1">
	       		<div class="col-md-12">
			         <div class="form-group">
                      <label>Category</label>
                      <select class="form-control" name="category" required>
                        <%
                        	ResultSet r = stmt.executeQuery("SELECT * FROM category");
                        	while(r.next()){
                        %>
                        	<option value="<%=r.getInt("id")%>"><%=r.getString("name")%></option>
                        <%}%>
                      </select>
                    </div>
			     </div>
	       		<div class="col-md-12">
		       		<p><b>Enter words (comma seperated):</b></p>
			         <div class="input-group input-group-sm">
			           <input type="text" class="form-control" name="words" required>
			           <span class="input-group-btn">
			             <button class="btn btn-primary btn-flat" type="submit">Add</button>
			           </span>
			         </div><!-- /input-group -->
			     </div>
		     </div>
		    </form>
	       </div><!-- /.box-body -->
	     </div>
	 </div>
<%@include file="footer.jsp" %>