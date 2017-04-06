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
		String search = (String) session.getAttribute("search");
		session.setAttribute("search","");
		if(search == null)
			search = "";
		String a_id = request.getParameter("i");
		ResultSet r = stmt.executeQuery("SELECT * FROM articles WHERE id='"+a_id+"'");
		r.next();
		String title = r.getString("title");
		String a_name = r.getString("name");
		String s_tags = r.getString("s_tags");
		String path = System.getProperty("user.dir")+"/";
		String time_when = r.getString("time_when");
		
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
			<div class="box box-primary">
	           <div class="box-header with-border">
	           	<div class="col-md-12" id="article_head">
	             <h3 class="box-title"><%=title %></h3>
	            </div>
	            <div class="col-md-12">
		            <span class="time pull-right text-muted"><i class="fa fa-clock-o"></i> <i><%= get_time_diff(time_when)%></i></span>
	            </div>
	           </div><!-- /.box-header -->
	           <div class="box-body" id="article_body">
	           	<p id="article_text"><%=str%></p>
	           </div><!-- /.box-body -->
	           <div class="box-footer clearfix" id="tags_div">
	             <% for(String t : tags){%>
					<div class="tag">
						<a href="explore_tags.jsp?t=<%=t%>" title="Explore">
							<span class="label label-primary"><%=t%></span>
						</a>
					</div>
				<%}%>
	           </div><!-- /.box-footer -->
	         </div>
			<div id="article">
				<div >
					<p class="text-center"><a href=""></a></p>
				</div>
				<div >
					
				</div>
				<div >
				
				</div>
			</div>
		</div>
		<div class="clearfix"></div><br/>
		
		<div id="review_div" class="col-md-offset-2 col-md-8">
			<div class="box box-primary">
	           <div class="box-header with-border text-center">
	           	 <h3 class="box-title">
	             	<span class="glyphicon glyphicon-pencil"></span>
					 Write a review
				 </h3>
	           </div><!-- /.box-header -->
	           <div class="box-body">
	           		<form action="submit_review.jsp" method="POST">
						<div class="form-group">
							<input type="text" name="name" class="form-control" placeholder="Your name (eg- John Doe)" maxlength="100"/>
						</div>
						<div class="form-group">
							<textarea class="form-control" id="review_text" name="review_text" rows="5" cols="100" placeholder="What do you think about the article (Upto 250 characters)" maxlength="250" required></textarea>
						</div>
						<input type="hidden" id="article_id" name="article_id" value="<%=a_id %>"/>
						<div class="clearfix"></div>
						<div class="col-md-2 lr0pad">
							<button class="btn">
								Submit 
							</button>
						</div>
					</form>
	           </div>
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
			<div id="all_reviews" class="box box-primary" <%if(!disp) out.println("style=\"display: none\""); %>>
	           <div class="box-header with-border text-center">
	             <h3><u>User reviews</u></h3>
		            <div class="col-md-12" id="sort_div">
						<div class="col-md-2 col-md-offset-7">
							<h4>Sort by:</h4> 
						</div>
						<div class="col-md-3">
							<select class="form-control" id="sort_select">
								<option value="score_desc" <%if(tmp.equals("score_desc")) out.println("selected"); %>>Highest rating first</option>
								<option value="score_asc" <%if(tmp.equals("score_asc")) out.println("selected"); %>>Lowest rating first</option>
								<option value="id_desc" <%if(tmp.equals("id_desc")) out.println("selected"); %>>Newest first</option>
								<option value="id_asc" <%if(tmp.equals("id_asc")) out.println("selected"); %>>Oldest first</option>
							</select>
						</div>
					</div>
	           </div><!-- /.box-header -->
	           <div class="box-body">
				<div id="all_reviews_body">
					<ul class="timeline">
					<%
						String query = "SELECT * FROM reviews WHERE article_id = "+a_id+" ORDER BY "+on+" "+sort;
						r = stmt.executeQuery(query);
						String clr;
						double score;
						int cnt = 0;
						String[] classes = {"blue","default"};
						String cls;
						while(r.next()){
							cls = classes[cnt%classes.length];
							cnt++;
							score = r.getDouble("score");
							if(score > 75)
								clr = "#00a65a";
							else if(score > 50)
								clr = "#3c8dbc";
							else
								clr = "#f56954";
							
					%>
						<li class="user_review">
		                  <i class="fa fa-user bg-<%=cls%>"></i>
			                  <div class="timeline-item border-default">
			                    <span class="time"><i class="fa fa-clock-o"></i> <%= get_time_diff(r.getString("time_when"))%></span>
			                    <h4 class="timeline-header"><i class="text-muted">Posted by </i><%=r.getString("name") %></h4>
			                    <div class="timeline-body" style="overflow: auto">
			                      <p><%=r.getString("text") %>
				                      <span class="knob_div pull-right text-center">
				                      	<input type="text" class="knob" value="<%=r.getString("score") %>" data-width="50" data-height="50" data-fgColor="<%=clr %>" data-skin="tron"  data-thickness="0.2" data-readonly="true" readonly="readonly">
				                      </span>
			                      </p>
			                    </div>
			                  </div>
		                </li>	
					<%}%>
					</ul>
				</div>
			</div>
		</div>
		<button class="form-control btn btn-github" id="view_reviews" <%if(disp) out.println("style=\"display: none\""); %>>
			<strong>View User reviews (<%=cnt %>)</strong>
		</button>
	</div>
		<%}else{ %>
		<div class="col-md-8 col-md-offset-2">
			<button class="form-control btn btn-github" onclick="add_one()">
               <span class="text-center h4">No reviews yet! Add one?</span>
             </button>
		</div>
		<%} %>
	</div>
	<script type="text/javascript">
		var search = '<%=search%>';
		function add_one()
		{
			$('#review_text').focus();
		}
		$(document).ready(function()
		{
			search = search.trim();
			if(search.length > 0)
			{
				var my_arr = search.split(" ");
				var str = "";
				for(w in my_arr)
				{
					str += my_arr[w]+"|";
				}
				str = str.substring(0,str.length-1);
				var regex = new RegExp(str,"gi");
				tmp_txt = $("#article_text").html().replace(regex, '<strong>$&</strong>');
				$("#article_text").html(tmp_txt);
			}
		});
	</script>
<%@include file="footer.jsp" %>