<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ page import="java.io.*" %>
<%@include file="header.jsp" %>
	<% 
		int articles_per_page = get_value("articles_per_page",vars);
		int no_of_chars = get_value("abstract_size",vars);
		int left_span = 60;
		int right_span = 60;
		
		int tag_cnt_weight = get_value("tag_weight",vars);
		int score_weight = get_value("score_weight",vars);
		int view_weight = get_value("view_weight",vars);
		int time_weight = get_value("time_weight",vars);
		int review_weight = get_value("review_weight",vars);
		
		int len = 5; //No of pagination pages
		int total_articles;
		String s = request.getParameter("t");
		String page_no = request.getParameter("p");
		
		ResultSet r = stmt.executeQuery("SELECT SUM(view_count) AS total_views, SUM(time_count) AS total_time FROM articles");
		r.next();
		int total_views = r.getInt("total_views");
		int total_time= r.getInt("total_time");
		
		String order_logic = " ORDER BY (cnt * "+tag_cnt_weight+")+(score * "+score_weight+")+((view_count*100/"+total_views+")*"+view_weight+")+((time_count*100/"+total_time+")*"+time_weight+")+(review_score*"+review_weight+") DESC";
		
		int p = 1;
		if(page_no != null)
			p = Integer.parseInt(page_no);
		
		p = (p-1)*articles_per_page;
		
		String count_q = "SELECT COUNT(*) AS total_articles FROM tags JOIN articles ON tags.article_id = articles.id WHERE tags.name='"+s+"'";
		r = stmt.executeQuery(count_q);
		r.next();
		total_articles = r.getInt("total_articles");
		String query = "SELECT * FROM tags JOIN articles ON tags.article_id = articles.id WHERE tags.name='"+s+"'"+order_logic+" LIMIT "+p+","+articles_per_page;
		r = stmt.executeQuery(query);
		ResultSet r2;
		String[] classes = {"primary","success","danger","info","warning"};
		String cls = "";
		int loop_cnt = 0;
	%>
	<link href="css/tags.css" rel="stylesheet" type="text/css"/>
	<div id="main_div" class="col-md-12">
		<div id="search_results_div" class="col-md-offset-2 col-md-8">
			<div class="clearfix"></div><br/>
			<div id="search_results">
			<% 
				int a_id = 0;
				String a_name = "";
				String title = "";
				String r_score = "";
				String s_tags = "";
				String path = System.getProperty("user.dir")+"/";
				String time_when = "";
				Statement st = c.createStatement();
				if(total_articles != 0){
				while(r.next())
				{
					cls = classes[loop_cnt%5];
					a_id = r.getInt("article_id");
					r2 = st.executeQuery("SELECT * FROM articles WHERE id='"+a_id+"'");
					r2.next();
					title = r2.getString("title");
					a_name = r2.getString("name");
					r_score = r2.getString("review_score");
					s_tags = r2.getString("s_tags");
					s_tags = s_tags.trim();
					s_tags = s_tags.replace(s,"");
					s_tags = s_tags.replace(",,",",");
					String[] tags = {};
					time_when = r2.getString("time_when");
					if(s_tags.length() > 0)
					{
						if(s_tags.charAt(0) == ',')
							s_tags = s_tags.substring(1,s_tags.length());
						if(s_tags.charAt(s_tags.length()-1) == ',')
							s_tags = s_tags.substring(0,s_tags.length()-1);
						tags = s_tags.split(",");
					}
					
					File file = new File(path+a_name);
					FileInputStream fis = new FileInputStream(file);
					byte[] data = new byte[(int) file.length()];
					fis.read(data);
					fis.close();
					
					String str = "";
					String tmp_str = "";
					String main_str = new String(data, "UTF-8").replaceAll("[^\\x00-\\x7F]", "");
					String rf_str = main_str.toLowerCase();
					int lastIndex = 0, tmp_index = 0;
					int count = 0,index_1 = 0, index_2 = 0, index_3 = 0;
					String str_1 = "";
					String str_2 = "";
					while((lastIndex != -1) && (str.length() < no_of_chars))
					{
					    lastIndex = rf_str.indexOf(s,lastIndex);
					    
					    if(lastIndex != -1)
					    {
					        tmp_str = rf_str.substring(0,lastIndex);
					        tmp_index = tmp_str.lastIndexOf('.') + 1;
					        if(tmp_index == -1)
					        	tmp_index = 0;
					        if((lastIndex-tmp_index) > left_span)
					        {
					        	index_1 = main_str.substring((lastIndex - left_span), lastIndex).indexOf(" ");
					        	index_1 += (lastIndex - left_span);
					        	
					        	if(main_str.length() > (lastIndex+right_span))
					        	{
					        		index_2 = main_str.substring(lastIndex).indexOf(".");
					        		index_2 += lastIndex + 1;
					        		
					        		if((index_2 - lastIndex) < right_span)
					        			str += main_str.substring(index_1, index_2);
					        		else
					        		{
					        			index_3 = main_str.substring(lastIndex, (lastIndex + right_span)).lastIndexOf(" ");
							        	index_3 += lastIndex + 1;
							        	str += main_str.substring(index_1, index_3)+"...   ";
					        		}
					        	}
					        		
					        	else
					        		str += main_str.substring(index_1, main_str.length());
					        }
					        else
					        {
					        	if(main_str.length() > (lastIndex+right_span))
					        	{
					        		index_2 = main_str.substring(lastIndex).indexOf(".");
					        		index_2 += lastIndex + 1;
					        		
					        		if((index_2 - lastIndex) < right_span)
					        			str += main_str.substring(tmp_index, index_2);
					        		else
					        		{
					        			index_3 = main_str.substring(lastIndex, (lastIndex + right_span)).lastIndexOf(" ");
							        	index_3 += lastIndex + 1;
							        	str += main_str.substring(tmp_index, index_3)+"...   ";
					        		}
					        	}
					        	else
					        		str += main_str.substring(tmp_index, main_str.length());
					        }
					        lastIndex += s.length();
					        count++;
					    }
					}
					if(str.length() < no_of_chars)
						str += main_str.substring(0,no_of_chars - str.length()) + "...";
					str = str.replaceAll("[^\\x00-\\x7F]", "");
					str = str.replace("?", "");
			%>
				<div class="col-md-12">
					<div class="box box-primary">
				       <div class="box-header with-border">
				          <div class="col-md-10 lr0pad">
					         <h3 class="box-title">
					         	<a href="view_article.jsp?i=<%=a_id %>" class="text-navy"><%=title %></a>
					         </h3>
				           </div>
				           <span class="time pull-right"><i class="fa fa-clock-o"></i> <%= get_time_diff(time_when)%></span>
				       </div>
				    
					    <div class="box-body with-border">
					    	<p class="result_str"><%=str%></p>
					    </div>
					    <%if(tags.length > 0) { %>
							<div class="box-body with-border">
								<% for(String t : tags){%>  
									<a href="explore_tags.jsp?t=<%=t%>" title="Explore">
										<span class="label label-default" title="<%=cls%>"><%=t%></span>
									</a>
								<%}%>
							</div>
						<%}%>
						<div class="box-body">
					    	<p>Average user ratings: <b><%=r_score%>%</b></p>
					    </div>
					</div>
			    </div>
			<%
					loop_cnt++;
					}
				r.close();
				}
				else{%>
					<h2 class="text-center">No Results found!</h2>
			<%}%>
			<%
				int pages = total_articles/articles_per_page;
				if(total_articles%articles_per_page != 0)
					pages++;
				int cp = 1;
				if(page_no != null)
					cp = Integer.parseInt(page_no);
			%>
			<div class="pagination_div">
				<ul class="pagination">
				<% if(pages <= len){ %>
					<% for(int j=1; j<=pages; j++){ %>
						<li <% if(cp==j) out.println("class=\"active\"");%>><a href="explore_tags.jsp?t=<%=s%>&p=<%=j%>"><%=j%></a></li>
					<%}}else if(cp<=len){for(int j=1; j<=len; j++){ %>
						<li <% if(cp==j) out.println("class=\"active\"");%>><a href="explore_tags.jsp?t=<%=s%>&p=<%=j%>"><%=j%></a></li>
					<%}%>
						<li title="Next Page"><a href="explore_tags.jsp?t=<%=s%>&p=<%=len+1%>">&gt;</a></li>
						<li title="Last Page"><a href="explore_tags.jsp?t=<%=s%>&p=<%=pages%>">&gt;&gt;</a></li>
					<%}else if(cp>=pages-len+1){%>
						<li title="First Page"><a href="explore_tags.jsp?t=<%=s%>&p=1">&lt;&lt;</a></li>
						<li title="Previous Page"><a href="explore_tags.jsp?t=<%=s%>&p=<%=pages-len%>">&lt;</a></li>
					<%for(int j=pages-len+1; j<=pages; j++){ %>
						<li <% if(cp==j) out.println("class=\"active\"");%>><a href="explore_tags.jsp?t=<%=s%>&p=<%=j%>"><%=j%></a></li>
					<%}}else {%>
						<li title="First Page"><a href="explore_tags.jsp?t=<%=s%>&p=1">&lt;&lt;</a></li>
						<li title="Previous Page"><a href="explore_tags.jsp?t=<%=s%>&p=<%=cp-(len/2)-1%>">&lt;</a></li>
					<%for(int j=cp-(len/2); j<=cp+(len/2); j++){ %>
						<li <% if(cp==j) out.println("class=\"active\"");%>><a href="explore_tags.jsp?t=<%=s%>&p=<%=j%>"><%=j%></a></li>
					<%}%>
						<li title="Next Page"><a href="explore_tags.jsp?t=<%=s%>&p=<%=cp+(len/2)+1%>">&gt;</a></li>
						<li title="Last Page"><a href="explore_tags.jsp?t=<%=s%>&p=<%=pages%>">&gt;&gt;</a></li>
					<%} %>
				</ul>
			</div>
			<script type="text/javascript">
				var key = '<%=s%>';
				var regex = new RegExp(key,"gi");
				$(".result_str").each(function()
				{
					tmp_txt = $(this).html().replace(regex, '<strong>$&</strong>');
					$(this).html(tmp_txt);
				});
			</script>
			</div>
		</div>
	</div>
<%@include file="footer.jsp" %>