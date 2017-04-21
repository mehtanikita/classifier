<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ page import="java.net.*,java.util.Map.Entry,java.util.stream.Collectors,java.util.regex.Pattern,java.lang.*,java.text.DecimalFormat, java.math.*, controller.WordDetails, com.jaunt.*" %>
<%@ page import="org.apache.commons.fileupload.*" %>
<%@ page import="org.apache.commons.fileupload.disk.*" %>
<%@ page import="org.apache.commons.fileupload.servlet.*" %>
<%@ page import="org.apache.commons.io.output.*" %>
<%@include file="header.jsp" %>
<link rel="stylesheet" href="css/morris.css" type="text/css"/>
<link href="css/article_report.css" rel="stylesheet" type="text/css"/>
<%!
public String get_title(String txt, int len)
{
	String USER_AGENT = "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/57.0.2987.133 Safari/537.36";
	String tmp_title = "";
	
	try{
		String text = URLEncoder.encode(txt, "UTF-8");
		String url = "http://freesummarizer.com/";

		URL obj = new URL(url);
		HttpURLConnection  con = (HttpURLConnection ) obj.openConnection();

		//add reuqest header
		con.setRequestMethod("POST");
		con.setRequestProperty("User-Agent", USER_AGENT);
		con.setRequestProperty("Accept", "text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,*/*;q=0.8");
		con.setRequestProperty("Content-Type", "application/x-www-form-urlencoded");
		//con.setRequestProperty("Accept-Language", "en-US,en;q=0.5");
		
		String urlParameters = "text="+text+"&maxsentences=1&maxtopwords=40";

		// Send post request
		con.setDoOutput(true);
		DataOutputStream wr = new DataOutputStream(con.getOutputStream());
		wr.writeBytes(urlParameters);
		wr.flush();
		wr.close();
		
		BufferedReader in = new BufferedReader(
		        new InputStreamReader(con.getInputStream()));
		
		String inputLine;
		StringBuffer resp = new StringBuffer();
		
		while ((inputLine = in.readLine()) != null) {
			resp.append(inputLine);
		}
		in.close();

		UserAgent userAgent = new UserAgent();
		userAgent.openContent(resp.toString());
		tmp_title = userAgent.doc.findFirst("<div class=summary2>").findFirst("<p>").getText().replaceAll("[^\\x00-\\x7F]", "");
		
		if(tmp_title.length() > len)
		{
			if(tmp_title.indexOf('.') > len)
			{
				if(tmp_title.indexOf('?') > len)
				{
					if(tmp_title.indexOf('!') > len)
					{
						if(tmp_title.indexOf(',') > len)
						{
							tmp_title = tmp_title.substring(0,tmp_title.substring(0,len).lastIndexOf(' '));
						}
						else
						{
							if((tmp_title.indexOf(',') > 0))
								tmp_title = tmp_title.substring(0,tmp_title.indexOf(','));
							else
								tmp_title = tmp_title.substring(0,tmp_title.substring(0,len).lastIndexOf(' '));
						}
					}
					else
					{
						if((tmp_title.indexOf('!') > 0))
							tmp_title = tmp_title.substring(0,tmp_title.indexOf('!'));
						else
							tmp_title = tmp_title.substring(0,tmp_title.substring(0,len).lastIndexOf(' '));
					}
				}
				else
				{
					if((tmp_title.indexOf('?') > 0))
						tmp_title = tmp_title.substring(0,tmp_title.indexOf('?'));
					else
						tmp_title = tmp_title.substring(0,tmp_title.substring(0,len).lastIndexOf(' '));
				}
			}
			else
			{
				if((tmp_title.indexOf('.') > 0))
					tmp_title = tmp_title.substring(0,tmp_title.indexOf('.'));
				else
					tmp_title = tmp_title.substring(0,tmp_title.substring(0,len).lastIndexOf(' '));
			}
		}
		tmp_title = tmp_title.replaceAll("[^\\w\\s]+", "");
		tmp_title = tmp_title.trim();
		
		HashMap<String,String> stop_words=new HashMap<String,String>();
		try (BufferedReader br = new BufferedReader(new FileReader(System.getProperty("user.dir")+"/remove_words.txt"))) {
		    String line;
		    
		    while ((line = br.readLine()) != null) {
		    	stop_words.put(line,"Yes");
		    }
		}catch(Exception e){}
		String[] remove_words = stop_words.keySet().toArray(new String[0]);
		int l_ind = tmp_title.lastIndexOf(" ");
		if(in_array(remove_words, tmp_title.substring(l_ind+1,tmp_title.length())))
		{
			tmp_title = tmp_title.substring(0,l_ind);
		}
	}
	catch(Exception e){e.printStackTrace(); }
	return tmp_title;
}
public boolean in_array(String[] arr, String targetValue)
{
	for(String s: arr)
	{
		if(s.equals(targetValue))
			return true;
	}
	return false;
}
public static HashMap<Integer, Integer> hsort(HashMap<Integer, Integer> unsortMap, final boolean order)
{
    List<Entry<Integer, Integer>> list = new LinkedList<Entry<Integer, Integer>>(unsortMap.entrySet());
    Collections.sort(list, new Comparator<Entry<Integer, Integer>>()
    {
        public int compare(Entry<Integer, Integer> o1,
                Entry<Integer, Integer> o2)
        {
            if (order)
                return o1.getValue().compareTo(o2.getValue());
            else
                return o2.getValue().compareTo(o1.getValue());
        }
    });
    HashMap<Integer, Integer> sortedMap = new LinkedHashMap<Integer, Integer>();
    for (Entry<Integer, Integer> entry : list)
        sortedMap.put(entry.getKey(), entry.getValue());
    return sortedMap;
}
public static HashMap<String, Integer> hssort(HashMap<String, Integer> unsortMap, final boolean order)
{
    List<Entry<String, Integer>> list = new LinkedList<Entry<String, Integer>>(unsortMap.entrySet());
    Collections.sort(list, new Comparator<Entry<String, Integer>>()
    {
        public int compare(Entry<String, Integer> o1,
                Entry<String, Integer> o2)
        {
            if (order)
                return o1.getValue().compareTo(o2.getValue());
            else
                return o2.getValue().compareTo(o1.getValue());
        }
    });
    HashMap<String, Integer> sortedMap = new LinkedHashMap<String, Integer>();
    for (Entry<String, Integer> entry : list)
        sortedMap.put(entry.getKey(), entry.getValue());
    return sortedMap;
}
public String[] insert_words(HashMap<String,Integer> words, int cat_id, int a_id, HashMap<String,String> stop_words)
{
	String[] arr = new String[2];
	String new_words = "";
	
	String ins_sql = "INSERT into word_list (category_id,word,count,articles) VALUES ";
	for (Map.Entry m:words.entrySet())
	{
		if(is_clean((String) m.getKey(),stop_words) && (int)m.getValue() >= 4)
		{
			ins_sql += "('"+cat_id+"','"+m.getKey()+"','"+m.getValue()+"','"+a_id+",'),";
			new_words += (String)m.getKey()+",";
		}
			
	}	
	ins_sql = ins_sql.substring(0,ins_sql.length()-1);
	new_words = new_words.substring(0,new_words.length()-1);
	arr[0] = ins_sql;
	arr[1] = new_words;
	return arr;
}
public static boolean is_clean(String s,HashMap<String,String> hm)
{
	String w1 = (String) hm.get(s);
	Pattern p = Pattern.compile("[^a-zA-Z0-9]");
	boolean hasSpecialChar = p.matcher(s).find();
	if(!hasSpecialChar)
	{
		if(w1 == null)
		{
			return true;
		}
	}
	return false;
}
%>
<% 
	int count_weight = get_value("word_weight",vars);		//Weight of number of words in deciding category
	int frequency_weight = get_value("freq_weight",vars);	//Weight of frequency of words in deciding category
	int title_length = 100;
	ResultSet r = stmt.executeQuery("SELECT MAX(id) AS m_id FROM articles");
	boolean ASC = true;
	boolean DESC = false;
	int m_id = 0;
	while(r.next())
		m_id = r.getInt("m_id");
	int id = m_id + 1;
	
	String txt = "";
	String type = request.getParameter("type");
	String title = "";
	String path = System.getProperty("user.dir");
	String name = "Article_"+id+".txt";
	String fpath = path + "/" + name;
	String tags = "";
	String s_tags = "";
	int total_words = 0, total_freq = 0;
	//Get text
	File file ;
	int maxFileSize = 5000 * 1024;
	int maxMemSize = 5000 * 1024;
	
	String contentType = request.getContentType();
	if ((contentType.indexOf("multipart/form-data") >= 0)) {
	
	   DiskFileItemFactory factory = new DiskFileItemFactory();
	   factory.setSizeThreshold(maxMemSize);
	   factory.setRepository(new File(fpath));
	
	   ServletFileUpload upload = new ServletFileUpload(factory);
	   upload.setSizeMax( maxFileSize );
	   try{ 
	      List fileItems = upload.parseRequest(request);
	      Iterator i = fileItems.iterator();
	
	      while ( i.hasNext () ) 
	      {
	         FileItem fi = (FileItem)i.next();
	         title = fi.getName();
	         if ( !fi.isFormField () )	
	         {
	        	 BufferedInputStream buff=new BufferedInputStream(fi.getInputStream());
                 byte []bytes=new byte[buff.available()];
                 buff.read(bytes,0,bytes.length);
                 txt = new String(bytes);
                 title = get_title(txt,title_length);
	         }
	      }
	   }catch(Exception ex) {
	      System.out.println(ex);
	   }
	}
	else if(type.equals("text"))
	{
		txt = (String)request.getParameter("file_text");
		if(!(request.getParameter("title").equals("")))
			title = (String)request.getParameter("title");
		else
			title = get_title(txt,title_length);
	}
	else{
	   response.sendRedirect("upload.jsp");
	}
	
	txt = encode(txt);
	//Save file
	try {
		File file_2 = new File(fpath);
		FileWriter fileWriter = new FileWriter(file_2);
		fileWriter.write(txt);
		fileWriter.flush();
		fileWriter.close(); 
	}
	catch (IOException e)
	{ e.printStackTrace(); }   
	txt = decode(txt);
	//out.println("<br/><br/><br/><br/><br/><div class=\"col-sm-12\">");
	
	//Algo
	int max_id = 0;
	try {
		r = stmt.executeQuery("SELECT * FROM word_list");
		
		HashMap<String,WordDetails> hm=new HashMap<String,WordDetails>();
		HashMap<String,Integer> hm1=new HashMap<String,Integer>();
		HashMap<String,Integer> extra_words=new HashMap<String,Integer>();
		String wrd;
		int cat_id,cnt,word_id;
		while(r.next())
		{
			wrd = r.getString("word");
			String wrd1=wrd.toLowerCase();
			word_id = r.getInt("id");
			cat_id = r.getInt("category_id");
			cnt = 0;
			hm.put(wrd1,new WordDetails(new Integer(word_id),new Integer(cat_id),new Integer(cnt)));
		}
		WordDetails wd;
		
		HashMap<Integer,Integer> word_cnt=new HashMap<Integer,Integer>();
		HashMap<Integer,Integer> freq_cnt=new HashMap<Integer,Integer>();
		HashMap<Integer,Integer> score = new HashMap<Integer,Integer>();
		HashMap<Integer,String> category = new HashMap<Integer,String>();
		
		ResultSet r2 = stmt.executeQuery("SELECT * FROM category");
		int tmp_id,w_cnt,f_cnt;
		while(r2.next())
		{
			tmp_id  = r2.getInt("id");
			word_cnt.put(tmp_id,0);
			freq_cnt.put(tmp_id,0);
			score.put(tmp_id, 0);
			category.put(tmp_id, r2.getString("name"));
		}
		
		String s = txt.toLowerCase();
		s = s.replaceAll("[^a-z0-9 ]", " ");
			
		while(s.indexOf("  ")>-1)
		{
			s=s.replace("  "," ");
		}
		if(s.equals(""))
		{}
		else
		{
			WordDetails w1;
			int e_cnt;
			String[] str = s.split("\\s");	
			for(String w:str)
			{  	
				if(is_clean(w,stop_words))
				{
					//out.println(w+"<br/>");
					w1 = hm.get(w);
					if(w1 != null)
					{
						w1.cnt += 1;
						hm.put(w, new WordDetails(new Integer(w1.word_id), new Integer(w1.cat_id),new Integer(w1.cnt)));
					}
					else
					{
						if(extra_words.get(w) == null)
							extra_words.put(w,1);
						else
						{
							e_cnt = extra_words.get(w);
							extra_words.put(w,e_cnt+1);
						}
					}
				}
			}
			extra_words = hssort(extra_words,DESC);
			int tmp_for_cnt = 0;
			String update_cnt_sql = "UPDATE word_list SET count = (CASE ";
			String update_article_sql = "UPDATE word_list SET articles = (CASE ";
			for(Map.Entry m:hm.entrySet())
			{
				wd = (WordDetails)m.getValue();
				//System.out.println(m.getKey()+" : Category_ID = "+wd.cat_id+" : Word_Count = "+wd.cnt);
				if(wd.cnt > 0)
				{
					tmp_id = wd.cat_id;
					w_cnt = word_cnt.get(tmp_id);
					f_cnt = freq_cnt.get(tmp_id);
					w_cnt += 1;
					f_cnt += wd.cnt-1;
					word_cnt.put(tmp_id,w_cnt);
					if(wd.cnt > 1)
						freq_cnt.put(tmp_id,f_cnt);

					hm1.put((String) m.getKey(), wd.cnt);

					total_words++;
					total_freq += wd.cnt-1;
					
					update_cnt_sql += "WHEN id = "+wd.word_id+" THEN count + "+wd.cnt+" ";
					update_article_sql += "WHEN id = "+wd.word_id+" THEN CONCAT(articles,'"+id+",') ";
					tmp_for_cnt++;
				}
			}
			update_cnt_sql += " ELSE count END);";
			update_article_sql += " ELSE articles END);";
			if(tmp_for_cnt > 0)
			{
				stmt.executeUpdate(update_cnt_sql);
				stmt.executeUpdate(update_article_sql);
			}
		}
		
		int max_score = 0;
		int tmp_score, total_score = 0;
		float max_percent = 0;
		for(Map.Entry m:score.entrySet())
		{
			tmp_id = (Integer)m.getKey();
			w_cnt = word_cnt.get(tmp_id);
			f_cnt = freq_cnt.get(tmp_id);
			tmp_score = (count_weight * (w_cnt*100/total_words)) + (frequency_weight * (f_cnt*100/total_freq));
			score.put(tmp_id, tmp_score);
			total_score += tmp_score;
			if(tmp_score > max_score)
			{
				max_score = tmp_score;
				max_id = tmp_id;
			}
		}
		//out.println("The article belongs to category: " + category.get(max_id)+"<br/>");
		max_percent = (float)max_score*100/total_score;
		DecimalFormat df = new DecimalFormat("#.##");
		df.setRoundingMode(RoundingMode.CEILING);
		Double percent;
		boolean debug = false;
		if(debug)
			return;
%>
<div id="main_div">
	<div class="col-md-10 col-md-offset-1">
		<div class="box box-primary">
	       <div class="box-header with-border text-center">
	         <h3 class="box-title">
	         	Article Analysis
	         </h3>
	       </div>
		   <div class="box-body with-border">
		   		<div class="col-md-12">
		   			<div class="col-md-1">
		   				<h4>Title:</h4>
		   			</div>
		   			<div class="col-md-11">
		   				<p class="result_str h4">&#10077<i><%=title %></i>&#10078</p>
		   			</div>
		   		</div>
		    	<div class="col-md-12">
		   			<div class="col-md-1">
		   				<h4>Abstract:</h4>
		   			</div>
		   			<div class="col-md-11">
		   				<p class="result_str h4"><i><%=txt.substring(0,300)+"..." %></i></p>
		   			</div>
		   		</div>
		   		<div class="col-md-12">
		   			<div class="col-md-1">
		   				<h4>Category:</h4>
		   			</div>
		   			<div class="col-md-11">
		   				<p class="result_str h4"><i><%= category.get(max_id) %> (<%=df.format(max_percent) %>%)</i></p>
		   			</div>
		   		</div>
		   </div>
		   <div class="box-body with-border">
		   </div>
		</div>
	</div>
	<div class="clearfix"></div>
	<div class="col-md-5 col-md-offset-1">
		<div class="box box-danger">
	       <div class="box-header with-border text-center">
	         <h3 class="box-title">
	         	Top Categories
	         </h3>
	       </div>
		   <div class="box-body with-border">	
			<%
				String cls = "";
				String cats = "";
				String scores ="";
				int cat_cnt = 0;
				String others = "";
				String morris_json = "";
				String[] classes = {"success","primary","danger","info","warning"};
				int lp_cnt = 0;
				score = hsort(score,DESC);
				for(Map.Entry m:score.entrySet())
				{
					tmp_id = (Integer)m.getKey();
					tmp_score = (Integer)m.getValue();
					if(total_score != 0)
					{
						percent = ((double)tmp_score/(double)total_score)*100;
						if(tmp_score > 0 && lp_cnt < 5)
						{
							lp_cnt++;
							if(!df.format(percent).equals(df.format(max_percent)))
								others += tmp_id+":"+df.format(percent)+",";
							cats += "'" + category.get(tmp_id) + "',";
							scores += df.format(percent) + ",";
							cat_cnt++;
							cls = classes[lp_cnt%classes.length];
							morris_json += "{label: \""+category.get(tmp_id)+"\", value: "+df.format(percent)+"},";
					
				%>
					<div class="col-md-12">
						<div class="col-md-6">
							<h3><%= category.get(tmp_id) %>: </h3> 
						</div>
						<div class="col-md-6">
							<div class="progress progress_tip tip_<%= cls%> pointer" data-toggle="tooltip" data-placement="bottom" title="<%= df.format(percent) + '%'%>" style="width: 90%; margin-top: 25px">
								<div class="progress-bar progress-bar-<%= cls%> text-center" role="progressbar" aria-valuenow="50" aria-valuemin="0" aria-valuemax="100" wid="<%= df.format(percent)%>">
								</div>
							</div>
						</div>
					</div>
				<%
					
						}
					}
					else
						percent = 0.00;
					//out.println(category.get(tmp_id) + " : " + df.format(percent) + " %"+"<br/>");
				}
				if(others.length() > 1)
					others = others.substring(0,others.length()-1);
			%>
			<%
			if(cats.length() > 0)
			{
				cats = cats.substring(0, cats.length()-1);
				cats.replaceAll("\'","\\\\'");
				scores = scores.substring(0, scores.length()-1);
			}
			%>
			</div>
		</div>
	</div>
	
	<div class="col-md-5">
		<div class="box box-danger">
	       <div class="box-header with-border text-center">
	         <h3 class="box-title">
	         	Categorical Pie Chart
	         </h3>
	       </div>
		   <div class="box-body with-border">	
				<div class="chart" id="percent-chart" style="height: 325px; position: relative;"></div>
	            <script type="text/javascript" src="js/raphael.js"></script>
				<script type="text/javascript" src="js/morris.js"></script>
				<script>
			      $(function () {
			        "use strict";
			        
			        var donut = new Morris.Donut({
			          element: 'percent-chart',
			          resize: true,
			          colors: ["#3c8dbc", "#f56954", "#00a65a"],
			          data: [
			            <%= morris_json %>
			          ],
			          hideHover: 'auto'
			        });
			      });
			    </script>
			</div>
		</div>
	</div>
	<div class="clearfix"></div>
	<div class="col-md-10 col-md-offset-1">
		<div class="box box-primary">
	       <div class="box-header with-border text-center">
	         <h3 class="box-title">
	         	Popular Tags
	         </h3>
	       </div>
		   <div class="box-body with-border">
		   		<div id="tags_div">
		   		<%
					hm1 = hssort(hm1,DESC);
					int count = total_words/4;
					if(count > 10)
						count = 10;
					int mcnt=0;
					String[] t_classes = {"primary","default"};
					String tag = "";
					String tag_sql = "INSERT into tags(name,article_id,cnt) VALUES ";
					for (Map.Entry m:hm1.entrySet())
					{
						if(count>0)
						{
							tag = (String)m.getKey();
							mcnt = (Integer)m.getValue();
							tags += "'"+tag+"',";
							s_tags += tag+",";
							tag_sql += "('"+tag+"',"+id+",'"+mcnt+"'),";
						%>
							<div class="tag">
								<a href="explore_tags.jsp?t=<%=tag%>" target="_blank" title="Explore">
									<span class="label label-<%= t_classes[count%t_classes.length]%>"><%=tag%> <span class="badge"><%=mcnt %></span> </span>
								</a>
							</div>
						<%
						}
						count--;
					}
					tag_sql = tag_sql.substring(0,tag_sql.length()-1);
					stmt.executeUpdate(tag_sql);
					if(tags.length() > 0)
					{
						tags = tags.substring(0, tags.length()-1);
						tags.replaceAll("\'","\\\\'");
						s_tags = s_tags.substring(0, s_tags.length()-1);
					}
					stmt.executeUpdate("INSERT into articles(id,title,name,category_id,score,view_count,time_count,review_score,tags,s_tags,others) VALUES ("+id+",'"+title+"','"+name+"',"+max_id+",'"+df.format(max_percent)+"','0','0','0',\""+tags+"\",'"+s_tags+"','"+others+"')");
				%>
		   		</div>
		   </div>
		</div>
	</div>
	<% 
		String[] arr = insert_words(extra_words,max_id,id, stop_words);
		stmt.executeUpdate(arr[0]);
		if(arr[1].length() > 0)
		{
			String[] new_arr = arr[1].split(",");
		%>
		<div class="clearfix"></div>
		<div class="col-md-10 col-md-offset-1">
			<div class="box box-danger">
		       <div class="box-header with-border text-center">
		         <h3 class="box-title">
		         	New Words
		         </h3>
		       </div>
			   <div class="box-body with-border">
			   		<div id="tags_div">
			   		<%
			   			for(String w : new_arr)
			   			{%>
			   				<div class="tag">
								<a href="search.jsp?q=<%=w%>" target="_blank" title="Search">
									<span class="label label-default"><%=w%> </span>
								</a>
							</div>
			   			<%}
			   		%>
			   		</div>
			   	</div>
			 </div>
		</div>
	</div>
	<%
			}
		}
		catch(Exception e)
		{ System.out.println(e); e.printStackTrace(); }
	%>
	<script type="text/javascript">
		$(document).ready(function()
		{
			$(".progress-bar").each(function()
			{
				$(this).animate({width : $(this).attr('wid')+'%'},200);
			});
		});
	</script>
</div>
<%@include file="footer.jsp" %>