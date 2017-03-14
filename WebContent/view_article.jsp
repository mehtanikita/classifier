<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ page import="java.sql.*,java.io.*" %>
<%@include file="header.jsp" %>
	<% 
		
		if(!request.getParameterMap().containsKey("i"))
		{
			response.sendRedirect("index.jsp");
			return;
		}
			
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
	<script src="js/knob.js" type="text/javascript"></script>
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
		<div class="clearfix"></div><br/>
		<div id="review_div" class="col-md-offset-2 col-md-8">
			<div id="write_review">
				<h3 class="text-center">
					<span class="glyphicon glyphicon-pencil"></span>
					 Write a review
				</h3>
				<form action="submit_review.jsp" method="POST">
					
					<div class="form-group">
						<input type="text" name="name" class="form-control" placeholder="Your name (eg- John Doe)" maxlength="100"/>
					</div>
					<div class="form-group">
						<textarea class="form-control" name="review_text" rows="5" cols="100" placeholder="What do you think about the article (Upto 120 characters)" maxlength="120" required></textarea>
					</div>
					<input type="hidden" id="article_id" name="article_id" value="<%=a_id %>"/>
					<div class="clearfix"></div>
					<div class="col-sm-2">
						<button class="btn btn-success">
							Submit 
						</button>
					</div>
				</form>
			</div>
		</div>
		<%
			String sql = "SELECT COUNT(*) AS r_cnt FROM reviews WHERE article_id = "+a_id;
			r = stmt.executeQuery(sql);
			r.next();
			int r_cnt = r.getInt("r_cnt");
			if(r_cnt > 0){
		%>
		<div class="clearfix"></div><br/>
		<%
			String on = "score",sort = "desc",tmp = "score_desc";
			boolean disp = false;
			if(request.getParameterMap().containsKey("on"))
			{
				disp = true;
				on = (String)request.getParameter("on");
				tmp = on+"_";
			}
			if(request.getParameterMap().containsKey("sort"))
			{
				disp = true;
				sort = (String)request.getParameter("sort");
				tmp += sort;
			}
		%>
		<div id="all_reviews_div" class="col-md-offset-2 col-md-8">
			<div id="all_reviews" <%if(!disp) out.println("style=\"display: none\""); %>>
				<div id="all_reviews_head">
					<span class="text-center">
						<span class="glyphicon glyphicon-user"></span>
						 User reviews
					</span>
				</div>
				<div class="col-md-12" id="sort_div">
					<div class="col-md-2 col-md-offset-7">
						<h4>Sort by:</h3> 
					</div>
					<div class="col-md-3">
						<select class="form-control" id="sort_select">
							<option value="score_desc" <%if(tmp.equals("score_desc")) out.println("selected"); %>>Ratings (High to Low)</option>
							<option value="score_asc" <%if(tmp.equals("score_asc")) out.println("selected"); %>>Ratings (Low to High)</option>
							<option value="id_desc" <%if(tmp.equals("id_desc")) out.println("selected"); %>>Newest First</option>
							<option value="id_asc" <%if(tmp.equals("id_asc")) out.println("selected"); %>>Oldest First</option>
						</select>
					</div>
				</div>
				
				<div id="all_reviews_body">
					<%
						String query = "SELECT * FROM reviews WHERE article_id = "+a_id+" ORDER BY "+on+" "+sort;
						r = stmt.executeQuery(query);
						String clr;
						double score;
						int cnt = 0;
						while(r.next()){
							cnt++;
							score = r.getDouble("score");
							if(score > 75)
								clr = "#00a65a";
							else if(score > 50)
								clr = "#3c8dbc";
							else
								clr = "#f56954";
							
					%>
						<div class="user_review col-md-12">
							
							<div class="col-md-12">
								<div class="col-md-9">
									<h4>Posted by <%=r.getString("name") %></h4>
									<p><%=r.getString("text") %></p>
								</div>
								<div class="knob_div col-md-3 text-center">
									<input type="text" class="knob" value="<%=r.getString("score") %>" data-width="50" data-height="50" data-fgColor="<%=clr %>" data-skin="tron"  data-thickness="0.2" data-readonly="true" readonly="readonly">
			                    </div>
			                </div>
						</div>			
					<%}%>
				</div>
			</div>
			<button class="form-control btn btn-default" id="view_reviews" <%if(disp) out.println("style=\"display: none\""); %>>
				<strong>View User reviews (<%=cnt %>)</strong>
			</button>
		</div>
		<%}else{ %>
		<div class="col-md-8 col-md-offset-2">
			<div class="col-md-12" style="background: #fff">
				<h3 class="text-center">No reviews found!</h3>
			</div>
		</div>
		<%} %>
	</div>
<%@include file="footer.jsp" %>