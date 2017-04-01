<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ page import="java.net.*,java.io.*, java.util.*, java.lang.*, java.text.DecimalFormat, java.math.*, controller.WordDetails, com.jaunt.*" %>
<%@ page import="org.apache.commons.fileupload.*" %>
<%@ page import="org.apache.commons.fileupload.disk.*" %>
<%@ page import="org.apache.commons.fileupload.servlet.*" %>
<%@ page import="org.apache.commons.io.output.*" %>
<%@include file="header.jsp" %>
<%!
public String get_title(String txt, int len)
{
	String USER_AGENT = "Mozilla/5.0";
	String tmp_title = "";
	try{
		String text = URLEncoder.encode(txt, "UTF-8");
		String url = "http://freesummarizer.com/";
		
		
		URL obj = new URL(url);
		HttpURLConnection  con = (HttpURLConnection ) obj.openConnection();

		//add reuqest header
		con.setRequestMethod("POST");
		con.setRequestProperty("User-Agent", USER_AGENT);
		con.setRequestProperty("Accept-Language", "en-US,en;q=0.5");

		String urlParameters = "text="+text+"&maxsentences=1";

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
				
		String[] remove_words = {"with","at","from","into","during","including","until","against","among","throughout","despite","towards","upon","concerning","of","to","in","for","on","by","about","like","through","over","before","between","after","since","without","under","within","along","following","across","behind","beyond","plus","except","but","up","out","around","down","off","above","near"};
		int l_ind = tmp_title.lastIndexOf(" ");
		if(in_array(remove_words, tmp_title.substring(l_ind+1,tmp_title.length())))
		{
			tmp_title = tmp_title.substring(0,l_ind);
		}
	}
	catch(Exception e){}
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
%>
<% 
	int count_weight = 50;		//Weight of number of words in deciding category
	int frequency_weight = 50;	//Weight of frequency of words in deciding category
	int title_length = 100;
	ResultSet r = stmt.executeQuery("SELECT MAX(id) AS m_id FROM articles");
	
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
	
		
	//Save file
	/* try {
		File file_2 = new File(fpath);
		FileWriter fileWriter = new FileWriter(file_2);
		fileWriter.write(txt);
		fileWriter.flush();
		fileWriter.close(); 
	}
	catch (IOException e)
	{ e.printStackTrace(); }  */
	
	//Algo
	int max_id = 0;
	try {
		r = stmt.executeQuery("SELECT * FROM word_list");
		
		HashMap<String,WordDetails> hm=new HashMap<String,WordDetails>();
		HashMap<String,Integer> hm1=new HashMap<String,Integer>();
		String wrd;
		int cat_id,cnt,word_id;
		while(r.next())
		{
			wrd = r.getString("word");
			String wrd1=wrd.toLowerCase();
			word_id = r.getInt("id");
			cat_id = r.getInt("category_id");
			cnt = r.getInt("count");
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
		s = s.replaceAll("[^a-z0-9 ]", "");
		
		while(s.indexOf("  ")>-1)
		{
			s=s.replace("  "," ");
		}
		if(s.equals(""))
		{}
		else
		{
			WordDetails w1;
			String[] str = s.split("\\s");	
			for(String w:str)
			{  	
				w1 = hm.get(w);
				if(w1 != null)
				{
					w1.cnt += 1;
					hm.put(w, new WordDetails(new Integer(w1.word_id), new Integer(w1.cat_id),new Integer(w1.cnt)));
				}
			}
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
					f_cnt += wd.cnt;
					word_cnt.put(tmp_id,w_cnt);
					freq_cnt.put(tmp_id,f_cnt);

					hm1.put((String) m.getKey(), wd.cnt);

					total_words++;
					total_freq += wd.cnt;
					
					update_cnt_sql += "WHEN id = "+wd.word_id+" THEN count + "+wd.cnt+" ";
					update_article_sql += "WHEN id = "+wd.word_id+" THEN CONCAT(articles,'"+id+",') ";
					tmp_for_cnt++;
				}
			}
			update_cnt_sql += " ELSE count END);";
			update_article_sql += " ELSE articles END);";
			if(tmp_for_cnt > 0)
			{
				//stmt.executeUpdate(update_cnt_sql);
				//stmt.executeUpdate(update_article_sql);
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
%>
<div id="main_div">
	<link href="css/article_report.css" rel="stylesheet" type="text/css"/>
	<div id="analysis_div" class="col-md-offset-3 col-md-6">
		<div id="analysis_head">
			Article Analysis
		</div>
		<div id="analysis_body">
			<h3 class="text-center">Classified as "<%= category.get(max_id) %>" article.</h3>
			<%
				String cls = "";
				String cats = "";
				String scores ="";
				int cat_cnt = 0;
				String others = "";
				String morris_json = "";
				for(Map.Entry m:score.entrySet())
				{
					tmp_id = (Integer)m.getKey();
					tmp_score = (Integer)m.getValue();
					if(total_score != 0)
					{
						percent = ((double)tmp_score/(double)total_score)*100;
						if(tmp_score > 0)
						{
							if(!df.format(percent).equals(df.format(max_percent)))
								others += tmp_id+":"+df.format(percent)+",";
							cats += "'" + category.get(tmp_id) + "',";
							scores += df.format(percent) + ",";
							cat_cnt++;
							if(percent > 80)
								cls = "success";
							else if(percent > 60)
								cls = "primary";
							else if(percent > 40)
								cls = "info";
							else if(percent > 20)
								cls = "warning";
							else
								cls = "danger";
							
							morris_json += "{label: \""+category.get(tmp_id)+"\", value: "+df.format(percent)+"},";
					
				%>
					<div class="col-md-12">
						<div class="col-md-4">
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
		<div id="analysis_body">
			<h3 class="text-center"><u>Suggested Title</u></h3>
			<div class="col-md-12">
				<h4><%=title %></h4>
			</div>
		</div>
		<div id="analysis_body">
			<link rel="stylesheet" href="css/morris.css" type="text/css"/>
			<div class="box-body chart-responsive">
				<div class="chart" id="percent-chart" style="height: 300px; position: relative;"></div>
            </div>
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
		<script type="text/javascript">
			$(document).ready(function()
			{
				$(".progress-bar").each(function()
				{
					$(this).animate({width : $(this).attr('wid')+'%'},200);
				});
			});
		</script>
		<div id="analysis_body">
		<h3 class="text-center"><u>Popular Tags</u></h3>
		<div id="tags_div">
		<%
			Object[] a = hm1.entrySet().toArray();
			Arrays.sort(a, new Comparator()
			{
			    public int compare(Object o1, Object o2)
			    {
			        return ((Map.Entry<String, Integer>) o2).getValue().compareTo(((Map.Entry<String, Integer>) o1).getValue());
			    }
			});
			int count = total_words/4;
			if(count > 10)
				count = 10;
			int mcnt=0;
			String tag = "";
			String[] classes = {"success","primary","danger","info","warning"};
			for (Object e : a)
			{
				if(count>0)
				{
					tag = ((Map.Entry<String, Integer>) e).getKey();
					mcnt = ((Map.Entry<String, Integer>) e).getValue();
					tags += "'"+tag+"',";
					s_tags += tag+","; 
					//stmt.executeUpdate("INSERT into tags VALUES ('','"+tag+"',"+id+",'"+mcnt+"')");
				%>
					<div class="tag">
						<a href="explore_tags.jsp?t=<%=tag%>" target="_blank" title="Explore">
							<span class="label label-<%= classes[count%5]%>"><%=tag%> <span class="badge"><%=mcnt %></span></span>
						</a>
					</div>
				<%
				}
					
				count--;
			}
			if(tags.length() > 0)
			{
				tags = tags.substring(0, tags.length()-1);
				tags.replaceAll("\'","\\\\'");
				s_tags = s_tags.substring(0, s_tags.length()-1);
			}
			//stmt.executeUpdate("INSERT into articles VALUES ("+id+",'"+title+"','"+name+"',"+max_id+",'"+df.format(max_percent)+"','0','0','0',\""+tags+"\",'"+s_tags+"','"+others+"')");
		}
		catch(Exception e)
		{ System.out.println(e); e.printStackTrace(); }
		%>
		</div>
		</div>
	</div>
</div>
<%@include file="footer.jsp" %>