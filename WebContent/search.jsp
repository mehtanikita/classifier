<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ page import="org.apache.commons.lang3.*,java.util.*,java.io.*,controller.ArticleDetails" %>
<%@include file="header.jsp" %>
	<%!
		public String get_abstract(byte[] data, String q, int no_of_chars, int left_span, int right_span)
		{
			String str = "";
			String tmp_str = "";
			String replace_str = "";
			int rs, re;
			
			int lastIndex = 0, tmp_index = 0;
			int count = 0,index_1 = 0, index_2 = 0, index_3 = 0;
			String str_1 = "";
			String str_2 = "";
			
			q = q.replaceAll("[^\\w\\s]+", "");
			q = q.trim();
			int spaces = q.length() - q.replace(" ", "").length();
			int n_splits = 1;
			int ind,e_ind,start = 0,end = q.length();
			
			ArrayList<String> words = new ArrayList<String>();
			
			try
			{
				String main_str = new String(data, "UTF-8").replaceAll("[^\\x00-\\x7F]", "");
				String rf_str = main_str.toLowerCase();
				
				while((n_splits <= spaces+1))
				{
					if(n_splits == 1)
					{
						words.add(q);
					}
					else
					{
						for(int i = 1; i <= n_splits ; i++)
						{
							if(i == 1)
							{
								ind = StringUtils.ordinalIndexOf(q, " ",spaces+2-n_splits);
								words.add(q.substring(start,ind));
							}
							else if(i == n_splits)
							{
								ind = StringUtils.ordinalIndexOf(q, " ",n_splits-1);
								words.add(q.substring(ind,end));
							}
							else
							{
								ind = StringUtils.ordinalIndexOf(q," ", i-1);
								e_ind = StringUtils.ordinalIndexOf(q," ", (spaces+i+1)-n_splits);
								words.add(q.substring(ind,e_ind));
							}
						}
					}
					
					n_splits++;
				} 
				String w;
				int list_index = 0;
				while((lastIndex != -1) && (str.length() < no_of_chars))
				{
					w = words.get(list_index);
					lastIndex = rf_str.indexOf(w,lastIndex);
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
				        		{
				        			replace_str = main_str.substring(index_1, index_2);
				        			rs = index_1;
				        			re = index_2;
				        		}
				        		else
				        		{
				        			index_3 = main_str.substring(lastIndex, (lastIndex + right_span)).lastIndexOf(" ");
						        	index_3 += lastIndex + 1;
						        	replace_str = main_str.substring(index_1, index_3)+"...   ";
						        	rs = index_1;
				        			re = index_3;
				        		}
				        	}
				        		
				        	else
				        	{
				        		replace_str = main_str.substring(index_1, main_str.length());
				        		rs = index_1;
			        			re = main_str.length();
				        	}
				        }
				        else
				        {
				        	if(main_str.length() > (lastIndex+right_span))
				        	{
				        		index_2 = main_str.substring(lastIndex).indexOf(".");
				        		index_2 += lastIndex + 1;
				        		
				        		if((index_2 - lastIndex) < right_span)
				        		{
				        			replace_str = main_str.substring(tmp_index, index_2);
				        			rs = tmp_index;
				        			re = index_2;
				        		}
				        		else
				        		{
				        			index_3 = main_str.substring(lastIndex, (lastIndex + right_span)).lastIndexOf(" ");
						        	index_3 += lastIndex + 1;
						        	replace_str = main_str.substring(tmp_index, index_3)+"...   ";
						        	rs = tmp_index;
				        			re = index_2;
				        		}
				        	}
				        	else
				        	{
				        		replace_str = main_str.substring(tmp_index, main_str.length());
				        		rs = tmp_index;
			        			re = main_str.length();
				        	}
				        }
				        str += replace_str;
				        
				        main_str = main_str.replace(main_str.substring(rs,re),"");
				        rf_str = rf_str.replace(rf_str.substring(rs,re),"");

				        lastIndex += w.length();
				        count++;
				    }
				    else
				    {
				    	if(list_index == words.size() - 1)
				    		break;
				    	else
				    	{
				    		lastIndex = 0;
				    		list_index++;
				    	}
				    		
				    }
				}
				if(str.length() < no_of_chars)
					str += main_str.substring(0,no_of_chars - str.length()) + "...";

				str = str.replaceAll("[^\\x00-\\x7F]", "");
				str = str.replace("?", "");
			}
			catch(Exception e){}
			return str;
		}
	%>
	<% 
		String s = request.getParameter("q");
		int articles_per_page = 5;
		int no_of_articles = 0;
		int total_articles;
		
		int no_of_chars = 300;
		int left_span = 60;
		int right_span = 60;
		
		int len = 5;//No of pagination pages
		String page_no = request.getParameter("p");
		int p = 1;
		if(page_no != null)
			p = Integer.parseInt(page_no);
		
		p = (p-1)*articles_per_page;
		
		HashMap<Integer,ArticleDetails> articles=new HashMap<Integer,ArticleDetails>();
		
		String ts = s.replaceAll("[^\\w\\s]+", "");
		ts = ts.trim();
		int spaces = ts.length() - ts.replace(" ", "").length();
		int n_splits = 1;
		int ind,e_ind,start = 0,end = ts.length();
		
		ArrayList<String> words = new ArrayList<String>();
		while((n_splits <= spaces+1))
		{
			if(n_splits == 1)
			{
				words.add(ts);
			}
			else
			{
				for(int i = 1; i <= n_splits ; i++)
				{
					if(i == 1)
					{
						ind = StringUtils.ordinalIndexOf(ts, " ",spaces+2-n_splits);
						words.add(ts.substring(start,ind));
					}
					else if(i == n_splits)
					{
						ind = StringUtils.ordinalIndexOf(ts, " ",n_splits-1);
						words.add(ts.substring(ind,end));
					}
					else
					{
						ind = StringUtils.ordinalIndexOf(ts," ", i-1);
						e_ind = StringUtils.ordinalIndexOf(ts," ", (spaces+i+1)-n_splits);
						words.add(ts.substring(ind,e_ind));
					}
				}
			}
			n_splits++;
		}
		String where_clause = "";
		String order_clause = "";
		for (int i = 0; i < words.size(); i++) 
		{
			if(i == words.size() - 1)
				where_clause += " title LIKE '%"+words.get(i)+"%' ";
			else
				where_clause += " title LIKE '%"+words.get(i)+"%' OR ";
			
			order_clause += " WHEN title LIKE '%"+words.get(i)+"%' THEN "+(i+1)+" ";
			
		}
		String[] splits = s.split(" ");
		String tag_query = "";
		String word_query = "";
		for(String w : splits)
		{
			tag_query += " UNION SELECT * FROM articles WHERE id IN (SELECT article_id FROM `tags` WHERE name = '"+w+"' GROUP BY name)";
			word_query += " UNION SELECT * FROM articles WHERE id IN (SELECT articles FROM `word_list` WHERE count > 0 AND word = '"+w+"')";
		}
		String query = "SELECT * FROM articles WHERE "+where_clause+" "+tag_query+" "+word_query+" ORDER BY CASE "+order_clause+" END LIMIT "+p+","+articles_per_page;
		
		ResultSet r = stmt.executeQuery(query);
		ArticleDetails ar;
		String s_tags;
		String path = System.getProperty("user.dir")+"/";
		int a_cnt = 0;
		while(r.next())
		{
			a_cnt++;
			s_tags = r.getString("s_tags");
			s_tags = s_tags.trim();
			s_tags = s_tags.replace(s,"");
			s_tags = s_tags.replace(",,",",");
			String[] tags = {};
			if(s_tags.length() > 0)
			{
				if(s_tags.charAt(0) == ',')
					s_tags = s_tags.substring(1,s_tags.length());
				if(s_tags.charAt(s_tags.length()-1) == ',')
					s_tags = s_tags.substring(0,s_tags.length()-1);
				tags = s_tags.split(",");
			}
			File file = new File(path+r.getString("name"));
			FileInputStream fis = new FileInputStream(file);
			byte[] data = new byte[(int) file.length()];
			fis.read(data);
			fis.close();
			
			ar = new ArticleDetails(r.getInt("id"), r.getString("title"), r.getString("name"), get_abstract(data,s,no_of_chars,left_span,right_span), r.getInt("review_score"), tags);
			out.println(ar.pr());
			articles.put(a_cnt, ar);
			
		}
		total_articles = 25;
		
		String[] classes = {"primary","success","danger","info","warning"};
		String cls = "";
	%>
	<link href="css/search.css" rel="stylesheet" type="text/css"/>
	<script type="text/javascript" src="js/search.js"></script>
	<div id="main_div" class="col-md-12">
		
		<div id="search_results_div" class="col-md-offset-2 col-md-8">
			<div id="search_header">
				<form action="search.jsp">
					<div class="col-md-10">
						<div id="search_div" class="form-group">
							<input id="search_box" type="text" name="q" class="form-control" value="<%=s%>" placeholder="Search Here.." required oninvalid="this.setCustomValidity('Please enter something')" onkeyup="this.setCustomValidity('')"/>
							<div id="search_list"></div>
						</div>
					</div>
					<div class="col-md-2">
						<button id="search_button" class="btn btn-primary">
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
					/* s = s.replaceAll("[^\\w\\s]+", "");
					s = s.trim();
					int spaces = s.length() - s.replace(" ", "").length();
					int n_splits = 1;
					int ind,e_ind,start = 0,end = s.length();
					while((n_splits <= spaces+1) && (true))
					{
						//out.println("<h1>------"+n_splits+"--------</h1>");
						if(n_splits == 1)
						{
							//out.println(s+ "<br/>");
						}
						else
						{
							for(int i = 1; i <= n_splits ; i++)
							{
								if(i == 1)
								{
									ind = StringUtils.ordinalIndexOf(s, " ",spaces+2-n_splits);
									//out.println(s.substring(start,ind)+ "<br/>");
								}
								else if(i == n_splits)
								{
									ind = StringUtils.ordinalIndexOf(s, " ",n_splits-1);
									//out.println(s.substring(ind,end)+"<br/>");
								}
								else
								{
									ind = StringUtils.ordinalIndexOf(s," ", i-1);
									e_ind = StringUtils.ordinalIndexOf(s," ", (spaces+i+1)-n_splits);
									//out.println(s.substring(ind,e_ind)+"<br/>");
								}
							}
						}
						n_splits++;
					} */
				%>
			</div>
			<% 
				if(a_cnt == 0)
				{%>
					<h2 class="text-center">No Results found!</h2>
				<%}
			%>
			<%
				for(int i=1; i<=a_cnt; i++){ ar = articles.get(i); cls = classes[i%5]; %>
				<div class="result">
					<div class="result_head">
						<a href="view_article.jsp?i=<%=ar.id %>" aid="<%=ar.id%>" class="article_link text-<%=cls %>"><%=ar.title %></a>
					</div>
					<div class="result_desc">
						<p class="result_str"><%= ar.abstr %></p>
					</div>
					<%if(ar.tags.length > 0) { %>
					<div class="result_desc">
					<% for(String t : ar.tags){%>  
						<a href="explore_tags.jsp?t=<%=t%>" title="Explore">
							<span class="label label-<%=cls %>" title="<%=cls%>"><%=t%></span>
						</a>
					<%}%>
					</div>
					<%}%>
					<div class="result_desc">
						<p>Average user ratings: <b><%=ar.r_score%>%</b></p>
					</div>
				</div>
			<%} %>
			</div>
		
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
				var s = '<%=s%>';
				var words = [];
				function ordinalIndexOf(string, subString, index)
				{
				   return string.split(subString, index).join(subString).length;
				}
				$(".result_str").each(function()
				{
					s = s.replace("[^\\w\\s]+", "");
					s = s.trim();
					var spaces = s.length - s.replace(" ", "").length;
					var n_splits = 1;
					var ind,e_ind,start = 0,end = s.length;
					while((n_splits <= spaces+1) && (true))
					{
						if(n_splits == 1)
						{
							words.push(s.trim());
						}
						else
						{
							for(var i = 1; i <= n_splits ; i++)
							{
								if(i == 1)
								{
									ind = ordinalIndexOf(s, " ",spaces+2-n_splits);
									words.push(s.substring(start,ind).trim());
								}
								else if(i == n_splits)
								{
									ind = ordinalIndexOf(s, " ",n_splits-1);
									words.push(s.substring(ind,end).trim());
								}
								else
								{
									ind = ordinalIndexOf(s," ", i-1);
									e_ind = ordinalIndexOf(s," ", (spaces+i+1)-n_splits);
									words.push(s.substring(ind,e_ind).trim());
								}
							}
						}
						n_splits++;
					}
					for(w in words)
					{
						var regex = new RegExp(words[w],"gi");
						tmp_txt = $(this).html().replace(regex, '<strong>$&</strong>');
						$(this).html(tmp_txt);
					}
					$(document).on("click",".article_link",function(e)
					{
						e.preventDefault();
						var return_url = $(this).attr('href');
						var a_id = $(this).attr('aid');
						var q = $("#search_box").val();
						window.location.href = "analyze.jsp?q="+q+"&a_id="+a_id+"&return_url="+return_url;
					});
				});
			</script>
		</div>
	</div>
<%@include file="footer.jsp" %>
    